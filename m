Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028071;
	b=BNxZmglDh5vDfuNXAsSarpWPbvohp597aufpkPwo2kwdwl6vtNl/b2do0R1KqpQFa1aj
	 SBiC9qnOSyt2rYAgHyovL9C/PIbkPEbuUfZvxu2Lsq9BE0Jiz6yqQ5TDAlHuAHsRIAT1Z
	 4HIxLGHJ4D+J7nqo5smsQkHy+ITQCrcXImkg63Wvzl74N3Q/g9k8ZDg46/VyQXzv132a/
	 //JTq8BtSv0JtcdTazrOQlWAeuOLXXN9P8Xgc0b5Ggv6SyPo59yiAHwpXvO+vtYAWOQID
	 7+cdjoLQ41zPI0WCPNcFeuBqF1KKUPqKxZjl6u9SyglzxxuylBgKex42sUoclnzcCYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BLms7mOO39kDmOdd0ffk2Enhi6Bd0YL1ca7nViLfews=;
	b=UgeGgipCa4tXCO4vGX8k26c2FDGFQNNMGVZUz8Dvx1cpigvaPyJWixUbMNMEXRVKQ0lt
	 tuoDIkVqh4iJVLWj36x2VbaKCTkBlU1G34wzRiINg9pSIVQ+dkNzBIYrAONRx9jLFA4GW
	 Ounj6A6xxtQDLZ0RRtIuGO1LLmf11UydF8q0RIUQNyhs/bzN6HSIL9/dSJMOUkwrZxEeC
	 1VicRjbAYYZrs0V4opP51Odyf3jaHqboAog/BwLAA/DV9X0DjLLhX56tpDxkk7u6VHXrP
	 Q1RY79k1VvVJDaDQzaodAAaNYY4ZPhTsio3M+tDb3ViWd73rdil8gIJ96iW3abGNgpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ltbwihdI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F994606A332;
	Wed, 18 Nov 2026 18:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ltbwihdI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9661F000C4;
	Wed, 18 Nov 2026 18:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028070;
	bh=BLms7mOO39kDmOdd0ffk2Enhi6Bd0YL1ca7nViLfews=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltbwihdIPFAdLvagGQ5/RJY2QMygHnADsKL/EGTIVt/HmHRNqK8Y+Q3AJJ4WkR3dm
	 M02vZ/OYrv6VqNpH6Sj+sQ7DtcpKwkUocky4i4bf2fweRaSYlUPM9OrUGj9XqVuNZ8
	 ZNwHOcDmt/lxNVpqVJhx7tI0AMUHTRiBBYvI/1x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2015/2151] usbnet: fix EVENT_RX_PAUSED race in usbnet_skb_return()
Date: Wed, 18 Nov 2026 16:02:30 +0100
Message-ID: <20261118150235.123785218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5d1675005903a..1afe43be0b5bc 100644
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



