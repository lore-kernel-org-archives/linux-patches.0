Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2244E238C1B;
	Wed,  3 Dec 2025 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778143; cv=none; b=dv2KxsoL0YKiqmOv1m71wZG6/d94GwzJSHnWaBNZuL++7fzzSy1McgxZsOcbXTFVlezIefSR02+wqh9hYOGyC8on4Zpg/wK9iAOuL/W+TGK9AXIDztkphslXDDalQw5lKJxBqIh0ypCnv7Y1g6VR0t7e1hoAGPPBgT54NgsOvMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778143; c=relaxed/simple;
	bh=aW6V3cG3E0UwKVqEl6eaCLIxBU+g54wU36pCcaYGuq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f86Zmpl4aIllC3iz3GIUAWjdeQxTkurGOm8HcOxail+ChiPhplRcbJuj4x2RAa53UET9jj+MagiYlBoJUyrcPFTXgbgfn+UITkuulNXUiHm7s87gjTbZbMiYaJ0JcNgrBcAkRGePW2XBQWKjLHReakT056qM5FcPaE20VBh+1/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UodJoh5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UodJoh5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED14C4CEF5;
	Wed,  3 Dec 2025 16:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778142;
	bh=aW6V3cG3E0UwKVqEl6eaCLIxBU+g54wU36pCcaYGuq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UodJoh5G1icnf9kQmabdc2GJ+Lp4Fjz8mj2wlF//NXzcyZQSv9dGwUF4jK/n4R903
	 6fYi8+Nr92RUif5FJtoWA2iSmgSk9q3CnN5iMHjkHwqYe9KR/SxuuzY1QOO5+E+nwX
	 Qwj/JqFzvR4+KE93QQ4t4YokwI/Fi0mW6pLYzu8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 239/392] Bluetooth: 6lowpan: reset link-local header on ipv6 recv path
Date: Wed,  3 Dec 2025 16:26:29 +0100
Message-ID: <20251203152422.970249825@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 3b78f50918276ab28fb22eac9aa49401ac436a3b ]

Bluetooth 6lowpan.c netdev has header_ops, so it must set link-local
header for RX skb, otherwise things crash, eg. with AF_PACKET SOCK_RAW

Add missing skb_reset_mac_header() for uncompressed ipv6 RX path.

For the compressed one, it is done in lowpan_header_decompress().

Log: (BlueZ 6lowpan-tester Client Recv Raw - Success)
------
kernel BUG at net/core/skbuff.c:212!
Call Trace:
<IRQ>
...
packet_rcv (net/packet/af_packet.c:2152)
...
<TASK>
__local_bh_enable_ip (kernel/softirq.c:407)
netif_rx (net/core/dev.c:5648)
chan_recv_cb (net/bluetooth/6lowpan.c:294 net/bluetooth/6lowpan.c:359)
------

Fixes: 18722c247023 ("Bluetooth: Enable 6LoWPAN support for BT LE devices")
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index c4a1b478cf3e9..cfe3753a6f160 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -288,6 +288,7 @@ static int recv_pkt(struct sk_buff *skb, struct net_device *dev,
 		local_skb->pkt_type = PACKET_HOST;
 		local_skb->dev = dev;
 
+		skb_reset_mac_header(local_skb);
 		skb_set_transport_header(local_skb, sizeof(struct ipv6hdr));
 
 		if (give_skb_to_upper(local_skb, dev) != NET_RX_SUCCESS) {
-- 
2.51.0



