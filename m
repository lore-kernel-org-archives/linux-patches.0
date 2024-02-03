Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AC141C98;
	Sat,  3 Feb 2024 04:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933647; cv=none; b=jfSdVxSTJAtEE/PLENS2ph9/lGWK9mZ9HNmfJGJcpmPBb+3QhAeJur7HngCETpz6J02lHxNhxKSVd3XwKvyAQ52IYUdirm2ImYWDGQd3REdyhUTsxdVkSAZ/dHiiJJ/ltQ6ma4fdEjITfB9uSSL8alZTTie0cH71peVpUIpk0O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933647; c=relaxed/simple;
	bh=kRdpAldQlXFpWsCHPA64hxcHDyqLjAgdX3YnsI3qE5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kral2aW3btn7D8jnbHbzxBByW384A2UVBSfuBd1aVXsRBuVVPcxfhrWkrJi2rbxojleH25BIOGrfUbE2VV7aN1bI4ItOpl64RIb5Ti7o9lwzW/QU6h1TZwMZEipMuNOQrW1qsqNqXNGcog1Epz6f5v8DIsKlrdvLr2H/4UXYd/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8f6hEPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8f6hEPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC47FC433C7;
	Sat,  3 Feb 2024 04:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933646;
	bh=kRdpAldQlXFpWsCHPA64hxcHDyqLjAgdX3YnsI3qE5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8f6hEPqS8pnULzghQrr37pIZqZQANo6xclQb1PMjHHqmfRT6bXnrekK61JxKeJZu
	 BlxMHQh0syBi5sLRJYoSGopiE/exZbSO3l83nt3pyKDVcdl5u1RVQwGZJleiyWWEIr
	 1Ahff1q+mKf2rCoH/8XiNXdr/VzBxKTcm7K1V8XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Huang Rui <ray.huang@amd.com>,
	Vicki Pfau <vi@endrift.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 229/322] PCI: Only override AMD USB controller if required
Date: Fri,  2 Feb 2024 20:05:26 -0800
Message-ID: <20240203035406.605968168@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8f3b91e0d264..b5b96d2a9f4b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -702,10 +702,13 @@ static void quirk_amd_dwc_class(struct pci_dev *pdev)
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



