Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B4B2356D6;
	Mon, 10 Mar 2025 18:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630542; cv=none; b=YyEKVn4hoUeCkllEFOS6VNmIe/oOPSV2YtpOrouk/5HbqZ7YA7t8Yfq2HgRDY+zZQQdlHXFdx4GT1dry1ZtES/8h2Qj2cQBPJvmvk/A1oPK/lJbVKKwRbtfXdaaCXc2MUkFqY6FpXbY541lelijoJQL6iEqpPnBluimcbQz30Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630542; c=relaxed/simple;
	bh=uprYDRVml2galCcTtqIl9EZfFM7XtrQc3dI8in4D5Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lywrkUqGteKhCf7MK7umhZZcQVsQTE12hXWzOxeUaoTL9N9oN6MTzXi16XHZU8ZuDOvaYHr6H60AWjUaD01+McWhmoXqaEcqkAFJpoM413s93neoea9SKOwEkKav/iRkwmiTgo5ObZVhw2o0G9b8AKnlK525cDtsPWfI5Y4uPhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2pLOP8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2pLOP8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8F2C4CEEC;
	Mon, 10 Mar 2025 18:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630542;
	bh=uprYDRVml2galCcTtqIl9EZfFM7XtrQc3dI8in4D5Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2pLOP8NaV6ODW6oEUf2q0X738HqU4gFhvInnbYSgY0+ImXsIVqpYNl3+IrKVxfi1
	 Q0+9L3w3zeuTrrLB09O1Z4mGD7Igg9m/bGitiy3iz9l3PMkRTNfxZAJrOJA6nPRE2q
	 qmYpzzdLS5IaU+GYNqin0o3D2qHIiFlLJvByrJ4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 449/620] soc: mediatek: mtk-devapc: Switch to devm_clk_get_enabled()
Date: Mon, 10 Mar 2025 18:04:55 +0100
Message-ID: <20250310170603.317229256@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 916120df5aa926d65f4666c075ed8d4955ef7bab ]

This driver does exactly devm_clk_get() and clk_prepare_enable() right
after, which is exactly what devm_clk_get_enabled() does: clean that
up by switching to the latter.

This commit brings no functional changes.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221006110935.59695-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Stable-dep-of: c0eb059a4575 ("soc: mediatek: mtk-devapc: Fix leaking IO map on error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-devapc.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-devapc.c b/drivers/soc/mediatek/mtk-devapc.c
index 7c65ad3d1f8a3..1ab7ca82745c6 100644
--- a/drivers/soc/mediatek/mtk-devapc.c
+++ b/drivers/soc/mediatek/mtk-devapc.c
@@ -261,19 +261,14 @@ static int mtk_devapc_probe(struct platform_device *pdev)
 	if (!devapc_irq)
 		return -EINVAL;
 
-	ctx->infra_clk = devm_clk_get(&pdev->dev, "devapc-infra-clock");
+	ctx->infra_clk = devm_clk_get_enabled(&pdev->dev, "devapc-infra-clock");
 	if (IS_ERR(ctx->infra_clk))
 		return -EINVAL;
 
-	if (clk_prepare_enable(ctx->infra_clk))
-		return -EINVAL;
-
 	ret = devm_request_irq(&pdev->dev, devapc_irq, devapc_violation_irq,
 			       IRQF_TRIGGER_NONE, "devapc", ctx);
-	if (ret) {
-		clk_disable_unprepare(ctx->infra_clk);
+	if (ret)
 		return ret;
-	}
 
 	platform_set_drvdata(pdev, ctx);
 
@@ -288,8 +283,6 @@ static int mtk_devapc_remove(struct platform_device *pdev)
 
 	stop_devapc(ctx);
 
-	clk_disable_unprepare(ctx->infra_clk);
-
 	return 0;
 }
 
-- 
2.39.5



