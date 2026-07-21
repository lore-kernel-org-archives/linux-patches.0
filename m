Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3C047252B;
	Tue, 21 Jul 2026 21:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667645; cv=none; b=XX7U1DgLrdm8+uGRCbu6a55FMNFjlu53HYZd9+WdrpVqw+H3VlczTvW30Sk3Q6ddLbgQTIEW+YLsc7O7eafKtX1NaLK9J1wuyGKchNigKl96zJkfBWu0+fnNJ71vIikT9AWIkdNTc7qwIfybO0yD2ZKwRb9cyiD9zTEa7QdhsT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667645; c=relaxed/simple;
	bh=9jmke+kV8GXUch/Z5KevSFylWxsmmgZFfGI3Wy9tXQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqjUPcn2Ap1CtebNj3fa2J7mRTz4BUcaFlELZj0cEt6yCC0wbMJUIFrYJTzgxmUziUF4Fz7GsV/yEYLwyP4w20zNYvVSAx5uqkR01ECYDvqFkB81GiNiPwaPShKvKZJk8Obi4h/lUmzmNSvoQw/d8BmfPJX9Sefw3AZbQ6pn69g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4ZaMxXv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4ZaMxXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CAE1F000E9;
	Tue, 21 Jul 2026 21:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667644;
	bh=AWtv//pkt+SRUvdDmyq7pqSj42BmvBYuhLvQLbxgjCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4ZaMxXv6P5uRuoJ3bl5wCB4MTEhrFVbo0yWB7eXQimjsQsdRTgRvqVMmJ5h64zMD
	 n9rdG4S2hCSFhOpXmHRwuIIpnkAnsOHCKUVYb/5xqQfcmVQckltCwuhhvbRNK2VlNE
	 WuAI/kDxRGj9FWd+jN4z7cLa0Gqa2oXZ0LeHyODs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Robby Cai <robby.cai@nxp.com>,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.6 1138/1266] reset: imx7: Correct polarity of MIPI CSI resets on i.MX8MQ
Date: Tue, 21 Jul 2026 17:26:15 +0200
Message-ID: <20260721152507.256413935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


