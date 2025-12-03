Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A8A35A94D;
	Wed,  3 Dec 2025 16:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780639; cv=none; b=Agkq4Y/CB5kKIR+yuK46QgKba/e981UkS2vEe8BjWbZ4KRRglkOrZ/hepx7ANdcCAF/1Eu3jjYoydbj7+jsKuK9HeBfmG426uCoREqstEtd7uyGwLVMLCRJc8gxIG0lGwx0zxTCmXGZUuepIezbg6YWIi1/SDkhkCHF3Db/RLJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780639; c=relaxed/simple;
	bh=KQWoYHe39gSnEzjl0CivEjqwvWYmh8JYtCOB6PVG9cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjecMvATlPc5zsbqpArTlpsM4Z0owL9RpKTxak9y4TyaoGCgGtbwiowxnddVru8JSeU/7kJ0FkcbzWi+zuN51mAUVtkj/p4FagjFN1TB+250UBNP4lYF4/zUhZ29vwKKwfsnBbkcV89apx6/MghTCPFPeVGHJWTNmNmxPYRacN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=An/ZtR2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="An/ZtR2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC975C4CEF5;
	Wed,  3 Dec 2025 16:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780639;
	bh=KQWoYHe39gSnEzjl0CivEjqwvWYmh8JYtCOB6PVG9cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=An/ZtR2px63k9E+gltiTz/qoN8M/BBVFrE1ZQeSElkOv94N56pgdAm4dBWjeRXPVI
	 yv4KJGoQHhHhPb/bneQnI1RqlOxZQVVWfcaUJk8VzWKHgv1HAKWTZ2DeHrzNydGUTb
	 6rZsHElYP8IDsK8L5RCkFXnDfb3dDfLS/mf9UfVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/132] spi: spi-nxp-fspi: Add OCT-DTR mode support
Date: Wed,  3 Dec 2025 16:28:45 +0100
Message-ID: <20251203152345.001823811@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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
index 825b2a36377c2..6cdeee9c581bd 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -325,6 +325,8 @@
 
 /* Access flash memory using IP bus only */
 #define FSPI_QUIRK_USE_IP_ONLY	BIT(0)
+/* Disable DTR */
+#define FSPI_QUIRK_DISABLE_DTR	BIT(1)
 
 struct nxp_fspi_devtype_data {
 	unsigned int rxfifo;
@@ -339,7 +341,7 @@ static struct nxp_fspi_devtype_data lx2160a_data = {
 	.rxfifo = SZ_512,       /* (64  * 64 bits)  */
 	.txfifo = SZ_1K,        /* (128 * 64 bits)  */
 	.ahb_buf_size = SZ_2K,  /* (256 * 64 bits)  */
-	.quirks = 0,
+	.quirks = FSPI_QUIRK_DISABLE_DTR,
 	.lut_num = 32,
 	.little_endian = true,  /* little-endian    */
 };
@@ -1157,6 +1159,13 @@ static const struct spi_controller_mem_ops nxp_fspi_mem_ops = {
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
 
@@ -1245,7 +1254,12 @@ static int nxp_fspi_probe(struct platform_device *pdev)
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
 
 	return devm_spi_register_controller(&pdev->dev, ctlr);
-- 
2.51.0



