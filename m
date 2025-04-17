Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC97B25525A;
	Thu, 17 Apr 2025 17:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912747; cv=none; b=g4HE/b3PCUj27OTLvi7rDejmU6jrPiYQ+a1iAxuJGyqU5l0cQzSgzalxeKOE6xIFa41dmOBkIoEB5XsFzaQzy71rvashIy/Hnq2OMM84rUfTTKtpB6xx91nLDvFn9uqNTfIP7Pg1nGbAUDxCMYcM19Ud91YmRZlCHFYs1C04dLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912747; c=relaxed/simple;
	bh=rqwy7IZB6+Z2khhJODe23gxhO//dcFuSI5HNSWpGT8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3MTjCqp+4weXSCjBkxXK0foi3vpNn3qcWkw1eW3y3XdqMCZCX2VYxAEiLz5poPLlB8weCIP7CEVdsvBDznOr8rCs2vxwkD/AYj6Sn4yq+4qN4LMq8uzFB3t+ENnJUoVaBgtm0MR0s5qCr/OKOvsktyntLUjip8IqBY8gAfKDQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvqD9mHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvqD9mHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4E4C4CEE4;
	Thu, 17 Apr 2025 17:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912747;
	bh=rqwy7IZB6+Z2khhJODe23gxhO//dcFuSI5HNSWpGT8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvqD9mHmbr/r3s+raCpmMFtE6ZHYBG7k9m63FhERbGDSDsQPdlP0fVzre8cBer5oD
	 qANW6S5Qy4Y+ynGXkagwLFEK8HIjO56q44XXUPBg5dI/A8v4V6DsFz7CoUudq7yUQt
	 qlJaYHYwSD3hrl8FjP6U2k2MzEhYh6OIeoJQjBgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ciprian Marian Costea <ciprianmarian.costea@oss.nxp.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 112/449] can: flexcan: add NXP S32G2/S32G3 SoC support
Date: Thu, 17 Apr 2025 19:46:40 +0200
Message-ID: <20250417175122.472443118@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



