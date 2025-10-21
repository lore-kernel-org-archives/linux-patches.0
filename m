Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F271B25A355;
	Tue, 21 Oct 2025 20:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077355; cv=none; b=TOwEE86Qebx0jhmZnEfIVuQDnNA0H9Bqr1EIaidQZxnaRQptzWazbImckYtKfedVdblKeN371XmQCFG6aRUiKyJLuw/TCh1n5Lali7SEc0x85D+qrPzuvkvHZ4MaWa+mfh7CBkaAaBMAwJwOl1xkyqcdgvvPBtv3t48qzPRkAVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077355; c=relaxed/simple;
	bh=qyucbPzcgAfEC0gKbv/1Jesim55GBYh9Z0fil1DXZn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmEIZsG6H4z7PrYB27Ms8Vj6G/f3naZQOefg65YQU1QrATlinhO3dBUXrz6AEACIMNEcVBVFYxmPxZZYrn89495WkqTGzPzuso6Md9AwdTuG1jdNp/N2rjR8XaApwJLtzIQPXARhGYCC1F6yAzr5RqwvduClZDX2wv9HBOBl+dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTIDeEaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTIDeEaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F551C4CEF1;
	Tue, 21 Oct 2025 20:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077354;
	bh=qyucbPzcgAfEC0gKbv/1Jesim55GBYh9Z0fil1DXZn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTIDeEaThD42M07IUjOhnkS52+5wUm20ek+WrS5n6ZNc+gShAwC8OYI0/87uTl/SD
	 HSh6fRy1rXv181W+SqXPgZ5NhGYhfW2wjjcaUUyhZfeBvNTTJ9ZBqFImrSHQJk9zHs
	 s0QWIlM+0gFDUB9GlqkVmqDuNh6caMdok1Of38EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Zqiang <qiang.zhang@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 078/159] usbnet: Fix using smp_processor_id() in preemptible code warnings
Date: Tue, 21 Oct 2025 21:50:55 +0200
Message-ID: <20251021195045.072651739@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang@linux.dev>

[ Upstream commit 327cd4b68b4398b6c24f10eb2b2533ffbfc10185 ]

Syzbot reported the following warning:

BUG: using smp_processor_id() in preemptible [00000000] code: dhcpcd/2879
caller is usbnet_skb_return+0x74/0x490 drivers/net/usb/usbnet.c:331
CPU: 1 UID: 0 PID: 2879 Comm: dhcpcd Not tainted 6.15.0-rc4-syzkaller-00098-g615dca38c2ea #0 PREEMPT(voluntary)
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x16c/0x1f0 lib/dump_stack.c:120
 check_preemption_disabled+0xd0/0xe0 lib/smp_processor_id.c:49
 usbnet_skb_return+0x74/0x490 drivers/net/usb/usbnet.c:331
 usbnet_resume_rx+0x4b/0x170 drivers/net/usb/usbnet.c:708
 usbnet_change_mtu+0x1be/0x220 drivers/net/usb/usbnet.c:417
 __dev_set_mtu net/core/dev.c:9443 [inline]
 netif_set_mtu_ext+0x369/0x5c0 net/core/dev.c:9496
 netif_set_mtu+0xb0/0x160 net/core/dev.c:9520
 dev_set_mtu+0xae/0x170 net/core/dev_api.c:247
 dev_ifsioc+0xa31/0x18d0 net/core/dev_ioctl.c:572
 dev_ioctl+0x223/0x10e0 net/core/dev_ioctl.c:821
 sock_do_ioctl+0x19d/0x280 net/socket.c:1204
 sock_ioctl+0x42f/0x6a0 net/socket.c:1311
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl fs/ioctl.c:892 [inline]
 __x64_sys_ioctl+0x190/0x200 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x260 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

For historical and portability reasons, the netif_rx() is usually
run in the softirq or interrupt context, this commit therefore add
local_bh_disable/enable() protection in the usbnet_resume_rx().

Fixes: 43daa96b166c ("usbnet: Stop RX Q on MTU change")
Link: https://syzkaller.appspot.com/bug?id=81f55dfa587ee544baaaa5a359a060512228c1e1
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Zqiang <qiang.zhang@linux.dev>
Link: https://patch.msgid.link/20251011070518.7095-1-qiang.zhang@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 511c4154cf742..bf01f27285318 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -702,6 +702,7 @@ void usbnet_resume_rx(struct usbnet *dev)
 	struct sk_buff *skb;
 	int num = 0;
 
+	local_bh_disable();
 	clear_bit(EVENT_RX_PAUSED, &dev->flags);
 
 	while ((skb = skb_dequeue(&dev->rxq_pause)) != NULL) {
@@ -710,6 +711,7 @@ void usbnet_resume_rx(struct usbnet *dev)
 	}
 
 	queue_work(system_bh_wq, &dev->bh_work);
+	local_bh_enable();
 
 	netif_dbg(dev, rx_status, dev->net,
 		  "paused rx queue disabled, %d skbs requeued\n", num);
-- 
2.51.0



