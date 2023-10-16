Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE871944F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idycwlXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E080C433C9;
	Mon, 16 Oct 2023 08:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446168;
	bh=37MZiQbcJRjSr7GL246vjmLQD2FO58qTrf9q8shB5Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idycwlXEf3uil02y8JI3yZcWnCrNqUv2JxZFvow2HknBlCCfVPSlpPdlGGFajOI6b
	 ANNQYSeXYMiNatecirT/qff0ECvAHa2pH2zfDkjx1E7b3LJHYlUauOeTohOEOtc2mB
	 QE855hKdQ59PkDfM6v0Vq2+OtHASO4CuhrvkzmII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 049/102] usb: xhci: xhci-ring: Use sysdev for mapping bounce buffer
Date: Mon, 16 Oct 2023 10:40:48 +0200
Message-ID: <20231016083955.005305326@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wesley Cheng <quic_wcheng@quicinc.com>

commit 41a43013d2366db5b88b42bbcd8e8f040b6ccf21 upstream.

As mentioned in:
  commit 474ed23a6257 ("xhci: align the last trb before link if it is
easily splittable.")

A bounce buffer is utilized for ensuring that transfers that span across
ring segments are aligned to the EP's max packet size.  However, the device
that is used to map the DMA buffer to is currently using the XHCI HCD,
which does not carry any DMA operations in certain configrations.
Migration to using the sysdev entry was introduced for DWC3 based
implementations where the IOMMU operations are present.

Replace the reference to the controller device to sysdev instead.  This
allows the bounce buffer to be properly mapped to any implementations that
have an IOMMU involved.

cc: stable@vger.kernel.org
Fixes: 4c39d4b949d3 ("usb: xhci: use bus->sysdev for DMA configuration")
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230915143108.1532163-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -772,7 +772,7 @@ static void xhci_giveback_urb_in_irq(str
 static void xhci_unmap_td_bounce_buffer(struct xhci_hcd *xhci,
 		struct xhci_ring *ring, struct xhci_td *td)
 {
-	struct device *dev = xhci_to_hcd(xhci)->self.controller;
+	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
 	struct xhci_segment *seg = td->bounce_seg;
 	struct urb *urb = td->urb;
 	size_t len;
@@ -3521,7 +3521,7 @@ static u32 xhci_td_remainder(struct xhci
 static int xhci_align_td(struct xhci_hcd *xhci, struct urb *urb, u32 enqd_len,
 			 u32 *trb_buff_len, struct xhci_segment *seg)
 {
-	struct device *dev = xhci_to_hcd(xhci)->self.controller;
+	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
 	unsigned int unalign;
 	unsigned int max_pkt;
 	u32 new_buff_len;


