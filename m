Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585902;
	b=vEoXu7XdjarCUNItxWbI4ctBGw/CqnLGnFgnOexzH4fd9tCEhABi853q0dXS9eakz0UF
	 xTHv/0B67MYmF34JfLKqSUgDuwxl854jE5RkpSsoYJxC9naGdTD8IuLoF1OAWG6mDgNmc
	 tG676wAh32cTfXHgUqi76OVDptGHE1ngXDDHYHFhO5CgbMXMGHDRPu/cMjP/Q8PSTfVGG
	 11HYixtBWVZTuLFquNy4IMErF+6y3CMwVycTORBGRWPyHhSi1jehfMK6en9DKQGeeLeXm
	 v7M8sYmLVWSJzcgCozd2NWJmFTHTEWjcF3OT9LBqLKkLOR6UMHw9akIiO7O+FIlEtsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H+8+qPBopRpp9IQzjgZSWzGfn9mSwkfV/2mSw+GeyaI=;
	b=J1IlOqZlhRPWj/9iGTg5mJPxwEwf3Ji28r7fbVePo2FOYoo4wuC48n5TEmNvYrkl4pbO
	 fCo+xmpIG93IbWtcB4AyTiJ72/wBtL8ZLNDgATQVv6uVUyQYUEaLsd3clZxKVHHraRgCK
	 ex4eKJX50tq6vlPdhJXoLi5zPbsAdLugGPLmo5o9OIDHj8d5w5/bf5xIo/tn1IMKhwIiw
	 NK7Nu7WFyGkBQ6/1PL+iJ3EnPN5mHmsPIHn+WZbO8AHpOeTMFVlS+azgAs1ljcrYIX59S
	 swT2n1oXdA/I8WijOFOMI6sFpE9ephWzp6rvWnl5pZSxtUKIhgsJaqVBimCmfswUl8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K6/EsVBB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A1D60A6F74;
	Fri, 13 Nov 2026 16:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6/EsVBB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2015D1F000D1;
	Fri, 13 Nov 2026 16:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585902;
	bh=H+8+qPBopRpp9IQzjgZSWzGfn9mSwkfV/2mSw+GeyaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6/EsVBBtqovBq9ts8A7vlYoF61Kq+CKNQAjbN0FpaoV+yqtbFF8zsiL/uYj13vYA
	 B+WZd3u9hKakjy84fqbXjCS9ybOi7mje3+Npp6TdG/xnPDGp9Xsz2HoY2F5Elb28s3
	 If81r0e+sx4q28OpXcFrFyGG1sH8wlaiuFafJwJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 468/507] wifi: rtw88: usb: only let the frames a dozing station needs use the after-DTIM queue
Date: Fri, 13 Nov 2026 10:52:52 -0500
Message-ID: <20261113153812.611507164@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

[ Upstream commit 185971f1b4eb4ea9059d76cf1a18f992eef998c1 ]

With the budget in place the high queue can no longer take the chip
down, but ordinary chatter still competes with the frames a sleeping
station actually needs. mac80211 marks every broadcast and multicast
frame with IEEE80211_TX_CTL_SEND_AFTER_DTIM while a station dozes,
mDNS and SSDP included, so under normal traffic the budget is spent on
frames nobody waits for.

Do what the vendor driver does with its default "allow special" high
queue filter: admit only ARP, EAPOL and DHCP to the after-DTIM path,
the frames a station coming out of power save has to see; everything
else goes out on its access category queue at line rate. The frames
are classified the way rtw89_core_tx_btc_spec_pkt_notify() does it,
from skb->protocol and the network and transport header offsets that
mac80211 keeps from the netdev path; EAPOL is the control port flag.
Frames the AP relays between its own stations arrive as ETH_P_802_3
and are not inspected, they leave on the access category queue.

With the filter in place the page pool stays at 1803 through the same
180 second storm, a DHCP flood still takes the after-DTIM path (and is
then held by the budget), and join/ping cycling without power save is
unchanged (10/10).

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260910081716.769081-3-mehmet.fide@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 27 ++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index d9c52094a6124..5c766701e632f 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -2,9 +2,11 @@
 /* Copyright(c) 2018-2019  Realtek Corporation
  */
 
+#include <linux/ip.h>
 #include <linux/module.h>
-#include <linux/usb.h>
 #include <linux/mutex.h>
+#include <linux/udp.h>
+#include <linux/usb.h>
 #include "main.h"
 #include "debug.h"
 #include "mac.h"
@@ -557,6 +559,27 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
 }
 
+static bool rtw_usb_bmc_needs_dtim(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct udphdr *udphdr;
+
+	if (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)
+		return true;
+
+	if (skb->protocol == htons(ETH_P_ARP))
+		return true;
+
+	if (skb->protocol == htons(ETH_P_IP) &&
+	    ip_hdr(skb)->protocol == IPPROTO_UDP) {
+		udphdr = udp_hdr(skb);
+
+		return udphdr->dest == htons(67) || udphdr->dest == htons(68);
+	}
+
+	return false;
+}
+
 #define RTW_USB_HIQ_REFILL_INTERVAL	(HZ / 10)	/* one unit of budget per 100 ms */
 #define RTW_USB_HIQ_BUDGET_MAX		16
 
@@ -599,7 +622,7 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct rtw_usb *rtwusb,
 	else if (is_broadcast_ether_addr(hdr->addr1) ||
 		 is_multicast_ether_addr(hdr->addr1))
 		qsel = (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) &&
-		       rtw_usb_hiq_take_budget(rtwusb) ?
+		       rtw_usb_bmc_needs_dtim(skb) && rtw_usb_hiq_take_budget(rtwusb) ?
 		       TX_DESC_QSEL_HIGH : skb->priority;
 	else if (skb_get_queue_mapping(skb) <= IEEE80211_AC_BK)
 		qsel = skb->priority;
-- 
2.53.0



