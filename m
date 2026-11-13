Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591407;
	b=EYcDN8ab3J9HcHo+ic9h38kToSvFuITM904c4Ly8e2gk+3+Wv528LkqN2+q5GUDaow0t
	 BE1SRgwFw20pKLoqrIF0DpyYOVAOPW42UmhuJLQ4aD/Sckdbl0LD3wChiIn73S595w63H
	 qTmQ63y0u3XI4eLJHfLnsuP/4p05Ho76aam6O4U3VfFWBHxOPhouT4ZyucZvvWWHggM3s
	 bTi0T4NoVr418Hq9VOnrfs1Ksywv6TJFbBVOXvMc6A9FeBFwV5GBp3lZUKxrEo+sILFNp
	 Ua5qcSdI5BQuQ6DrCG1UjBdEU+ulOMOrdk/wa1fne4iE4BAD3PjuEIvsjUxxexhPgjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EWtkHkNgoLlZ3w5esTtQE0j26/IsA/6XlocKbl9h53k=;
	b=zI2LVMEd+FGBWE4Qkh9WgbZW7pLFZTQX1SUqeEklP+nHPSjNwCo9UPsmGiNBFFnnQ6hl
	 eTyoaAkPucBniHqB5Yu87o2yGwEYGKBTgZZWEmNWUeNx/eusDzyLCfrfE3srrgIFDn5lj
	 vZjZtfHbpnXt5TnZPZkeMIR5jyWKxQlmdR6FjkTpdMuGFIW9rItl3857SH4yq1JshAESw
	 hlQ6cej6akZgz4Vmr0IzSWOA/ATgcOMMxb+b0Bg89E0RH4LJSKHm3TKxyri3OntsrUtVO
	 PlrQEkuX1q6+f53kD71WWTPy5mbAdJlJZK4JtHgYHQ6UwOtCtwUdyaDMmQX/tyQDM+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YfhQSupq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6D86079D5B;
	Fri, 13 Nov 2026 17:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YfhQSupq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5B31F000C4;
	Fri, 13 Nov 2026 17:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591407;
	bh=EWtkHkNgoLlZ3w5esTtQE0j26/IsA/6XlocKbl9h53k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YfhQSupqas0qFpSUVhRnAqNi4uZUtSMUVzsEtzmbOp7Ro68W1ypckhL8xLuS2X1mD
	 T3YS7YNFA5QpgxFBvC8Yko1rvaIvZdHFvyDxYHU6+AQUGtvlEetIEWhyWSWHwF6k3E
	 0PP5x+GB4jx7GoRXb9ri0l+w+RiGjuxPaEaL7vXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 503/670] wifi: rtw88: usb: only let the frames a dozing station needs use the after-DTIM queue
Date: Fri, 13 Nov 2026 10:51:07 -0500
Message-ID: <20261113153828.998915679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 434bc7e0e9d1a..e1df0ad1852b0 100644
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
 #include "reg.h"
@@ -555,6 +557,27 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
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
 
@@ -597,7 +620,7 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct rtw_usb *rtwusb,
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



