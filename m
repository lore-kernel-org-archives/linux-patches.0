Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A742566D2;
	Thu, 17 Apr 2025 18:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915434; cv=none; b=WgUjrSwNlkjgSJywUmN1dYdd5XQfgr7RToCQcgrNWtuqFJ1c/kF8U9LVXzLShWWXVAjyPRqMAvc4/V5X0i4unnKC+3Tdw1tZ6s+tbP3j/hk5hCjQfqRTmwND4CaY5qdK8sO9GBR/M8bll5WwkZASyB3SL4h1rxEBtrb7vuE+laU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915434; c=relaxed/simple;
	bh=VTj/0El40+mksZBk2cMQuBf4EaOS17v04xCQ0MSLGbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqvoS3AikmO5rwI8t4IWJJtH2r1E6OS2yJrY1h9hCkq0OzP9dVIjl1XazJLHhaGqJp7t4NncTtF1VbAA57L2mQgMeWK8K6QGq36UVrHM1q/8odf//l6QeJVI3AC131bLFKL6XntO8zQnibOBBjFeyk7bP7XJ7q53U72HVXupaTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZONAjr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZONAjr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EEAC4CEE4;
	Thu, 17 Apr 2025 18:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915434;
	bh=VTj/0El40+mksZBk2cMQuBf4EaOS17v04xCQ0MSLGbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZONAjr9oO3/U9pKPa9NpdsQhujDU/jkKeBQmY77aZPIx8mILUDRsF8l32Rut7mq6
	 MFLhNB34wMLRJAUBlXX1ZomTi7FKXcvX2mH76efowMbwqEFez5smzv/YcWlNuRWYrg
	 EYvn2Mb8RSEiOpgzNSt/DPghlJFQU0iacRA8gdzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ciprian Marian Costea <ciprianmarian.costea@oss.nxp.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/393] can: flexcan: add NXP S32G2/S32G3 SoC support
Date: Thu, 17 Apr 2025 19:48:26 +0200
Message-ID: <20250417175111.493979188@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ciprian Marian Costea <ciprianmarian.costea@oss.nxp.com>

[ Upstream commit 8503a4b1a24d32e95f3a233062e8f1dc0b2052bd ]

Add device type data for S32G2/S32G3 SoC.

FlexCAN module from S32G2/S32G3 is similar with i.MX SoCs, but interrupt
management is different.

On S32G2/S32G3 SoC, there are separate interrupts for state change, bus
errors, Mailboxes 0-7 and Mailboxes 8-127 respectively.
In order to handle this FlexCAN hardware particularity, first reuse the
'FLEXCAN_QUIRK_NR_IRQ_3' quirk provided by mcf5441x's irq handling
support. Secondly, use the newly introduced
'FLEXCAN_QUIRK_SECONDARY_MB_IRQ' quirk which handles the case where two
separate mailbox ranges are controlled by independent hardware interrupt
lines.

Signed-off-by: Ciprian Marian Costea <ciprianmarian.costea@oss.nxp.com>
Link: https://patch.msgid.link/20250113120704.522307-4-ciprianmarian.costea@oss.nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan/flexcan-core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/flexcan/flexcan-core.c
index 1a94586cbd11e..fca290afb5329 100644
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -386,6 +386,16 @@ static const struct flexcan_devtype_data fsl_lx2160a_r1_devtype_data = {
 		FLEXCAN_QUIRK_SUPPORT_RX_MAILBOX_RTR,
 };
 
+static const struct flexcan_devtype_data nxp_s32g2_devtype_data = {
+	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
+		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
+		FLEXCAN_QUIRK_USE_RX_MAILBOX | FLEXCAN_QUIRK_SUPPORT_FD |
+		FLEXCAN_QUIRK_SUPPORT_ECC | FLEXCAN_QUIRK_NR_IRQ_3 |
+		FLEXCAN_QUIRK_SUPPORT_RX_MAILBOX |
+		FLEXCAN_QUIRK_SUPPORT_RX_MAILBOX_RTR |
+		FLEXCAN_QUIRK_SECONDARY_MB_IRQ,
+};
+
 static const struct can_bittiming_const flexcan_bittiming_const = {
 	.name = DRV_NAME,
 	.tseg1_min = 4,
@@ -2055,6 +2065,7 @@ static const struct of_device_id flexcan_of_match[] = {
 	{ .compatible = "fsl,vf610-flexcan", .data = &fsl_vf610_devtype_data, },
 	{ .compatible = "fsl,ls1021ar2-flexcan", .data = &fsl_ls1021a_r2_devtype_data, },
 	{ .compatible = "fsl,lx2160ar1-flexcan", .data = &fsl_lx2160a_r1_devtype_data, },
+	{ .compatible = "nxp,s32g2-flexcan", .data = &nxp_s32g2_devtype_data, },
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, flexcan_of_match);
-- 
2.39.5



