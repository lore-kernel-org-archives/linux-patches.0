Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98747331220;
	Wed, 20 May 2026 18:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300628; cv=none; b=i8xgf3bJfTK3xhjpzmsIL4rTPlbq72Pl8WsP6hciDN4iN5opM8wBYgP731deZRZItvqe5mpc+DVSJXDTATLaMxsKEhLB9GxrpVq8MEKIE/ZXWWa8c3/GX4VJm90V2bfLrPl0SntgSDqB01vobwvpJRfppEpe1X19CKjZjAztBdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300628; c=relaxed/simple;
	bh=KFyrfXK+8h1JDyz3LoUBMH9ONP2uRO9QJ2Sz2llzPUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITy+8lez+L0nYmx4paZJY8zNeClM/PHmvFZ7bMVfOs5AgT24WU0hfHAfHJsXNHQ0F4srCapYojcrFd0V7Qi9vOj3yBBHjTAIwMDiapYwLeUOdne2YlBudqMjA8voqfBjB8ZpJ0aca8dKODvhd+dOEqL85tt5ykmEY9OoXHdKxB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=db7g2Z78; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="db7g2Z78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACE11F000E9;
	Wed, 20 May 2026 18:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300627;
	bh=KKwHl5doEKM362jPtT/2/4e0sgocpCaY28xOt8YRWYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=db7g2Z78WB9/M+4zOpn4Anmd1+mKJxWXxnTcN0XbNKjTvnnseBEH6AkxaHL0+Wh7d
	 anc0zETgBMK7KUW8tW6PVB3VVVrn85rVA2QytQNWjRwD9kTRBZ3j8NI7YCTkWSxU9V
	 rDGuYOMsIHAZeDxGi6blY0fZoEcH1cJspSO3x4GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/666] spi: mtk-snfi: unregister ECC engine on probe failure and remove() callback
Date: Wed, 20 May 2026 18:17:37 +0200
Message-ID: <20260520162116.550499876@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index c5677fd94e5e1..8234064921f36 100644
--- a/drivers/spi/spi-mtk-snfi.c
+++ b/drivers/spi/spi-mtk-snfi.c
@@ -1307,6 +1307,13 @@ static const struct spi_controller_mem_caps mtk_snand_mem_caps = {
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
@@ -1447,6 +1454,13 @@ static int mtk_snand_probe(struct platform_device *pdev)
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



