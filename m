Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDE030DD37;
	Mon, 13 Oct 2025 15:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370007; cv=none; b=a9TjAGvsZMJhlBQRC+fg485DIpR+ylpOm8xpCIUDsO98i7tG3BLvSSXYN+ts6E4+BX27fwj2106sWHf5AduI3axCXzi6POQ3icOZweYxoFG88h5nyvNiX5ikG3fCUdMTbNcGQDtckcyQ5jm0I19Puhz8xNaJQuBC2r0m6tOKyhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370007; c=relaxed/simple;
	bh=2nlmFnKULJxfhETje2LpF43WkOY3fgeiGPnPn/7imkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/G50p/BULm5b9Oz7NFwRYH9Zfa15zpitClxQpqfzJqSjAETHS3IP0eJcl3knIlzQgveQOaPwsmra/WC8NOE6NEgHj226Hrwx/x9UM9v3x2ZEVupH+UvVyjCbOnmIQVbZnupyrf3Lm8G6NN6vdkm048Murbkx6A4HQBRYIfc7dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5iRBGob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5iRBGob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC3CC4CEE7;
	Mon, 13 Oct 2025 15:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370007;
	bh=2nlmFnKULJxfhETje2LpF43WkOY3fgeiGPnPn/7imkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5iRBGobn3UKWaaYgr/jLebHBsH2hC7jz9EFQX3VnwTaSEJekolhcLeQztlUP/da3
	 2t5XD7fHjUblcNwGj2rSE5Q2jLjDnSTgRCEkYGGIucIZJpllilJWnyRXtZSdecSsjO
	 adiSQzGzEixN43HMew5Vb/HAgcLIeV7SJMJ6tFOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 444/563] PCI: rcar-gen4: Fix inverted break condition in PHY initialization
Date: Mon, 13 Oct 2025 16:45:05 +0200
Message-ID: <20251013144427.366419834@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 2bdf1d428f48e1077791bb7f88fd00262118256d ]

R-Car V4H Reference Manual R19UH0186EJ0130 Rev.1.30 Apr. 21, 2025 page 4581
Figure 104.3b Initial Setting of PCIEC(example), third quarter of the
figure indicates that register 0xf8 should be polled until bit 18 becomes
set to 1.

Register 0xf8, bit 18 is 0 immediately after write to PCIERSTCTRL1 and is
set to 1 in less than 1 ms afterward. The current readl_poll_timeout()
break condition is inverted and returns when register 0xf8, bit 18 is set
to 0, which in most cases means immediately. In case
CONFIG_DEBUG_LOCK_ALLOC=y, the timing changes just enough for the first
readl_poll_timeout() poll to already read register 0xf8, bit 18 as 1 and
afterward never read register 0xf8, bit 18 as 0, which leads to timeout
and failure to start the PCIe controller.

Fix this by inverting the poll condition to match the reference manual
initialization sequence.

Fixes: faf5a975ee3b ("PCI: rcar-gen4: Add support for R-Car V4H")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250915235910.47768-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-rcar-gen4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-rcar-gen4.c b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
index 9ac3f0f11adad..c16c4c2be4993 100644
--- a/drivers/pci/controller/dwc/pcie-rcar-gen4.c
+++ b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
@@ -733,7 +733,7 @@ static int rcar_gen4_pcie_ltssm_control(struct rcar_gen4_pcie *rcar, bool enable
 	val &= ~APP_HOLD_PHY_RST;
 	writel(val, rcar->base + PCIERSTCTRL1);
 
-	ret = readl_poll_timeout(rcar->phy_base + 0x0f8, val, !(val & BIT(18)), 100, 10000);
+	ret = readl_poll_timeout(rcar->phy_base + 0x0f8, val, val & BIT(18), 100, 10000);
 	if (ret < 0)
 		return ret;
 
-- 
2.51.0



