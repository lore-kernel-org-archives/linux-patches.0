Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062116;
	b=cqOmp/Y6gQ/BJXpTYzOHCfara0zM25XcB96JyRvXw/z9JIxikBoHHJ9BwC4zAa2LFL5m
	 dXxVuvX2oaNUvpW32jvzMVgyGtoi2o7lS4UM8+xEmDrsUlEedtB84On/zeWkXfuUzs7Nt
	 lAVKCSDH3o17PotB4Bg8EbiCP8bHpQ3oXhbm9omXNm6rSa1VOXDZbkDwz7eQaVg3hcCEa
	 JVLgsBWvfGIaCLmsW8XYceOJcenVRN/TyNniPfB9PKspNCCQFxYaRR/R7bcW4c8QbDCau
	 N159FPzkDN6fEGgLYkdNI/K6tLpTeEjDKY2TUqgP3Suek6DEhS6QR8/G5vMoqrD2wpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3MSd4j4VnAKX5a6WLhPti8gKAKnx+D9hIMQY1YP1ALk=;
	b=UeP2AQHQIkR4Y00EXJTMt5EsDAcWvlkwlvCsyYcgp9Sdzz+/f1jIB4AYj+a80eK8gMiz
	 3lpOrUmetRvczlRvAngNKmIlx0A3GD+5Pafhq9GguxNYdMC42nIprWMNC2EAaORySztQv
	 /+3tV2oaQHCOKiniE7/4cfQ5QuRB6dq2b/tOaMheGVnMGfGP/OJQodavDx2DN9yeV3Zf3
	 xUH8FykGA4Xur9wD4VEKpWjh7Gte67IWNSjwxuM0QQPg/z06hQkMwL6LIu4cRt2n6bOsL
	 ckkY7TeUCnI/TuS/J4oKH+i673PQXSE1e1K0kX1U/udXNdx/c7l/pJ5V2zuBA8ziBKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VWcOsv6t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28038606A325;
	Thu, 19 Nov 2026 04:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VWcOsv6t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797F51F000C4;
	Thu, 19 Nov 2026 04:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062116;
	bh=3MSd4j4VnAKX5a6WLhPti8gKAKnx+D9hIMQY1YP1ALk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWcOsv6ttMaFw2c7R9Qy+8PaeEUbRVCDIhk4AAUZTJxf9M9GWWG337bKDnJwNyhiJ
	 wQE/xnTDv3B9LmV+kcCxoeM4kmYS/JYCEIoCHntpxUcooW5QXj+tA2WVJgt6z0/eXJ
	 EI/vysjVdjJb9HysEqkexwbSHthANgdMU+jZmZiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1795/1848] usbnet: fix EVENT_RX_PAUSED race in usbnet_skb_return()
Date: Wed, 18 Nov 2026 16:03:53 +0100
Message-ID: <20261118150034.416771711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6a7caf3dd337a..98aec5c9029d6 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -318,9 +318,14 @@ void usbnet_skb_return (struct usbnet *dev, struct sk_buff *skb)
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
@@ -683,13 +688,20 @@ EXPORT_SYMBOL_GPL(usbnet_pause_rx);
 
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



