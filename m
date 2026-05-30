Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22423261B9E;
	Sat, 30 May 2026 17:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163227; cv=none; b=BVdp5WnBd5tJVIfIEp9leo+3HpwDWCNNModC1iREtNb9qIBOvZm2hFbBdL/rZu4BYEVBH6qy5H39qj+OGZhzAbSxSkgU7nyHRyEGdOd5s0M+oC2hdaGJ4/BKyfTX9MYihOmstJM+mZT3OhQcmcMb19NgVwg5JLmYwP0vLQ1P2jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163227; c=relaxed/simple;
	bh=HrlrmiVNkbkmPwr2dQegkNGdCPZ6SGmVQqcM/LzoqYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3bFhj5elOPEBR9j9x62WMb5avDQjOGtBblUWm0KcuIsMW/7Wxp9Nwgyfx3fBpnZODEgTTslQXOFyo9l7GIzUJv2I2/aLblhxyTmANBSGCPR7m8/KfAisHSFTPIDKyhWpjlkuH529qMrH7Er9VqekIiblTOmWZdfZbvLUiXtM84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HN7u7cF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HN7u7cF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E271F00893;
	Sat, 30 May 2026 17:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163225;
	bh=M3IKdg1oIP1TKRALUAS2Zr6pSw0X6Fs57i+ZNiOwQZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1HN7u7cFgPTAXra3t0jRZruTOwLL8wY7U7ZJ29rNw8lvN7GgLlL0aZq5TY9rvp3H4
	 oAbcQktxol1Ah5wuqszJr15PCVJObimTn3qtZf4YwlHGJpE+/8BhJrASzlCh0OkYH6
	 pZZG2HwzUhHPlYtH7dM6E7Ij42iHRvSPf+Jhv1Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Jan Kara <jack@suse.cz>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 193/776] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Sat, 30 May 2026 17:58:27 +0200
Message-ID: <20260530160245.494532415@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Heming Zhao <heming.zhao@suse.com>

commit d647c5b2fbf81560818dacade360abc8c00a9665 upstream.

During ocfs2 dio operations, JBD2 may report warnings via following
call trace:
ocfs2_dio_end_io_write
 ocfs2_mark_extent_written
  ocfs2_change_extent_flag
   ocfs2_split_extent
    ocfs2_try_to_merge_extent
     ocfs2_extend_rotate_transaction
      ocfs2_extend_trans
       jbd2__journal_restart
        start_this_handle
         output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449

To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write() to
handle extents in a batch of transaction.

Additionally, relocate ocfs2_del_inode_from_orphan().  The orphan inode
should only be removed from the orphan list after the extent tree update
is complete.  This ensures that if a crash occurs in the middle of extent
tree updates, we won't leave stale blocks beyond EOF.

This patch also changes the logic for updating the inode size and removing
orphan, making it similar to ext4_dio_write_end_io().  Both operations are
performed only when everything looks good.

Finally, thanks to Jans and Joseph for providing the bug fix prototype and
suggestions.

Link: https://lkml.kernel.org/r/20260402134328.27334-2-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/aops.c |   74 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 29 deletions(-)

--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -37,6 +37,8 @@
 #include "namei.h"
 #include "sysfile.h"
 
+#define OCFS2_DIO_MARK_EXTENT_BATCH 200
+
 static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
@@ -2305,7 +2307,7 @@ static int ocfs2_dio_end_io_write(struct
 	struct ocfs2_alloc_context *meta_ac = NULL;
 	handle_t *handle = NULL;
 	loff_t end = offset + bytes;
-	int ret = 0, credits = 0;
+	int ret = 0, credits = 0, batch = 0;
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
@@ -2322,18 +2324,6 @@ static int ocfs2_dio_end_io_write(struct
 		goto out;
 	}
 
-	/* Delete orphan before acquire i_rwsem. */
-	if (dwc->dw_orphaned) {
-		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
-
-		end = end > i_size_read(inode) ? end : 0;
-
-		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
-				!!end, end);
-		if (ret < 0)
-			mlog_errno(ret);
-	}
-
 	down_write(&oi->ip_alloc_sem);
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
@@ -2354,24 +2344,25 @@ static int ocfs2_dio_end_io_write(struct
 
 	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
 
-	handle = ocfs2_start_trans(osb, credits);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		mlog_errno(ret);
-		goto unlock;
-	}
-	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto commit;
-	}
-
 	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
+		if (!handle) {
+			handle = ocfs2_start_trans(osb, credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				mlog_errno(ret);
+				goto unlock;
+			}
+			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+					OCFS2_JOURNAL_ACCESS_WRITE);
+			if (ret) {
+				mlog_errno(ret);
+				goto commit;
+			}
+		}
 		ret = ocfs2_assure_trans_credits(handle, credits);
 		if (ret < 0) {
 			mlog_errno(ret);
-			break;
+			goto commit;
 		}
 		ret = ocfs2_mark_extent_written(inode, &et, handle,
 						ue->ue_cpos, 1,
@@ -2379,19 +2370,44 @@ static int ocfs2_dio_end_io_write(struct
 						meta_ac, &dealloc);
 		if (ret < 0) {
 			mlog_errno(ret);
-			break;
+			goto commit;
+		}
+
+		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
+			ocfs2_commit_trans(osb, handle);
+			handle = NULL;
+			batch = 0;
 		}
 	}
 
 	if (end > i_size_read(inode)) {
+		if (!handle) {
+			handle = ocfs2_start_trans(osb, credits);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				mlog_errno(ret);
+				goto unlock;
+			}
+		}
 		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
 		if (ret < 0)
 			mlog_errno(ret);
 	}
+
 commit:
-	ocfs2_commit_trans(osb, handle);
+	if (handle)
+		ocfs2_commit_trans(osb, handle);
 unlock:
 	up_write(&oi->ip_alloc_sem);
+
+	/* everything looks good, let's start the cleanup */
+	if (!ret && dwc->dw_orphaned) {
+		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
+
+		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
+		if (ret < 0)
+			mlog_errno(ret);
+	}
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:


