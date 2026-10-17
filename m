Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A568D3C09EF;
	Sat, 17 Oct 2026 17:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259219; cv=none; b=qsbg0rqpfctHkbIdTOVDK1CgmFjtWEby0kqRwTXl8B7bRjnH7A1/ZrW5FTHty/CZUaGyXytQPqBVgrbj33HNRQcS7D7NSuqxsQWsok+W1IYc3UZxAae/YgThc6Tvzy9zn36AYYZoPpP58ty1Fc5EjU2MbmKNr6o+kWfyr+W/Tg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259219; c=relaxed/simple;
	bh=9OjwjHSKnR0DiKtNMOdNoB2LPpcwM+zShvu5ntsvz1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lu9882THqB2LQfoTCo8idY/IbeIc+T9cDJeDm2kjRg5tD/AhnKu3sn4znwbeQCvRA8dKQtVXXpWzxjxrroeOmHIyBOgGBOQPSAgl7QJ0omqb1aOBDOHidR5yF5ouYG96z17v4A0b9c4rM5u0dso0ODkxEHAP9V5BitPuea9LxI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bpz5psWR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bpz5psWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084071F000C4;
	Sat, 17 Oct 2026 17:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259218;
	bh=ttdl4yUIFIPjXkjiU6E9LOo2id2kFZdoWy1LRNOT5Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bpz5psWRwOUl/qln5OgGhtTMu0ID0Vy7WhjlhFI4mXn7tGQ+/qgOcqjSnD2pGwU10
	 SahUdI5djti4lo13rKiMH0ooU+zbO0bgCt/dijcr8yH6Csv+L5KE8xf0aBP85jc0Vd
	 4IiKkxk4KcxOqpYr2EPWzqGwtfqXdpj4iCLEmFWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1140/1674] md/raid5: avoid R5_Overlap races while breaking stripe batches
Date: Sat, 17 Oct 2026 17:56:52 +0200
Message-ID: <20261017160500.420687653@linuxfoundation.org>
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

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 55b77337bdd088c77461588e5ec094421b89911b ]

KCSAN report a race in break_stripe_batch_list() vs. raid5_make_request()
on sh->dev[i].flags (plain word write vs. atomic bit op)..

and .. one possible scenario is:

CPU1                            CPU2
break_stripe_batch_list(sh1)
-> handle sh2
-> lock(sh2)
-> sh2->batch_head = NULL
-> unlock(sh2)
-> test_and_clear_bit(R5_Overlap, sh2->dev[i].flags)
-> wake_up_bit(sh2->dev[i].flags)
                                raid5_make_request()
                                -> add_all_stripe_bios(sh2)
                                -> lock(sh2)
                                -> stripe_bio_overlaps(sh2) returns true
				   batch_head is NULL, so new bio overlap
				   exist bio on sh2 -> true
                                -> set_bit(R5_Overlap, sh2->dev[i].flags)
                                -> unlock(sh2)
                                -> wait_on_bit(sh2->dev[i].flags)
-> sh2->dev[i].flags = sh1->dev[i].flags & ~R5_Overlap

No wait_up_bit(), CPU2 could be wait_on_bit() forever...

Fix by :
- Expand the protect zone.
- Use batch_head's device flag's snaphot when no held head_sh->stripe_lock.
- Move sh/head_sh->batch_head = NULL to the end of protected zone , and ,
  any concurrent add_all_stripe_bios() grabs sh->stripe_lock now either:
	- see batch_head != null, and , is rejected by stripe_bio_overlaps()
	  under the lock (no R5_Overlap wait ) , or ,
	- sees batch_head == NULL, only after dev[i].flags has already been
	  set and the prior R5_Overlap waiters worken.

KCSAN report:
================================================
  BUG: KCSAN: data-race in break_stripe_batch_list / raid5_make_request

  write (marked) to 0xffff8e89c8117548 of 8 bytes by task 4042 on cpu 0:
    raid5_make_request+0xea0/0x2930
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
    __x64_sys_io_submit+0xf7/0x220
    x64_sys_call+0x1907/0x1c60
    do_syscall_64+0x130/0x570
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

  read to 0xffff8e89c8117548 of 8 bytes by task 4010 on cpu 5:
    break_stripe_batch_list+0x249/0x480
    handle_stripe_clean_event+0x720/0x9b0
    handle_stripe+0x32fb/0x4500
    handle_active_stripes.isra.0+0x6e0/0xa50
    raid5d+0x7e0/0xba0
    md_thread+0x15a/0x2d0
    kthread+0x1e3/0x220
    ret_from_fork+0x37a/0x410
    ret_from_fork_asm+0x1a/0x30

  value changed: 0x0000000000000019 -> 0x0000000000000099 --> R5_Overlap

Fixes: fb642b92c267 ("md/raid5: duplicate some more handle_stripe_clean_event code in break_stripe_batch_list")

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Link: https://patch.msgid.link/20260619041013.1207148-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d83b23b122171..ac14655c85d66 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4916,25 +4916,25 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 		sh->check_state = head_sh->check_state;
 		sh->reconstruct_state = head_sh->reconstruct_state;
 		spin_lock_irq(&sh->stripe_lock);
-		sh->batch_head = NULL;
-		spin_unlock_irq(&sh->stripe_lock);
 		for (i = 0; i < sh->disks; i++) {
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				do_wakeup = 1;
-			sh->dev[i].flags = head_sh->dev[i].flags &
+			sh->dev[i].flags = READ_ONCE(head_sh->dev[i].flags) &
 				(~((1 << R5_WriteError) | (1 << R5_Overlap)));
 		}
+		sh->batch_head = NULL;
+		spin_unlock_irq(&sh->stripe_lock);
 		if (handle_flags == 0 ||
 		    sh->state & handle_flags)
 			set_bit(STRIPE_HANDLE, &sh->state);
 		raid5_release_stripe(sh);
 	}
 	spin_lock_irq(&head_sh->stripe_lock);
-	head_sh->batch_head = NULL;
-	spin_unlock_irq(&head_sh->stripe_lock);
 	for (i = 0; i < head_sh->disks; i++)
 		if (test_and_clear_bit(R5_Overlap, &head_sh->dev[i].flags))
 			do_wakeup = 1;
+	head_sh->batch_head = NULL;
+	spin_unlock_irq(&head_sh->stripe_lock);
 	if (head_sh->state & handle_flags)
 		set_bit(STRIPE_HANDLE, &head_sh->state);
 
-- 
2.53.0



