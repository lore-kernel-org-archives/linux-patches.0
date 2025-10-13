Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C322727FE;
	Mon, 13 Oct 2025 15:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368541; cv=none; b=Ksok+xcJGN+SkRJq60ZxmGnq74uUoYJD98twmHX3tY5lHPKTXnrfPd/RgU27vkru6folshMx2+UzeyCGOb2Vim1ynhN/hrbA5YaaDpHeZqO8sBDt9IFJV7sFKHGVeI+GrgZhdDkV+CpJ29bpH2yvYVK6h+Jqpux1mt94sKmsJfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368541; c=relaxed/simple;
	bh=+IHfBzj6VhJC+1DhuekWkK2h/N1U2t2c3WWaLTAnq7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sa+ylHsqPQLO6C0RetqSBNNhC2LRjyLeC54UfaEgMRnb8YlZKmrloETyATSPqXufgkK+51IAtRnfmW4zjPhXyc9jwR+SJIvYQyfRIVxxcZ3pgZ4tdG5V8iMb2lmZ5JleMJooCYtKBI+fs4VBOavDFiakKrlRPeloS7wErskoHwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZy+o2bB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZy+o2bB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C183C113D0;
	Mon, 13 Oct 2025 15:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368540;
	bh=+IHfBzj6VhJC+1DhuekWkK2h/N1U2t2c3WWaLTAnq7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZy+o2bB+ka5ap1azqy1FUNy1inac6wkAYd0j1OWRcBCzcTWg1kO1UcZ8/pFWF5jF
	 SbSMq/4dnRaWDc+gKq815I9vvL6pktI+Eg2002lIENwBUl0FoYUlwegsK9ZaIMFZ9u
	 U7P3cN5PypeCOqQXin6qPKvNc0t7ZQ2a9T2c1i6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 196/262] PCI: rcar-gen4: Fix inverted break condition in PHY initialization
Date: Mon, 13 Oct 2025 16:45:38 +0200
Message-ID: <20251013144333.306724777@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 30d16f85f6465..14f69efa243c3 100644
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



