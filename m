Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870504E4300;
	Tue, 13 Oct 2026 12:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895810; cv=none; b=oP/znM0gx2O47NixtGTfh+MemtpEtGrGpSFma0sLtk/8ichlYOXqHnzMBy5R7kKRqJ55SN71nrLDRjuNIVLA0iCv9ueQLC1HFRlClwkq9flQ7cw4Z7gmGX5ixG5yRT8f9Uip+H1lCotONNdpacgJYgG56Y8PUrRcQ8XcCbenC08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895810; c=relaxed/simple;
	bh=6oUaZ5IoIJMJ1MzqenAIPSdYRlsvDs5ob1Gzu2KFmwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oeEelqgtD72PtQ/8rt4chR+zYjM9bSdEQ/wo3wVmhYL5S149vBX90EZP6ZcSoFQ0Vg7bbymSI8BJtq5nMYKm8+AMBtoSPKdIeA6QP+gxhB/0xf9fhZdKOHbplFUvM5MpHKcNlqwnQZoXCJ4YvSikmERlZzxsJ+2l1JFOvazQyQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgTsZ7RP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgTsZ7RP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6131F0089D;
	Tue, 13 Oct 2026 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895809;
	bh=Qiz6HvsiSYI69iYJztWNWn9e01rla6fVfNqUKGfiARM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgTsZ7RPpSKcqbmhWaFS+WuuBX9y6ASiotLshQoCsvG7LbVqUiR4Y2q8WEYPr5gDL
	 Nz+Q8EpaoCitGMf7voalCf+GCcMlK8jbBPdusi8UFCR9qZ6eYSUNm4l3jQBqaexEid
	 O4p3dHOnMxBZ/TBbOcyEkotp7ASYRTwmalkpiDB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quchaosheng <quchaosheng000406@163.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 399/497] net/packet: guard the ll header push in packet_rcv_spkt()
Date: Tue, 13 Oct 2026 13:39:26 +0200
Message-ID: <20261013112917.362148376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -1963,7 +1963,8 @@ static int packet_rcv_spkt(struct sk_buf
 
 	spkt = &PACKET_SKB_CB(skb)->sa.pkt;
 
-	skb_push(skb, skb->data - skb_mac_header(skb));
+	if (dev_has_header(dev))
+		skb_push(skb, skb->data - skb_mac_header(skb));
 
 	/*
 	 *	The SOCK_PACKET socket receives _all_ frames.


