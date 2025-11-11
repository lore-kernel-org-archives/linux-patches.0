Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462F426A0C7;
	Tue, 11 Nov 2025 01:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824123; cv=none; b=gzxVF/cZg9ayVi0ELFasEYzc5TL9Wel48RswOLXZjse/73alBvcqnyVKNRLy2gexM8SuDBAag+7G6fGPTDQQg93H8nvSpPiGXev99+cGfVTFYoxDq7nVUFARXJDXplLmIxN+cL8G2shCDvD6QrjlhOF10sHtyfASZdhmAALVUYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824123; c=relaxed/simple;
	bh=JWa8WG+jzriurd8seTIAi9KfnTzI2cM5Liu/iOcFVB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQDtuvYJlaSJ1hAPBUOdk4eDAQvr2Umc7yaVzVBARwNGBiVLX9lLqp54IUPoeYkftB6AMOUPwdXgVqnanElubx2KiCcGTlkUADM4pxqD2V8OobdperZ08eVAdQSHW67ywO80MbwqnKiWsO8XRvU4Q1XLESu9Hz1WhTbBZC13GB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0o0sPt6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0o0sPt6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D1FC19425;
	Tue, 11 Nov 2025 01:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824123;
	bh=JWa8WG+jzriurd8seTIAi9KfnTzI2cM5Liu/iOcFVB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0o0sPt6Q0DOfpS9uvItHw1Z/hGcvLcFdrAe5DoBhQbgB0z4/57vnIfLDm13kjEPsl
	 oxw3+l8KGsw9Jah0iyGjuMiYIpdVYd7p1D8rYS4lBdaB5dJuhauWHTtDKVASvAPdIt
	 v+9wIpMpme/tFzTO8J1SOUZk13SjGyuc1o4lr9hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 441/849] PCI: imx6: Enable the Vaux supply if available
Date: Tue, 11 Nov 2025 09:40:11 +0900
Message-ID: <20251111004547.094846194@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index 80e48746bbaf6..db51e382a7cf3 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1745,6 +1745,10 @@ static int imx_pcie_probe(struct platform_device *pdev)
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



