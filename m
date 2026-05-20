Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D114312825;
	Wed, 20 May 2026 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298234; cv=none; b=Nobz/9dqk9Iw8p0PVEVTy6DBKFm8eSmDnOv8V7fUwNfvvC/VXr6A3X3N4sh2om99pcS+Ao/2d4YQwkgoqaeonax3JePu6FeflHjuvYIYmR6y1EoYYtK9eosmWVhwAfmkc09NuFEiCt8oatQ935tkSRWjay2VbIQipfH8rIMESDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298234; c=relaxed/simple;
	bh=e0Zbu78AqucgIGvU6vghDhK6DXSkqRhDZPkwDnFJpwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYpZtGVbGnGswWysujcmXYPiJfVTkLLqFPn39rnvNIn8HJDbKV5CM/0jCmDASb8CT0JU2GJjoB6F0U8srvsvrDoM3Zxo3/1pkAGAjcw63ZXx1q8T1wl5F3tPJExg3cNZejuV/9Q7zEpdCd26e7LweAVrC+eXPh7Trr5e12tGKXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwSBL7Y+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwSBL7Y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7671F000E9;
	Wed, 20 May 2026 17:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298233;
	bh=5AzUaVtUA0yuLjAnpACZRPY47vsoyyS4oGzlJPpFBfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pwSBL7Y+7v0480MniI49QKNXextcAzSKypiOdjqxydY+vJMeycxVt3J50zTHnVx6w
	 MypJm6ZOTe1zoSzeMid7o7ux0SQBUnhDlyR8RmZFD6+TG+NdLbI1oT7hwrmj67x7yU
	 vJyAwIKB+2xHm8x2M0rgfM3BGBhzqwHP1MjPBB4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 333/957] spi: mtk-snfi: unregister ECC engine on probe failure and remove() callback
Date: Wed, 20 May 2026 18:13:36 +0200
Message-ID: <20260520162141.753265707@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ae38c244e2581..a026b0e61994b 100644
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



