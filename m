Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4165E7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49863C433D6;
	Wed,  2 Nov 2022 02:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356806;
	bh=4e2EYndJHgu+BCxLjWsaIE/peMlQlXIgh8jZ4wEIebM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Un7jmmFTEDZW4wUpy+A+ycZGKjGB4E5/9Jb7ANw7CIGkAaS73knh/LHCP9JYFkvyQ
	 0voSvtSJMqteG754bOz8EqHLyzA3AtKHC44lP1ZPxFw4jmCUE20xAltMQYzsoIKmnb
	 KtWicMfyeai0IxCjsHhk8x5qVe2+iwj5CEwtx3OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Glathe <jens.glathe@oldschoolsolutions.biz>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.0 034/240] usb: xhci: add XHCI_SPURIOUS_SUCCESS to ASM1042 despite being a V0.96 controller
Date: Wed,  2 Nov 2022 03:30:09 +0100
Message-Id: <20221102022112.176122964@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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
@@ -306,8 +306,14 @@ static void xhci_pci_quirks(struct devic
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


