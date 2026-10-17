Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F233A1E92;
	Sat, 17 Oct 2026 17:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259698; cv=none; b=XtNMvtxGFyD026eMOU8V5O19Ao0uYnuXOdzttfLg1sDXwvE8rBKNVhc4SlCURxd/SD7OTYR1o/8M+qUpLyPGcX15hgoyrjfF0vCPb6FwQIbjom13VwxdNjdmP497EVHTtBLBCci6A0YhFwGulCOlWtYLWRg2bMs+2+gboot2lb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259698; c=relaxed/simple;
	bh=/7W+sR0UqD3aRQVjff37tvu9P3JQKJCy9aSJSxgszeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cM5OIGX7LEuayKuKJYB4GEr1a8Fpj4f0D8yJbuub/8JMWkkb7SF53RmIZ8B2ccvi31frufy4PRdeABKuya+MhYpKU/D1nLUVhBQX6qQ6TVJynb+dJ9EBv9lk4MNveSsvB9c+D5vCXb+AbTW8Eo2xpsBQUxCQ1xyh+Jp6uCb9PlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8DSBDiW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8DSBDiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A472C1F000C4;
	Sat, 17 Oct 2026 17:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259697;
	bh=P8DSAAvV/CX+gIGugJ7Thf5zWqydnalhk5ldgT2R1H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8DSBDiWeb8R5THu+loRQFeYafUCk4E0akOTgL8ZXFZZzTFRuG2MyZ+CfO6WmMZcA
	 riRA1weRCS8UqfckHTkruJfTL53tEz/AOtz7Ykgn0ySJXdHhdyW035+kxGhZMdjzh3
	 cR1R3K9jdsfxlo/HRGyWtFaH0Vsk3vFR+BBFjeXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1300/1674] jbd2: use shrink_type type instead of bool type for __jbd2_journal_clean_checkpoint_list()
Date: Sat, 17 Oct 2026 17:59:32 +0200
Message-ID: <20261017160504.515703975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 078760d950016f5982751f5512e69f26ad8feb31 ]

"enum shrink_type" can clearly express the meaning of the parameter of
__jbd2_journal_clean_checkpoint_list(), and there is no need to use the
bool type.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20240407065355.1528580-2-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 15cb16496446 ("jbd2: bound shrinker scans by examined checkpoint buffers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/checkpoint.c | 16 +++++++++-------
 fs/jbd2/commit.c     |  2 +-
 include/linux/jbd2.h |  4 +++-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 0462101f683c8..95177cddf73db 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -355,8 +355,6 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
 
 /* Checkpoint list management */
 
-enum shrink_type {SHRINK_DESTROY, SHRINK_BUSY_STOP, SHRINK_BUSY_SKIP};
-
 /*
  * journal_shrink_one_cp_list
  *
@@ -495,21 +493,25 @@ unsigned long jbd2_journal_shrink_checkpoint_list(journal_t *journal,
  * journal_clean_checkpoint_list
  *
  * Find all the written-back checkpoint buffers in the journal and release them.
- * If 'destroy' is set, release all buffers unconditionally.
+ * If 'type' is SHRINK_DESTROY, release all buffers unconditionally. If 'type'
+ * is SHRINK_BUSY_STOP, will stop release buffers if encounters a busy buffer.
+ * To avoid wasting CPU cycles scanning the buffer list in some cases, don't
+ * pass SHRINK_BUSY_SKIP 'type' for this function.
  *
  * Called with j_list_lock held.
  */
-void __jbd2_journal_clean_checkpoint_list(journal_t *journal, bool destroy)
+void __jbd2_journal_clean_checkpoint_list(journal_t *journal,
+					  enum shrink_type type)
 {
 	transaction_t *transaction, *last_transaction, *next_transaction;
-	enum shrink_type type;
 	bool released;
 
+	WARN_ON_ONCE(type == SHRINK_BUSY_SKIP);
+
 	transaction = journal->j_checkpoint_transactions;
 	if (!transaction)
 		return;
 
-	type = destroy ? SHRINK_DESTROY : SHRINK_BUSY_STOP;
 	last_transaction = transaction->t_cpprev;
 	next_transaction = transaction;
 	do {
@@ -550,7 +552,7 @@ void jbd2_journal_destroy_checkpoint(journal_t *journal)
 			spin_unlock(&journal->j_list_lock);
 			break;
 		}
-		__jbd2_journal_clean_checkpoint_list(journal, true);
+		__jbd2_journal_clean_checkpoint_list(journal, SHRINK_DESTROY);
 		spin_unlock(&journal->j_list_lock);
 		cond_resched();
 	}
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 84663ff7dc505..4de8b49afd226 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -501,7 +501,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	 * frees some memory
 	 */
 	spin_lock(&journal->j_list_lock);
-	__jbd2_journal_clean_checkpoint_list(journal, false);
+	__jbd2_journal_clean_checkpoint_list(journal, SHRINK_BUSY_STOP);
 	spin_unlock(&journal->j_list_lock);
 
 	jbd2_debug(3, "JBD2: commit phase 1\n");
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 7dad9b761cbce..9f498fef91cd4 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1451,7 +1451,9 @@ void jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block);
 extern void jbd2_journal_commit_transaction(journal_t *);
 
 /* Checkpoint list management */
-void __jbd2_journal_clean_checkpoint_list(journal_t *journal, bool destroy);
+enum shrink_type {SHRINK_DESTROY, SHRINK_BUSY_STOP, SHRINK_BUSY_SKIP};
+
+void __jbd2_journal_clean_checkpoint_list(journal_t *journal, enum shrink_type type);
 unsigned long jbd2_journal_shrink_checkpoint_list(journal_t *journal, unsigned long *nr_to_scan);
 int __jbd2_journal_remove_checkpoint(struct journal_head *);
 int jbd2_journal_try_remove_checkpoint(struct journal_head *jh);
-- 
2.53.0



