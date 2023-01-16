Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C136B33F0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21297C433F0;
	Mon, 16 Jan 2023 16:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885501;
	bh=RJyORvhLRhQrMNV00q54wreXrP1fCoBnJevya5XH9GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TeXKhiLbshLM8WAJdnzD19lRmYs8QN0fqMsMyD5yRnJE7MXluVToTArSdTqbWhndM
	 lNbBUV+RRRh8zfqEW1Lqx80qkAjatGrLGHwixnDcxa/D/R24i5BeUyv6wzXYEQcNkp
	 Ujyg8ufYgcgaU3UA88kkzjj4Hq1Qsx6bqJiETC1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/658] ocfs2: ocfs2_mount_volume does cleanup job before return error
Date: Mon, 16 Jan 2023 16:42:44 +0100
Message-Id: <20230116154913.101118079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>

[ Upstream commit 0737e01de9c411e4db87dcedf4a9789d41b1c5c1 ]

After this patch, when error, ocfs2_fill_super doesn't take care to
release resources which are allocated in ocfs2_mount_volume.

Link: https://lkml.kernel.org/r/20220424130952.2436-5-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/super.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c1cf67b24c19..ead43f95bb43 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1787,11 +1787,10 @@ static int ocfs2_get_sector(struct super_block *sb,
 static int ocfs2_mount_volume(struct super_block *sb)
 {
 	int status = 0;
-	int unlock_super = 0;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
 	if (ocfs2_is_hard_readonly(osb))
-		goto leave;
+		goto out;
 
 	mutex_init(&osb->obs_trim_fs_mutex);
 
@@ -1801,44 +1800,56 @@ static int ocfs2_mount_volume(struct super_block *sb)
 		if (status == -EBADR && ocfs2_userspace_stack(osb))
 			mlog(ML_ERROR, "couldn't mount because cluster name on"
 			" disk does not match the running cluster name.\n");
-		goto leave;
+		goto out;
 	}
 
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_dlm;
 	}
-	unlock_super = 1;
 
 	/* This will load up the node map and add ourselves to it. */
 	status = ocfs2_find_slot(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_super_lock;
 	}
 
 	/* load all node-local system inodes */
 	status = ocfs2_init_local_system_inodes(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_super_lock;
 	}
 
 	status = ocfs2_check_volume(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
+		goto out_system_inodes;
 	}
 
 	status = ocfs2_truncate_log_init(osb);
-	if (status < 0)
+	if (status < 0) {
 		mlog_errno(status);
+		goto out_system_inodes;
+	}
 
-leave:
-	if (unlock_super)
-		ocfs2_super_unlock(osb, 1);
+	ocfs2_super_unlock(osb, 1);
+	return 0;
 
+out_system_inodes:
+	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
+		ocfs2_shutdown_local_alloc(osb);
+	ocfs2_release_system_inodes(osb);
+	/* before journal shutdown, we should release slot_info */
+	ocfs2_free_slot_info(osb);
+	ocfs2_journal_shutdown(osb);
+out_super_lock:
+	ocfs2_super_unlock(osb, 1);
+out_dlm:
+	ocfs2_dlm_shutdown(osb, 0);
+out:
 	return status;
 }
 
-- 
2.35.1



