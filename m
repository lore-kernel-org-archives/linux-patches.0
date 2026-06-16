Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5028B3CC303;
	Tue, 16 Jun 2026 18:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636003; cv=none; b=QxifNImN8lWfu0FUQNpesrNIulW4DiEj9yHsnVifr6HZ0/Tje7OZ5Rg8gTXjdK90vx+4a7kQKH5EfvCOevDu+GCnWCv7GGd+ZglSuxSieoLKJto7hIwLJgoN+PblMgirmnH0FqdWXVAPrUpr8R0K8n+JYoBmjZkSPoNG67e02L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636003; c=relaxed/simple;
	bh=37y1V9u5gyB9J2JN58b2o5XJ5swAK/YzXs13A4OqLb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6zLlZ+/TAX2qiUoKBfYrJfzRttea55rrtYRHJLrnZbUmlasvaywZL0lj6kz9dzLFT7Jz56ZVaagwuZKb1oXzYl/BVWwRoknxNKSm7WXxdIwhG4m2lMMskEcH0OXBPmE/wI4giUNLBMrrzSrRNbKPKe0F1lpoVX4NMvBX7jIzMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjq2OzhI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjq2OzhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496E01F000E9;
	Tue, 16 Jun 2026 18:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636002;
	bh=uz0uqLkopI5p4YSalrtaZ7g7IY2R/dsHXMLz1IdVayQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tjq2OzhI5WTfgDNEiIk8bZPn+8jjBk/79Pq3p2mY/WO7Vfkt+a8+6QV8L5IUw6ZtN
	 4VUSId8MQ8hw0vk2ylONV8VxsOF4K0o+6yIfeVVEYIltjrR4XucjJjezGObmX5hw4B
	 hYcDZHlrCSCzklwnz9lQUQEkV8geFsCMXYKnhjKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Zqiang <qiang.zhang@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexey Panov <apanov@astralinux.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/342] usbnet: Fix using smp_processor_id() in preemptible code warnings
Date: Tue, 16 Jun 2026 20:27:31 +0530
Message-ID: <20260616145055.380558271@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Zqiang <qiang.zhang@linux.dev>

commit 327cd4b68b4398b6c24f10eb2b2533ffbfc10185 upstream.

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
[ Alexey: Keep tasklet_schedule() because commit 2c04d279e857 ("net: usb:
  Convert tasklet API to new bottom half workqueue mechanism") is not present
  in linux-5.10.y. ]
Signed-off-by: Alexey Panov <apanov@astralinux.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 4a83228a2db578..4b34544d88aa86 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -684,6 +684,7 @@ void usbnet_resume_rx(struct usbnet *dev)
 	struct sk_buff *skb;
 	int num = 0;
 
+	local_bh_disable();
 	clear_bit(EVENT_RX_PAUSED, &dev->flags);
 
 	while ((skb = skb_dequeue(&dev->rxq_pause)) != NULL) {
@@ -692,6 +693,7 @@ void usbnet_resume_rx(struct usbnet *dev)
 	}
 
 	tasklet_schedule(&dev->bh);
+	local_bh_enable();
 
 	netif_dbg(dev, rx_status, dev->net,
 		  "paused rx queue disabled, %d skbs requeued\n", num);
-- 
2.53.0



