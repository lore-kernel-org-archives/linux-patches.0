Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36BE1A76A1;
	Tue, 30 Jul 2024 17:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360251; cv=none; b=ZiJksOgbaCKasQVmxN+fj8jTaKIly1ZO9x+A1tFLnYRmyxL+GXQxLMuSXCrwFZX5WNmPvaWg+l2n8Ia5114ngTjjOW+QpLP5yAzDNohBmvugIf7XL6c5XQy1PwZ7wvOT/bfArDlUCGnPxqLraqvO/HWJIob6l6Jn8BO20rtmtps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360251; c=relaxed/simple;
	bh=PrixVi/FU+mOa3iMiqKid+ITNQg4j2dN37tFbtY5suU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjZMl3eG/d2wK+5kcm3uM2MQ4Wgikru3qfQZTuvY4V0eu14jKeK2Dv2JhPszYiwfyl6fNdEOIU/OOSMjuodRJvAbhCk9K3rS+vY7x5Cz5wwhcf98C2GmLxtPTSC/G0lWvfAWkRpbWtpAvzkdsmLxrEUkpImTRuNk+AC5eeM9TyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8i7+w0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8i7+w0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6729EC32782;
	Tue, 30 Jul 2024 17:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360250;
	bh=PrixVi/FU+mOa3iMiqKid+ITNQg4j2dN37tFbtY5suU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8i7+w0qGkHVf0EN5/Gb9bzdHuEZ/J5YyeM5GIxJBXDdqgSLEcu5RqiT0+PuxAEGO
	 tBWFcaX1+EWnwhLG/1nY1ID1FELoCp/lEHOku58GEN8VR/jfwA4NaxJL+LxtmG++0Y
	 U499eVi2pILIOUgd/4dI1/aym7ct8ovy7QxOfTRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reka Norman <rekanorman@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.10 643/809] xhci: Apply XHCI_RESET_TO_DEFAULT quirk to TGL
Date: Tue, 30 Jul 2024 17:48:39 +0200
Message-ID: <20240730151750.262585841@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reka Norman <rekanorman@chromium.org>

commit b4c87bc5ce9292d494d9354e25cc8ea152fbcbbd upstream.

TGL systems have the same issue as ADL, where a large boot firmware
delay is seen if USB ports are left in U3 at shutdown. So apply the
XHCI_RESET_TO_DEFAULT quirk to TGL as well.

The issue it fixes is a ~20s boot time delay when booting from S5. It
affects TGL devices, and TGL support was added starting from v5.3.

Cc: stable@vger.kernel.org
Signed-off-by: Reka Norman <rekanorman@chromium.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240626124835.1023046-21-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -50,6 +50,7 @@
 #define PCI_DEVICE_ID_INTEL_DENVERTON_XHCI		0x19d0
 #define PCI_DEVICE_ID_INTEL_ICE_LAKE_XHCI		0x8a13
 #define PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI		0x9a13
+#define PCI_DEVICE_ID_INTEL_TIGER_LAKE_PCH_XHCI		0xa0ed
 #define PCI_DEVICE_ID_INTEL_COMET_LAKE_XHCI		0xa3af
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI		0x51ed
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_PCH_XHCI	0x54ed
@@ -373,7 +374,8 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_MISSING_CAS;
 
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    (pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI ||
+	    (pdev->device == PCI_DEVICE_ID_INTEL_TIGER_LAKE_PCH_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_PCH_XHCI))
 		xhci->quirks |= XHCI_RESET_TO_DEFAULT;
 


