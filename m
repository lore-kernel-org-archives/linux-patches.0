Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F370A46F48F;
	Tue, 21 Jul 2026 17:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655268; cv=none; b=HkQPrwLEOuevIccz6IuZaHiMI1yKCwVrOW3Usgro6p47d4/L0XkQ0a/q4Sep5ZDBb/DcUs1I7d8mefyktKNgICvNq723VahYg+flD7sT0CdLSf0d1zlj2etWhnjWn9Fhg9ey10PMuhhlOoNT8DAvUXLpr9xoJ9x8W+JWJHHpUHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655268; c=relaxed/simple;
	bh=YSFA9Y6up4IgOdit0xpMJ2uJp8dyb6vpFOlyCZZshBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGjVM+0gYh5qLqKzCqgVohcBP2lMuDL1qi3kaVXFUznLLdYmICvMj1NQh2adEdR8rDyp/q50W79Bw8+hnFMdsjtq8V7sGIAoZU+KLJt/Z+OXfDxOGqYP6TyEEhY6HOTZdLJhDfg+cfE8WaOxitlzQlQajCDsWZ6o8hctK7ii4wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUDsWisl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUDsWisl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B90F1F000E9;
	Tue, 21 Jul 2026 17:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655266;
	bh=CKPNGFSugpZPMAf8KjbHsBH3Uf1A0HPejkMddd55BTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QUDsWislu7/2DFIIwNLtbLaLKrprD/4iLt/FcqdlZa9BHN66QLFjFLWAfFB51ySSz
	 a4EdtySg1Xl/oYh/ihjCdeNa22omckRGKzLc/p2meT5WZE6mXfu7rUVBs4502RIeT7
	 gjELqhUOIU0ej5HBJS6hmSl0qJRjvGdFr8oMdf8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Robby Cai <robby.cai@nxp.com>,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 7.1 2018/2077] reset: imx7: Correct polarity of MIPI CSI resets on i.MX8MQ
Date: Tue, 21 Jul 2026 17:28:11 +0200
Message-ID: <20260721152640.298993921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robby Cai <robby.cai@nxp.com>

commit 71827776667f4e4677a4fa806bcfb24d4b8dd9d7 upstream.

On i.MX8MQ, the MIPI CSI reset lines are active-low and not self-clearing.
Writing '0' asserts reset and it remains asserted until explicitly
deasserted by software.

This driver previously treated the MIPI CSI reset signals as active-high,
which led to incorrect reset assert/deassert sequencing. This issue was
exposed by commit 6d79bb8fd2aa ("media: imx8mq-mipi-csi2: Explicitly
release reset").

Fix this by reflecting the correct reset polarity and ensuring proper
reset handling.

Fixes: c979dbf59987 ("reset: imx7: Add support for i.MX8MQ IP block variant")
Cc: stable@vger.kernel.org # 6d79bb8fd2aa: media: imx8mq-mipi-csi2: Explicitly release reset
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Robby Cai <robby.cai@nxp.com>
Reviewed-by: Guoniu Zhou <guoniu.zhou@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/reset/reset-imx7.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/reset/reset-imx7.c
+++ b/drivers/reset/reset-imx7.c
@@ -236,6 +236,12 @@ static int imx8mq_reset_set(struct reset
 
 	case IMX8MQ_RESET_PCIE_CTRL_APPS_EN:
 	case IMX8MQ_RESET_PCIE2_CTRL_APPS_EN:
+	case IMX8MQ_RESET_MIPI_CSI1_CORE_RESET:
+	case IMX8MQ_RESET_MIPI_CSI1_PHY_REF_RESET:
+	case IMX8MQ_RESET_MIPI_CSI1_ESC_RESET:
+	case IMX8MQ_RESET_MIPI_CSI2_CORE_RESET:
+	case IMX8MQ_RESET_MIPI_CSI2_PHY_REF_RESET:
+	case IMX8MQ_RESET_MIPI_CSI2_ESC_RESET:
 	case IMX8MQ_RESET_MIPI_DSI_PCLK_RESET_N:
 	case IMX8MQ_RESET_MIPI_DSI_ESC_RESET_N:
 	case IMX8MQ_RESET_MIPI_DSI_DPI_RESET_N:


