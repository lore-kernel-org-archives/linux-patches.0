Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCC5342507;
	Tue, 16 Dec 2025 11:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884457; cv=none; b=NLyZ/RZ2vudC1O1S58DNOdaWaZjnK1WPXlrEmaI0SnnACC30I5KYYhAYy2GoOitctLWhlW3GcoL19cBoLk2oZ78b/SPaFASCEGJD+N84nI3opIMERT6cOE62nMfu1Dpj4uRxG8w8OmOrin8ntsfldiVB3zciutHxoFFpJ9EYVFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884457; c=relaxed/simple;
	bh=LU1cJ0y7RG0PJG6l1N1e5B/oJELYTo4zxArjtMuOfP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5v8mxJAColwzOQGLmhrp0bIHGlltVF9JtnzRAUmbdYP95UUvI+by0MfEcqovjhsja7bkXD68jG5s+EJPk037MGKL4ua5y+rmN6Hz/sAq8ThXUxYhEVhL9EUp59dptUlojSI6WU1J2o/ohQdxF6/Fp9cS8IgzRaknKAvZN/mc4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oATEKlUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oATEKlUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11361C4CEF1;
	Tue, 16 Dec 2025 11:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884456;
	bh=LU1cJ0y7RG0PJG6l1N1e5B/oJELYTo4zxArjtMuOfP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oATEKlUY0yo3cQy+mtbrkteJRcqs66bxMUJJH1iHhmYeSId8/vtKjMohggFMNvoxv
	 K8Gp8SunHz3VSzdGySrys7G0XyotPLm89NvOWBTOs8uqV+Egh36ucgujDe6H1cbeZK
	 qqN474KArcmmz7/NESA57R3+5uEH9Ahmdwf14mg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/354] wifi: rtl818x: rtl8187: Fix potential buffer underflow in rtl8187_rx_cb()
Date: Tue, 16 Dec 2025 12:12:46 +0100
Message-ID: <20251216111328.127541382@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8a57d6c72335e..876bf79847717 100644
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



