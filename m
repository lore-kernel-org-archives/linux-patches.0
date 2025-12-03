Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712E7364EA6;
	Wed,  3 Dec 2025 16:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781040; cv=none; b=IMfnPda+PP+4uLVFGL8gcWyT+2ednL/X/cUbmQvd8vv4MUGVutvRjTwjJrrLx3cDkV8IjQ16izYpJAhgN3BFkYxTp3t9AiFDsoKkt/NHsuIBHWgMkEXot32kjHX9zDmqwJNVxs0/8N4z7Sq4cx8PaS8L/hE2shZVFaD2NII5vuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781040; c=relaxed/simple;
	bh=TyIuTT79uLMlcVRqHf/py2GH62sfXlyukGHfd+W7Dr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRrBJJPAO7TO/69wLoreJWG/uDVtsI61S1ZTQpFUoLcjU4TiY8mu3EKnegqf4qgwQpYRgRLjQKX1XF7qVSh+iWIe5laH1hUlbZGgDUQMH2xsyayaFDEFDLpDenfOcA2d+zhlBXoafTwSM4sUiQ2jyiWLtkMP+bUO0UbUSvJpdC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKq2bH73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKq2bH73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35075C4CEF5;
	Wed,  3 Dec 2025 16:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781039;
	bh=TyIuTT79uLMlcVRqHf/py2GH62sfXlyukGHfd+W7Dr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKq2bH73vjw7xIa8gqd33hZmN6MNg3FzS6w0N0LZRTIa0UVs8PqZAA2gtv37knLdr
	 KkvB2YS4wAmeTDYe2iK2GGAthOvXNYRPzfksek3/yknqjZOITPPCHWzvseHDtBSFmj
	 +N9q9OJY6fdVAVwumnNufKeL3ZPRu068UGR/Su7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 31/93] spi: nxp-fspi: Support per spi-mem operation frequency switches
Date: Wed,  3 Dec 2025 16:29:24 +0100
Message-ID: <20251203152337.668290192@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 26851cf65ffca2d3a8d529a125e54cf0084d69e7 ]

Every ->exec_op() call correctly configures the spi bus speed to the
maximum allowed frequency for the memory using the constant spi default
parameter. Since we can now have per-operation constraints, let's use
the value that comes from the spi-mem operation structure instead. In
case there is no specific limitation for this operation, the default spi
device value will be given anyway.

The per-operation frequency capability is thus advertised to the spi-mem
core.

Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20241224-winbond-6-11-rc1-quad-support-v2-12-ad218dbc406f@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 40ad64ac25bb ("spi: nxp-fspi: Propagate fwnode in ACPI case as well")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index 731504ec7ef8b..5d631f8c593e3 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -711,9 +711,10 @@ static void nxp_fspi_dll_calibration(struct nxp_fspi *f)
  * Value for rest of the CS FLSHxxCR0 register would be zero.
  *
  */
-static void nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi)
+static void nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
+				const struct spi_mem_op *op)
 {
-	unsigned long rate = spi->max_speed_hz;
+	unsigned long rate = op->max_freq;
 	int ret;
 	uint64_t size_kb;
 
@@ -938,7 +939,7 @@ static int nxp_fspi_exec_op(struct spi_mem *mem, const struct spi_mem_op *op)
 				   FSPI_STS0_ARB_IDLE, 1, POLL_TOUT, true);
 	WARN_ON(err);
 
-	nxp_fspi_select_mem(f, mem->spi);
+	nxp_fspi_select_mem(f, mem->spi, op);
 
 	nxp_fspi_prepare_lut(f, op);
 	/*
@@ -1156,6 +1157,10 @@ static const struct spi_controller_mem_ops nxp_fspi_mem_ops = {
 	.get_name = nxp_fspi_get_name,
 };
 
+static const struct spi_controller_mem_caps nxp_fspi_mem_caps = {
+	.per_op_freq = true,
+};
+
 static int nxp_fspi_probe(struct platform_device *pdev)
 {
 	struct spi_controller *ctlr;
@@ -1253,6 +1258,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	ctlr->bus_num = -1;
 	ctlr->num_chipselect = NXP_FSPI_MAX_CHIPSELECT;
 	ctlr->mem_ops = &nxp_fspi_mem_ops;
+	ctlr->mem_caps = &nxp_fspi_mem_caps;
 
 	nxp_fspi_default_setup(f);
 
-- 
2.51.0



