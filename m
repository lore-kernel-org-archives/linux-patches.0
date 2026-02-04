Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0F92BD012;
	Wed,  4 Feb 2026 15:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217296; cv=none; b=reKnVR4hbl4nfwyTVlD0bYOPR7uatvFCvDlTMaPBo9rF0TUaLmQYBC7XAyrsI01TV0UQ2RqJqzbTcx83Wcm5dvxgvD0+Fgg6oFuaqWo/cGIzVOz1iB+xSZI0aXbRrYsNATRK6QQ2DJ8pKhDml1V9r9dlnT57LcPn3JV2JBDsguo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217296; c=relaxed/simple;
	bh=FLj484Xfg34QCvZtwF77bQTdVnaKCOrdYGJpEuqLG6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7ry3yQvvYd4ZJIGC2ZwzFAgrUF6qx6NRwSeffmUmTLs8+fIzXa+e4FhWgCm72+t8DlkFuvxXVzDsXLMmsYvuF9zzRih8EUy6YdzT9O6HRzP4V+ST/xn5ClRg2WHog2v3bBGsOT+rJXJ14MmtrEbtosx3YXD8BwQcGzvrU8aibo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXxvc6qG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXxvc6qG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7C1C116C6;
	Wed,  4 Feb 2026 15:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217296;
	bh=FLj484Xfg34QCvZtwF77bQTdVnaKCOrdYGJpEuqLG6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXxvc6qGzg0BNZeg2VZu+XewrEQTpgx3Z2Z/iiSY0utZdALPDAn/U3JxcdCTUDGTq
	 1R5zFf57fu8I7nKgzdFI8iF/b7ZcVeakgUh8/9y+gjL9AeD+jJCsvQy10W9Yix90rX
	 qfAMYyp/clCp1vBJI2QTH9AJmcqk+t22BSTNcBJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Zqiang <qiang.zhang@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 5.15 182/206] usbnet: Fix using smp_processor_id() in preemptible code warnings
Date: Wed,  4 Feb 2026 15:40:13 +0100
Message-ID: <20260204143904.774143890@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ The context change is due to the commit 2c04d279e857
("net: usb: Convert tasklet API to new bottom half workqueue mechanism")
in v6.17 which is irrelevant to the logic of this patch.]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -707,6 +707,7 @@ void usbnet_resume_rx(struct usbnet *dev
 	struct sk_buff *skb;
 	int num = 0;
 
+	local_bh_disable();
 	clear_bit(EVENT_RX_PAUSED, &dev->flags);
 
 	while ((skb = skb_dequeue(&dev->rxq_pause)) != NULL) {
@@ -715,6 +716,7 @@ void usbnet_resume_rx(struct usbnet *dev
 	}
 
 	tasklet_schedule(&dev->bh);
+	local_bh_enable();
 
 	netif_dbg(dev, rx_status, dev->net,
 		  "paused rx queue disabled, %d skbs requeued\n", num);


