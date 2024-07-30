Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6C2183CC3;
	Tue, 30 Jul 2024 17:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358853; cv=none; b=uXx5kJWua9AWnqa1FiogGMwqSw9wAUGLsKBUWWfONM9oZElTkcSXrRN8xFfmlTmNNd/iGGX0VEVhBH3pnbcrkUbCA2v5W4xiuSCzHWEifdPtmBJztfispJ+ePysxOM50bo0PvwYYuU0fjoKL12iETewd4Q/W1DiXGNNlxjtXXEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358853; c=relaxed/simple;
	bh=oYXTDAgXcWAynT89s4onkLbFPaCu5RnzPYBHueZXFbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxtAOx4wz0HG6izb/YEwAG5gVUw97KFevbte/hvjcHKBPUS8JRNQnoiQBeJMcQLuA6Qmqt5aasSjCvnDwAaxQHli4jjbxjt9vmPJK1DV05L/ySjv2A8PLX5tasS2ALPZx5uFELdcv5/9PE7dy9zA26e1sPW3Xng2SBD5QgXWJoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkhBfqHx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkhBfqHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304DBC32782;
	Tue, 30 Jul 2024 17:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358853;
	bh=oYXTDAgXcWAynT89s4onkLbFPaCu5RnzPYBHueZXFbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkhBfqHx6JW9+mouCAGirBx7s8oHQMY3IoCxlLU9q/fblusL1xQhz1Mpc+NO0Lq63
	 QPWONcnzMHW/nD2vTOCS/nQYE6Rsevv+/O6iJPEp03CP8yIL/Py+tOnemf8KzLCiVe
	 +MhDrr92Y9UkyMq/d9cwm6oFnSP/jPSvg5JjwzF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.6 403/568] wifi: rtw88: usb: Fix disconnection after beacon loss
Date: Tue, 30 Jul 2024 17:48:30 +0200
Message-ID: <20240730151655.622112743@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit 28818b4d871bc93cc4f5c7c7d7c526a6a096c09c upstream.

When there is beacon loss, for example due to unrelated Bluetooth
devices transmitting music nearby, the wifi connection dies soon
after the first beacon loss message:

Apr 28 20:47:14 ideapad2 wpa_supplicant[1161]: wlp3s0f3u4:
 CTRL-EVENT-BEACON-LOSS
Apr 28 20:47:15 ideapad2 wpa_supplicant[1161]: wlp3s0f3u4:
 CTRL-EVENT-DISCONNECTED bssid=... reason=4 locally_generated=1

Apr 28 20:47:24 ideapad2 wpa_supplicant[1161]: wlp3s0f3u4:
 CTRL-EVENT-BEACON-LOSS
Apr 28 20:47:25 ideapad2 wpa_supplicant[1161]: wlp3s0f3u4:
 CTRL-EVENT-DISCONNECTED bssid=... reason=4 locally_generated=1

Apr 28 20:47:34 ideapad2 wpa_supplicant[1161]: wlp3s0f3u4:
 CTRL-EVENT-BEACON-LOSS
Apr 28 20:47:35 ideapad2 wpa_supplicant[1161]: wlp3s0f3u4:
 CTRL-EVENT-DISCONNECTED bssid=... reason=4 locally_generated=1

When the beacon loss happens, mac80211 makes rtw88 transmit a QOS
NULL frame and asks to confirm the ACK status. Even though rtw88
confirms to mac80211 that the QOS NULL was transmitted successfully,
the connection still dies. This is because rtw88 is handing the QOS
NULL back to mac80211 with skb->data pointing to the headroom (the
TX descriptor) instead of ieee80211_hdr.

Fix the disconnection by moving skb->data to the correct position
before ieee80211_tx_status_irqsafe().

The problem was observed with RTL8811AU (TP-Link Archer T2U Nano)
and the potential future rtw88_8821au driver. Also tested with
RTL8811CU (Tenda U9).

Cc: stable@vger.kernel.org
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/ecbf0601-810d-4609-b8fc-8b0e38d2948d@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -273,6 +273,8 @@ static void rtw_usb_write_port_tx_comple
 		info = IEEE80211_SKB_CB(skb);
 		tx_data = rtw_usb_get_tx_data(skb);
 
+		skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
+
 		/* enqueue to wait for tx report */
 		if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
 			rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);


