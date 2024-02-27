Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE6D145350;
	Tue, 27 Feb 2024 14:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044173; cv=none; b=Kc89reKoWF4wPmYOrTGh7jmiq8OPkIOdVQhZwVwjj2VX1yT+G1AcXiJUvkHE4Uv0GsaSDTPJWjB1Gc5S6/sEnsApyf3Lsrf53sIjAepUk6BWm0ikl2utQwMVo2sIkmSsfcer/zD2i6k7mKPFsly0aHc0cbVKfQg+wTLP4OJJjxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044173; c=relaxed/simple;
	bh=t/xcHxh1cMEqlsz4WXKo0hQc+0Ejousuplsq6CYgBb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lywtjcrakqUEZXAMZC6HAtoDzUQptPO0V0IkadiK6UQhXKVZsqITc+LeGctjdN3oA07Sze63l7vx9v3aEXWGfKgRQC52D8Q8wiXv926Bp4v9GyPvJrBdSzVgzpxSoAQchuW/A4mQSTTB3bN4zz1fdJC+rISIFn+6h46WArxuf90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwB3QTUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwB3QTUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E27EC433C7;
	Tue, 27 Feb 2024 14:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044172;
	bh=t/xcHxh1cMEqlsz4WXKo0hQc+0Ejousuplsq6CYgBb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwB3QTUABMAh1GuZyFK0olr343f6TcNv6xJml5PBZiSi2fdvjy4UAq0A1A+o4GOqu
	 8y89M0pud0vxIHGYdxpUqPULzCcjF3F4ptZUjh3QWD53oNbOYD4hS6x3/BnOV2qWF6
	 oIX6+vGliureJvbjob6CovEMb4/9Zj1jRU/F/02A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/122] jbd2: Fix wrongly judgement for buffer head removing while doing checkpoint
Date: Tue, 27 Feb 2024 14:27:12 +0100
Message-ID: <20240227131601.026120095@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index aac17c59b7ece..7898983c9fba0 100644
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
2.43.0



