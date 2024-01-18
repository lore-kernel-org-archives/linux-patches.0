Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB6625544;
	Thu, 18 Jan 2024 11:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575615; cv=none; b=aef1PmgmSkFiLnN4YgHOhcLiNgHZ5IpROyJJtzN2jP9gnEhYy8G15ELgDXrht0u/diRNkXenFQwhl+NCoVRD7J4eWPIaLNbjZUm06ISDrzUhIdR39INPHBCkZCFINav2+cOpdRMjGyCSLeTdqbkj0R4frimPalpsqGltgOg50MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575615; c=relaxed/simple;
	bh=L582cnXpPJZzxTNZD95JGKlugZr1LclH8VfN9QuZLV0=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=MRyP2pHKubCCITbsWbk9y3pAU3jIwFrch1RLxlQVJz/Tp7OGvxC641/5BWB3JpfMONGeNymYOPTLbwYGK5XlZ63eUTsL5ALhfJMhJ7U49E8XFU3zbTkvxe4eWAZnNnYtQHa+pAGuEprZIRGG77ebbL6hDDcfEWfxQm9Gce0kjiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbMgAoVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbMgAoVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3346FC433F1;
	Thu, 18 Jan 2024 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575615;
	bh=L582cnXpPJZzxTNZD95JGKlugZr1LclH8VfN9QuZLV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbMgAoVRQS4GO373OZu8JcG2SVORstlgycweMmHRE5m6T3G7YWiDbNtBU+m5DQh+n
	 IWVL/E4HDI1PyYodLu33efTQOYup2PDNcd0pEyUhHV6W0P/M8h5vtSecdSy4Waksz1
	 Y5hwzfGHz+nwBnQIg9TyL/zn2UPFOrqmifnxVThc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/100] jbd2: increase the journal IOs priority
Date: Thu, 18 Jan 2024 11:48:53 +0100
Message-ID: <20240118104312.868379328@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 6a3afb6ac6dfab158ebdd4b87941178f58c8939f ]

Current jbd2 only add REQ_SYNC for descriptor block, metadata log
buffer, commit buffer and superblock buffer, the submitted IO could be
throttled by writeback throttle in block layer, that could lead to
priority inversion in some cases. The log IO looks like a kind of high
priority metadata IO, so it should not be throttled by WBT like QOS
policies in block layer, let's add REQ_SYNC | REQ_IDLE to exempt from
writeback throttle, and also add REQ_META together indicates it's a
metadata IO.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20231129114740.2686201-2-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/commit.c     |  9 +++++----
 fs/jbd2/journal.c    | 20 +++++++++++---------
 include/linux/jbd2.h |  3 +++
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index f1d9db6686e3..447c6972a6d3 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -123,7 +123,7 @@ static int journal_submit_commit_record(journal_t *journal,
 	struct commit_header *tmp;
 	struct buffer_head *bh;
 	struct timespec64 now;
-	blk_opf_t write_flags = REQ_OP_WRITE | REQ_SYNC;
+	blk_opf_t write_flags = REQ_OP_WRITE | JBD2_JOURNAL_REQ_FLAGS;
 
 	*cbh = NULL;
 
@@ -429,8 +429,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		 */
 		jbd2_journal_update_sb_log_tail(journal,
 						journal->j_tail_sequence,
-						journal->j_tail,
-						REQ_SYNC);
+						journal->j_tail, 0);
 		mutex_unlock(&journal->j_checkpoint_mutex);
 	} else {
 		jbd2_debug(3, "superblock not updated\n");
@@ -749,6 +748,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 
 			for (i = 0; i < bufs; i++) {
 				struct buffer_head *bh = wbuf[i];
+
 				/*
 				 * Compute checksum.
 				 */
@@ -761,7 +761,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 				clear_buffer_dirty(bh);
 				set_buffer_uptodate(bh);
 				bh->b_end_io = journal_end_buffer_io_sync;
-				submit_bh(REQ_OP_WRITE | REQ_SYNC, bh);
+				submit_bh(REQ_OP_WRITE | JBD2_JOURNAL_REQ_FLAGS,
+					  bh);
 			}
 			cond_resched();
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 611337b0b5ad..3df45e4699f1 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1109,8 +1109,7 @@ int __jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block)
 	 * space and if we lose sb update during power failure we'd replay
 	 * old transaction with possibly newly overwritten data.
 	 */
-	ret = jbd2_journal_update_sb_log_tail(journal, tid, block,
-					      REQ_SYNC | REQ_FUA);
+	ret = jbd2_journal_update_sb_log_tail(journal, tid, block, REQ_FUA);
 	if (ret)
 		goto out;
 
@@ -1597,8 +1596,7 @@ static int journal_reset(journal_t *journal)
 		 */
 		jbd2_journal_update_sb_log_tail(journal,
 						journal->j_tail_sequence,
-						journal->j_tail,
-						REQ_SYNC | REQ_FUA);
+						journal->j_tail, REQ_FUA);
 		mutex_unlock(&journal->j_checkpoint_mutex);
 	}
 	return jbd2_journal_start_thread(journal);
@@ -1620,6 +1618,11 @@ static int jbd2_write_superblock(journal_t *journal, blk_opf_t write_flags)
 		return -EIO;
 	}
 
+	/*
+	 * Always set high priority flags to exempt from block layer's
+	 * QOS policies, e.g. writeback throttle.
+	 */
+	write_flags |= JBD2_JOURNAL_REQ_FLAGS;
 	if (!(journal->j_flags & JBD2_BARRIER))
 		write_flags &= ~(REQ_FUA | REQ_PREFLUSH);
 
@@ -1873,7 +1876,7 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
 	jbd2_debug(1, "JBD2: updating superblock error (errno %d)\n", errcode);
 	sb->s_errno    = cpu_to_be32(errcode);
 
-	jbd2_write_superblock(journal, REQ_SYNC | REQ_FUA);
+	jbd2_write_superblock(journal, REQ_FUA);
 }
 EXPORT_SYMBOL(jbd2_journal_update_sb_errno);
 
@@ -2178,8 +2181,7 @@ int jbd2_journal_destroy(journal_t *journal)
 				++journal->j_transaction_sequence;
 			write_unlock(&journal->j_state_lock);
 
-			jbd2_mark_journal_empty(journal,
-					REQ_SYNC | REQ_PREFLUSH | REQ_FUA);
+			jbd2_mark_journal_empty(journal, REQ_PREFLUSH | REQ_FUA);
 			mutex_unlock(&journal->j_checkpoint_mutex);
 		} else
 			err = -EIO;
@@ -2488,7 +2490,7 @@ int jbd2_journal_flush(journal_t *journal, unsigned int flags)
 	 * the magic code for a fully-recovered superblock.  Any future
 	 * commits of data to the journal will restore the current
 	 * s_start value. */
-	jbd2_mark_journal_empty(journal, REQ_SYNC | REQ_FUA);
+	jbd2_mark_journal_empty(journal, REQ_FUA);
 
 	if (flags)
 		err = __jbd2_journal_erase(journal, flags);
@@ -2538,7 +2540,7 @@ int jbd2_journal_wipe(journal_t *journal, int write)
 	if (write) {
 		/* Lock to make assertions happy... */
 		mutex_lock_io(&journal->j_checkpoint_mutex);
-		jbd2_mark_journal_empty(journal, REQ_SYNC | REQ_FUA);
+		jbd2_mark_journal_empty(journal, REQ_FUA);
 		mutex_unlock(&journal->j_checkpoint_mutex);
 	}
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index ebb1608d9dcd..6611af5f1d0c 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1374,6 +1374,9 @@ JBD2_FEATURE_INCOMPAT_FUNCS(csum2,		CSUM_V2)
 JBD2_FEATURE_INCOMPAT_FUNCS(csum3,		CSUM_V3)
 JBD2_FEATURE_INCOMPAT_FUNCS(fast_commit,	FAST_COMMIT)
 
+/* Journal high priority write IO operation flags */
+#define JBD2_JOURNAL_REQ_FLAGS		(REQ_META | REQ_SYNC | REQ_IDLE)
+
 /*
  * Journal flag definitions
  */
-- 
2.43.0



