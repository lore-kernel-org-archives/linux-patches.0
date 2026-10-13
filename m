Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63574EFFD4;
	Tue, 13 Oct 2026 11:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891993; cv=none; b=K+l0dKMiAx3FXSKjw9pnjFBTRVHJaDJhs/Gh7k7kbXcWd4JZ8FhQ0KWnV6Rh0JldrACyicN4EPTAwWOCdlXRdWc/xc2rIi/hvedyTnSr7Dt0rShHFqA8H4e0vMhsXH3YHTHzJM4353JJ8TpGyO/P+awKNV+cUspUyJMqHiVNV6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891993; c=relaxed/simple;
	bh=Yw2V0W6TLIT247I8TdxAz+6tLQgF5uGGHsHjVbGQYpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BF+5scaI79rb5uwdRIXHD7o2fyGAyno2Ud/GAQZbxAsCOZ8NaIQazCQK4rbu7CVMb7V7IJ0shzXrGCkH+3pH00CIiOipcM1tG6V1L8LehlGjPTdrSnA8tkbLV7+H0jESLaXsBu1KpgyoLm88SDfP0OscRYTVnm0p88sxPcS1wc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOOaO2UL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOOaO2UL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E848D1F00893;
	Tue, 13 Oct 2026 11:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791891991;
	bh=mVJmHMC0MJK9FPfV6jWkkaGDERKNK43ujazL/k/oiug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mOOaO2ULfY68GZQoZokEHduhGvitXnlY4A5m5YkqNWuIRXlqjfyK8zkvXlY32KcJq
	 H0h54SAXKMAMHrBw+iorORXeuvgqrspJNG56IXKGjrSBtyj4UbLA0UsY7+w5HoYX7+
	 FNlinttKRLF+yzlYPNCSuCmnaxhDcw/2MGFRiZ5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	zjamg <ndaugoing@gmail.com>,
	Quchaosheng <quchaosheng000406@163.com>,
	Shaunak Datar <shaunakkdatar@gmail.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 7.2 024/281] can: dev: init_can_skb(): restore skb header initialization
Date: Tue, 13 Oct 2026 13:35:40 +0200
Message-ID: <20261013112855.637289124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zjamg <ndaugoing@gmail.com>

commit 0a04c0cb8606ff88399489d03ef255afe90d0d5f upstream.

Commit 9f10374bb024 ("can: remove private CAN skb headroom infrastructure")
removed the skb_reset_mac_header()/skb_reset_network_header()/
skb_reset_transport_header() calls from init_can_skb(). As a result, RX
skbs from alloc_can_skb() and friends again carry mac_header = 0xFFFF.
When such an skb reaches packet_rcv_spkt() (SOCK_PACKET), the push length
calculation overflows and triggers skb_under_panic -> kernel BUG -> full
machine panic.

The same issue was originally reported in 2014 on linux-can and fixed by
commit 969439016d2c ("can: add missing initialisations in CAN related
skbuffs"). packet_rcv_spkt() itself has never been hardened: only
packet_rcv() and tpacket_rcv() gained dev_has_header() checks in
commit d549699048b4 ("net/packet: fix packet receive on L3 devices
without visible hard header").

Fixes: 9f10374bb024 ("can: remove private CAN skb headroom infrastructure")
Cc: stable@vger.kernel.org
Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: zjamg <ndaugoing@gmail.com>
Tested-by: Quchaosheng <quchaosheng000406@163.com>
Link: https://patch.msgid.link/20260917123716.63116-1-ndaugoing@gmail.com
Reported-by: Shaunak Datar <shaunakkdatar@gmail.com>
Closes: https://lore.kernel.org/all/20260918151606.765490-1-shaunakkdatar@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/dev/skb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -210,6 +210,10 @@ static void init_can_skb(struct sk_buff
 {
 	skb->pkt_type = PACKET_BROADCAST;
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+	skb_reset_mac_header(skb);
+	skb_reset_network_header(skb);
+	skb_reset_transport_header(skb);
 }
 
 struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf)


