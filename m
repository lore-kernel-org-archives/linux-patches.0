Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62BC6FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43D9C433CA;
	Sun, 17 Sep 2023 20:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982762;
	bh=ueJmrYC9G0QaXWr9xjvpjqbqPgIkQMyPr09xa594b5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQf6C/d9ARMmfxSaq/10eKtQV4YNzG/O0JW7DT58mUaIFvFpMBwJrUZDWjRTluIqH
	 oN7l9/mPHvWeVnYxCuSr+WsPVJcMqYnN6/VweM6sYyMlXLr6hpPPqcDf8vuGu5AJMT
	 JFZUMuSFbnzMYdxT1wmaX1vqyWByK7rk1xj2+QkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 346/511] procfs: block chmod on /proc/thread-self/comm
Date: Sun, 17 Sep 2023 21:12:53 +0200
Message-ID: <20230917191122.161827990@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksa Sarai <cyphar@cyphar.com>

commit ccf61486fe1e1a48e18c638d1813cda77b3c0737 upstream.

Due to an oversight in commit 1b3044e39a89 ("procfs: fix pthread
cross-thread naming if !PR_DUMPABLE") in switching from REG to NOD,
chmod operations on /proc/thread-self/comm were no longer blocked as
they are on almost all other procfs files.

A very similar situation with /proc/self/environ was used to as a root
exploit a long time ago, but procfs has SB_I_NOEXEC so this is simply a
correctness issue.

Ref: https://lwn.net/Articles/191954/
Ref: 6d76fa58b050 ("Don't allow chmod() on the /proc/<pid>/ files")
Fixes: 1b3044e39a89 ("procfs: fix pthread cross-thread naming if !PR_DUMPABLE")
Cc: stable@vger.kernel.org # v4.7+
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Message-Id: <20230713141001.27046-1-cyphar@cyphar.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3544,7 +3544,8 @@ static int proc_tid_comm_permission(stru
 }
 
 static const struct inode_operations proc_tid_comm_inode_operations = {
-		.permission = proc_tid_comm_permission,
+		.setattr	= proc_setattr,
+		.permission	= proc_tid_comm_permission,
 };
 
 /*


