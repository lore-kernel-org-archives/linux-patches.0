Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D03388E40;
	Tue, 21 Jul 2026 19:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661080; cv=none; b=FBYA6EXZA+UKOEx7IV5fVjtdIEAHg5+1F1JuNgELvBK4tlUL3FLFEoPVi+IMgfHMOqbpf7vEKmjSKChtYwuSisHYSjVvPJHRqa4EZBDw7Lt0nx6/UZ1LAh+7jyKHCCIRKR1inj9p2pyzuI6AQ5xbbG92nDTYZVxU0HFugcOrAx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661080; c=relaxed/simple;
	bh=okntFbA0W1OwcR0hR3yWdcCUqOTEkQ9rkzaH9JnkyPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tluohKW415XrW6rT/Bdm6/5RqiF4w+EOPQSA3byfWwZ3+/dPzGyra74gOaqLygOTQE4U2HjfFuyz7kupAKq92vN44ZwY2WIFy6zcvSEgQXjr+LjnERMYEEUXi1DVk30bIyYIzB3gYbjeRJVRPgeE52dwKtU2a7wtplUX9TziHBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCKPCoHy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCKPCoHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8B21F000E9;
	Tue, 21 Jul 2026 19:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661079;
	bh=p6i52TpJqhvNqQr71wZrD91nVBRdhZLKL0/Mzp6KwVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCKPCoHy9YtcEk4X57ykww+l4CJkuC936BfGlQdQZEf+7zw/8O7Y8ktH36TfZyO3t
	 kIWMU523D7HgqIoelZBeMMLF0ndP98lC1wPRQThaZVDUey937xUlPAbqewM98wqSaa
	 vpoxx5g8kcT442B0P0ixlmoWLieHzQCbe26YS5J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1223/2077] md/raid5: use stripe state snapshot in break_stripe_batch_list()
Date: Tue, 21 Jul 2026 17:14:56 +0200
Message-ID: <20260721152621.658808799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0d76e82f4506e6..133d5e5f0dce57 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4837,31 +4837,35 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
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
@@ -4874,8 +4878,9 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
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
@@ -4885,7 +4890,9 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
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



