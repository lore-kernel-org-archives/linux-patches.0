Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87864EB879;
	Tue, 13 Oct 2026 11:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892294; cv=none; b=oB5mhFP4b83Lo/XHNLmUvehqFNpBllH6U4LVWj4JXl/CnTmst9nI9PYov8OThsLKqaVU/gKz/y08BlCRg4MPT6nKt8IKtoqQm/x3472b+JbPL7kva5L+k4vUkijopei5zTmpFIyjKj++4uvEa6cy+4v/oMRmtraQvWzx4ZorlUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892294; c=relaxed/simple;
	bh=uNOSBF37wq5ugpLKrIKbfFVEsJvraiYpgDyr5Vo16+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnszZTVcR0EDPfi+O3ZyGmyJM1GQANnQdVy+0DiE7hr5R3ne+sMUcFv2hOCzYfxC+aHSk61xSIvSn0TpPXg/FjTxOl4cIVTjYoAmbxCAYTmLQmaYsl89Ty4yyoolUjHYaB/kUskjjfCEq7fNP4F0Q3IqT0DARany4HL0m7u0/SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xG6kKMRc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xG6kKMRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDD91F000FF;
	Tue, 13 Oct 2026 11:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892293;
	bh=6e3p7TNIy/dErP6prUO2Cp1UhHHk2Qgi4Q/gYv2soGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xG6kKMRcWH5QVxcgRmx7Bpod9ffWhhYkXj1bzcs4ONBFooDrC3aVX5DAUTrEr4ciM
	 002bQ65wsNKA7r9+MYxP6vT3wm40Mm0Wi7cSZ54E1nrCVRO2kM70WkWcNU1OLb4dR+
	 ZFFzkFe+mQAQj2GHopQt/EN/3XjQkLfO9yxZ6JpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quchaosheng <quchaosheng000406@163.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 081/281] net/packet: guard the ll header push in packet_rcv_spkt()
Date: Tue, 13 Oct 2026 13:36:37 +0200
Message-ID: <20261013112857.096616793@linuxfoundation.org>
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

From: Quchaosheng <quchaosheng000406@163.com>

commit 28bc1ef699610ee09ce3d46a00552f5a0a0144bd upstream.

packet_rcv_spkt() restores the link layer header with

	skb_push(skb, skb->data - skb_mac_header(skb));

That subtraction is only meaningful when the device actually has a link
layer header.  packet_rcv() and tpacket_rcv() both wrap it in
dev_has_header(), which is also the predicate the block comment at the
top of the file states the restore in terms of; packet_rcv_spkt() does
not.  commit d549699048b4 ("net/packet: fix packet receive on L3
devices without visible hard header") introduced the helper and changed
the two call sites, and this one stayed behind.

A device without a visible ll header can leave skb->mac_header at the
0xFFFF sentinel that __alloc_skb() initialises it to.  A CAN skb does:
init_can_skb() sets pkt_type and ip_summed but does not reset the
headers, and commit 9f10374bb024 ("can: remove private CAN skb
headroom infrastructure") dropped the skb_reset_*_header() calls that
used to be there.  skb_mac_header() is then 0xFFFF, the length becomes
a large negative number and skb_push() reports it through
skb_under_panic() -- from softirq context, so it is a full system panic
even with panic_on_oops=0:

  skbuff: skb_under_panic: text:ffffffff8bd21bc1 len:-65455 put:-65471 head:... data:... tail:0x50 end:0x180 dev:can0
  kernel BUG at net/core/skbuff.c:214!
  RIP: 0010:skb_panic+0x50/0x60
  Call Trace:
   <IRQ>
   skb_push+0x38/0x40
   packet_rcv_spkt+0xe1/0x170
   __netif_receive_skb_core.constprop.0+0x7e8/0xd30
   ...
  Kernel panic - not syncing: Fatal exception in interrupt

The socket type is reachable: packet_create() accepts SOCK_PACKET
alongside SOCK_RAW and SOCK_DGRAM behind the same CAP_NET_RAW check,
and neither the socket length nor a capability check keeps it away
from a CAN interface.

The missing skb_reset_*_header() calls in init_can_skb() are a
regression in their own right and are being fixed separately, but a
packet socket should not turn a link layer that did not initialise its
mac header into a kernel panic.  Guard the push the way the other two
receive paths do.

Tested on v7.3-rc5 under QEMU with a slcan device on a pty, which is
the driver RX path: vcan does not reproduce it, because can_send()
resets the headers on the way out.  One SOCK_PACKET socket bound to
can0 and one frame written into the line discipline panics an
unpatched kernel with the trace above; the same image with this patch
prints no panic and powers off normally.  Both kernels are this tree,
defconfig plus CONFIG_CAN_SLCAN=y, differing only in this hunk.

Fixes: d549699048b4 ("net/packet: fix packet receive on L3 devices without visible hard header")
Cc: stable@vger.kernel.org
Signed-off-by: Quchaosheng <quchaosheng000406@163.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260928113108.2127215-1-quchaosheng000406@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1911,7 +1911,8 @@ static int packet_rcv_spkt(struct sk_buf
 
 	spkt = &PACKET_SKB_CB(skb)->sa.pkt;
 
-	skb_push(skb, skb->data - skb_mac_header(skb));
+	if (dev_has_header(dev))
+		skb_push(skb, skb->data - skb_mac_header(skb));
 
 	/*
 	 *	The SOCK_PACKET socket receives _all_ frames.


