Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D2AFC00
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFB9C433EF;
	Mon, 15 May 2023 17:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172049;
	bh=o+KMXiCq1DBJWT7LA7RDUDmk+R1++gOk+TuPuIQz8t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1LMW6b8D2pZ6OjSuKVwLY4WDTW06xDnkyUOadqMz9eoXYDS28QlmUzXl+cFNyE3S
	 PlXEMIVjixTATDD2Y6+rUDGdUNBwEeOdHzU7rMqN+nX/2S/3uoeNTIQgZTewZ1speW
	 MD/UnP6SeAFKlT5MnyfYWNkFiJcglul2KfpownIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 027/381] ext4: use ext4_journal_start/stop for fast commit transactions
Date: Mon, 15 May 2023 18:24:38 +0200
Message-Id: <20230515161738.008423425@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

commit 2729cfdcfa1cc49bef5a90d046fa4a187fdfcc69 upstream.

This patch drops all calls to ext4_fc_start_update() and
ext4_fc_stop_update(). To ensure that there are no ongoing journal
updates during fast commit, we also make jbd2_fc_begin_commit() lock
journal for updates. This way we don't have to maintain two different
transaction start stop APIs for fast commit and full commit. This
patch doesn't remove the functions altogether since in future we want
to have inode level locking for fast commits.

Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20211223202140.2061101-2-harshads@google.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/acl.c     |    2 --
 fs/ext4/extents.c |    2 --
 fs/ext4/file.c    |    4 ----
 fs/ext4/inode.c   |    7 +------
 fs/ext4/ioctl.c   |    8 +-------
 fs/jbd2/journal.c |    2 ++
 6 files changed, 4 insertions(+), 21 deletions(-)

--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -242,7 +242,6 @@ retry:
 	handle = ext4_journal_start(inode, EXT4_HT_XATTR, credits);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
-	ext4_fc_start_update(inode);
 
 	if ((type == ACL_TYPE_ACCESS) && acl) {
 		error = posix_acl_update_mode(inode, &mode, &acl);
@@ -260,7 +259,6 @@ retry:
 	}
 out_stop:
 	ext4_journal_stop(handle);
-	ext4_fc_stop_update(inode);
 	if (error == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 	return error;
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4694,7 +4694,6 @@ long ext4_fallocate(struct file *file, i
 		     FALLOC_FL_INSERT_RANGE))
 		return -EOPNOTSUPP;
 
-	ext4_fc_start_update(inode);
 	inode_lock(inode);
 	ret = ext4_convert_inline_data(inode);
 	inode_unlock(inode);
@@ -4764,7 +4763,6 @@ out:
 	inode_unlock(inode);
 	trace_ext4_fallocate_exit(inode, offset, max_blocks, ret);
 exit:
-	ext4_fc_stop_update(inode);
 	return ret;
 }
 
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -260,7 +260,6 @@ static ssize_t ext4_buffered_write_iter(
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		return -EOPNOTSUPP;
 
-	ext4_fc_start_update(inode);
 	inode_lock(inode);
 	ret = ext4_write_checks(iocb, from);
 	if (ret <= 0)
@@ -272,7 +271,6 @@ static ssize_t ext4_buffered_write_iter(
 
 out:
 	inode_unlock(inode);
-	ext4_fc_stop_update(inode);
 	if (likely(ret > 0)) {
 		iocb->ki_pos += ret;
 		ret = generic_write_sync(iocb, ret);
@@ -559,9 +557,7 @@ static ssize_t ext4_dio_write_iter(struc
 			goto out;
 		}
 
-		ext4_fc_start_update(inode);
 		ret = ext4_orphan_add(handle, inode);
-		ext4_fc_stop_update(inode);
 		if (ret) {
 			ext4_journal_stop(handle);
 			goto out;
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5437,7 +5437,7 @@ int ext4_setattr(struct dentry *dentry,
 		if (error)
 			return error;
 	}
-	ext4_fc_start_update(inode);
+
 	if ((ia_valid & ATTR_UID && !uid_eq(attr->ia_uid, inode->i_uid)) ||
 	    (ia_valid & ATTR_GID && !gid_eq(attr->ia_gid, inode->i_gid))) {
 		handle_t *handle;
@@ -5461,7 +5461,6 @@ int ext4_setattr(struct dentry *dentry,
 
 		if (error) {
 			ext4_journal_stop(handle);
-			ext4_fc_stop_update(inode);
 			return error;
 		}
 		/* Update corresponding info in inode so that everything is in
@@ -5473,7 +5472,6 @@ int ext4_setattr(struct dentry *dentry,
 		error = ext4_mark_inode_dirty(handle, inode);
 		ext4_journal_stop(handle);
 		if (unlikely(error)) {
-			ext4_fc_stop_update(inode);
 			return error;
 		}
 	}
@@ -5488,12 +5486,10 @@ int ext4_setattr(struct dentry *dentry,
 			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 
 			if (attr->ia_size > sbi->s_bitmap_maxbytes) {
-				ext4_fc_stop_update(inode);
 				return -EFBIG;
 			}
 		}
 		if (!S_ISREG(inode->i_mode)) {
-			ext4_fc_stop_update(inode);
 			return -EINVAL;
 		}
 
@@ -5619,7 +5615,6 @@ err_out:
 		ext4_std_error(inode->i_sb, error);
 	if (!error)
 		error = rc;
-	ext4_fc_stop_update(inode);
 	return error;
 }
 
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1322,13 +1322,7 @@ out:
 
 long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	long ret;
-
-	ext4_fc_start_update(file_inode(filp));
-	ret = __ext4_ioctl(filp, cmd, arg);
-	ext4_fc_stop_update(file_inode(filp));
-
-	return ret;
+	return __ext4_ioctl(filp, cmd, arg);
 }
 
 #ifdef CONFIG_COMPAT
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -757,6 +757,7 @@ int jbd2_fc_begin_commit(journal_t *jour
 	}
 	journal->j_flags |= JBD2_FAST_COMMIT_ONGOING;
 	write_unlock(&journal->j_state_lock);
+	jbd2_journal_lock_updates(journal);
 
 	return 0;
 }
@@ -768,6 +769,7 @@ EXPORT_SYMBOL(jbd2_fc_begin_commit);
  */
 static int __jbd2_fc_end_commit(journal_t *journal, tid_t tid, bool fallback)
 {
+	jbd2_journal_unlock_updates(journal);
 	if (journal->j_fc_cleanup_callback)
 		journal->j_fc_cleanup_callback(journal, 0);
 	write_lock(&journal->j_state_lock);


