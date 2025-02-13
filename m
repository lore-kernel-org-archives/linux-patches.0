Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1344F26B0BC;
	Thu, 13 Feb 2025 14:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458153; cv=none; b=Lrk+rtiLOpV4/gGaM3V8nQDHiYKM2Y8LEkHQTkgcOkBZAnX3T6bevqSL+BNYpZraB/5Gm6eW00+H+9zkQMQgizL4f2KTtYZj7k5hacXOG0y/LPjziVH74AXRQrApTdT+Wk4pm/W29WhiFCj3AiA+IMQiEv3HwOfIRplviD//PUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458153; c=relaxed/simple;
	bh=dk67/5gDAHQkariIGgJ/FU5CQaCRv2e0clqq3FZn71w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKSd9iMQRxOlMd3+mRMprLMAwoGzkotfszJbW5xq+rhEG7Ov6/Fox0D7VCxBUMkpH0iYhsyozCV7Pe80TsoZRsytJxzOLg+Jn4n/K3y1syLCOfTDgIASvNbHi8eLm2uIZZSZmoPQxG3UqnG4H2xh9L5SFqlvfCkuj7x9MCsc1wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAkK70Nx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAkK70Nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F91AC4CED1;
	Thu, 13 Feb 2025 14:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458152;
	bh=dk67/5gDAHQkariIGgJ/FU5CQaCRv2e0clqq3FZn71w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAkK70NxwDd/PDrAUoI2XVzairdBd4FlTnmZiICsNvMNfNl9s9CXE7tIMBjLWlxzK
	 U27l3dA7uyv7XNXD1+EuhRHjZsM3zERnhbWQ/yBQTI+ZACylkWUEHOLPcDnlBLhSHi
	 pO9oeVW/5911As4LKgzEX1BIZIN3GAhDMGT1r/DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.12 317/422] soc: mediatek: mtk-devapc: Fix leaking IO map on error paths
Date: Thu, 13 Feb 2025 15:27:46 +0100
Message-ID: <20250213142448.783038018@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit c0eb059a4575ed57f265d9883a5203799c19982c upstream.

Error paths of mtk_devapc_probe() should unmap the memory.  Reported by
Smatch:

  drivers/soc/mediatek/mtk-devapc.c:292 mtk_devapc_probe() warn: 'ctx->infra_base' from of_iomap() not released on lines: 277,281,286.

Fixes: 0890beb22618 ("soc: mediatek: add mt6779 devapc driver")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250104142012.115974-1-krzysztof.kozlowski@linaro.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/mediatek/mtk-devapc.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/soc/mediatek/mtk-devapc.c
+++ b/drivers/soc/mediatek/mtk-devapc.c
@@ -273,23 +273,31 @@ static int mtk_devapc_probe(struct platf
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
 
 static void mtk_devapc_remove(struct platform_device *pdev)


