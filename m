Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A681A76A7;
	Tue, 30 Jul 2024 17:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359843; cv=none; b=ZYIL5csXNouPwe8durzzukx7o356ECrk37dYSRrS20UhCPBJcXXaJEmK69wOB97/zRopmv23LzwAeUmF9YAamJvPGYrLjGBeKYPK441zqJ+TA6db0sITg5xbILndBTA6sF3zq2DYQ+4fVO//nFX5si7sMsYq3p+YlnFKULKjXG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359843; c=relaxed/simple;
	bh=7BZ/lXKNtwLKxW3WTP6ccYcTkvPEldBUjljA5V43FyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NafypgiCiDxy7qM5xnW0Tz8ab5gPlWV4PlBl8lgDuF2m2wEk2HPtc+I7bwfmZR3aCfackTUjDSZKm4CNxTPv/ZKKAolIn1lLQd+DDGO7IZIPLY6tBAvD6STmz1Tthx5GoGyud6BBseZCjIMhyjOrL8qVSKcwU8u5BVtqG8WOqI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEZ69w0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEZ69w0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAABC32782;
	Tue, 30 Jul 2024 17:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359843;
	bh=7BZ/lXKNtwLKxW3WTP6ccYcTkvPEldBUjljA5V43FyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEZ69w0oAPkjHoYV+nxivXu1leu1mb5dUCqoRmtzRzVRJ/YAuf2mZDo/1nY+YoeXn
	 S9DibeqRih4uoU6G5pnfH5LWJ6XquxkOXobAJz9UjfMRKnH07sGqLR9GMm2qTmU5X9
	 EXwOM/EGF5mBDc/vgcwUxecKb2PLlwKod9WzFUbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 545/568] apparmor: Fix null pointer deref when receiving skb during sock creation
Date: Tue, 30 Jul 2024 17:50:52 +0200
Message-ID: <20240730151701.463802905@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Liang <shaw.leon@gmail.com>

[ Upstream commit fce09ea314505a52f2436397608fa0a5d0934fb1 ]

The panic below is observed when receiving ICMP packets with secmark set
while an ICMP raw socket is being created. SK_CTX(sk)->label is updated
in apparmor_socket_post_create(), but the packet is delivered to the
socket before that, causing the null pointer dereference.
Drop the packet if label context is not set.

    BUG: kernel NULL pointer dereference, address: 000000000000004c
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 0 P4D 0
    Oops: 0000 [#1] PREEMPT SMP NOPTI
    CPU: 0 PID: 407 Comm: a.out Not tainted 6.4.12-arch1-1 #1 3e6fa2753a2d75925c34ecb78e22e85a65d083df
    Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 05/28/2020
    RIP: 0010:aa_label_next_confined+0xb/0x40
    Code: 00 00 48 89 ef e8 d5 25 0c 00 e9 66 ff ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 0f 1f 44 00 00 89 f0 <8b> 77 4c 39 c6 7e 1f 48 63 d0 48 8d 14 d7 eb 0b 83 c0 01 48 83 c2
    RSP: 0018:ffffa92940003b08 EFLAGS: 00010246
    RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000e
    RDX: ffffa92940003be8 RSI: 0000000000000000 RDI: 0000000000000000
    RBP: ffff8b57471e7800 R08: ffff8b574c642400 R09: 0000000000000002
    R10: ffffffffbd820eeb R11: ffffffffbeb7ff00 R12: ffff8b574c642400
    R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
    FS:  00007fb092ea7640(0000) GS:ffff8b577bc00000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 000000000000004c CR3: 00000001020f2005 CR4: 00000000007706f0
    PKRU: 55555554
    Call Trace:
     <IRQ>
     ? __die+0x23/0x70
     ? page_fault_oops+0x171/0x4e0
     ? exc_page_fault+0x7f/0x180
     ? asm_exc_page_fault+0x26/0x30
     ? aa_label_next_confined+0xb/0x40
     apparmor_secmark_check+0xec/0x330
     security_sock_rcv_skb+0x35/0x50
     sk_filter_trim_cap+0x47/0x250
     sock_queue_rcv_skb_reason+0x20/0x60
     raw_rcv+0x13c/0x210
     raw_local_deliver+0x1f3/0x250
     ip_protocol_deliver_rcu+0x4f/0x2f0
     ip_local_deliver_finish+0x76/0xa0
     __netif_receive_skb_one_core+0x89/0xa0
     netif_receive_skb+0x119/0x170
     ? __netdev_alloc_skb+0x3d/0x140
     vmxnet3_rq_rx_complete+0xb23/0x1010 [vmxnet3 56a84f9c97178c57a43a24ec073b45a9d6f01f3a]
     vmxnet3_poll_rx_only+0x36/0xb0 [vmxnet3 56a84f9c97178c57a43a24ec073b45a9d6f01f3a]
     __napi_poll+0x28/0x1b0
     net_rx_action+0x2a4/0x380
     __do_softirq+0xd1/0x2c8
     __irq_exit_rcu+0xbb/0xf0
     common_interrupt+0x86/0xa0
     </IRQ>
     <TASK>
     asm_common_interrupt+0x26/0x40
    RIP: 0010:apparmor_socket_post_create+0xb/0x200
    Code: 08 48 85 ff 75 a1 eb b1 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 41 54 <55> 48 89 fd 53 45 85 c0 0f 84 b2 00 00 00 48 8b 1d 80 56 3f 02 48
    RSP: 0018:ffffa92940ce7e50 EFLAGS: 00000286
    RAX: ffffffffbc756440 RBX: 0000000000000000 RCX: 0000000000000001
    RDX: 0000000000000003 RSI: 0000000000000002 RDI: ffff8b574eaab740
    RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
    R10: ffff8b57444cec70 R11: 0000000000000000 R12: 0000000000000003
    R13: 0000000000000002 R14: ffff8b574eaab740 R15: ffffffffbd8e4748
     ? __pfx_apparmor_socket_post_create+0x10/0x10
     security_socket_post_create+0x4b/0x80
     __sock_create+0x176/0x1f0
     __sys_socket+0x89/0x100
     __x64_sys_socket+0x17/0x20
     do_syscall_64+0x5d/0x90
     ? do_syscall_64+0x6c/0x90
     ? do_syscall_64+0x6c/0x90
     ? do_syscall_64+0x6c/0x90
     entry_SYSCALL_64_after_hwframe+0x72/0xdc

Fixes: ab9f2115081a ("apparmor: Allow filtering based on secmark policy")
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 366cdfd6a7baf..5303a51eff9c1 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -1130,6 +1130,13 @@ static int apparmor_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	if (!skb->secmark)
 		return 0;
 
+	/*
+	 * If reach here before socket_post_create hook is called, in which
+	 * case label is null, drop the packet.
+	 */
+	if (!ctx->label)
+		return -EACCES;
+
 	return apparmor_secmark_check(ctx->label, OP_RECVMSG, AA_MAY_RECEIVE,
 				      skb->secmark, sk);
 }
-- 
2.43.0



