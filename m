Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211547;
	b=i+nqRMnaM+nzUNpmj0kLnHRIIsFlFJExzCzMdcYmVLn+kNRNemNFuAzS3pjyVZ92pIFz
	 LdoA3apBP0FU7ac2eZgZWtX7A/Vh7oJG/plbuwHqd4hF7QOiqCr3D4ez3DQDMqTFwgE3l
	 3ZbbmdbNRT9nnJXQ18u0/3wZ3HXrAkhJEfb6nYdsrgKn9tXStDuAZCR71MK8V/vZ5xP28
	 USdTmMt0nTJtBs2pz8nG5i9qdPZEMzdHRb8xuDKal5Wk8/tkESHTMkX6Cc0lA5NKDRyX4
	 vMzPxW/Mg4Xj/MoR3F3/QARqFF/t+OsCAW7bGpoeDWuv/LkYUUiUzI8TK+1XYiVztyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ueRNCoCxspYnrCLsQfyIChXExilDOu3tpt7OVNOmQ2k=;
	b=F4FQsLzS/JUuTpfQVegQi2H4DoXtS3KBxPH1qTsBSShTrjdgdRfnGY86uW+9xxiQCWYV
	 1k6ooCFDee0kZ5MP+NV2CmztK0tVAQmfUxdyn7VVczEirb+GumEBXu7+jcap08dbWVGDH
	 SGIiC0HNUhNPV5XkWn54wAEDT8mnKmifQlo+fDY246shtoWcRhUlWOoazbIQy1znYYaUj
	 PaGO9hG+1Q76dPzRPE7cXgD7AVgc3K+Y+JsZSksxY66DBYyjbQp+XJUI8+NCx0KCy8dPS
	 Gh+yg7xw20YSAPW+d1yfPrVOOZ1ymqYYuMG5RXbUb+lf2RaW9iUfcTdj8ZuUiL7HW1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8QikYtW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947F6606A31A;
	Wed, 28 Oct 2026 18:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8QikYtW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4BC1F01825;
	Wed, 28 Oct 2026 18:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211547;
	bh=ueRNCoCxspYnrCLsQfyIChXExilDOu3tpt7OVNOmQ2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I8QikYtW8zX2czOkyO6iHdRENBkeM0wTLzf2X7b3TamKItgXoNlbVs7Xj9Li+ikRu
	 vWG4yA7ag0GnXdfY5XmfUsC34uoGiDp1B6OzCFD33ACcmfX+pRib11vdmDXx4L3BDV
	 avyTOz7i16M1/hU3eHo+oS3REiqsk0BqpOgh+T58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quchaosheng <quchaosheng000406@163.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 371/571] net/packet: guard the ll header push in packet_rcv_spkt()
Date: Wed, 28 Oct 2026 17:58:38 +0100
Message-ID: <20261028170016.816991389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1926,7 +1926,8 @@ static int packet_rcv_spkt(struct sk_buf
 
 	spkt = &PACKET_SKB_CB(skb)->sa.pkt;
 
-	skb_push(skb, skb->data - skb_mac_header(skb));
+	if (dev_has_header(dev))
+		skb_push(skb, skb->data - skb_mac_header(skb));
 
 	/*
 	 *	The SOCK_PACKET socket receives _all_ frames.


