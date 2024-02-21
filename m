Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E094279DBF;
	Wed, 21 Feb 2024 14:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524315; cv=none; b=QHeOJp/YPypBGSq+nh34vbhC816on63EYUvBzqZ3DfLm4Sh4F6Kq1bNBFdFRWcUrsVco8nGvKuGnn1VIns3fDKO1MHDzkyI/1G3UkT37M52RWQr01MaM/h5FWJM2OIgQeBXIT9KNAU5RxTtki7cMjJW5CvFJJF7t6H4PXbcup9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524315; c=relaxed/simple;
	bh=hSBKY5jNF50ROsynj2hYNHSA02iumKQR2Ljzhw+okK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5VLev+j4uSORfBrTsNdwJjEeAjxxIn13p5QiTukllgYtvpWb9nx4e4SWBx/vAToRt5c23TYclx0vHEbdWbOmNca2n+D3UQN4i0f6GeqrlEZWim+eUIMhIpXIwhuZYODq11wV6qQV4t0ygXrZGJFvVpE1U3kmrW4/ZPBkeosP5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gs7arh7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gs7arh7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184EEC433C7;
	Wed, 21 Feb 2024 14:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524314;
	bh=hSBKY5jNF50ROsynj2hYNHSA02iumKQR2Ljzhw+okK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gs7arh7ticG8g4BUH8lJuEb88gQxaALurVVNgh8kBTkqmq7CHPSBs6S0yRkjkJrrg
	 nCH1CSqNK2qAz5D6DijdZegGX5cJcG+kqlHlsheSlAFdPiawD8OAHTwqFbJbGFfijK
	 Kh7C6ZJXj/xXvhnWaNkyD2sy47JBkYXk7D5+btL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Huang Rui <ray.huang@amd.com>,
	Vicki Pfau <vi@endrift.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/379] PCI: Only override AMD USB controller if required
Date: Wed, 21 Feb 2024 14:06:26 +0100
Message-ID: <20240221130001.024708571@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

[ Upstream commit e585a37e5061f6d5060517aed1ca4ccb2e56a34c ]

By running a Van Gogh device (Steam Deck), the following message
was noticed in the kernel log:

  pci 0000:04:00.3: PCI class overridden (0x0c03fe -> 0x0c03fe) so dwc3 driver can claim this instead of xhci

Effectively this means the quirk executed but changed nothing, since the
class of this device was already the proper one (likely adjusted by newer
firmware versions).

Check and perform the override only if necessary.

Link: https://lore.kernel.org/r/20231120160531.361552-1-gpiccoli@igalia.com
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Vicki Pfau <vi@endrift.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 03a30734cdc6..b67aea8d8f19 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -609,10 +609,13 @@ static void quirk_amd_dwc_class(struct pci_dev *pdev)
 {
 	u32 class = pdev->class;
 
-	/* Use "USB Device (not host controller)" class */
-	pdev->class = PCI_CLASS_SERIAL_USB_DEVICE;
-	pci_info(pdev, "PCI class overridden (%#08x -> %#08x) so dwc3 driver can claim this instead of xhci\n",
-		 class, pdev->class);
+	if (class != PCI_CLASS_SERIAL_USB_DEVICE) {
+		/* Use "USB Device (not host controller)" class */
+		pdev->class = PCI_CLASS_SERIAL_USB_DEVICE;
+		pci_info(pdev,
+			"PCI class overridden (%#08x -> %#08x) so dwc3 driver can claim this instead of xhci\n",
+			class, pdev->class);
+	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_NL_USB,
 		quirk_amd_dwc_class);
-- 
2.43.0



