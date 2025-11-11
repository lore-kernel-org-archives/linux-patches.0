Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55842DC32A;
	Tue, 11 Nov 2025 01:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823678; cv=none; b=fv6iRZZupwihQFaMMNE90+hYhsbI/WQAzqoGLwwJV1rqFZXffcES5zl/MvLsx3mSLoU2FWM0/Wi7BQyF9LnaunbSXe/sWfhQP08QIc2zR4w9A725JHKHEf4OVXvPfylmREqAFtsRMR3r/ziSuI8PLhM6JAHFxWdSAhh7apU/kE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823678; c=relaxed/simple;
	bh=Exep3jqikyMJsXQoH6TEjLtiXvBzTEwDSLqb7ru3ITg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fc7ZNeNKUGUsrsK4isqvKZ9OmavW+d61WE+g7KMPPfuNZK7GVSqUm5w0FRWoExgf0LBnayssZW1Hvj0CDZ3JjPGriMd29DgnfwONsjfMu8Im/YeCM+TFk1G3ozoPo8nEdDxpRVLSFiyWsnsvcqGn1GX+5KDquWa6kwHL0iTVzxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+jo9U8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+jo9U8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F386BC4CEFB;
	Tue, 11 Nov 2025 01:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823678;
	bh=Exep3jqikyMJsXQoH6TEjLtiXvBzTEwDSLqb7ru3ITg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+jo9U8GZN0RtN6RJGo03S8Qz0dQ9KwDm7udWsos9qzp0kOiNV917W6gYNtAu1U0v
	 dzVI2vGr1PJ4Xro4144GseeeGEXXr0taEzGuISjIxIu1CwoMCprWfzERe4bgEAjc4i
	 4FrUfDNT2ysYA1GeaEfP3YV9+68yE+kPktytnVwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 299/565] PCI: imx6: Enable the Vaux supply if available
Date: Tue, 11 Nov 2025 09:42:35 +0900
Message-ID: <20251111004533.604127637@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit c221cbf8dc547eb8489152ac62ef103fede99545 ]

When the 3.3Vaux supply is present, fetch it at the probe time and keep it
enabled for the entire PCIe controller lifecycle so that the link can enter
L2 state and the devices can signal wakeup using either Beacon or WAKE#
mechanisms.

Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[mani: reworded the subject, description and error message]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250820022328.2143374-1-hongxing.zhu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index c5254241942d3..8877d327867ee 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1487,6 +1487,10 @@ static int imx_pcie_probe(struct platform_device *pdev)
 	pci->max_link_speed = 1;
 	of_property_read_u32(node, "fsl,max-link-speed", &pci->max_link_speed);
 
+	ret = devm_regulator_get_enable_optional(&pdev->dev, "vpcie3v3aux");
+	if (ret < 0 && ret != -ENODEV)
+		return dev_err_probe(dev, ret, "failed to enable Vaux supply\n");
+
 	imx_pcie->vpcie = devm_regulator_get_optional(&pdev->dev, "vpcie");
 	if (IS_ERR(imx_pcie->vpcie)) {
 		if (PTR_ERR(imx_pcie->vpcie) != -ENODEV)
-- 
2.51.0



