Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EB020F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DDBC433C7;
	Fri, 21 Jul 2023 19:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967449;
	bh=nmtVQuKlD8EpJmtybrj/cZDBI1k8Z6kOrx3VJC/zcjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZg0XBZOwLp85UpWuxqkFlsAz92+DkX7wTJhnIhLLO0XhuH3wmgMoOStyxFm++95+
	 owHMCmtcjGsjuqzMFCzH1KpGkbFTiGnUfiAD5HDtbysygTQr/uc6KLeBZoUvImM0Uj
	 m8RQ7q+EcHuN+l/8A+EP79VPtN2ocUKPEDTYHOGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weitao Wang <WeitaoWang-oc@zhaoxin.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 166/223] xhci: Fix resume issue of some ZHAOXIN hosts
Date: Fri, 21 Jul 2023 18:06:59 +0200
Message-ID: <20230721160527.954073752@linuxfoundation.org>
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

commit f927728186f0de1167262d6a632f9f7e96433d1a upstream.

On ZHAOXIN ZX-100 project, xHCI can't work normally after resume
from system Sx state. To fix this issue, when resume from system
Sx state, reinitialize xHCI instead of restore.
So, Add XHCI_RESET_ON_RESUME quirk for ZX-100 to fix issue of
resuming from system Sx state.

Cc: stable@vger.kernel.org
Signed-off-by: Weitao Wang <WeitaoWang-oc@zhaoxin.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Message-ID: <20230602144009.1225632-9-mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -335,6 +335,11 @@ static void xhci_pci_quirks(struct devic
 	     pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_4))
 		xhci->quirks |= XHCI_NO_SOFT_RETRY;
 
+	if (pdev->vendor == PCI_VENDOR_ID_ZHAOXIN) {
+		if (pdev->device == 0x9202)
+			xhci->quirks |= XHCI_RESET_ON_RESUME;
+	}
+
 	/* xHC spec requires PCI devices to support D3hot and D3cold */
 	if (xhci->hci_version >= 0x120)
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;


