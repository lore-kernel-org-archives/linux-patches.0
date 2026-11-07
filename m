Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064666;
	b=de07uDhXS3yrM7lrk+jgEO++ucSPyDdWPNeSLaVsmhuV1tuJuFL9PBI6ZXlQxGtMzw3+
	 FZ93te6n385B/VZDApJ3OIfxcw9Ar00H+X3mOC6Xk1WZ6JScLCNET/LYSu913j6UVWjX5
	 RJlrJfBp7Vt1QDQQtHc7mLuYMiETm3BETZmYTjb4vu5TLPSPlfo4QL0AU+nCyizy00uPw
	 4Wb2IRrHB5L1CrRXUqCaj7Gcs2UEXxRRI1PfJv6noy2/Sy7ZVWP2mAdKjUqRIktwCbtEP
	 ZoXZpi03cnFEob2K7BLvrqyqAKWhhhOrAyHk7GXrr1rIPv57MqO7ezzMJvVwFZtEGlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/QlCR8Zq/oq7kEBkKU6zdfMb4TMs8YrjZNFFFtfidD0=;
	b=P816gK6djPbgLbQnU75AaV0WIZtA3CAVqhffSGoGUPqOOxgVZwFo3bAclR+dol5DwRhO
	 1Up7dou5Vpy8P+56UJQ2qSYSED9MPYloPYw9JbCRET1hsnBKMDbEdKTOozuBfQFRQrulD
	 njU+D+nlCcW3Yo+zyJLwIySEchKkL621IX/eknSElYyWA4YaRmviIphzhfwUfYrvWoRMN
	 KXgsKIXAcYmtx0vHyWTtldrzM64gy9P06Kokqro6J45Lb2ALZ9PY6OEySuo4zcDf5VCdD
	 ni60eCWrLWQ5otPViSnk1+HsW0e7b4VyTHl5Lg57HWJ/4ikfPWufKm8VgycQ9MZocEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZH/ktbX6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6139E606A9CF;
	Sat,  7 Nov 2026 15:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZH/ktbX6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8311F008A2;
	Sat,  7 Nov 2026 15:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064666;
	bh=/QlCR8Zq/oq7kEBkKU6zdfMb4TMs8YrjZNFFFtfidD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZH/ktbX6DNJSf3ikm4Fi2mMZmXrjj13JVakNoISfEkk0iMrUhp9eJbzTuMVlY9d7W
	 +BHVaMfPT0zdTfLZQxO8wvbIlpUZGxVSiTl8Xyrq4CVrnvIZezmurBWQY4tqMm3e1m
	 vcNtQ66Th2CecuzpMCPlBaL/0U91nkrLUGpky2Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+fd80bc5967eb22c3@bugs.sh,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0628/1257] usb: xhci: Fix bounce buffer overflow
Date: Sat,  7 Nov 2026 08:48:44 -0500
Message-ID: <20261107134956.638446827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ec278a9f95404..fffd901b59e7f 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3544,15 +3544,13 @@ static u32 xhci_td_remainder(struct xhci_hcd *xhci, int transferred,
 
 
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
@@ -3697,9 +3695,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
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



