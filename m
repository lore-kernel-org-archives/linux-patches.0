Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7041A315A;
	Mon, 10 Mar 2025 17:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626926; cv=none; b=h7l3UUKmdy+Foap+dM9q3qevu1+tukE1aRDRWUSWL7e038QgwSH6PycYvZl+/alTo/6/LnNqHSknJXud2xfkRZDec0+zrInqg0bOQ5EnijSl2rtMGeXhFRCnUy1TMActjiCmF0HLJDvibKGmTSYMJjnZnHy2uYsODXxC2F7RW2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626926; c=relaxed/simple;
	bh=EDzSk+pVsGJKHDwfSv/ZsNN20surdORObq6NCF0WRWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1z3XaDHl+ilt8CFAu3Vbw6TptOn87xaMtO3sgndcGVEpviPgTlvpr9EhPGy6wLVnygSfnAGnetXi/YyLQSapacjjGLdpBHcCsH+/WJh4SIgxipJds7L1DVyqC2LwJGclGEfMD/XuqR6dM85JOFWMi3L5Y68xdBpMjrRmdiVjsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVkaZkF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVkaZkF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F3CC4CEE5;
	Mon, 10 Mar 2025 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626926;
	bh=EDzSk+pVsGJKHDwfSv/ZsNN20surdORObq6NCF0WRWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVkaZkF85ssAijS7zdvahdvoEqZUETD9YoFJKMT0YXTk8dTI0q4KhkqaM1THpCEz9
	 riukO/yj22x8N0aeTZtlhSdPa5PBvLO/KjWQMPLIJxwx3cW1i2uwg318zjbJ5pYigJ
	 FlOvLPjxGuKfUtL6emp5Mtp6VbArYxyKf3wN+wE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.13 160/207] usb: xhci: Enable the TRB overfetch quirk on VIA VL805
Date: Mon, 10 Mar 2025 18:05:53 +0100
Message-ID: <20250310170454.151946515@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

commit c133ec0e5717868c9967fa3df92a55e537b1aead upstream.

Raspberry Pi is a major user of those chips and they discovered a bug -
when the end of a transfer ring segment is reached, up to four TRBs can
be prefetched from the next page even if the segment ends with link TRB
and on page boundary (the chip claims to support standard 4KB pages).

It also appears that if the prefetched TRBs belong to a different ring
whose doorbell is later rung, they may be used without refreshing from
system RAM and the endpoint will stay idle if their cycle bit is stale.

Other users complain about IOMMU faults on x86 systems, unsurprisingly.

Deal with it by using existing quirk which allocates a dummy page after
each transfer ring segment. This was seen to resolve both problems. RPi
came up with a more efficient solution, shortening each segment by four
TRBs, but it complicated the driver and they ditched it for this quirk.

Also rename the quirk and add VL805 device ID macro.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Link: https://github.com/raspberrypi/linux/issues/4685
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=215906
CC: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250225095927.2512358-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mem.c |    3 ++-
 drivers/usb/host/xhci-pci.c |   10 +++++++---
 drivers/usb/host/xhci.h     |    2 +-
 3 files changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2437,7 +2437,8 @@ int xhci_mem_init(struct xhci_hcd *xhci,
 	 * and our use of dma addresses in the trb_address_map radix tree needs
 	 * TRB_SEGMENT_SIZE alignment, so we pick the greater alignment need.
 	 */
-	if (xhci->quirks & XHCI_ZHAOXIN_TRB_FETCH)
+	if (xhci->quirks & XHCI_TRB_OVERFETCH)
+		/* Buggy HC prefetches beyond segment bounds - allocate dummy space at the end */
 		xhci->segment_pool = dma_pool_create("xHCI ring segments", dev,
 				TRB_SEGMENT_SIZE * 2, TRB_SEGMENT_SIZE * 2, xhci->page_size * 2);
 	else
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -38,6 +38,8 @@
 #define PCI_DEVICE_ID_ETRON_EJ168		0x7023
 #define PCI_DEVICE_ID_ETRON_EJ188		0x7052
 
+#define PCI_DEVICE_ID_VIA_VL805			0x3483
+
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI		0x8c31
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI		0x9c31
 #define PCI_DEVICE_ID_INTEL_WILDCATPOINT_LP_XHCI	0x9cb1
@@ -418,8 +420,10 @@ static void xhci_pci_quirks(struct devic
 			pdev->device == 0x3432)
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 
-	if (pdev->vendor == PCI_VENDOR_ID_VIA && pdev->device == 0x3483)
+	if (pdev->vendor == PCI_VENDOR_ID_VIA && pdev->device == PCI_DEVICE_ID_VIA_VL805) {
 		xhci->quirks |= XHCI_LPM_SUPPORT;
+		xhci->quirks |= XHCI_TRB_OVERFETCH;
+	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI) {
@@ -467,11 +471,11 @@ static void xhci_pci_quirks(struct devic
 
 		if (pdev->device == 0x9202) {
 			xhci->quirks |= XHCI_RESET_ON_RESUME;
-			xhci->quirks |= XHCI_ZHAOXIN_TRB_FETCH;
+			xhci->quirks |= XHCI_TRB_OVERFETCH;
 		}
 
 		if (pdev->device == 0x9203)
-			xhci->quirks |= XHCI_ZHAOXIN_TRB_FETCH;
+			xhci->quirks |= XHCI_TRB_OVERFETCH;
 	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_CDNS &&
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1628,7 +1628,7 @@ struct xhci_hcd {
 #define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
 #define XHCI_SUSPEND_RESUME_CLKS	BIT_ULL(43)
 #define XHCI_RESET_TO_DEFAULT	BIT_ULL(44)
-#define XHCI_ZHAOXIN_TRB_FETCH	BIT_ULL(45)
+#define XHCI_TRB_OVERFETCH	BIT_ULL(45)
 #define XHCI_ZHAOXIN_HOST	BIT_ULL(46)
 #define XHCI_WRITE_64_HI_LO	BIT_ULL(47)
 #define XHCI_CDNS_SCTX_QUIRK	BIT_ULL(48)


