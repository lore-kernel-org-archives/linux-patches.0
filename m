Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554A4439354;
	Tue, 21 Jul 2026 21:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669773; cv=none; b=FvMUIyWNxvdqQI1I6BNnl15ccLpCXcEfX2jInTY4QbsPnZB8d8Q2FerifgAlFZd0Z/o+8iMAuBvPT7MW88HWXfpWOJMh2lHnELNwfZd5rP/S0aEvR9dipuISAH+VALqu7pmtoO97jwXlaOW4T7FFAcCsmqwmxkJGiCpvDST5CFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669773; c=relaxed/simple;
	bh=MNPugJPNVlyU5QzqDjMgPOETlDOCdG5TUY3lOYJeex8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KovQ6+0yJp4jnUHxuFXw1siLjd/dpYqfsOQkIxcblX2iO3AIUIAy9gwyTvLGrpLiNOlts0/7iwtEPerzrJZB6weNE7/N1auHntHFqXe4jxw/fNIBBVyIMn/qgPTLesuhkQudZexo3FqptWwcvyfS4fTxvYMElREM1ILzrpWfDB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAeRd9N3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAeRd9N3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49BE1F000E9;
	Tue, 21 Jul 2026 21:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669772;
	bh=2zVHlRHRoEkLnxiY/qr1CugrtgMNS98uWi2Opi4qjNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nAeRd9N3p0Xub8Mv+pBmC1QRUn82u9jKm1aB9tryYlMLxuNqFGG+j7dA4id2wnkM7
	 VyFEhnnX4ngOUqgUMwhTGnPU0v1hlKLMyy5OcJRg54WdGDw1Yf7qnyuChfykfr5E7+
	 lpHIpM80oPtnAMu+7ok4ryjZJtJPIMCOCuNrkDQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0681/1067] net: usb: net1080: validate packet_len before pad-byte access in rx_fixup
Date: Tue, 21 Jul 2026 17:21:22 +0200
Message-ID: <20260721152439.832457200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 03f384bc0cb8d4a1301d4f5b0baef2d980258383 ]

For an even packet_len, net1080_rx_fixup() reads the pad byte at
skb->data[packet_len] before the skb->len != packet_len check further
down, and packet_len is only bounded against NC_MAX_PACKET. A malicious
NetChip 1080 device can send a short frame advertising a large even
packet_len (e.g. 0x4000), so the pad-byte read lands past the end of the
skb:

  BUG: KASAN: slab-out-of-bounds in net1080_rx_fixup
  Read of size 1 at addr ffff8880106c83c6 by task ksoftirqd/0/14
   ...
   net1080_rx_fixup (drivers/net/usb/net1080.c:384)
   usbnet_bh (drivers/net/usb/usbnet.c:1589)
   process_one_work (kernel/workqueue.c:3322)
   bh_worker (kernel/workqueue.c:3708)
   tasklet_action (kernel/softirq.c:965)
   handle_softirqs (kernel/softirq.c:622)
   ...

Reject the frame when packet_len >= skb->len before reading.

Fixes: 904813cd8a0b ("[PATCH] USB: usbnet (4/9) module for net1080 cables")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260630045121.1565324-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/net1080.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/net1080.c b/drivers/net/usb/net1080.c
index b0c0c9dd6a028d..8a66549cefa7df 100644
--- a/drivers/net/usb/net1080.c
+++ b/drivers/net/usb/net1080.c
@@ -381,7 +381,7 @@ static int net1080_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	skb_trim(skb, skb->len - sizeof *trailer);
 
 	if ((packet_len & 0x01) == 0) {
-		if (skb->data [packet_len] != PAD_BYTE) {
+		if (packet_len >= skb->len || skb->data[packet_len] != PAD_BYTE) {
 			dev->net->stats.rx_frame_errors++;
 			netdev_dbg(dev->net, "bad pad\n");
 			return 0;
-- 
2.53.0



