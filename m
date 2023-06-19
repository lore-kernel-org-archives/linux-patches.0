Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A24C5381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129CAC433C0;
	Mon, 19 Jun 2023 10:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171420;
	bh=wAXS9rGRh1fGK4NpglGdrw6ioq9Vv7UfKDQ0HUWyxDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beeyOvvpFQOsTd5iSBf4LP06q2i6iJN+Ab4WLGoT3tCLojzlI3pXMYMm906YGJTdr
	 eCYtShie1D6sMzg8duVKMfEAGOM4dM+2al9oo1KxgEyJoXZGwE2XnGBTA2y7t1mIV0
	 tw9FA53J5CGEVAFjLgBQZg7iKBhil4Z2KBGLhWKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Sperbeck <jsperbeck@google.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/166] cgroup: always put cset in cgroup_css_set_put_fork
Date: Mon, 19 Jun 2023 12:28:02 +0200
Message-ID: <20230619102154.908246524@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Sperbeck <jsperbeck@google.com>

[ Upstream commit 2bd110339288c18823dcace602b63b0d8627e520 ]

A successful call to cgroup_css_set_fork() will always have taken
a ref on kargs->cset (regardless of CLONE_INTO_CGROUP), so always
do a corresponding put in cgroup_css_set_put_fork().

Without this, a cset and its contained css structures will be
leaked for some fork failures.  The following script reproduces
the leak for a fork failure due to exceeding pids.max in the
pids controller.  A similar thing can happen if we jump to the
bad_fork_cancel_cgroup label in copy_process().

[ -z "$1" ] && echo "Usage $0 pids-root" && exit 1
PID_ROOT=$1
CGROUP=$PID_ROOT/foo

[ -e $CGROUP ] && rmdir -f $CGROUP
mkdir $CGROUP
echo 5 > $CGROUP/pids.max
echo $$ > $CGROUP/cgroup.procs

fork_bomb()
{
	set -e
	for i in $(seq 10); do
		/bin/sleep 3600 &
	done
}

(fork_bomb) &
wait
echo $$ > $PID_ROOT/cgroup.procs
kill $(cat $CGROUP/cgroup.procs)
rmdir $CGROUP

Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 002e563ec2ac8..36c95626afecc 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6471,19 +6471,18 @@ static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
 static void cgroup_css_set_put_fork(struct kernel_clone_args *kargs)
 	__releases(&cgroup_threadgroup_rwsem) __releases(&cgroup_mutex)
 {
+	struct cgroup *cgrp = kargs->cgrp;
+	struct css_set *cset = kargs->cset;
+
 	cgroup_threadgroup_change_end(current);
 
-	if (kargs->flags & CLONE_INTO_CGROUP) {
-		struct cgroup *cgrp = kargs->cgrp;
-		struct css_set *cset = kargs->cset;
+	if (cset) {
+		put_css_set(cset);
+		kargs->cset = NULL;
+	}
 
+	if (kargs->flags & CLONE_INTO_CGROUP) {
 		cgroup_unlock();
-
-		if (cset) {
-			put_css_set(cset);
-			kargs->cset = NULL;
-		}
-
 		if (cgrp) {
 			cgroup_put(cgrp);
 			kargs->cgrp = NULL;
-- 
2.39.2



