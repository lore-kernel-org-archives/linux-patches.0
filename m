Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBA83D6B
	for <patches@lists.linux.dev>; Wed, 16 Mar 2022 23:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CBFC340EC;
	Wed, 16 Mar 2022 23:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647472510;
	bh=I3KlzWWISu6bKc3RthGyJbP6gMdZJBgq9UqJ9Av16mM=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=rQWetDYlla979RjnU6/jYv2CDSyz2S9rUL1zYPf4AUoCtXjz8fkya/CzLMJlIiqsp
	 a3jhMwFJWROEIKerIT086VvPlsgXODRdlSrNlso4Sq/o1hIhZYle/YTgryHyFr2OdE
	 AghCBBb+THzaIcERiw8tYCo09XU8GK/jEmcGrZj0=
Date: Wed, 16 Mar 2022 16:15:09 -0700
To: stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220316161433.5c2e137a69eaee50d2249a27@linux-foundation.org>
Subject: [patch 3/4] ocfs2: fix crash when initialize filecheck kobj fails
Message-Id: <20220316231510.02CBFC340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: fix crash when initialize filecheck kobj fails

Once s_root is set, genric_shutdown_super() will be called if fill_super()
fails.  That means, we will call ocfs2_dismount_volume() twice in such
case, which can lead to kernel crash.  Fix this issue by initializing
filecheck kobj before setting s_root.

Link: https://lkml.kernel.org/r/20220310081930.86305-1-joseph.qi@linux.alibaba.com
Fixes: 5f483c4abb50 ("ocfs2: add kobject for online file check")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-fix-crash-when-initialize-filecheck-kobj-fails
+++ a/fs/ocfs2/super.c
@@ -1105,17 +1105,6 @@ static int ocfs2_fill_super(struct super
 		goto read_super_error;
 	}
 
-	root = d_make_root(inode);
-	if (!root) {
-		status = -ENOMEM;
-		mlog_errno(status);
-		goto read_super_error;
-	}
-
-	sb->s_root = root;
-
-	ocfs2_complete_mount_recovery(osb);
-
 	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
 						&ocfs2_kset->kobj);
 	if (!osb->osb_dev_kset) {
@@ -1133,6 +1122,17 @@ static int ocfs2_fill_super(struct super
 		goto read_super_error;
 	}
 
+	root = d_make_root(inode);
+	if (!root) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto read_super_error;
+	}
+
+	sb->s_root = root;
+
+	ocfs2_complete_mount_recovery(osb);
+
 	if (ocfs2_mount_local(osb))
 		snprintf(nodestr, sizeof(nodestr), "local");
 	else
_
