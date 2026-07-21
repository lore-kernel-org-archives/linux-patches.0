Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0289375AC3;
	Tue, 21 Jul 2026 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653452; cv=none; b=W9CCfp3BxhHE8xZ9uc6DqVQRxox2rAFRj7Pul2OBwfmQSCkhHY8Ei2Mum65/ODLWBgmXbcBHRKfVfENLXaDzAOoRU0xK5ekGfnpcnvzjhKeznjrGthMwVDxU5OChUhJNbkBK/G8ximY+KYYLkJ6s79c8SkCgEiLp9gMYKEBA9Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653452; c=relaxed/simple;
	bh=py6ZnA6PYAgR77sOKhuw+QEhfDllBDFLkDSa2y0d+eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hl7vHjMMJirg9UfCeAWyCOLdHKzzOjj9bpHVFfuBxN+wSG3PXmsAu5WE5K3VfXHHQyLWsmdBMqIY+XE5q2NVZDOoXTd14vAdJNVLGRXameEJaHKbWLAohmnB1OfH7fJDGsPFS36cpbjiWN5cJuUEMlDFTtOM0H2PaVJk1L2hj6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znv5259J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znv5259J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213261F000E9;
	Tue, 21 Jul 2026 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653451;
	bh=uw9kBuFhmeSD9eKSt+VFgFHE2wUbh4DJWc9gPN2w9i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=znv5259J6fXAXGshxd+5OSy8omDBCGeLy5jPI5bX1SoNzukS0OEY51qTXzjGYm8L0
	 HTK3sqcbcRMe0LheDdiSMonDYO8HcID3GiHZtsP+06d81rElgW+cS1XNUOVL2tlXwH
	 llHVqYbWQHr1D9NBa1P0FQCAQAnYTuodEPN9s/IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1330/2077] usbnet: gl620a: fix out-of-bounds read in genelink_rx_fixup()
Date: Tue, 21 Jul 2026 17:16:43 +0200
Message-ID: <20260721152624.185547693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 8ff7f2a6da4fccaa5cc9be7251a24e71e29fbd1a ]

genelink_rx_fixup() splits an aggregated RX frame into its individual
packets, using a per-packet length taken from device-supplied data. That
length is only bounded by GL_MAX_PACKET_LEN (1514); it is never compared
against how many bytes were actually received.

A malicious GeneLink (GL620A) device can therefore send a short URB whose
header claims packet_count > 1 and a first packet of up to 1514 bytes.

	skb_put_data(gl_skb, packet->packet_data, size);

then copies past the end of the receive buffer and hands the adjacent slab
contents up the network stack, an out-of-bounds read that leaks kernel heap.
No privilege is required: the path runs in the usbnet RX softirq as soon as
the interface is up.

  BUG: KASAN: slab-out-of-bounds in genelink_rx_fixup (drivers/net/usb/gl620a.c:112)
  Read of size 1514 at addr ffff888011309708 by task ksoftirqd/0/14
  Call Trace:
    ...
    __asan_memcpy (mm/kasan/shadow.c:105)
    genelink_rx_fixup (include/linux/skbuff.h:2814 drivers/net/usb/gl620a.c:112)
    usbnet_bh (drivers/net/usb/usbnet.c:572 drivers/net/usb/usbnet.c:1589)
    process_one_work (kernel/workqueue.c:3322)
    bh_worker (kernel/workqueue.c:3405)
    tasklet_action (kernel/softirq.c:965)
    handle_softirqs (kernel/softirq.c:622)
    run_ksoftirqd (kernel/softirq.c:1076)
    ...

skb_pull() already verifies that the requested length fits the buffer and
returns NULL otherwise. Move it ahead of the copy and check its result, so
a packet that overruns the received data is rejected before it is read.
Well-formed frames, whose packets are fully present, are unaffected.

Fixes: 47ee3051c856 ("[PATCH] USB: usbnet (5/9) module for genesys gl620a cables")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260627205353.4000788-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/gl620a.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/gl620a.c b/drivers/net/usb/gl620a.c
index 0bfa37c1405918..09afd137b64e15 100644
--- a/drivers/net/usb/gl620a.c
+++ b/drivers/net/usb/gl620a.c
@@ -104,6 +104,9 @@ static int genelink_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			return 0;
 		}
 
+		if (!skb_pull(skb, size + 4))
+			return 0;
+
 		// allocate the skb for the individual packet
 		gl_skb = alloc_skb(size, GFP_ATOMIC);
 		if (gl_skb) {
@@ -116,9 +119,6 @@ static int genelink_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		// advance to the next packet
 		packet = (struct gl_packet *)&packet->packet_data[size];
 		count--;
-
-		// shift the data pointer to the next gl_packet
-		skb_pull(skb, size + 4);
 	}
 
 	// skip the packet length field 4 bytes
-- 
2.53.0



