Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046764;
	b=swF+mEQgK+ziKeRfWWkcB5KQXOBxJ40mMmDsHqEY2FjGMT16sXYnYv3BxI735JGI8cyd
	 eksLu8tC0q3+nxpHZL7XBeCW7bthSII0LgUVVaSigeUd4TovXQF9ODl0+hGgIy9AMnkqw
	 Q8uByqfaeZNUIA4JVVfUXEiEk+O4OpkKI3R1LbQlgMdvRzriHXx1Dc3iE6usUfGSf01Ov
	 RYu3VdeCwthyhxa2/f/b9ZdzEOaWmUWY4D5cHGlurkHgRII/iAqH+Hgf8mPZd7ofrwT0b
	 roj8Zgjc423yi4jTigsuaRZ0mLEBPizz9gjWrmqmAji04YEtU0b1GVN5xyWA9iU8nzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pgxFLQ44M7K/j88/XiHpcWujPiRDh81ZXvF6PaZ4ock=;
	b=lvV1ifq+PPEIij1vuuUzr2ZeaZfeHZPQszK3+/0A7jcow01YqbOCOlvQOKXxuVSWC3qf
	 ncXJrNYtkPaXgab4fjwj8Hy8QsX+4KxtdL3W7COLjqmURsSoCM4gcNeDJaXFEbZg879Tm
	 40lKUidvtK1VvpAtKb7D3PEmnM7UjFK55dhU6DEXaPem/RcaMfrCACIA31dHEzcmZ4EVY
	 6qCWemceE5V/2qyqY2lHPEhbfJ9Xm0m6jJ1sO6cn4jgA8VZWH4azobgk9ez4a1QftCo1h
	 AGbPBxl7G6nI2bwfZIearr1WBoF0ebILtSAuZadmObxt0s7kM9hOwHUGUu1QjDqGKLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AO1yldbD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C84606A320;
	Thu, 19 Nov 2026 00:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AO1yldbD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4AA1F000C4;
	Thu, 19 Nov 2026 00:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046763;
	bh=pgxFLQ44M7K/j88/XiHpcWujPiRDh81ZXvF6PaZ4ock=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AO1yldbDujn3ahn05qU6wzJrHESSTpQx4fuuPZ/GsN0WiFgxKcwsDt8Gl9ZsAMkeb
	 H1gepExZl70nVmFSsV4FmaN/f5F6sKnERX3nyusKizY6WrnFeK2tgF8O7CJpayKmKH
	 zUiuTU4Pl+aAmGyULuB+YPkM0JivHcQsNXWVdnlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+fd80bc5967eb22c3@bugs.sh,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1397/2857] usb: xhci: Fix bounce buffer overflow
Date: Wed, 18 Nov 2026 15:40:31 +0100
Message-ID: <20261118150251.653705994@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted the max_pkt replacement for the existing usb_endpoint_maxp() call instead of xhci_usb_endpoint_maxp() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 3f34aa004bc98..9c1b97846266e 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3619,15 +3619,13 @@ static u32 xhci_td_remainder(struct xhci_hcd *xhci, int transferred,
 
 
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
@@ -3772,9 +3770,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
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



