Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E793A3BFE29;
	Thu, 15 Jan 2026 17:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499454; cv=none; b=gB9bmKydtEsuSs2iaTlq4VfdMTKEF/8dHS0rT7TFRm/7ADQCZlCaBj40Z6q3M0C8m4VYI/wQO3/9NRC45DvhniXwMJ0nRb73FCfe/6fWRWW/JQ/VCruqpJbeE2Z9ZKqCK09D2vFfVzvcvaqJ3a/bkJAgHs0edhcd3JF1q+CdpIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499454; c=relaxed/simple;
	bh=oFlVOK4NoqB70FLie9kycd9jzD1mVb3DAyMmSKnPO7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/3NVI10+6V0bXfkxIuTsCnutBGjqEWcko1zs3udU3uKudiL4zRBBitl8/LWRxXqQ9QN04mtPnDwpzjjMAYBx3Y7G29D38Ot2aF5ameQCcbS3tyxbVJg3GVEehc1Y+V+GHr28bQKln8ZgnacMMjwb+Tpl3M48Ku7EE4bSIsr8rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CY9hixoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CY9hixoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E410C116D0;
	Thu, 15 Jan 2026 17:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499453;
	bh=oFlVOK4NoqB70FLie9kycd9jzD1mVb3DAyMmSKnPO7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CY9hixoRnR6SgzJIs1Knhs0fEmg6egF0KB1acLOGJl9qsDZOIGfTXBjFy1X5UBitE
	 orEIrSai0mmAJ3h0k/gikcvC7zG2zfiGnZLopaG2nzS1/qRVRsZhokLVgd0gINTS/W
	 Rm37lPWwMlRqjUqPOMUrQ979EmSsdrS/tN/G/5+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2fa344348a579b779e05@syzkaller.appspotmail.com,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	Felix Maurer <fmaurer@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 199/451] net/hsr: fix NULL pointer dereference in prp_get_untagged_frame()
Date: Thu, 15 Jan 2026 17:46:40 +0100
Message-ID: <20260115164238.100142938@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>

commit 188e0fa5a679570ea35474575e724d8211423d17 upstream.

prp_get_untagged_frame() calls __pskb_copy() to create frame->skb_std
but doesn't check if the allocation failed. If __pskb_copy() returns
NULL, skb_clone() is called with a NULL pointer, causing a crash:

Oops: general protection fault, probably for non-canonical address 0xdffffc000000000f: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000078-0x000000000000007f]
CPU: 0 UID: 0 PID: 5625 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:skb_clone+0xd7/0x3a0 net/core/skbuff.c:2041
Code: 03 42 80 3c 20 00 74 08 4c 89 f7 e8 23 29 05 f9 49 83 3e 00 0f 85 a0 01 00 00 e8 94 dd 9d f8 48 8d 6b 7e 49 89 ee 49 c1 ee 03 <43> 0f b6 04 26 84 c0 0f 85 d1 01 00 00 44 0f b6 7d 00 41 83 e7 0c
RSP: 0018:ffffc9000d00f200 EFLAGS: 00010207
RAX: ffffffff892235a1 RBX: 0000000000000000 RCX: ffff88803372a480
RDX: 0000000000000000 RSI: 0000000000000820 RDI: 0000000000000000
RBP: 000000000000007e R08: ffffffff8f7d0f77 R09: 1ffffffff1efa1ee
R10: dffffc0000000000 R11: fffffbfff1efa1ef R12: dffffc0000000000
R13: 0000000000000820 R14: 000000000000000f R15: ffff88805144cc00
FS:  0000555557f6d500(0000) GS:ffff88808d72f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555581d35808 CR3: 000000005040e000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 hsr_forward_do net/hsr/hsr_forward.c:-1 [inline]
 hsr_forward_skb+0x1013/0x2860 net/hsr/hsr_forward.c:741
 hsr_handle_frame+0x6ce/0xa70 net/hsr/hsr_slave.c:84
 __netif_receive_skb_core+0x10b9/0x4380 net/core/dev.c:5966
 __netif_receive_skb_one_core net/core/dev.c:6077 [inline]
 __netif_receive_skb+0x72/0x380 net/core/dev.c:6192
 netif_receive_skb_internal net/core/dev.c:6278 [inline]
 netif_receive_skb+0x1cb/0x790 net/core/dev.c:6337
 tun_rx_batched+0x1b9/0x730 drivers/net/tun.c:1485
 tun_get_user+0x2b65/0x3e90 drivers/net/tun.c:1953
 tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1999
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x5c9/0xb30 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0449f8e1ff
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 f9 92 02 00 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 4c 93 02 00 48
RSP: 002b:00007ffd7ad94c90 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f044a1e5fa0 RCX: 00007f0449f8e1ff
RDX: 000000000000003e RSI: 0000200000000500 RDI: 00000000000000c8
RBP: 00007ffd7ad94d20 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000003e R11: 0000000000000293 R12: 0000000000000001
R13: 00007f044a1e5fa0 R14: 00007f044a1e5fa0 R15: 0000000000000003
 </TASK>

Add a NULL check immediately after __pskb_copy() to handle allocation
failures gracefully.

Reported-by: syzbot+2fa344348a579b779e05@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2fa344348a579b779e05
Fixes: f266a683a480 ("net/hsr: Better frame dispatch")
Cc: stable@vger.kernel.org
Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
Reviewed-by: Felix Maurer <fmaurer@redhat.com>
Tested-by: Felix Maurer <fmaurer@redhat.com>
Link: https://patch.msgid.link/20251129093718.25320-1-ssrane_b23@ee.vjti.ac.in
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_forward.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -134,6 +134,8 @@ struct sk_buff *prp_get_untagged_frame(s
 				__pskb_copy(frame->skb_prp,
 					    skb_headroom(frame->skb_prp),
 					    GFP_ATOMIC);
+			if (!frame->skb_std)
+				return NULL;
 		} else {
 			/* Unexpected */
 			WARN_ONCE(1, "%s:%d: Unexpected frame received (port_src %s)\n",


