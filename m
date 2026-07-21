Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3976643C7AE;
	Tue, 21 Jul 2026 22:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674507; cv=none; b=bZLCg2/QxtVaTufdvtbd8ydjx1dMaKdbek8jy/ybvaOZWrhrJNlFgfAKIIH7LHbr+tO4pBGJyfjg/o0kcWYHhVdGiB2/pXNfGin1nT4rl4r4DpXCftggN1b/qlfAAyudh8K48MrGz/D6+DAB0HQPYC8SeCtNMCW0SyKEnS9GkUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674507; c=relaxed/simple;
	bh=lTO/AAxtQPz6XCu+Lv6QiYRcg+Lw6As+C3C8HAaCzIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpe2dOCieSdFOHS9KdcCBzliSCUM8BcLSDr47ij+8BsPTayEfCIU+7q27YtJIlVrzi+P9CpWXMpnMlqyltePZgyXGlsKFv5+LEIwSZZKVX1+7fj6do9bWgAmiq2rtsW+owYkVNTFhOTUhWDD2dghKcZ/cS0ILT4gLSQHLRDuR+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rEMT8Hy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rEMT8Hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903541F000E9;
	Tue, 21 Jul 2026 22:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674506;
	bh=058q62oAFurT7alpTgevL1Icc8WBl7zUwfC1jioQdag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2rEMT8Hy86V/s4/jNwNTNLr4dV4LLzADXulZjGAwsQRHtMDFpKP8c777YwdlQ/ZmV
	 hnY7g3qoOHtufpmdXUlMeNVUBewo1mplnejJd8+T21h8vzsB0kPypb4Q35udbG175S
	 pubefoqaUfHm65cJAKxf+Go+B+V8ELmU7Qj19hGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Robby Cai <robby.cai@nxp.com>,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 5.10 567/699] reset: imx7: Correct polarity of MIPI CSI resets on i.MX8MQ
Date: Tue, 21 Jul 2026 17:25:26 +0200
Message-ID: <20260721152408.498589658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


