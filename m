Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F511A6192;
	Tue, 30 Jul 2024 17:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358944; cv=none; b=hGimJU5z7zfeAK10EJFh0VbvYpctruYih1mooRojL20Nk+xBL91ejK6cRYPLnDX86xpvBJR11RDPeD5AScql3mXLw89OWGf4InofnK8anRFiTObNmQMhrQZ9rE184soHTyFHupy2hOlLBOA1pME9/KutG5EAAkgEr8RotM+/Tos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358944; c=relaxed/simple;
	bh=Z0eY9i5rpMtPnE0Oq9ONUPHWVxTqSWiqc1bVHRDatgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcn7X5LLrLyVocgppb7oTGGkbV6E8KxhlAzVs2my96RqRdSCprPq5zeBveAIsvKv9/tkrt0Yxjokgd3xibM8XVjP7Y5MkooAkMXFTCF0DmtM+I/2GypOY6JL/KrA0Lq0omZvo6TfwLoPtc5vLpe+Fc5otdi2b+ncwZJUPF0r2nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2jDbDcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2jDbDcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15797C32782;
	Tue, 30 Jul 2024 17:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358944;
	bh=Z0eY9i5rpMtPnE0Oq9ONUPHWVxTqSWiqc1bVHRDatgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2jDbDcyhmfH0hfOAktcCTTg2ZjFLlHgjZkcWwBXctoWop3JA5nOwf145INE+g+R5
	 iI2lMnnbXsj8/3VfAdD8E7355mXA2MeQZeaAhBHetbVXF65Il6B6XQxc42YgKylxBm
	 TXfctZuYnjwDz+FjDfDqFbgkTn7kuQf1eWj0id7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 411/568] jbd2: precompute number of transaction descriptor blocks
Date: Tue, 30 Jul 2024 17:48:38 +0200
Message-ID: <20240730151655.932469873@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit e3a00a23781c1f2fcda98a7aecaac515558e7a35 upstream.

Instead of computing the number of descriptor blocks a transaction can
have each time we need it (which is currently when starting each
transaction but will become more frequent later) precompute the number
once during journal initialization together with maximum transaction
size. We perform the precomputation whenever journal feature set is
updated similarly as for computation of
journal->j_revoke_records_per_block.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20240624170127.3253-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/journal.c     |   61 +++++++++++++++++++++++++++++++++++++-------------
 fs/jbd2/transaction.c |   24 -------------------
 include/linux/jbd2.h  |    7 +++++
 3 files changed, 54 insertions(+), 38 deletions(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1451,6 +1451,48 @@ static int journal_revoke_records_per_bl
 	return space / record_size;
 }
 
+static int jbd2_journal_get_max_txn_bufs(journal_t *journal)
+{
+	return (journal->j_total_len - journal->j_fc_wbufsize) / 4;
+}
+
+/*
+ * Base amount of descriptor blocks we reserve for each transaction.
+ */
+static int jbd2_descriptor_blocks_per_trans(journal_t *journal)
+{
+	int tag_space = journal->j_blocksize - sizeof(journal_header_t);
+	int tags_per_block;
+
+	/* Subtract UUID */
+	tag_space -= 16;
+	if (jbd2_journal_has_csum_v2or3(journal))
+		tag_space -= sizeof(struct jbd2_journal_block_tail);
+	/* Commit code leaves a slack space of 16 bytes at the end of block */
+	tags_per_block = (tag_space - 16) / journal_tag_bytes(journal);
+	/*
+	 * Revoke descriptors are accounted separately so we need to reserve
+	 * space for commit block and normal transaction descriptor blocks.
+	 */
+	return 1 + DIV_ROUND_UP(jbd2_journal_get_max_txn_bufs(journal),
+				tags_per_block);
+}
+
+/*
+ * Initialize number of blocks each transaction reserves for its bookkeeping
+ * and maximum number of blocks a transaction can use. This needs to be called
+ * after the journal size and the fastcommit area size are initialized.
+ */
+static void jbd2_journal_init_transaction_limits(journal_t *journal)
+{
+	journal->j_revoke_records_per_block =
+				journal_revoke_records_per_block(journal);
+	journal->j_transaction_overhead_buffers =
+				jbd2_descriptor_blocks_per_trans(journal);
+	journal->j_max_transaction_buffers =
+				jbd2_journal_get_max_txn_bufs(journal);
+}
+
 /*
  * Load the on-disk journal superblock and read the key fields into the
  * journal_t.
@@ -1492,8 +1534,8 @@ static int journal_load_superblock(journ
 	if (jbd2_journal_has_csum_v2or3(journal))
 		journal->j_csum_seed = jbd2_chksum(journal, ~0, sb->s_uuid,
 						   sizeof(sb->s_uuid));
-	journal->j_revoke_records_per_block =
-				journal_revoke_records_per_block(journal);
+	/* After journal features are set, we can compute transaction limits */
+	jbd2_journal_init_transaction_limits(journal);
 
 	if (jbd2_has_feature_fast_commit(journal)) {
 		journal->j_fc_last = be32_to_cpu(sb->s_maxlen);
@@ -1690,11 +1732,6 @@ journal_t *jbd2_journal_init_inode(struc
 	return journal;
 }
 
-static int jbd2_journal_get_max_txn_bufs(journal_t *journal)
-{
-	return (journal->j_total_len - journal->j_fc_wbufsize) / 4;
-}
-
 /*
  * Given a journal_t structure, initialise the various fields for
  * startup of a new journaling session.  We use this both when creating
@@ -1740,8 +1777,6 @@ static int journal_reset(journal_t *jour
 	journal->j_commit_sequence = journal->j_transaction_sequence - 1;
 	journal->j_commit_request = journal->j_commit_sequence;
 
-	journal->j_max_transaction_buffers = jbd2_journal_get_max_txn_bufs(journal);
-
 	/*
 	 * Now that journal recovery is done, turn fast commits off here. This
 	 * way, if fast commit was enabled before the crash but if now FS has
@@ -2282,8 +2317,6 @@ jbd2_journal_initialize_fast_commit(jour
 	journal->j_fc_first = journal->j_last + 1;
 	journal->j_fc_off = 0;
 	journal->j_free = journal->j_last - journal->j_first;
-	journal->j_max_transaction_buffers =
-		jbd2_journal_get_max_txn_bufs(journal);
 
 	return 0;
 }
@@ -2371,8 +2404,7 @@ int jbd2_journal_set_features(journal_t
 	sb->s_feature_ro_compat |= cpu_to_be32(ro);
 	sb->s_feature_incompat  |= cpu_to_be32(incompat);
 	unlock_buffer(journal->j_sb_buffer);
-	journal->j_revoke_records_per_block =
-				journal_revoke_records_per_block(journal);
+	jbd2_journal_init_transaction_limits(journal);
 
 	return 1;
 #undef COMPAT_FEATURE_ON
@@ -2403,8 +2435,7 @@ void jbd2_journal_clear_features(journal
 	sb->s_feature_compat    &= ~cpu_to_be32(compat);
 	sb->s_feature_ro_compat &= ~cpu_to_be32(ro);
 	sb->s_feature_incompat  &= ~cpu_to_be32(incompat);
-	journal->j_revoke_records_per_block =
-				journal_revoke_records_per_block(journal);
+	jbd2_journal_init_transaction_limits(journal);
 }
 EXPORT_SYMBOL(jbd2_journal_clear_features);
 
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -63,28 +63,6 @@ void jbd2_journal_free_transaction(trans
 }
 
 /*
- * Base amount of descriptor blocks we reserve for each transaction.
- */
-static int jbd2_descriptor_blocks_per_trans(journal_t *journal)
-{
-	int tag_space = journal->j_blocksize - sizeof(journal_header_t);
-	int tags_per_block;
-
-	/* Subtract UUID */
-	tag_space -= 16;
-	if (jbd2_journal_has_csum_v2or3(journal))
-		tag_space -= sizeof(struct jbd2_journal_block_tail);
-	/* Commit code leaves a slack space of 16 bytes at the end of block */
-	tags_per_block = (tag_space - 16) / journal_tag_bytes(journal);
-	/*
-	 * Revoke descriptors are accounted separately so we need to reserve
-	 * space for commit block and normal transaction descriptor blocks.
-	 */
-	return 1 + DIV_ROUND_UP(journal->j_max_transaction_buffers,
-				tags_per_block);
-}
-
-/*
  * jbd2_get_transaction: obtain a new transaction_t object.
  *
  * Simply initialise a new transaction. Initialize it in
@@ -109,7 +87,7 @@ static void jbd2_get_transaction(journal
 	transaction->t_expires = jiffies + journal->j_commit_interval;
 	atomic_set(&transaction->t_updates, 0);
 	atomic_set(&transaction->t_outstanding_credits,
-		   jbd2_descriptor_blocks_per_trans(journal) +
+		   journal->j_transaction_overhead_buffers +
 		   atomic_read(&journal->j_reserved_credits));
 	atomic_set(&transaction->t_outstanding_revokes, 0);
 	atomic_set(&transaction->t_handle_count, 0);
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1084,6 +1084,13 @@ struct journal_s
 	int			j_revoke_records_per_block;
 
 	/**
+	 * @j_transaction_overhead:
+	 *
+	 * Number of blocks each transaction needs for its own bookkeeping
+	 */
+	int			j_transaction_overhead_buffers;
+
+	/**
 	 * @j_commit_interval:
 	 *
 	 * What is the maximum transaction lifetime before we begin a commit?


