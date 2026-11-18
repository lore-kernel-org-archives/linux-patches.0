Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022015;
	b=yWOf7C4h6skFWjoz7g38FYoZ89hOgksMa7nloWZ19G8M+jCDWvnbEL8KaEwP+bFUh0F2
	 FPip+GebTMKHV+eySGL4pDwDxxAG9GSLWWQqNZrEOt12DiFq6wcsSq1yda0cCE1ZtKZCD
	 d574L3Zk80o523l8ZdnF04EQIGtxySr6pN8kDugIHKdjKd/dlMiJ9xKtFvi4Yd+Bv2+Vi
	 YhI6B+IGu40q8ARhhvoixWvoJkuIFgaQI7F0jPeMyRW/t1j2PULIxW9ZraAbxchGvUmfd
	 OxVmEOOnx2e5mWXvoM1ddGkula/PRByElhnuBZGmsgT55/BcmNPiERS08F/C9oc1OnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FHFIlGgeTjDvITLjxWhXyTXQazMAbnMSkot7S1QsDho=;
	b=D1/OZnKDXV8DVzCfVYAaVwt4s+shnG6lp7V9pG8PpQjowGVcvJaOgWyaZW+7mtjrE0TL
	 gw8e4Ye+5rpu5/xcfdGexZ6lx1HZ8vRt6ssAOL5OezqND6gx5L9ShyXbs+1rGKh88FBSm
	 l6mQv9oOUjwlER3ch4ImkntPN0bGJSqErXq/kWOVukymdfCzNy2+pan0T3Po38kiG+9Sv
	 Ak1QVfTor25wGDQ3Gc5dh1VxaPq0nLu1AjOjVRwk/SwzLknJiHnBH2UdeQZDPF7we4bna
	 E8MmiU+uGKQijcNa5NLKx4GGZJQkW6ze2r1r1Nozcz33FAXGl79nMwW0IcKjW80Tvkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FyOKk1/J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F63C606A32C;
	Wed, 18 Nov 2026 17:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyOKk1/J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A421F000C4;
	Wed, 18 Nov 2026 17:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022015;
	bh=FHFIlGgeTjDvITLjxWhXyTXQazMAbnMSkot7S1QsDho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FyOKk1/Jpu8EC1O4r1+6fouwR8RR0hpM8sF7GnkPJl5OQTw6XrZMSW9hExC+RHXUI
	 Txqgvdr2/ZpZqx4MmVyqlwMimBfzAvgOBXpJUUZAvM9uv5ltOHE+zdLrtXRQk7z94h
	 VoR0NSykCGVZ2Y85TgK3gf/2s2fqX/MX5zvKR1HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2512/2651] usbnet: fix EVENT_RX_PAUSED race in usbnet_skb_return()
Date: Wed, 18 Nov 2026 16:02:32 +0100
Message-ID: <20261118150415.169037873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ömer Mete Kaya <omermetekaya0@gmail.com>

[ Upstream commit 67ae1b80cf73f592b35e4b5e5001a24d6d6c8637 ]

On SMP, usbnet_skb_return() can observe EVENT_RX_PAUSED as set on CPU0
while usbnet_resume_rx() clears the flag and drains rxq_pause on CPU1.
The skb can then be queued after the drain has completed and remain
stranded until the next MTU change or device stop.

Synchronize the EVENT_RX_PAUSED state transition and paused-queue
dequeue operations with rxq_pause.lock. In usbnet_resume_rx() splice
the paused queue into a local queue under the lock, then drain the
local queue lock-free. In usbnet_skb_return() use a double-check
pattern under rxq_pause.lock on the slow path, keeping the normal
RX fast path lock-free. Use spin_lock_irqsave() to match the lockdep
class shared with other sk_buff_head locks taken from hardirq context
in defer_bh().

Discovered by Sashiko, not triggered, not tested on real hardware.

Fixes: 43daa96b166c ("usbnet: Stop RX Q on MTU change")
Signed-off-by: Ömer Mete Kaya <omermetekaya0@gmail.com>
Link: https://patch.msgid.link/20261024084538.256596-1-omermetekaya0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 84f97f448b2da..97a30dd22c545 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -329,9 +329,14 @@ void usbnet_skb_return(struct usbnet *dev, struct sk_buff *skb)
 	unsigned long flags;
 	int	status;
 
-	if (test_bit(EVENT_RX_PAUSED, &dev->flags)) {
-		skb_queue_tail(&dev->rxq_pause, skb);
-		return;
+	if (unlikely(test_bit(EVENT_RX_PAUSED, &dev->flags))) {
+		spin_lock_irqsave(&dev->rxq_pause.lock, flags);
+		if (test_bit(EVENT_RX_PAUSED, &dev->flags)) {
+			__skb_queue_tail(&dev->rxq_pause, skb);
+			spin_unlock_irqrestore(&dev->rxq_pause.lock, flags);
+			return;
+		}
+		spin_unlock_irqrestore(&dev->rxq_pause.lock, flags);
 	}
 
 	/* only update if unset to allow minidriver rx_fixup override */
@@ -698,13 +703,20 @@ EXPORT_SYMBOL_GPL(usbnet_pause_rx);
 
 void usbnet_resume_rx(struct usbnet *dev)
 {
+	struct sk_buff_head q;
 	struct sk_buff *skb;
+	unsigned long flags;
 	int num = 0;
 
+	__skb_queue_head_init(&q);
+
 	local_bh_disable();
+	spin_lock_irqsave(&dev->rxq_pause.lock, flags);
 	clear_bit(EVENT_RX_PAUSED, &dev->flags);
+	skb_queue_splice_init(&dev->rxq_pause, &q);
+	spin_unlock_irqrestore(&dev->rxq_pause.lock, flags);
 
-	while ((skb = skb_dequeue(&dev->rxq_pause)) != NULL) {
+	while ((skb = __skb_dequeue(&q))) {
 		usbnet_skb_return(dev, skb);
 		num++;
 	}
-- 
2.53.0



