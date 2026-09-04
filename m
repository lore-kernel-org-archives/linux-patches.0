Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DEE41F5D4;
	Fri,  4 Sep 2026 06:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502503; cv=none; b=FRP6vmFXGe6x0JbaxovKZv4+8WxFliwMtxNn5V86e1YtUXJqhPXJFc2JtD4xZKxA8+xtS4mTFCSJSAfeCF+93M5NwKpzzXpp/Z9s2lipZ4ZWhm9fjm9FoWPsp++FMdJZqwnHswZe4os0TgoETprcW0ZiO8kEPnjsjocKZSVdKpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502503; c=relaxed/simple;
	bh=54+FJtfkmYoIRT+TmDabVgALjRLAkSjGv+RDtf6G3nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wa8k01EjLzezMgtv9ZZmZlxsWx6+9ns2XYtNQKqO9HU5JsDedvbgTJu9VnlyAT5bdpkvGftrYsh89MdKgPW7gacT/5pAMYOKgljvlI0UhDCnQJz5jBYcT1PdkWN204sfRAlMHrwR8tzWR/Qnpbis/9wL3U896BEJbaMCAJ2J9i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRvyot5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRvyot5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2569D1F00A3E;
	Fri,  4 Sep 2026 06:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502502;
	bh=dbuqfDcO0ZM0NqH9c63hMjsNAJFLGsfdfpIgGLqlvN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRvyot5t7DstvwQEuKgA/2Zjbsu8lNbZO48VwI9kxOI6siTUNSMLsdvM1OsS/C0sJ
	 L9gf+JOJOJcHBS/iI2T5hsXNJIWbbdPTcfVcG/MhFp4kCJO2yzDz/AiOT5gX+hi0XL
	 EwSLKGCy+uxXLMPZzfS/BpCKTWagQwQDHqdGfx/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 187/403] jbd2: bound shrinker scans by examined checkpoint buffers
Date: Fri,  4 Sep 2026 06:59:50 +0200
Message-ID: <20260904045739.109735630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


