Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700E23A961E;
	Fri,  4 Sep 2026 05:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499254; cv=none; b=DI76n0i2GNMZhlB6Pl179P4KtOXDcN7b93gV+nXmECoXBwG8g8dOCUdW7yRGsi+39T70jRauFjzfa1U5c09OeqVT6U9/t+JqfN8nsOljSaEjInX8DrWjqQQVRIxQqTnXkSRi2riAyrYQO1Dve6QTjF6mZo7+DLWlP/dq2d/yXVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499254; c=relaxed/simple;
	bh=1ttUR+AixQzb+/0Pjrg3ossapsAOsPOpuxo14D1npyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfJnvmQOq9xcV8GqT5DqztC5M5CnQeuYSXnD1bAwFj+CKixo4UUl8fpOdGN8jTKZ6qEn2vVfmSToqIEu8W2e2O2aWIyy20ig4WNLwle70UpEhSa5KWHA+XBnsWJ7XMDj8142/5JVbhS2R2JwHh5rBT6xgHsYFeMBmjkj+21VSio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwHXg8xX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwHXg8xX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86F01F00A3D;
	Fri,  4 Sep 2026 05:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499253;
	bh=YhjvW9O/tL1S2vBgZp5OU/Du2f0hojw48SbusMhX2FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rwHXg8xXe2O5Nnwl/uNswwJLo94xTvV9hQVjE1ZdT+Xbo/BVWQgYaTmOEhfXHwzMj
	 kp5/b7XnMiuVm5RFP7ud8L433sqnW2PDAQnSPlPKYe+JzZKMWswxYflNZ8Vsgo0lQ/
	 Ippfc763gTJrml6ZfElWgcdu5JiPx1yXgdlg1Vos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 7.2 350/713] jbd2: bound shrinker scans by examined checkpoint buffers
Date: Fri,  4 Sep 2026 06:55:18 +0200
Message-ID: <20260904045811.676959154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit 15cb16496446b94e67f7abcb049b8e2c75cd3d02 upstream.

The jbd2 shrinker currently accounts only checkpoint buffers that it
successfully releases against nr_to_scan.  Busy buffers therefore do not
consume the scan budget.

If a checkpoint transaction contains mostly busy buffers, the shrinker
can scan its entire checkpoint list while holding journal->j_list_lock.
Large checkpoint lists can result in excessive lock hold times and leave
other CPUs spinning on j_list_lock, causing soft lockups or RCU stalls.

Pass nr_to_scan into journal_shrink_one_cp_list() and decrement it for
every buffer examined, including busy buffers.  Pass NULL from checkpoint
cleanup paths so their existing full-list behavior is preserved.

This restores the scan-budget semantics that existed before
journal_shrink_one_cp_list() was changed to always scan a complete
checkpoint list.

Fixes: b98dba273a0e ("jbd2: remove journal_clean_one_cp_list()")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260713102229.1598812-3-max.kellermann@ionos.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/checkpoint.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -358,15 +358,16 @@ int jbd2_cleanup_journal_tail(journal_t
 /*
  * journal_shrink_one_cp_list
  *
- * Find all the written-back checkpoint buffers in the given list
- * and try to release them. If the whole transaction is released, set
- * the 'released' parameter. Return the number of released checkpointed
- * buffers.
+ * Find written-back checkpoint buffers in the given list and try to release
+ * them. If 'nr_to_scan' is set, scan at most that many buffers. If the whole
+ * transaction is released, set the 'released' parameter. Return the number of
+ * released checkpointed buffers.
  *
  * Called with j_list_lock held.
  */
 static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
 						enum jbd2_shrink_type type,
+						unsigned long *nr_to_scan,
 						bool *released)
 {
 	struct journal_head *last_jh;
@@ -375,13 +376,15 @@ static unsigned long journal_shrink_one_
 	int ret;
 
 	*released = false;
-	if (!jh)
+	if (!jh || (nr_to_scan && !*nr_to_scan))
 		return 0;
 
 	last_jh = jh->b_cpprev;
 	do {
 		jh = next_jh;
 		next_jh = jh->b_cpnext;
+		if (nr_to_scan)
+			(*nr_to_scan)--;
 
 		if (type == JBD2_SHRINK_DESTROY) {
 			ret = __jbd2_journal_remove_checkpoint(jh);
@@ -402,7 +405,7 @@ static unsigned long journal_shrink_one_
 
 		if (need_resched())
 			break;
-	} while (jh != last_jh);
+	} while (jh != last_jh && (!nr_to_scan || *nr_to_scan));
 
 	return nr_freed;
 }
@@ -424,7 +427,6 @@ unsigned long jbd2_journal_shrink_checkp
 	tid_t first_tid = 0, last_tid = 0, next_tid = 0;
 	tid_t tid = 0;
 	unsigned long nr_freed = 0;
-	unsigned long freed;
 	bool first_set = false;
 
 again:
@@ -457,10 +459,9 @@ again:
 		next_transaction = transaction->t_cpnext;
 		tid = transaction->t_tid;
 
-		freed = journal_shrink_one_cp_list(transaction->t_checkpoint_list,
-						   JBD2_SHRINK_BUSY_SKIP, &released);
-		nr_freed += freed;
-		(*nr_to_scan) -= min(*nr_to_scan, freed);
+		nr_freed += journal_shrink_one_cp_list(transaction->t_checkpoint_list,
+						       JBD2_SHRINK_BUSY_SKIP,
+						       nr_to_scan, &released);
 		if (*nr_to_scan == 0)
 			break;
 		if (need_resched() || spin_needbreak(&journal->j_list_lock))
@@ -516,7 +517,7 @@ void __jbd2_journal_clean_checkpoint_lis
 		transaction = next_transaction;
 		next_transaction = transaction->t_cpnext;
 		journal_shrink_one_cp_list(transaction->t_checkpoint_list,
-					   type, &released);
+					   type, NULL, &released);
 		/*
 		 * This function only frees up some memory if possible so we
 		 * dont have an obligation to finish processing. Bail out if


