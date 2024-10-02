Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649511A08A4;
	Wed,  2 Oct 2024 14:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880627; cv=none; b=dNeCyGJ0MM97xKsPXIYLKV4dqXemJ62lB+A2z0WcGfMYayyMcsXXPmcQXeefu9SEpgPx6ddgrEG/kRwmzK5pEM7XtxO0urLYtdYAsyQiGE96nb3qHhvaUO/sMGrt2Q4wOLmnYEvgD/thpbKOmVrHFmChbf1NN9Ly6+vMrrja1t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880627; c=relaxed/simple;
	bh=Hgr/0t7/REa+G6iyS2QXN5mE6ERVfepdBY0Kb+zSojc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PypLzLYdXvmH76lgPVTJv6neifRZ+deX2dsQ0mTnwIi3ZicoZaU1qYn7L1UD5VSAvQ6+8fbQAdId+XP3DDSMIgoKDGbAneK+nw5PwF1fO+KDHE++/t6g1ocKr59nSvy5OfsO2srgqsiiuP1+B8VKLXoTmxPTygG42jrRBnGQz3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJ8AwwIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJ8AwwIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D529AC4CECD;
	Wed,  2 Oct 2024 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880627;
	bh=Hgr/0t7/REa+G6iyS2QXN5mE6ERVfepdBY0Kb+zSojc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJ8AwwILOIZhrmgR/ILAQkSwuA6d0Zj6kxERvcIXOkoATvBhpKgXlGVhHsT95K5kb
	 PmzKNVQeSYiQsE6NkSkRDJRbzMHMUcPI+QPdhkskHJfNAQxC+/5EmxlYaGadY36dmd
	 nzO8aaby61lEuN3LBmCo6R/dlMaOncTLcOYE7x14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 523/538] spi: fspi: add support for imx8ulp
Date: Wed,  2 Oct 2024 15:02:42 +0200
Message-ID: <20241002125813.091473580@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Haibo Chen <haibo.chen@nxp.com>

commit 9228956a620553d7fd17f703a37a26c91e4d92ab upstream.

The flexspi on imx8ulp only has 16 LUTs, different with others which
have up to 32 LUTs.

Add a separate compatible string and nxp_fspi_devtype_data to support
flexspi on imx8ulp.

Fixes: ef89fd56bdfc ("arm64: dts: imx8ulp: add flexspi node")
Cc: stable@kernel.org
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20240905094338.1986871-4-haibo.chen@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-nxp-fspi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -371,6 +371,15 @@ static struct nxp_fspi_devtype_data imx8
 	.little_endian = true,  /* little-endian    */
 };
 
+static struct nxp_fspi_devtype_data imx8ulp_data = {
+	.rxfifo = SZ_512,       /* (64  * 64 bits)  */
+	.txfifo = SZ_1K,        /* (128 * 64 bits)  */
+	.ahb_buf_size = SZ_2K,  /* (256 * 64 bits)  */
+	.quirks = 0,
+	.lut_num = 16,
+	.little_endian = true,  /* little-endian    */
+};
+
 struct nxp_fspi {
 	void __iomem *iobase;
 	void __iomem *ahb_addr;
@@ -1297,6 +1306,7 @@ static const struct of_device_id nxp_fsp
 	{ .compatible = "nxp,imx8mp-fspi", .data = (void *)&imx8mm_data, },
 	{ .compatible = "nxp,imx8qxp-fspi", .data = (void *)&imx8qxp_data, },
 	{ .compatible = "nxp,imx8dxl-fspi", .data = (void *)&imx8dxl_data, },
+	{ .compatible = "nxp,imx8ulp-fspi", .data = (void *)&imx8ulp_data, },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, nxp_fspi_dt_ids);


