Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D703E31DDA4;
	Mon, 13 Oct 2025 15:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370001; cv=none; b=NXbiuPx8se174mC3TP3JV66qLk5b37qDRzAtN3V/4Z/MV6w27mUzm/n69EWhDlaWlCDDeqvbfbthREIDAlXwbBsH4QbgEE6rnRabZqXfKhqgGzjiZtQ4zuvoV1zWxlcjtyWZjgoICOmJSEAekRA/rFxaFrT0GxgV8YR/s7GwbYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370001; c=relaxed/simple;
	bh=wnB7Fn+7oz5MAW0UaDlR7ukLxrxAAQjXpdZGoJp7Up8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=geaUFJInhJlBv0Saizudpi0O1ZXNvJ4bb/Ou/KdFalbfdLwRDzz95lc+YR5yZHEPMCFay8amoAg9rfq1gM8KqfJHmtef9rLU6J+oTuu1Vh4WyHHM9QWWNXQIogMvB4UkbOuqp9P7IQKgtOc/InAStIHDtSLkTPPANe/XjX0hPJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAq4ygOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAq4ygOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C05C4CEE7;
	Mon, 13 Oct 2025 15:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370001;
	bh=wnB7Fn+7oz5MAW0UaDlR7ukLxrxAAQjXpdZGoJp7Up8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAq4ygORUXfM4bMfwDOe6ZgfYz4gXdCvU9JrAbgvUs1/Cd/iE15ekSBSLyNwd8gGZ
	 tzj5MZAJq9Wkck05ZJ4e2nFcM81cpD8pRkm+FZqKQi3jjOUpDY9Nxo7ODI1ylF7lMC
	 3XYHKlidv1PceCwcsYeQRdRnHV4jZr6i0sJq+u6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 442/563] PCI: rcar-gen4: Add missing 1ms delay after PWR reset assertion
Date: Mon, 13 Oct 2025 16:45:03 +0200
Message-ID: <20251013144427.293844957@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 8795b70581770657cd5ead3c965348f05242580f ]

R-Car V4H Reference Manual R19UH0186EJ0130 Rev.1.30 Apr. 21, 2025 page 585
Figure 9.3.2 Software Reset flow (B) indicates that for peripherals in HSC
domain, after reset has been asserted by writing a matching reset bit into
register SRCR, it is mandatory to wait 1ms.

Because it is the controller driver which can determine whether or not the
controller is in HSC domain based on its compatible string, add the missing
delay in the controller driver.

This 1ms delay is documented on R-Car V4H and V4M; it is currently unclear
whether S4 is affected as well. This patch does apply the extra delay on
R-Car S4 as well.

Fixes: 0d0c551011df ("PCI: rcar-gen4: Add R-Car Gen4 PCIe controller support for host mode")
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
[mani: added the missing r-b tag from Krzysztof]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Link: https://patch.msgid.link/20250919134644.208098-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-rcar-gen4.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-rcar-gen4.c b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
index 18055807a4f5f..d9a42fa51520a 100644
--- a/drivers/pci/controller/dwc/pcie-rcar-gen4.c
+++ b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
@@ -182,8 +182,17 @@ static int rcar_gen4_pcie_common_init(struct rcar_gen4_pcie *rcar)
 		return ret;
 	}
 
-	if (!reset_control_status(dw->core_rsts[DW_PCIE_PWR_RST].rstc))
+	if (!reset_control_status(dw->core_rsts[DW_PCIE_PWR_RST].rstc)) {
 		reset_control_assert(dw->core_rsts[DW_PCIE_PWR_RST].rstc);
+		/*
+		 * R-Car V4H Reference Manual R19UH0186EJ0130 Rev.1.30 Apr.
+		 * 21, 2025 page 585 Figure 9.3.2 Software Reset flow (B)
+		 * indicates that for peripherals in HSC domain, after
+		 * reset has been asserted by writing a matching reset bit
+		 * into register SRCR, it is mandatory to wait 1ms.
+		 */
+		fsleep(1000);
+	}
 
 	val = readl(rcar->base + PCIEMSR0);
 	if (rcar->drvdata->mode == DW_PCIE_RC_TYPE) {
-- 
2.51.0



