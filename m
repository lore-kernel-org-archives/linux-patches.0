Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063261;
	b=Lndd+oQZTfTGJvnc9/8il4aOBAIL8N0YGgHEDcrsZMbaJNXdga9OkKqoa1fKWEA1wkiB
	 WbtzBdEql9XqrpWGhMvuntRGApeakEW2XCBLCK18Df/jpWprBl8WTPqj+yanHdJs8SpUy
	 3uDe+gvZbZHN+mI8WmkEuWmz9gx/uhuiBWwth068h01SNAC2jck4d0NWOKZfhT21ncHIt
	 +0vaP2dvuqg3qBajtJQk1kuOz///LRom5mbNqcQHe5o9uGmmUHlovoWTRlHJgGKzxzB89
	 gzw3KdjSrGI3KdYp6XN13tVz5YfrRrwgMo3tH1FXOnT0+Vv3fSvUFv9QzI1sbKoTEzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ay4SnrDerLx5rHXMG8sQIrsJSbskjy3aPwNTXEV+J/M=;
	b=qiJa29uaeUrtmYNNJ289SHSy5Qpud1UIX4aG98aMmzGKGmldsEXHzYYqzvyjxbYkOyIv
	 4R/h9ZJ+ThZS8P+aKFFE+Gd+Nt9m8p/1Qi1aW/ks9jjAkPQdUDcnldE2hQ245/1HAJZiL
	 cwNybcU2ozMO3ICCa+0ZlSl4MDdIvw2RQMU6ipWIHcX9sgFr22gAPJ8zXyP18irBart54
	 O2t3XWQkhU4kZLaK2aWgaA95Z7BiaIWuFWBgvpuMjwT6u9sbd/jQf8HDH7Ov1Mhe3w7Y1
	 K57PnvQdL/UbHwmMvw9Qwzm/LeVcrwtY2YDXq6dpg7M7+Fh6KsYtnj7g6CkPmJ2JN6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3ZoGT0T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E2C606A331;
	Sat,  7 Nov 2026 14:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3ZoGT0T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054BD1F0089F;
	Sat,  7 Nov 2026 14:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063261;
	bh=ay4SnrDerLx5rHXMG8sQIrsJSbskjy3aPwNTXEV+J/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3ZoGT0TWrbbz8LIxMJu/pVkxyAlM50ZKNRJoKR1No8Q392gt5ooD3CagmoDHFley
	 zFchqlVTu0baKbQqYnflus0FXnquqe3OaeQARjzaKTvXHRacc6iyzn7hhkSoPeudj6
	 mhTvRLy8WFZHATaajcOT1XEDoP1EUjiErOSkBExI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+fd80bc5967eb22c3@bugs.sh,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 461/869] usb: xhci: Fix bounce buffer overflow
Date: Sat,  7 Nov 2026 08:52:23 -0500
Message-ID: <20261107134909.307877236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit 68c5cb7574c567e83ba95258cb146db95e069a87 ]

High-speed devices with out of spec 1024 byte bulk endpoints exist and
are allowed by USB core, but xhci-hcd always sets packet size to 512.
The exact nature of these devices isn't documented, commit fb5ee84ea72c
("USB: Accept bulk endpoints with 1024-byte maxpacket") only states
that they "don't work with xHCI host controllers", whatever it means.

But somebody (or a malicious device) can try, and then the driver will
allocate a 512 byte bounce buffer for this endpoint and may write up to
1024 bytes into it if particular scatter-gather URBs are used, because
xhci_align_td() obtains packet size from the descriptor. Fix this.

As a side effect, TRBs will be aligned to the packet size chosen by the
driver on all endpoints of all speeds. Alignment serves the xHC, not
device, so this is fine. Only out of spec devices are affected anyway.

Reported-by: co+fd80bc5967eb22c3@bugs.sh
Link: https://lore.kernel.org/linux-usb/D4tcSGerkYkIV1DmaUo1t8TaR5qQElDLkidn@bugs.sh/
Fixes: f9c589e142d0 ("xhci: TD-fragment, align the unsplittable case with a bounce buffer")
Cc: stable@vger.kernel.org
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20261009151624.618967-11-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index dc18da8385a21..071a0310d6100 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3600,15 +3600,13 @@ static u32 xhci_td_remainder(struct xhci_hcd *xhci, int transferred,
 
 
 static int xhci_align_td(struct xhci_hcd *xhci, struct urb *urb, u32 enqd_len,
-			 u32 *trb_buff_len, struct xhci_segment *seg)
+			 u32 *trb_buff_len, struct xhci_segment *seg, u32 max_pkt)
 {
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
 	unsigned int unalign;
-	unsigned int max_pkt;
 	u32 new_buff_len;
 	size_t len;
 
-	max_pkt = xhci_usb_endpoint_maxp(urb->dev, urb->ep);
 	unalign = (enqd_len + *trb_buff_len) % max_pkt;
 
 	/* we got lucky, last normal TRB data on segment is packet aligned */
@@ -3753,9 +3751,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 		if (enqd_len + trb_buff_len < full_len) {
 			field |= TRB_CHAIN;
 			if (trb_is_link(ring->enqueue + 1)) {
-				if (xhci_align_td(xhci, urb, enqd_len,
-						  &trb_buff_len,
-						  ring->enq_seg)) {
+				if (xhci_align_td(xhci, urb, enqd_len, &trb_buff_len,
+						ring->enq_seg, ring->bounce_buf_len)) {
 					send_addr = ring->enq_seg->bounce_dma;
 					/* TD bounced at least, and last on this seg */
 					td->bounce_seg = ring->enq_seg;
-- 
2.53.0



