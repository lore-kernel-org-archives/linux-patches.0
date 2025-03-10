Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C179822B597;
	Mon, 10 Mar 2025 18:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630545; cv=none; b=XJGJfTGrYR3scIgrfFcVWuLtNctn3MBspzCHfJX3AnqFG7wJbJ6uF4qUvbozWPL3+4qLpujWEFvN4c9cMUrSldbVnzRcY1pnUVR76qv1OwbNdFonSz15xjJuQQLPkpAAEZ0hujUhl4FJWvz0tmfStgA28VkaHNKm/N3hhuN151Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630545; c=relaxed/simple;
	bh=uLHARftLsXwh2ZwLFZCATKBU39GqKLpoPr0K4xGtMl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIS55pAoDJeWXSWZFvxeYiGlfYoi1bYRRRCcHAtNJGllV/sTNYpwoOrLMabzzVvpK808cbuKdnW+S+dH+ljq5cZjE/Pg+HROTKEyVml6Y/6K6PqP96CfR9uMgD9zfLYQnOlsGE54R0TXZl+pU0AsUC3eQdpBw0sLxRgETUEehlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkVcJd4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkVcJd4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48452C4CEEE;
	Mon, 10 Mar 2025 18:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630545;
	bh=uLHARftLsXwh2ZwLFZCATKBU39GqKLpoPr0K4xGtMl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkVcJd4RkQdiFHEvcd8r6pD3+jpek29AvWG2ui5YHWw/sO3lP3yHOiKa6TojcASOw
	 v5gwzDdsYMuwh4R06I8uPXzR79eDvOzfWh1PEUfJtrPxU0eHB1/2zs91tGUBZ41oAQ
	 X+ZbQXe/fmEQFjGVrUX0TdaUgZGZwQjQLtTB03CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 450/620] soc: mediatek: mtk-devapc: Fix leaking IO map on error paths
Date: Mon, 10 Mar 2025 18:04:56 +0100
Message-ID: <20250310170603.354424142@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit c0eb059a4575ed57f265d9883a5203799c19982c ]

Error paths of mtk_devapc_probe() should unmap the memory.  Reported by
Smatch:

  drivers/soc/mediatek/mtk-devapc.c:292 mtk_devapc_probe() warn: 'ctx->infra_base' from of_iomap() not released on lines: 277,281,286.

Fixes: 0890beb22618 ("soc: mediatek: add mt6779 devapc driver")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250104142012.115974-1-krzysztof.kozlowski@linaro.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-devapc.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-devapc.c b/drivers/soc/mediatek/mtk-devapc.c
index 1ab7ca82745c6..552726456fa2f 100644
--- a/drivers/soc/mediatek/mtk-devapc.c
+++ b/drivers/soc/mediatek/mtk-devapc.c
@@ -258,23 +258,31 @@ static int mtk_devapc_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	devapc_irq = irq_of_parse_and_map(node, 0);
-	if (!devapc_irq)
-		return -EINVAL;
+	if (!devapc_irq) {
+		ret = -EINVAL;
+		goto err;
+	}
 
 	ctx->infra_clk = devm_clk_get_enabled(&pdev->dev, "devapc-infra-clock");
-	if (IS_ERR(ctx->infra_clk))
-		return -EINVAL;
+	if (IS_ERR(ctx->infra_clk)) {
+		ret = -EINVAL;
+		goto err;
+	}
 
 	ret = devm_request_irq(&pdev->dev, devapc_irq, devapc_violation_irq,
 			       IRQF_TRIGGER_NONE, "devapc", ctx);
 	if (ret)
-		return ret;
+		goto err;
 
 	platform_set_drvdata(pdev, ctx);
 
 	start_devapc(ctx);
 
 	return 0;
+
+err:
+	iounmap(ctx->infra_base);
+	return ret;
 }
 
 static int mtk_devapc_remove(struct platform_device *pdev)
-- 
2.39.5



