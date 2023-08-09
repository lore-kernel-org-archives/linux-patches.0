Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A1017AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A32EC433C7;
	Wed,  9 Aug 2023 11:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580418;
	bh=6zPNgIGkzoRWs5wmD+bzGo2ZH3OR2GPvx2iCWQLbT14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOHKzNIJ87G+UGfL+4g5Uho9HpFL7oQw59iWJJyzbJFcMZNk2TXp95YW9BLMhGYFK
	 5iUjA+8YZdU/VPX2TKKabf27XEgYIkDrGLk8gNfVu6m76rYPL3qgROr6w+0/OuVQcZ
	 rGy22UhHVRJEnsz2UUIaKIy+SPdyoniLDocw8X0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/154] jbd2: Fix wrongly judgement for buffer head removing while doing checkpoint
Date: Wed,  9 Aug 2023 12:40:36 +0200
Message-ID: <20230809103637.095401063@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit e34c8dd238d0c9368b746480f313055f5bab5040 ]

Following process,

jbd2_journal_commit_transaction
// there are several dirty buffer heads in transaction->t_checkpoint_list
          P1                   wb_workfn
jbd2_log_do_checkpoint
 if (buffer_locked(bh)) // false
                            __block_write_full_page
                             trylock_buffer(bh)
                             test_clear_buffer_dirty(bh)
 if (!buffer_dirty(bh))
  __jbd2_journal_remove_checkpoint(jh)
   if (buffer_write_io_error(bh)) // false
                             >> bh IO error occurs <<
 jbd2_cleanup_journal_tail
  __jbd2_update_log_tail
   jbd2_write_superblock
   // The bh won't be replayed in next mount.
, which could corrupt the ext4 image, fetch a reproducer in [Link].

Since writeback process clears buffer dirty after locking buffer head,
we can fix it by try locking buffer and check dirtiness while buffer is
locked, the buffer head can be removed if it is neither dirty nor locked.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217490
Fixes: 470decc613ab ("[PATCH] jbd2: initial copy of files from jbd")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230606135928.434610-5-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/checkpoint.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 587b89b67c1c6..edb17822f8e6b 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -228,20 +228,6 @@ int jbd2_log_do_checkpoint(journal_t *journal)
 		jh = transaction->t_checkpoint_list;
 		bh = jh2bh(jh);
 
-		/*
-		 * The buffer may be writing back, or flushing out in the
-		 * last couple of cycles, or re-adding into a new transaction,
-		 * need to check it again until it's unlocked.
-		 */
-		if (buffer_locked(bh)) {
-			get_bh(bh);
-			spin_unlock(&journal->j_list_lock);
-			wait_on_buffer(bh);
-			/* the journal_head may have gone by now */
-			BUFFER_TRACE(bh, "brelse");
-			__brelse(bh);
-			goto retry;
-		}
 		if (jh->b_transaction != NULL) {
 			transaction_t *t = jh->b_transaction;
 			tid_t tid = t->t_tid;
@@ -276,7 +262,22 @@ int jbd2_log_do_checkpoint(journal_t *journal)
 			spin_lock(&journal->j_list_lock);
 			goto restart;
 		}
-		if (!buffer_dirty(bh)) {
+		if (!trylock_buffer(bh)) {
+			/*
+			 * The buffer is locked, it may be writing back, or
+			 * flushing out in the last couple of cycles, or
+			 * re-adding into a new transaction, need to check
+			 * it again until it's unlocked.
+			 */
+			get_bh(bh);
+			spin_unlock(&journal->j_list_lock);
+			wait_on_buffer(bh);
+			/* the journal_head may have gone by now */
+			BUFFER_TRACE(bh, "brelse");
+			__brelse(bh);
+			goto retry;
+		} else if (!buffer_dirty(bh)) {
+			unlock_buffer(bh);
 			BUFFER_TRACE(bh, "remove from checkpoint");
 			/*
 			 * If the transaction was released or the checkpoint
@@ -286,6 +287,7 @@ int jbd2_log_do_checkpoint(journal_t *journal)
 			    !transaction->t_checkpoint_list)
 				goto out;
 		} else {
+			unlock_buffer(bh);
 			/*
 			 * We are about to write the buffer, it could be
 			 * raced by some other transaction shrink or buffer
-- 
2.39.2



