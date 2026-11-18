Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053712;
	b=zKFYGQ3/neDX+v54zdU81AoNhLxhClXgSRIxwiOveliwO7bEhRe0bJTVrvnguxa+3z0R
	 Wn2U77K/BG2SiNCUU7NFRvXLwB2Xk/FTk80VhJDvsH1F8z1BD8wE+Rh5fNUa+sghfBls/
	 MzzOCIcjQvr2rQ+KPzZho12ZOIxnNaltItQCWDlCEgJloWVG/7DoTt/HAIFBtQMGNmzjN
	 g6rqoRsVIaiciifSLMIdFvGTq65/PGNA00Aoyglx3v+Qj4sUTdnE4PmY8XBawbserA14H
	 a1LQyQI5fej1vwhFOk+/4vobGi0tpkYnuWuGCqkHoet2nRbEzZgo09dYNfzHys3wkMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b3hYg7g+DRqep8bwr4jOxdfAkZvHF2TxnybdXGcEwWQ=;
	b=AEiL3v/I32Fc5SYkIKEKhThp33vQuBv49Xp8IuOkDLPYZoYwpoi+u5mKFYOnwFTI83Uu
	 4m6HT/SMiIcttRBOjKGhR08bcpsi1avvZ/thMna67gPUjL7ZvKHVE1G5EaWmZDi9rXo5P
	 kTjdfDwZ7z3vr51PdZxRa3UdPrUbKksdD0IyeQze5CpGv72zZRKx8PLnSgWO00xNI9dQR
	 S6srU/IX/V7s+NmX4TocRHBII2eO2cPNgAntl4GyAWHA66bAo7i7F1dzbIMukyUROgExb
	 mygQ2unuL3/sv90gyw9HJweGZI3kLW1ijx4rF8vevRgGNbMMV+zjCSwlaRP/AeqdwQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oauFNgpX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F06606A31C;
	Thu, 19 Nov 2026 02:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oauFNgpX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E921F000C4;
	Thu, 19 Nov 2026 02:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053712;
	bh=b3hYg7g+DRqep8bwr4jOxdfAkZvHF2TxnybdXGcEwWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oauFNgpXgsNa9HWpYhuOGOM7aLTPir6NYMLjmWgur1KZALG5Hy7dcdww6mC0sV6KH
	 OMJCagNiMc6poRh5CuqZn3Mxe4XYruZe+8xMwRY164PZ0TUSoP2ZPLqYcAkO755ho7
	 mK/GYPKDY1SPrjIWqYVDZZHeU28JgoO8Pa36WTQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+fd80bc5967eb22c3@bugs.sh,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1015/2214] usb: xhci: Fix bounce buffer overflow
Date: Wed, 18 Nov 2026 15:44:51 +0100
Message-ID: <20261118150052.977356885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
[ sashal: adapted removal of xhci_usb_endpoint_maxp() to the existing usb_endpoint_maxp() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 978ff4d112fb8..b8da9386b5af6 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3689,15 +3689,13 @@ static u32 xhci_td_remainder(struct xhci_hcd *xhci, int transferred,
 
 
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
@@ -3842,9 +3840,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
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



