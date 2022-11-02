Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CD57E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C2DC433C1;
	Wed,  2 Nov 2022 03:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358101;
	bh=S4iKR3j3/dPQLiL7T3FJY6bIoN0XSCrny/AqU6Y9218=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIBdCNbgqlSDwT5/bnncRi4H507rnByzMi5aiEBI0gVfWcGs8BBIvjms06p5wuyc6
	 ASKoICJB40HVZRQZ+xpEEhyFcjjzzbaM7GYKqz3sKpnmEdVyFG8Yfj6wqr+T5L43mF
	 bWKPw2B4eLV+hd1NiCUNJloJY8HHe8DzBCVV+o1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Glathe <jens.glathe@oldschoolsolutions.biz>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 015/132] usb: xhci: add XHCI_SPURIOUS_SUCCESS to ASM1042 despite being a V0.96 controller
Date: Wed,  2 Nov 2022 03:32:01 +0100
Message-Id: <20221102022100.026895598@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Glathe <jens.glathe@oldschoolsolutions.biz>

commit 4f547472380136718b56064ea5689a61e135f904 upstream.

This appears to fix the error:
"xhci_hcd <address>; ERROR Transfer event TRB DMA ptr not part of
current TD ep_index 2 comp_code 13" that appear spuriously (or pretty
often) when using a r8152 USB3 ethernet adapter with integrated hub.

ASM1042 reports as a 0.96 controller, but appears to behave more like 1.0

Inspired by this email thread: https://markmail.org/thread/7vzqbe7t6du6qsw3

Cc: stable@vger.kernel.org
Signed-off-by: Jens Glathe <jens.glathe@oldschoolsolutions.biz>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20221024142720.4122053-2-mathias.nyman@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -307,8 +307,14 @@ static void xhci_pci_quirks(struct devic
 	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI)
+		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI) {
+		/*
+		 * try to tame the ASMedia 1042 controller which reports 0.96
+		 * but appears to behave more like 1.0
+		 */
+		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
+	}
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI) {
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;


