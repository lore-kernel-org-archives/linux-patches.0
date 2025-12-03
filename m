Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB475328B65;
	Wed,  3 Dec 2025 15:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776983; cv=none; b=AHLiKLRcf2EFqAfKs25CMehYsQXxwprYAjJn2ntljeEFOWxzFnk4RTUGXQ40Tnj73DhUPAZvbwiGgt2QsCgor1s7VdY6NF9pF5YDznfJB1pDiy3nG3b7jx/ZrzYxzaTV25Jky3I3hNdZxXiEeToQ2g1c3S9BjrKhAZf26Vxd62c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776983; c=relaxed/simple;
	bh=t4pjJU9EwdedkfKNxndNUKxbmLeWXTbGDvGNN9bzMg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldFjtqs3E6HtOxVBHDCMysuLKkki9wEGrUt301kO2AzFJaUHshmmfPD27D7mOZ51wBJhMY8n3UqcZwNCY2w5Pz8phdtVH65d7AsN/TsGr3SfLvu7U6e+A6CYl5SPMSKKvm29Db0A7rUUMzN0VmkYh0A2+zacQiP8SBTAxafXJnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5GP6ark; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5GP6ark"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA83EC4CEF5;
	Wed,  3 Dec 2025 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776983;
	bh=t4pjJU9EwdedkfKNxndNUKxbmLeWXTbGDvGNN9bzMg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5GP6arkp/fqjru+lUXajShVxk7/y2ybCdTY9EKr7F+2Oc4GLzKL14L/Gdd2CCtFo
	 2sZhZJN5CraaqvrfpQB0FUoSKLA0w1Ii4NeOWNNiw0aMcrNnIq1r8A2Ja3x/nuGpbi
	 PzwQyiCokyfTKyNOU1a3IxZW0hHEIbCECvgfcdxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 047/146] spi: spi-nxp-fspi: Add OCT-DTR mode support
Date: Wed,  3 Dec 2025 16:27:05 +0100
Message-ID: <20251203152348.195895937@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 0f67557763accbdd56681f17ed5350735198c57b ]

Add OCT-DTR mode support in default, since flexspi do not supports
swapping bytes on a 16 bit boundary in OCT-DTR mode, so mark swap16
as false.

lx2160a do not support DQS, so add a quirk to disable DTR mode for this
platform.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250917-flexspi-ddr-v2-5-bb9fe2a01889@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 40ad64ac25bb ("spi: nxp-fspi: Propagate fwnode in ACPI case as well")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index ab13f11242c3c..fcf10be66d391 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -330,6 +330,8 @@
 
 /* Access flash memory using IP bus only */
 #define FSPI_QUIRK_USE_IP_ONLY	BIT(0)
+/* Disable DTR */
+#define FSPI_QUIRK_DISABLE_DTR	BIT(1)
 
 struct nxp_fspi_devtype_data {
 	unsigned int rxfifo;
@@ -344,7 +346,7 @@ static struct nxp_fspi_devtype_data lx2160a_data = {
 	.rxfifo = SZ_512,       /* (64  * 64 bits)  */
 	.txfifo = SZ_1K,        /* (128 * 64 bits)  */
 	.ahb_buf_size = SZ_2K,  /* (256 * 64 bits)  */
-	.quirks = 0,
+	.quirks = FSPI_QUIRK_DISABLE_DTR,
 	.lut_num = 32,
 	.little_endian = true,  /* little-endian    */
 };
@@ -1236,6 +1238,13 @@ static const struct spi_controller_mem_ops nxp_fspi_mem_ops = {
 };
 
 static const struct spi_controller_mem_caps nxp_fspi_mem_caps = {
+	.dtr = true,
+	.swap16 = false,
+	.per_op_freq = true,
+};
+
+static const struct spi_controller_mem_caps nxp_fspi_mem_caps_disable_dtr = {
+	.dtr = false,
 	.per_op_freq = true,
 };
 
@@ -1351,7 +1360,12 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	ctlr->bus_num = -1;
 	ctlr->num_chipselect = NXP_FSPI_MAX_CHIPSELECT;
 	ctlr->mem_ops = &nxp_fspi_mem_ops;
-	ctlr->mem_caps = &nxp_fspi_mem_caps;
+
+	if (f->devtype_data->quirks & FSPI_QUIRK_DISABLE_DTR)
+		ctlr->mem_caps = &nxp_fspi_mem_caps_disable_dtr;
+	else
+		ctlr->mem_caps = &nxp_fspi_mem_caps;
+
 	ctlr->dev.of_node = np;
 
 	ret = devm_add_action_or_reset(dev, nxp_fspi_cleanup, f);
-- 
2.51.0



