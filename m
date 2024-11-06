Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129B91D2F42;
	Wed,  6 Nov 2024 13:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898015; cv=none; b=JJXZSlUkxyvcPod+SSvg33DUp/9td/3CccNCZZsejUCtJFsUfwFOuiyC8aRQIGrwyJfzNHqe//4ybsZ3VteICk/asBqkIGKqyrBR3Mv4cNVfTcOpcIIoHTahGYyfy58i3OQXSD94I0O41kdRgS46LlMjMuXjMV6mfLMyCpMXL/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898015; c=relaxed/simple;
	bh=yxnRszO8aT1RjcAbzF/42/ELsXHuF9KEWjZc+GkJL+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQz29nDyWe3gZQN3mu2G47+0AY4pS8wkqe8yKxdocM+Gd2pWCL+d6VrYt+5jTMtGBsDeV04u/jl0PWIcm9WkOkP0m7L6GPpF2fSMaOyZcZoBvosSgyyO5SN0eywGHqQRghgDjJTq+yUYrg+wNWZczHeBPZ6J2PW+m/kNP/x0VOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxU8b0ca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxU8b0ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BE7C4CECD;
	Wed,  6 Nov 2024 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898014;
	bh=yxnRszO8aT1RjcAbzF/42/ELsXHuF9KEWjZc+GkJL+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxU8b0carQGKNQDU27kIF+p3XABy2qtWFUSQV+YO48Wm64WxOgLPQOzdEECK/m0XG
	 n0ZOh/qkQZTPGIJ58KGeyrI2PMKD+Fco9othAAQuBZ8ayeW7jOpLTuquB0k3XMZ0QG
	 wb2mL5mpH+o9NvGws483yeHANCdJLZLW4vfWGOl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Faria de Oliveira <mfo@canonical.com>,
	Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/462] jbd2: introduce/export functions jbd2_journal_submit|finish_inode_data_buffers()
Date: Wed,  6 Nov 2024 12:59:48 +0100
Message-ID: <20241106120333.855229219@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauricio Faria de Oliveira <mfo@canonical.com>

[ Upstream commit aa3c0c61f62d682259e3e66cdc01846290f9cd6c ]

Export functions that implement the current behavior done
for an inode in journal_submit|finish_inode_data_buffers().

No functional change.

Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20201006004841.600488-2-mfo@canonical.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 20cee68f5b44 ("ext4: clear EXT4_GROUP_INFO_WAS_TRIMMED_BIT even mount with discard")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/commit.c     | 36 ++++++++++++++++--------------------
 fs/jbd2/journal.c    |  2 ++
 include/linux/jbd2.h |  4 ++++
 3 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 7bd4b1d4224ef..255026497b8cf 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -187,19 +187,17 @@ static int journal_wait_on_commit_record(journal_t *journal,
  * use writepages() because with delayed allocation we may be doing
  * block allocation in writepages().
  */
-static int journal_submit_inode_data_buffers(struct address_space *mapping,
-		loff_t dirty_start, loff_t dirty_end)
+int jbd2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
 {
-	int ret;
+	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
 	struct writeback_control wbc = {
 		.sync_mode =  WB_SYNC_ALL,
 		.nr_to_write = mapping->nrpages * 2,
-		.range_start = dirty_start,
-		.range_end = dirty_end,
+		.range_start = jinode->i_dirty_start,
+		.range_end = jinode->i_dirty_end,
 	};
 
-	ret = generic_writepages(mapping, &wbc);
-	return ret;
+	return generic_writepages(mapping, &wbc);
 }
 
 /*
@@ -215,16 +213,11 @@ static int journal_submit_data_buffers(journal_t *journal,
 {
 	struct jbd2_inode *jinode;
 	int err, ret = 0;
-	struct address_space *mapping;
 
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
-		loff_t dirty_start = jinode->i_dirty_start;
-		loff_t dirty_end = jinode->i_dirty_end;
-
 		if (!(jinode->i_flags & JI_WRITE_DATA))
 			continue;
-		mapping = jinode->i_vfs_inode->i_mapping;
 		jinode->i_flags |= JI_COMMIT_RUNNING;
 		spin_unlock(&journal->j_list_lock);
 		/*
@@ -234,8 +227,7 @@ static int journal_submit_data_buffers(journal_t *journal,
 		 * only allocated blocks here.
 		 */
 		trace_jbd2_submit_inode_data(jinode->i_vfs_inode);
-		err = journal_submit_inode_data_buffers(mapping, dirty_start,
-				dirty_end);
+		err = jbd2_journal_submit_inode_data_buffers(jinode);
 		if (!ret)
 			ret = err;
 		spin_lock(&journal->j_list_lock);
@@ -248,6 +240,15 @@ static int journal_submit_data_buffers(journal_t *journal,
 	return ret;
 }
 
+int jbd2_journal_finish_inode_data_buffers(struct jbd2_inode *jinode)
+{
+	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
+
+	return filemap_fdatawait_range_keep_errors(mapping,
+						   jinode->i_dirty_start,
+						   jinode->i_dirty_end);
+}
+
 /*
  * Wait for data submitted for writeout, refile inodes to proper
  * transaction if needed.
@@ -262,16 +263,11 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
 	/* For locking, see the comment in journal_submit_data_buffers() */
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
-		loff_t dirty_start = jinode->i_dirty_start;
-		loff_t dirty_end = jinode->i_dirty_end;
-
 		if (!(jinode->i_flags & JI_WAIT_DATA))
 			continue;
 		jinode->i_flags |= JI_COMMIT_RUNNING;
 		spin_unlock(&journal->j_list_lock);
-		err = filemap_fdatawait_range_keep_errors(
-				jinode->i_vfs_inode->i_mapping, dirty_start,
-				dirty_end);
+		err = jbd2_journal_finish_inode_data_buffers(jinode);
 		if (!ret)
 			ret = err;
 		spin_lock(&journal->j_list_lock);
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index cfa21c29f3123..564aedbd867f1 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -91,6 +91,8 @@ EXPORT_SYMBOL(jbd2_journal_try_to_free_buffers);
 EXPORT_SYMBOL(jbd2_journal_force_commit);
 EXPORT_SYMBOL(jbd2_journal_inode_ranged_write);
 EXPORT_SYMBOL(jbd2_journal_inode_ranged_wait);
+EXPORT_SYMBOL(jbd2_journal_submit_inode_data_buffers);
+EXPORT_SYMBOL(jbd2_journal_finish_inode_data_buffers);
 EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index b60adc4210b57..45c7e21ba1afc 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1415,6 +1415,10 @@ extern int	   jbd2_journal_inode_ranged_write(handle_t *handle,
 extern int	   jbd2_journal_inode_ranged_wait(handle_t *handle,
 			struct jbd2_inode *inode, loff_t start_byte,
 			loff_t length);
+extern int	   jbd2_journal_submit_inode_data_buffers(
+			struct jbd2_inode *jinode);
+extern int	   jbd2_journal_finish_inode_data_buffers(
+			struct jbd2_inode *jinode);
 extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
 				struct jbd2_inode *inode, loff_t new_size);
 extern void	   jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode);
-- 
2.43.0



