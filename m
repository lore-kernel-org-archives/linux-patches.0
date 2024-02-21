Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D993669951;
	Wed, 21 Feb 2024 13:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522758; cv=none; b=TfZJcVthzv3QRqnw1gX+OxQDIJC5laQrUn7dnLBhWko7G2GxwRMJpr8T+Fc3nnewpocIxTqzjfDyLsL9mtHmEy4+uiwqcqJ2zTrJU/Glj9fLgJyWDUd6bt+6ObKpiVTC6/WiWqe+aNDoqSYyBf8ubfH8vlh4E8MpxLZyRoGRLn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522758; c=relaxed/simple;
	bh=L9ACVQBSaW8UXyWK8bb3ifYd5uavL6hUdfk8pnefA/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVIIhHV3Z4vdK8mLTjTn4F0xw738PuB7Dd/DLUQEA7OijJ8zDJ/JqPwHS9IOggSLe3iRip/jPHdBdEMGkbph8Bfstpb8yKklVYvDcvNQ0pvIgcdE6Cbg35gb79+5m6rZj+Q4uBTVSD0gz/nPOhgDPMRSl0cB9XVszvH0Sx/8sTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsp2y61Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsp2y61Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658B1C433C7;
	Wed, 21 Feb 2024 13:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522758;
	bh=L9ACVQBSaW8UXyWK8bb3ifYd5uavL6hUdfk8pnefA/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsp2y61QE5C4HjuIbtkaicD+Jj9/VX7Ac8qNKmpGviks634F78AApsdKqd872uQ4r
	 QvdngvuDEsYO3AVMn37r+i7rYl7ErL4rltR9zl8d0ZHB/XMctMse/PhRvHGM5sTTEO
	 9ZVlcYiUbQLz8nPvCw3ch/yJ21TvnloBnjsM/ETU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Huang Rui <ray.huang@amd.com>,
	Vicki Pfau <vi@endrift.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 249/476] PCI: Only override AMD USB controller if required
Date: Wed, 21 Feb 2024 14:05:00 +0100
Message-ID: <20240221130017.066332880@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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
index be43ea2a15e7..fcdc17bbcc8e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -604,10 +604,13 @@ static void quirk_amd_dwc_class(struct pci_dev *pdev)
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



