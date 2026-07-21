Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A714385D67;
	Tue, 21 Jul 2026 19:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662960; cv=none; b=aF3gRe0NJEpbyxpLvvRCFjZ+PMnFftczkTScHWDUmxwgkc0JxVWEYFrAErJ5Jr9i5TXk9Dk6AJPJ+dwUEPB5lzwT/WDbt0FpOmlc9iuWngEql+y8Iu5Rdiynhcj7AptauoJKK+TGG0JSGD8iZb/ta9fyZtPhCCbSOZBi9DrwPrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662960; c=relaxed/simple;
	bh=pnhjX1Rn+yaAAYozB6cqsZSpkAqFfBXmFlBGCyy86J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkHzjtmiRHpEOL/CKqYm+HGnyygRvQbLhyny2PFnOqMMf4BKHrWy+LV20y/icKlTv8DUXiF1W8vAbJ2+gdXo57s6PjfKMWKRjfTxqaiLAnTJgEFtdNpqwXwj67/rLDET3Jh6JUlIsrybNz0gDjv5muqJVgskYlWdqGaCs9wV9iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6Kfe7Oj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6Kfe7Oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF9C1F000E9;
	Tue, 21 Jul 2026 19:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662959;
	bh=MBeYQidoT2Nbio43U4ltEJDu+3RtZwgZUx1eXp5IMwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6Kfe7OjYLJEnx8KviumCLYDEEZk49ClcHDGACrP3dWsNjqxazV93NtsZA/CWeaXd
	 tWXabt2tGJRXrGJGbI1s/7uj3aEAchTCCRkSH1vlYmnWFVP0AAEE/StJhbvzPOU5gD
	 1PjXpEvqK4AgtMuRPlur8mMeKlNxxG826s+a6o0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0640/1276] md/raid5: use stripe state snapshot in break_stripe_batch_list()
Date: Tue, 21 Jul 2026 17:18:03 +0200
Message-ID: <20260721152500.432330594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 9b249f5ffbeda24c57e6c56ed896c5ca4fc70549 ]

The patch just suppress KCSAN noise. No functional change.

RAID-5 can group multi full-stripe-write aka stripe_head into a
batch aka batch_list, with one head_sh leading them. Call
break_stripe_batch_list() when the batch is finished, or,
a stripe has to be dropped out of the batch.

break_stripe_batch_list() reads stripe state several times while
request paths can update thost state words concurrently with
lockless bitops, which reported by KCSAN.

Use a snapshot to guarantees that the value used for
warning, copying, and handle checks is internally consistent
at current read moment.

KCSAN report:
==============================================
BUG: KCSAN: data-race in __add_stripe_bio / break_stripe_batch_list

write (marked) to 0xffff8e89d4f0b988 of 8 bytes by task 4323 on cpu 3:
  __add_stripe_bio+0x35e/0x400
  raid5_make_request+0x6ac/0x2930
  md_handle_request+0x4a2/0xa40
  md_submit_bio+0x109/0x1a0
  __submit_bio+0x2ec/0x390
  submit_bio_noacct_nocheck+0x457/0x710
  submit_bio_noacct+0x2a7/0xc20
  submit_bio+0x56/0x250
  blkdev_direct_IO+0x54c/0xda0
  blkdev_write_iter+0x38f/0x570
  aio_write+0x22b/0x490
  io_submit_one+0xa51/0xf70

read to 0xffff8e89d4f0b988 of 8 bytes by task 4290 on cpu 4:
  break_stripe_batch_list+0x3ce/0x480
  handle_stripe_clean_event+0x720/0x9b0
  handle_stripe+0x32fb/0x4500
  handle_active_stripes.isra.0+0x6e0/0xa50
  raid5d+0x7e0/0xba0

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Link: https://patch.msgid.link/20260618134748.1168360-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Stable-dep-of: 55b77337bdd0 ("md/raid5: avoid R5_Overlap races while breaking stripe batches")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f71ed0f5382588..7548a01acc17e1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4835,31 +4835,35 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 {
 	struct stripe_head *sh, *next;
 	int i;
+	unsigned long state;
 
 	list_for_each_entry_safe(sh, next, &head_sh->batch_list, batch_list) {
 
 		list_del_init(&sh->batch_list);
 
-		WARN_ONCE(sh->state & ((1 << STRIPE_ACTIVE) |
-					  (1 << STRIPE_SYNCING) |
-					  (1 << STRIPE_REPLACED) |
-					  (1 << STRIPE_DELAYED) |
-					  (1 << STRIPE_BIT_DELAY) |
-					  (1 << STRIPE_FULL_WRITE) |
-					  (1 << STRIPE_BIOFILL_RUN) |
-					  (1 << STRIPE_COMPUTE_RUN)  |
-					  (1 << STRIPE_DISCARD) |
-					  (1 << STRIPE_BATCH_READY) |
-					  (1 << STRIPE_BATCH_ERR)),
-			"stripe state: %lx\n", sh->state);
-		WARN_ONCE(head_sh->state & ((1 << STRIPE_DISCARD) |
-					      (1 << STRIPE_REPLACED)),
-			"head stripe state: %lx\n", head_sh->state);
+		state = READ_ONCE(sh->state);
+		WARN_ONCE(state & ((1 << STRIPE_ACTIVE) |
+				   (1 << STRIPE_SYNCING) |
+				   (1 << STRIPE_REPLACED) |
+				   (1 << STRIPE_DELAYED) |
+				   (1 << STRIPE_BIT_DELAY) |
+				   (1 << STRIPE_FULL_WRITE) |
+				   (1 << STRIPE_BIOFILL_RUN) |
+				   (1 << STRIPE_COMPUTE_RUN)  |
+				   (1 << STRIPE_DISCARD) |
+				   (1 << STRIPE_BATCH_READY) |
+				   (1 << STRIPE_BATCH_ERR)),
+			"stripe state: %lx\n", state);
+
+		state = READ_ONCE(head_sh->state);
+		WARN_ONCE(state & ((1 << STRIPE_DISCARD) |
+				   (1 << STRIPE_REPLACED)),
+			"head stripe state: %lx\n", state);
 
 		set_mask_bits(&sh->state, ~(STRIPE_EXPAND_SYNC_FLAGS |
 					    (1 << STRIPE_PREREAD_ACTIVE) |
 					    (1 << STRIPE_ON_UNPLUG_LIST)),
-			      head_sh->state & (1 << STRIPE_INSYNC));
+			      state & (1 << STRIPE_INSYNC));
 
 		sh->check_state = head_sh->check_state;
 		sh->reconstruct_state = head_sh->reconstruct_state;
@@ -4872,8 +4876,9 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 			sh->dev[i].flags = head_sh->dev[i].flags &
 				(~((1 << R5_WriteError) | (1 << R5_Overlap)));
 		}
-		if (handle_flags == 0 ||
-		    sh->state & handle_flags)
+
+		state = READ_ONCE(sh->state);
+		if (handle_flags == 0 || (state & handle_flags))
 			set_bit(STRIPE_HANDLE, &sh->state);
 		raid5_release_stripe(sh);
 	}
@@ -4883,7 +4888,9 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 	for (i = 0; i < head_sh->disks; i++)
 		if (test_and_clear_bit(R5_Overlap, &head_sh->dev[i].flags))
 			wake_up_bit(&head_sh->dev[i].flags, R5_Overlap);
-	if (head_sh->state & handle_flags)
+
+	state = READ_ONCE(head_sh->state);
+	if (state & handle_flags)
 		set_bit(STRIPE_HANDLE, &head_sh->state);
 }
 
-- 
2.53.0



