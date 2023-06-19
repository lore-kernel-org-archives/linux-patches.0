Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2098C06
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 11:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01733C433CB;
	Mon, 19 Jun 2023 11:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172524;
	bh=Aez1CU8yWAfr+Ks5NePyn+7JE/L0rT42RWjjCmuBhDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxAYONlrev5YmcdOaIFGtEkvGyK0++AxWUcEpO8DbEkiRa9jxO0TPm+9Zf4cZctNu
	 M/MUlCra4jHXSLx1Z9PC2FXPgI9z6Shywi1X6YixgpIptJsxE/q/bfWLJoixNxaPQv
	 ndNGvqpNEHD8DnmlJcFcenI6mEO5n3l5v39eZQmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Sperbeck <jsperbeck@google.com>,
	Tejun Heo <tj@kernel.org>,
	"T.J. Mercier" <tjmercier@google.com>
Subject: [PATCH 5.15 099/107] cgroup: always put cset in cgroup_css_set_put_fork
Date: Mon, 19 Jun 2023 12:31:23 +0200
Message-ID: <20230619102146.064358502@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
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

commit 2bd110339288c18823dcace602b63b0d8627e520 upstream.

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
[TJM: This backport accommodates the lack of cgroup_unlock]
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6259,19 +6259,18 @@ err:
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
 		mutex_unlock(&cgroup_mutex);
-
-		if (cset) {
-			put_css_set(cset);
-			kargs->cset = NULL;
-		}
-
 		if (cgrp) {
 			cgroup_put(cgrp);
 			kargs->cgrp = NULL;


