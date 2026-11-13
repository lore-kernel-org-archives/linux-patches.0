Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591378;
	b=l2grqHFyXUDkPjgJcQCvxD3zyubvIzhbHIkhuZmJZAhQz4p1mx9PSfHXXmCgpy9vbjfA
	 jMtiCpxtVZzd4rxfH3whhXBz93GD6ZA0zJl2AJGmamwizeVLelIOKU/9CEpbxg+jZ8L4m
	 4Z1nCCsoS/c7f4QJ0haImaX0ZX9e849AiCVmEpE7E47GS4eZBL4+i1AYv+Br2uBiY6cja
	 nHbqpUjkgwR8Gj/4BORTQPdz7UVHJy/F5q2XRwWjEwHjx0rBEDYX7JsE23ILURvf+Kcxa
	 50kjVzz2ZGT5Yg6ED2E0CQu1FiK2V4i+gvSQ7NNynvVKJq49X0ePkMqTsBTILVjuQ5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3NG9GkgVP+xpLqZA1haj2z/7M7hluTbYg0aJ+T1Cgo0=;
	b=BwwdI+HWcHEHNpgqjKcnSKJJ2bzd60p7Yj6GAJGJ9FKycIbxKV4QswAoXnC0bIx1wiQK
	 yF6MxDfHD2oGTB/4zSF2WS/tPm8BiF8bjZrB02tWVpPRFxVfiJVPngsv3Pc8UtEKwNU3W
	 8aMQzDT7CdUqsX/K9dtSE4iEksbzXCnvo1Igrz3ih6VqHDmgk9pK6PrA44Q85mgcYG3tA
	 IczBzEOpaKj/3cNY5N+IBCGoE4fZcfulwsqQeOvlz/CAn0t2iEo+8nITDRzmWfPcPCUbV
	 ueFGAKAMZcEbcz/+Eo3CYKT5WXK77mQoYSDUvB4ekC31YHfndDsjDoscOlpMD4l1EyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tM1Esqje;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02F6606B234;
	Fri, 13 Nov 2026 17:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tM1Esqje
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D9C1F000C5;
	Fri, 13 Nov 2026 17:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591378;
	bh=3NG9GkgVP+xpLqZA1haj2z/7M7hluTbYg0aJ+T1Cgo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tM1Esqje9FyibfjM1sHmkw5fVrpoTcSMZUO6AsxejA5e9H1ppY8PScBofJVlhKX2W
	 G2drs/CasO2mbr5O2LZ8U0wq40ScUr3pI886V/B8VdALHHndoQJgTXrk3ULjFPAQBR
	 tMBiY1ItqlGZ10ev0ozqnstzEwqvmZtF89WuQJxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+fd80bc5967eb22c3@bugs.sh,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 481/670] usb: xhci: Fix bounce buffer overflow
Date: Fri, 13 Nov 2026 10:50:45 -0500
Message-ID: <20261113153828.248292552@linuxfoundation.org>
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
[ sashal: Removed usb_endpoint_maxp() instead of xhci_usb_endpoint_maxp() in xhci_align_td(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 597a9a8c16b9f..2c35cb444f737 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3583,15 +3583,13 @@ static u32 xhci_td_remainder(struct xhci_hcd *xhci, int transferred,
 
 
 static int xhci_align_td(struct xhci_hcd *xhci, struct urb *urb, u32 enqd_len,
-			 u32 *trb_buff_len, struct xhci_segment *seg)
+			 u32 *trb_buff_len, struct xhci_segment *seg, u32 max_pkt)
 {
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
 	unsigned int unalign;
-	unsigned int max_pkt;
 	u32 new_buff_len;
 	size_t len;
 
-	max_pkt = usb_endpoint_maxp(&urb->ep->desc);
 	unalign = (enqd_len + *trb_buff_len) % max_pkt;
 
 	/* we got lucky, last normal TRB data on segment is packet aligned */
@@ -3736,9 +3734,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
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



