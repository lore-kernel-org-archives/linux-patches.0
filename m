Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF0C20F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C517C433C7;
	Fri, 21 Jul 2023 19:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967452;
	bh=SMTAppfj/r0OY9yqMV5R0quq6ukbQG+AriRPkhYqBDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZPmlfaciOo1p7+oPUGvg7xgTtWNzcyE4vkzTZMKHXGPzQ7cLh9/IiHbahFK5B5ON
	 /W4ce7dcHGwVFg3JXO9kJCk6iu59rxjKIfdGLnABm01XIFPx/8kMvsgnZyGBetLRGH
	 yvNYrmtSyPTmtlJT4ukubs3wOoUD0NfVOsgNnhRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weitao Wang <WeitaoWang-oc@zhaoxin.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 167/223] xhci: Fix TRB prefetch issue of ZHAOXIN hosts
Date: Fri, 21 Jul 2023 18:07:00 +0200
Message-ID: <20230721160527.996293409@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Weitao Wang <WeitaoWang-oc@zhaoxin.com>

commit 2a865a652299f5666f3b785cbe758c5f57453036 upstream.

On some ZHAOXIN hosts, xHCI will prefetch TRB for performance
improvement. However this TRB prefetch mechanism may cross page boundary,
which may access memory not allocated by xHCI driver. In order to fix
this issue, two pages was allocated for a segment and only the first
page will be used. And add a quirk XHCI_ZHAOXIN_TRB_FETCH for this issue.

Cc: stable@vger.kernel.org
Signed-off-by: Weitao Wang <WeitaoWang-oc@zhaoxin.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <20230602144009.1225632-10-mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mem.c |    8 ++++++--
 drivers/usb/host/xhci-pci.c |    7 ++++++-
 drivers/usb/host/xhci.h     |    1 +
 3 files changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2439,8 +2439,12 @@ int xhci_mem_init(struct xhci_hcd *xhci,
 	 * and our use of dma addresses in the trb_address_map radix tree needs
 	 * TRB_SEGMENT_SIZE alignment, so we pick the greater alignment need.
 	 */
-	xhci->segment_pool = dma_pool_create("xHCI ring segments", dev,
-			TRB_SEGMENT_SIZE, TRB_SEGMENT_SIZE, xhci->page_size);
+	if (xhci->quirks & XHCI_ZHAOXIN_TRB_FETCH)
+		xhci->segment_pool = dma_pool_create("xHCI ring segments", dev,
+				TRB_SEGMENT_SIZE * 2, TRB_SEGMENT_SIZE * 2, xhci->page_size * 2);
+	else
+		xhci->segment_pool = dma_pool_create("xHCI ring segments", dev,
+				TRB_SEGMENT_SIZE, TRB_SEGMENT_SIZE, xhci->page_size);
 
 	/* See Table 46 and Note on Figure 55 */
 	xhci->device_pool = dma_pool_create("xHCI input/output contexts", dev,
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -336,8 +336,13 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_NO_SOFT_RETRY;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ZHAOXIN) {
-		if (pdev->device == 0x9202)
+		if (pdev->device == 0x9202) {
 			xhci->quirks |= XHCI_RESET_ON_RESUME;
+			xhci->quirks |= XHCI_ZHAOXIN_TRB_FETCH;
+		}
+
+		if (pdev->device == 0x9203)
+			xhci->quirks |= XHCI_ZHAOXIN_TRB_FETCH;
 	}
 
 	/* xHC spec requires PCI devices to support D3hot and D3cold */
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1899,6 +1899,7 @@ struct xhci_hcd {
 #define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
 #define XHCI_SUSPEND_RESUME_CLKS	BIT_ULL(43)
 #define XHCI_RESET_TO_DEFAULT	BIT_ULL(44)
+#define XHCI_ZHAOXIN_TRB_FETCH	BIT_ULL(45)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;


