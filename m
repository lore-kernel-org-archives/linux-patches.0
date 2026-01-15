Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC0C15530C;
	Thu, 15 Jan 2026 17:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497558; cv=none; b=ryxDFXnsroxSYTbdQR9ro1jWGcCeiIErvdoKoDzMlorJG+OvO7YztEfCWmKMk0yf/j9YB0qf4Kw7QxR6lkThA20lavR0uxGunv33khM9MMeljlYumFwtjs0QVcjCxmwIBvGHumfhstTy9cmZHRtA+McB9kXjiplnzbDvI8325Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497558; c=relaxed/simple;
	bh=nEOKFdNwjdj1mdmQQ5+GyC5J6V71fmmjNGdcbb6ry3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZAnzYGI30glno3OzoF5GSwTwN4F41PL10NfhDXL68PbzT5u+ugJwts1LkzyUQA7pW131HcxriXpUN6JV0IvusxX0A6gWSJn8zyW13z8pYJoEjggk5K9zusIbCasICi6NMtDcYLLGROIbLDyKNZNi2ZDnVWJPXCuRqgJ4p1mVbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nz8gaZJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nz8gaZJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3166C116D0;
	Thu, 15 Jan 2026 17:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497558;
	bh=nEOKFdNwjdj1mdmQQ5+GyC5J6V71fmmjNGdcbb6ry3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nz8gaZJkOcy+zldAxPkdxtxgvKtPkRSOHgd2NBqgcFhi7OrvrtPwhnf98HZuPMR+u
	 TvLA/10Gmer4rYfbXMjBxYB6OlCmkvXjhfu0pwxGJ1UCNVltyg9Si87vUdBv5G+sn4
	 /KBx/T6WCSXQ75nhkWLvItIjAyCYLvHXfV57zHc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/554] wifi: rtl818x: rtl8187: Fix potential buffer underflow in rtl8187_rx_cb()
Date: Thu, 15 Jan 2026 17:43:09 +0100
Message-ID: <20260115164250.700515133@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Seungjin Bae <eeodqql09@gmail.com>

[ Upstream commit b647d2574e4583c2e3b0ab35568f60c88e910840 ]

The rtl8187_rx_cb() calculates the rx descriptor header address
by subtracting its size from the skb tail pointer.
However, it does not validate if the received packet
(skb->len from urb->actual_length) is large enough to contain this
header.

If a truncated packet is received, this will lead to a buffer
underflow, reading memory before the start of the skb data area,
and causing a kernel panic.

Add length checks for both rtl8187 and rtl8187b descriptor headers
before attempting to access them, dropping the packet cleanly if the
check fails.

Fixes: 6f7853f3cbe4 ("rtl8187: change rtl8187_dev.c to support RTL8187B (part 2)")
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251118013258.1789949-2-eeodqql09@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtl818x/rtl8187/dev.c    | 27 +++++++++++++------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
index c9df185dc3f4f..00493a2391179 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -338,14 +338,16 @@ static void rtl8187_rx_cb(struct urb *urb)
 	spin_unlock_irqrestore(&priv->rx_queue.lock, f);
 	skb_put(skb, urb->actual_length);
 
-	if (unlikely(urb->status)) {
-		dev_kfree_skb_irq(skb);
-		return;
-	}
+	if (unlikely(urb->status))
+		goto free_skb;
 
 	if (!priv->is_rtl8187b) {
-		struct rtl8187_rx_hdr *hdr =
-			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
+		struct rtl8187_rx_hdr *hdr;
+
+		if (skb->len < sizeof(struct rtl8187_rx_hdr))
+			goto free_skb;
+
+		hdr = (typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
 		flags = le32_to_cpu(hdr->flags);
 		/* As with the RTL8187B below, the AGC is used to calculate
 		 * signal strength. In this case, the scaling
@@ -355,8 +357,12 @@ static void rtl8187_rx_cb(struct urb *urb)
 		rx_status.antenna = (hdr->signal >> 7) & 1;
 		rx_status.mactime = le64_to_cpu(hdr->mac_time);
 	} else {
-		struct rtl8187b_rx_hdr *hdr =
-			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
+		struct rtl8187b_rx_hdr *hdr;
+
+		if (skb->len < sizeof(struct rtl8187b_rx_hdr))
+			goto free_skb;
+
+		hdr = (typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
 		/* The Realtek datasheet for the RTL8187B shows that the RX
 		 * header contains the following quantities: signal quality,
 		 * RSSI, AGC, the received power in dB, and the measured SNR.
@@ -409,6 +415,11 @@ static void rtl8187_rx_cb(struct urb *urb)
 		skb_unlink(skb, &priv->rx_queue);
 		dev_kfree_skb_irq(skb);
 	}
+	return;
+
+free_skb:
+	dev_kfree_skb_irq(skb);
+	return;
 }
 
 static int rtl8187_init_urbs(struct ieee80211_hw *dev)
-- 
2.51.0



