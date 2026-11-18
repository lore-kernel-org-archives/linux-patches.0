Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042646;
	b=HCJh+VmYBTFuTqOpbN3p+QcdaqIGuUwSvKq7bTaEb3tsd9Or1u1XYaEG5NKN2pV+wc0A
	 XczpL63GnjdTU0d1ApoybNBs6FLUCVb9iuUu4Plpfzc/S1uE6210CE9g5XxSZ3BR3LzV7
	 du73+pm++k/uviDjbvCumM6Vv17rTf/ZqwzGB59dDa9BpmhjvAfZ0go0dlZ9ceFEcVxS4
	 bXLohuFww7akm7TXB5rmCTh9j3wojce9fQidlm2AWksFftbzfJCM5xwZc1LyBgG2uu6gP
	 9Ikck/Ndl75okvZWgrkPWu4YbNfEjYD60N67sLV6lHmiU0/jIvcMfDI5nE2QyrHDrig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/He0JRiGVPHRoj7byyjqeTZ7uiZZpxouyNrDBQ+74kk=;
	b=oTDRWes+y815oVKVIpYXPruEg6cStPIAJxxIV2xCef7XS1X29P5JYMh/xGZGWS10xRtB
	 g4T8XQAjRwJjlRUUYr2tAqA2fIu/gTJ/NtCFXVpYJvhpb3dr31ykcuE/PUct+OhFj5LDX
	 o4pDOH+kB0Xx0nKJInpC28sArFrUMyOCGmz5KhfTkisVSzkrwDddUOikbGmVn91dhPQiK
	 XEKuAtkNC+pOigkE07SBc9xVQEjDIy1BbVgal8yBe/7S6PiDvk/ig1w+6wc1Z4of/rjZE
	 LMn1kxJcTpiAIGZ8feUZ4YvuYslpOwhIC+QpO7WMev6oaK2EroC4a5AHEAnfWxbsWyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WK5Wm5LX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADCD606A31C;
	Wed, 18 Nov 2026 22:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WK5Wm5LX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE111F000C4;
	Wed, 18 Nov 2026 22:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042646;
	bh=/He0JRiGVPHRoj7byyjqeTZ7uiZZpxouyNrDBQ+74kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WK5Wm5LXW6gLYUneViPlgj9JORR+OVBztGVcwLV3gwCAOc0G62oajevnxbUxWI6Pl
	 Z+9NVfgZ3aBh3uKhYKWDOB6Y3A/Sl76CxjK0aYvvZ3ISfSgIIvpjcRajCjwNyBX0Fw
	 r1TwB4WTD5vDqwJdbHzENld313YPToNtt+D2mR74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3204/3318] usbnet: fix EVENT_RX_PAUSED race in usbnet_skb_return()
Date: Wed, 18 Nov 2026 16:03:46 +0100
Message-ID: <20261118150455.874155871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c4416d933b6c3..065cdc86c8569 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -332,9 +332,14 @@ void usbnet_skb_return (struct usbnet *dev, struct sk_buff *skb)
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
@@ -701,13 +706,20 @@ EXPORT_SYMBOL_GPL(usbnet_pause_rx);
 
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



