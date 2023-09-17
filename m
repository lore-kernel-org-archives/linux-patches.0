Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE186FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69122C433C8;
	Sun, 17 Sep 2023 20:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983314;
	bh=XL25KCxH4gaJhUTRKfPOQZ70KU0vbjr73f+sLGvoJ78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNsmmqgL33AqanmxttRtpoOGF7HLawXq4mBrbu49QQGe36cGIao050umC2HHKYxNR
	 Xzx+cXz1sLErltdTe8Di3GQDnJBCTOVPdwZJ8ARbvNx/YoCGh5Aeyp42yZXxn5BvHm
	 Ts2roDMyhx2Oh+vcJT0dvO/LengVvw8w+X3elIuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 466/511] jbd2: fix checkpoint cleanup performance regression
Date: Sun, 17 Sep 2023 21:14:53 +0200
Message-ID: <20230917191125.003083101@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit 373ac521799d9e97061515aca6ec6621789036bb upstream.

journal_clean_one_cp_list() has been merged into
journal_shrink_one_cp_list(), but do chekpoint buffer cleanup from the
committing process is just a best effort, it should stop scan once it
meet a busy buffer, or else it will cause a lot of invalid buffer scan
and checks. We catch a performance regression when doing fs_mark tests
below.

Test cmd:
 ./fs_mark  -d  scratch  -s  1024  -n  10000  -t  1  -D  100  -N  100

Before merging checkpoint buffer cleanup:
 FSUse%        Count         Size    Files/sec     App Overhead
     95        10000         1024       8304.9            49033

After merging checkpoint buffer cleanup:
 FSUse%        Count         Size    Files/sec     App Overhead
     95        10000         1024       7649.0            50012
 FSUse%        Count         Size    Files/sec     App Overhead
     95        10000         1024       2107.1            50871

After merging checkpoint buffer cleanup, the total loop count in
journal_shrink_one_cp_list() could be up to 6,261,600+ (50,000+ ~
100,000+ in general), most of them are invalid. This patch fix it
through passing 'shrink_type' into journal_shrink_one_cp_list() and add
a new 'SHRINK_BUSY_STOP' to indicate it should stop once meet a busy
buffer. After fix, the loop count descending back to 10,000+.

After this fix:
 FSUse%        Count         Size    Files/sec     App Overhead
     95        10000         1024       8558.4            49109

Cc: stable@kernel.org
Fixes: b98dba273a0e ("jbd2: remove journal_clean_one_cp_list()")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230714025528.564988-2-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/checkpoint.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -349,6 +349,8 @@ int jbd2_cleanup_journal_tail(journal_t
 
 /* Checkpoint list management */
 
+enum shrink_type {SHRINK_DESTROY, SHRINK_BUSY_STOP, SHRINK_BUSY_SKIP};
+
 /*
  * journal_shrink_one_cp_list
  *
@@ -360,7 +362,8 @@ int jbd2_cleanup_journal_tail(journal_t
  * Called with j_list_lock held.
  */
 static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
-						bool destroy, bool *released)
+						enum shrink_type type,
+						bool *released)
 {
 	struct journal_head *last_jh;
 	struct journal_head *next_jh = jh;
@@ -376,12 +379,15 @@ static unsigned long journal_shrink_one_
 		jh = next_jh;
 		next_jh = jh->b_cpnext;
 
-		if (destroy) {
+		if (type == SHRINK_DESTROY) {
 			ret = __jbd2_journal_remove_checkpoint(jh);
 		} else {
 			ret = jbd2_journal_try_remove_checkpoint(jh);
-			if (ret < 0)
-				continue;
+			if (ret < 0) {
+				if (type == SHRINK_BUSY_SKIP)
+					continue;
+				break;
+			}
 		}
 
 		nr_freed++;
@@ -445,7 +451,7 @@ again:
 		tid = transaction->t_tid;
 
 		freed = journal_shrink_one_cp_list(transaction->t_checkpoint_list,
-						   false, &released);
+						   SHRINK_BUSY_SKIP, &released);
 		nr_freed += freed;
 		(*nr_to_scan) -= min(*nr_to_scan, freed);
 		if (*nr_to_scan == 0)
@@ -485,19 +491,21 @@ out:
 void __jbd2_journal_clean_checkpoint_list(journal_t *journal, bool destroy)
 {
 	transaction_t *transaction, *last_transaction, *next_transaction;
+	enum shrink_type type;
 	bool released;
 
 	transaction = journal->j_checkpoint_transactions;
 	if (!transaction)
 		return;
 
+	type = destroy ? SHRINK_DESTROY : SHRINK_BUSY_STOP;
 	last_transaction = transaction->t_cpprev;
 	next_transaction = transaction;
 	do {
 		transaction = next_transaction;
 		next_transaction = transaction->t_cpnext;
 		journal_shrink_one_cp_list(transaction->t_checkpoint_list,
-					   destroy, &released);
+					   type, &released);
 		/*
 		 * This function only frees up some memory if possible so we
 		 * dont have an obligation to finish processing. Bail out if


