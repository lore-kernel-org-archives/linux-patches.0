Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C34F6FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99241C433C7;
	Sun, 17 Sep 2023 20:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983318;
	bh=N4ITTM1fnk+dmTGXrSVLfkt2ZMf0Rt3z2Vus0of1JiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJg/yLoY9/Z/UYr5umnhz/0yy2vHvvzDpZS3CBYwWcmLVy5bu6jFrhn8fgLp0e6pL
	 8+yx7gy/+seXQ5+4orAqsviensQ2shTuquLjVBVm1cjxsfGVfQdI7IzhA5VUP2CCDF
	 crX1nemgwLkU8yfGxmLVCRWTJK1lWPUJQkZM59tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 467/511] jbd2: check jh->b_transaction before removing it from checkpoint
Date: Sun, 17 Sep 2023 21:14:54 +0200
Message-ID: <20230917191125.025951843@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 590a809ff743e7bd890ba5fb36bc38e20a36de53 upstream.

Following process will corrupt ext4 image:
Step 1:
jbd2_journal_commit_transaction
 __jbd2_journal_insert_checkpoint(jh, commit_transaction)
 // Put jh into trans1->t_checkpoint_list
 journal->j_checkpoint_transactions = commit_transaction
 // Put trans1 into journal->j_checkpoint_transactions

Step 2:
do_get_write_access
 test_clear_buffer_dirty(bh) // clear buffer dirty，set jbd dirty
 __jbd2_journal_file_buffer(jh, transaction) // jh belongs to trans2

Step 3:
drop_cache
 journal_shrink_one_cp_list
  jbd2_journal_try_remove_checkpoint
   if (!trylock_buffer(bh))  // lock bh, true
   if (buffer_dirty(bh))     // buffer is not dirty
   __jbd2_journal_remove_checkpoint(jh)
   // remove jh from trans1->t_checkpoint_list

Step 4:
jbd2_log_do_checkpoint
 trans1 = journal->j_checkpoint_transactions
 // jh is not in trans1->t_checkpoint_list
 jbd2_cleanup_journal_tail(journal)  // trans1 is done

Step 5: Power cut, trans2 is not committed, jh is lost in next mounting.

Fix it by checking 'jh->b_transaction' before remove it from checkpoint.

Cc: stable@kernel.org
Fixes: 46f881b5b175 ("jbd2: fix a race when checking checkpoint buffer busy")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230714025528.564988-3-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/checkpoint.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 936c6d758a65..f033ac807013 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -639,6 +639,8 @@ int jbd2_journal_try_remove_checkpoint(struct journal_head *jh)
 {
 	struct buffer_head *bh = jh2bh(jh);
 
+	if (jh->b_transaction)
+		return -EBUSY;
 	if (!trylock_buffer(bh))
 		return -EBUSY;
 	if (buffer_dirty(bh)) {
-- 
2.42.0



