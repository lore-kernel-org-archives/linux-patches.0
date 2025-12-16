Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D00134EEE8;
	Tue, 16 Dec 2025 12:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887846; cv=none; b=rhYVtBGmB1FMTet+XFLGw3YKpgNHTEnMVIEvuFaUyc5xSukPKSmHeqW7/dPsoqmaEOyi4Dq8TVc1kGCezHG/+l3TxSdcsvvheIoPuBudFqBPdg8X/2gOSzUNxVCo1K4YC6wsql6cpAyu8SBzMLOAWpsmu7aqL69yvFooVQLkI9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887846; c=relaxed/simple;
	bh=sJGGcgbNpZMqhzDUna1PKX8AuPdCw5r/NXeRId0HdNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeQHcOthH9Wh0uTD+vxvGCveTWsqaxRXvJEMLqAnzNAVaoQBlpNOPXKyc1o+lYJYJGPUzGwGRGcIrzdpjMC6p6PhlmwwFPmmyV079+aAqP9Xd/Rb/RHoqrHLgBEgC48D7EMm2yhR0dL25m8tdayIZKPwpDBp/jtfYJq6RPD2ga4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIIEJWKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIIEJWKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EC0C4CEF1;
	Tue, 16 Dec 2025 12:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887846;
	bh=sJGGcgbNpZMqhzDUna1PKX8AuPdCw5r/NXeRId0HdNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIIEJWKmE8UxmJ6uimQyc3lM1sKV3gHNx0YQGYJk/gV8dI3i0gTPMZdOWh7s9kmZY
	 13pK9XWU7hZka8K4+idt/cH/mb2MJZZbIVV40LpjXd2nn/5ROx7uOhByMlv97uCahG
	 KnwiZV2RCeFybsc7JOkBY5OTvTWLpO/jq4V2GSw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 356/614] wifi: rtl818x: rtl8187: Fix potential buffer underflow in rtl8187_rx_cb()
Date: Tue, 16 Dec 2025 12:12:03 +0100
Message-ID: <20251216111414.259611078@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0c5c66401daa6..7aa2da0cd63cc 100644
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



