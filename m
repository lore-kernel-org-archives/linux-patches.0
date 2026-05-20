Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A381CDFCA;
	Wed, 20 May 2026 16:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295585; cv=none; b=KMTPUNCGxvUVhUvXjPuvVwEgt3ceaskKD2xB/vCbKuO1EtdE3Y2v7XPcq8F1tvsAV4Jbjmsdas0Xlj1Ca2CfVXbSjnJF+d2/otA3fLxQeniFTl5VsiONwSxAajCHjqJXflNJ/N2WtQYzCg7wwbrW3Fa1svGo2i7A8im+M5qpFGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295585; c=relaxed/simple;
	bh=HStzBdvHbx35AKvvAT0iVBCfoirHS6nt8HyGMH/kGB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0w6sGBLPyASWJUQ6dwUfaxUnILF0EGOKmQIcsZYwQNVCqRq2ILP5nwgtoJcrLW9VsV7iCtw6P5dBidSJ7/H9BklHvBGPz55LP4/sXpNOlHSXInmxPvhmbsawCErXSdLhXHzh6Z8VpVwZUgyV2SWXUZgVp76zKGv2bJNFgUBmDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fI8XyVfE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fI8XyVfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B3A1F000E9;
	Wed, 20 May 2026 16:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295584;
	bh=YmkP0rjXypqSoqokMrPohMb/nHo3wicXhRb7SEsEhpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fI8XyVfEBhg0jAwqSRMSJBrOpVFYyjoHxRH4vwjeAmQUaFJCFlAuldFhI+6D+O98v
	 JkWFXbyZMuHbpdqNEryCBaDFsFtSfABfmTLjcH3uDjJ8Csq0Qqf5xl7nXmAUB7Xu52
	 4Q2/bn+1x02ya5zYPYmovBaKiKh/ODSYCKyDLo9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0434/1146] spi: mtk-snfi: unregister ECC engine on probe failure and remove() callback
Date: Wed, 20 May 2026 18:11:24 +0200
Message-ID: <20260520162158.021133342@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit ab00febad191d7a4400aa1c3468279fb508258d4 ]

mtk_snand_probe() registers the on-host NAND ECC engine, but teardown was
missing from both probe unwind and remove-time cleanup. Add a devm cleanup
action after successful registration so
nand_ecc_unregister_on_host_hw_engine() runs automatically on probe
failures and during device removal.

Fixes: 764f1b748164 ("spi: add driver for MTK SPI NAND Flash Interface")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://patch.msgid.link/20263f885f1a9c9d559f95275298cd6de4b11ed5.1775546401.git.xiaopei01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mtk-snfi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/spi/spi-mtk-snfi.c b/drivers/spi/spi-mtk-snfi.c
index 437edbd658aa2..73fa84475f0e4 100644
--- a/drivers/spi/spi-mtk-snfi.c
+++ b/drivers/spi/spi-mtk-snfi.c
@@ -1303,6 +1303,13 @@ static const struct spi_controller_mem_caps mtk_snand_mem_caps = {
 	.ecc = true,
 };
 
+static void mtk_unregister_ecc_engine(void *data)
+{
+	struct nand_ecc_engine *eng = data;
+
+	nand_ecc_unregister_on_host_hw_engine(eng);
+}
+
 static irqreturn_t mtk_snand_irq(int irq, void *id)
 {
 	struct mtk_snand *snf = id;
@@ -1443,6 +1450,13 @@ static int mtk_snand_probe(struct platform_device *pdev)
 		goto release_ecc;
 	}
 
+	ret = devm_add_action_or_reset(&pdev->dev, mtk_unregister_ecc_engine,
+				       &ms->ecc_eng);
+	if (ret) {
+		dev_err_probe(&pdev->dev, ret, "failed to add ECC unregister action\n");
+		goto release_ecc;
+	}
+
 	ctlr->num_chipselect = 1;
 	ctlr->mem_ops = &mtk_snand_mem_ops;
 	ctlr->mem_caps = &mtk_snand_mem_caps;
-- 
2.53.0



