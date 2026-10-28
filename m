Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215514;
	b=4No2AQD0pnkJhGH/WbXnma6lm3tess+FUDxC8gEPjAOhwCZ06+e9X/TXoGGVzs4eb1O/
	 B+Fe8inbRygOULPh7f5orQbaSIP2Nn3ALtD5R4Z/jECgKKnxk85/UISwSxmNT9iQhelRn
	 fFACCV+thWvDHPyGKTh95b+26hq4dQ5XDWOri/a385igq/K0bd226ypPeD3mNGQpD/YXE
	 3nwiUrmxe7i7XGr3HYuofaJgGgPsk0C0cCt7gjsqNWsI9IrX9UNKdO2tGsb8IWkGPuSy8
	 ztFVzFdlsulcOKGZJUYJIRJH/hHUkjNaoW51P8zi8LErQxRAxY6lQLx7pz1U67B/euw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EjqSHG2sbw8604nssVDDJQroCJw5T9NJIuLNBOSNJXc=;
	b=I30BxTNduECp7leLXmwtivLDJuVVye2m+1t54Cy0o0YQhPZOhDCF3zxyRLvhKYx0TW+X
	 kU/AMXJ1NFpEVJHikiYH57xqh8lkqBQTYKlzVZAakQ2jB50v0Y9wboYpx4fn1Xm5fww4p
	 0kLjgEMo3wJC5G4vOczRQIkzTYcNP5HpCMk5z6Wl98d5+gAE719zZIXr/j/D05xB7BeqR
	 dzGjoBNgrUUVkxyS0yj0MVicT/wPPMI8I1Y03ZqIsJMB+auGk77f3pTyffvZa+qFablz9
	 7dGTlegTO7HWt+26dOJWhzbgQZ3xfYWBGDn66Hc+eaS5Gai0B5Mfpl3CqTSR+YYPBqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V3Wx9KtQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CDE606A322;
	Wed, 28 Oct 2026 19:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V3Wx9KtQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D1D1F01825;
	Wed, 28 Oct 2026 19:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215514;
	bh=EjqSHG2sbw8604nssVDDJQroCJw5T9NJIuLNBOSNJXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V3Wx9KtQ1n3ytJJiUTQgnpyGZTxe8Dw//45sjm5sKId9JtdUjLBK8YQCbxLJcMsU8
	 VMEe64KLiiiv9uwEmp2rUD1gWSr7MSLb8QSMu7Ldo/Eb7Y32/MxP4Y0Vyd1x5mv7y1
	 xY1jNpMBbZ1E5nf+rYjKlVma1wQ5QTymYXy8Av10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1238/1887] md/raid5: avoid R5_Overlap races while breaking stripe batches
Date: Wed, 28 Oct 2026 17:55:34 +0100
Message-ID: <20261028170527.595289638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/md/raid5.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dd0864df1d8cf..092cf1d0008ee 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4958,25 +4958,27 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
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
+
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
+
 	if (head_sh->state & handle_flags)
 		set_bit(STRIPE_HANDLE, &head_sh->state);
 
-- 
2.53.0



