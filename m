Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AC9433E87;
	Thu,  2 Jul 2026 16:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011050; cv=none; b=KgVe6sqYZ0EX56nYRC0oki0SLo0BQone8MEa/VBagAOePp21THgh2DQY3xW72Of/UxUFve93xC54mulovzYtm4AAsrqwhs4c+DF2t8Igjtzzx1nkiFv7kYKSbhGtMgpGiwln7CnndrqC7Gb03orAB3rKusGQcAhRMACV5+sz0ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011050; c=relaxed/simple;
	bh=FfH1Ga5Pa3g6Xi06UtLgtwtXlqx+Jx/gPbBsS65dVh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2RsUoL50cRrcFIEQsedyJvvmffh/oLnxfix4WV+Us1hc/pGNrnjQUTWfUh5AyGjHVwSfLkmFzTzhgeprhyJ6kXlZSFVTGlgwxj4850Kix1eShmMhpvdopWf9gln6r4cuEVLc4/77NkmyixHijV76mGD5lAeUFctn/hvxgSS5Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYvpfvao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYvpfvao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243101F000E9;
	Thu,  2 Jul 2026 16:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011049;
	bh=/Y5Y97G/gMaIrr+w5seB0STTYS8OeRZO1uEJ6Zl1kHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYvpfvaoqLQKRuGjjaj4nlNjGZpcXBcb13fnYr4ltkzlYiZeFjvhkzCpuxnKTUxY1
	 UgW4B5+llU/EqbwRseh3XyewFEpJuIlJPuEYQtXqvc7QKDqchipRGD8C7sXkXLJwST
	 EyXr5VaehPbxy3ZwfLn1l3eIz/IITphyrdbbpSQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 6.6 135/175] wifi: rtw88: usb: fix memory leaks on USB write failures
Date: Thu,  2 Jul 2026 18:20:36 +0200
Message-ID: <20260702155118.654869535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luka Gejak <luka.gejak@linux.dev>

commit 6b964941bbfe6e0f18b1a5e008486dbb62df440a upstream.

When rtw_usb_write_port() fails to submit a USB Request Block (URB)
(e.g., due to device disconnect or ENOMEM), the completion callback is
never executed.

Currently, the driver ignores the return value of rtw_usb_write_port()
in rtw_usb_write_data() and rtw_usb_tx_agg_skb(). Because these
functions rely on the completion callback to free the socket buffers
(skbs) and the transaction control block (txcb), a submission failure
results in:
1. A memory leak of the allocated skb in rtw_usb_write_data().
2. A memory leak of the txcb structure and all aggregated skbs in
   rtw_usb_tx_agg_skb().

Fix this by checking the return value of rtw_usb_write_port(). If it
fails, explicitly free the skb in rtw_usb_write_data(), and properly
purge the tx_ack_queue and free the txcb in rtw_usb_tx_agg_skb().

The issue was discovered in practice during device disconnect/reconnect
scenarios and memory pressure conditions. Tested by verifying normal TX
operation continues after the fix without regressions.

Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
Cc: stable@vger.kernel.org
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Tested-by: Luka Gejak <luka.gejak@linux.dev>
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260518142311.10328-2-luka.gejak@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -339,6 +339,7 @@ static bool rtw_usb_tx_agg_skb(struct rt
 	int agg_num = 0;
 	unsigned int align_next = 0;
 	u8 qsel;
+	int ret;
 
 	if (skb_queue_empty(list))
 		return false;
@@ -394,7 +395,13 @@ queue:
 	tx_desc = (struct rtw_tx_desc *)skb_head->data;
 	qsel = le32_get_bits(tx_desc->w1, RTW_TX_DESC_W1_QSEL);
 
-	rtw_usb_write_port(rtwdev, qsel, skb_head, rtw_usb_write_port_tx_complete, txcb);
+	ret = rtw_usb_write_port(rtwdev, qsel, skb_head,
+				 rtw_usb_write_port_tx_complete, txcb);
+	if (ret) {
+		ieee80211_purge_tx_queue(rtwdev->hw, &txcb->tx_ack_queue);
+		kfree(txcb);
+		return false;
+	}
 
 	return true;
 }
@@ -458,8 +465,10 @@ static int rtw_usb_write_data(struct rtw
 
 	ret = rtw_usb_write_port(rtwdev, qsel, skb,
 				 rtw_usb_write_port_complete, skb);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
 		rtw_err(rtwdev, "failed to do USB write, ret=%d\n", ret);
+		dev_kfree_skb_any(skb);
+	}
 
 	return ret;
 }


