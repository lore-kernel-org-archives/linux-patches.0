Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE4917E459;
	Wed,  3 Jul 2024 10:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003385; cv=none; b=dOjFbvax93RF0vF+TGSLRKIgtxbra546R6D3unW9iaIOpSCe2N3lQwYmOJcSPMAQh1bsLqjuMoMBSzurmnEq8Cb1AgJH71H5Nw9XJuv9H8erdLrMPGbJLj4j1MLgbeIUD/MgcJcRBv3sfItOZIWvw0nxxyf+T5hF754RyuLF52E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003385; c=relaxed/simple;
	bh=jsLZcq4zycgNPJxi2uWxVJGIP/vGidxfQfmMZoe5zp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I//Q9TqVfTOqsXmyYHeuQ68mGrMdofiyBMOeTlweMMyQl3JLscqMOsBuTDGk2znd8GLxKO67Mm6DCqktO2xGZdu+oSRGM5V9kdXkVr7i5i1FukaKy5lyBnlNEOO6xI08BMIKL1VEwye2HLwxYI9Y+bAdeED2hCxK2Hfc8D74hNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0vjjnObO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0vjjnObO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF6BC2BD10;
	Wed,  3 Jul 2024 10:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003385;
	bh=jsLZcq4zycgNPJxi2uWxVJGIP/vGidxfQfmMZoe5zp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0vjjnObOgFcKR4aK3hlHnGSpA/tqQZe9BUMQZK3G3X+E8XFeVl1ZZ+4oXws+fqswV
	 lccSNRPO+DWlJ9hBvH1yocc3PjKvqQY4FoQ9uaf87/EU9zbpa8+STBKhIMlV4hZypU
	 K/+JzjXowVylHnJhWoWuzK8LM2trgnojCem2FM5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 032/139] xhci: Apply reset resume quirk to Etron EJ188 xHCI host
Date: Wed,  3 Jul 2024 12:38:49 +0200
Message-ID: <20240703102831.654210016@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuangyi Chiang <ki.chiang65@gmail.com>

commit 17bd54555c2aaecfdb38e2734149f684a73fa584 upstream.

As described in commit c877b3b2ad5c ("xhci: Add reset on resume quirk for
asrock p67 host"), EJ188 have the same issue as EJ168, where completely
dies on resume. So apply XHCI_RESET_ON_RESUME quirk to EJ188 as well.

Cc: stable@vger.kernel.org
Signed-off-by: Kuangyi Chiang <ki.chiang65@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240611120610.3264502-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -33,6 +33,7 @@
 
 #define PCI_VENDOR_ID_ETRON		0x1b6f
 #define PCI_DEVICE_ID_EJ168		0x7023
+#define PCI_DEVICE_ID_EJ188		0x7052
 
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI	0x8c31
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI	0x9c31
@@ -223,6 +224,10 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 	}
+	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
+			pdev->device == PCI_DEVICE_ID_EJ188)
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
+
 	if (pdev->vendor == PCI_VENDOR_ID_RENESAS &&
 	    pdev->device == 0x0014) {
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;


