Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0B66FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38BBC433D2;
	Mon, 19 Dec 2022 19:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671478017;
	bh=9PflqMHndcrEEj+KVu6hLngyH7XT+6q3LunISMM9Eoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfpg3wi/7emVdQpLrpBU0lQhQ0Up1d/qU9FcthsmOptWFjlWb9pWBRK6/KWL+JNiv
	 znl2Ot0+0VfliWSkfP5yP78PUpPj3MlmOBgqD6NHKW3nF+puejJ+BSLJp9EdsBX9JO
	 Z8rEdNY1AGV9eAdFTkGsxjp5pGVtm0i5Zgl3yTww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reka Norman <rekanorman@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 10/17] xhci: Apply XHCI_RESET_TO_DEFAULT quirk to ADL-N
Date: Mon, 19 Dec 2022 20:24:56 +0100
Message-Id: <20221219182941.053489013@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
References: <20221219182940.739981110@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Reka Norman <rekanorman@chromium.org>

commit fed70b61ef2c0aed54456db3d485b215f6cc3209 upstream.

ADL-N systems have the same issue as ADL-P, where a large boot firmware
delay is seen if USB ports are left in U3 at shutdown. So apply the
XHCI_RESET_TO_DEFAULT quirk to ADL-N as well.

This patch depends on commit 34cd2db408d5 ("xhci: Add quirk to reset
host back to default state at shutdown").

The issue it fixes is a ~20s boot time delay when booting from S5. It
affects ADL-N devices, and ADL-N support was added starting from v5.16.

Cc: stable@vger.kernel.org
Signed-off-by: Reka Norman <rekanorman@chromium.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20221130091944.2171610-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -59,6 +59,7 @@
 #define PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI		0x9a13
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI		0x1138
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI		0x51ed
+#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_PCH_XHCI	0x54ed
 
 #define PCI_DEVICE_ID_AMD_RENOIR_XHCI			0x1639
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
@@ -247,7 +248,8 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_MISSING_CAS;
 
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI)
+	    (pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_PCH_XHCI))
 		xhci->quirks |= XHCI_RESET_TO_DEFAULT;
 
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&


