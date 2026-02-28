Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAAA359A8B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302445; cv=none; b=ZT86TfzQBI/F72mnZQkFm1AWqFt6YB/X0LncQhaCsT27PfyxP+WB3lHFr1jaHNlV2zNkMj+lD4ZmA4UadiKxOTTJFklZ42RRbIOqj2Mlzb5chIVxwSRkRiE3VVgbrJVhriQJDAyBcg80hYseZKiW6rY3cto4QXMj/lnypctA+50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302445; c=relaxed/simple;
	bh=JTn9QaFbkPYzy8XLB8om/ts+INi7zdRJpYlGisdfurM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSd7rUhFuuCEvj2wt6woNdVbii7CkA/lNQIf+FmuLwOkbaOdrgAiLenKjwb780tPlWW/pGS/uJtKLmZ4ixfvLulfjKM8/uoY5yC0WXrA9iuPRd2cbkihCgaA7Q4e2gXWXIW/IsSI3XuviWDzY87OkAU+iT+PHL4MiRmzd+8aUjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a7vwIOAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a7vwIOAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A55C116D0;
	Sat, 28 Feb 2026 18:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302445;
	bh=JTn9QaFbkPYzy8XLB8om/ts+INi7zdRJpYlGisdfurM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7vwIOAS0ugg0MH8pMi7I2YF2pHsSKJrxSNNWnZVuhqqoEoNh5WeWsajXOZ1FFuri
	 PjV+hj77zYTTKl0U5VLhGlvQcS+ln59ilZKPRruBA9SMk3/75Bv66AS/hxKHxEKbn5
	 bdA79OaDzZNowdrwj4eIs/iC6O1vBi4p/PMI98oPQqyVUzYTTxmA3M0yaW2Fj7HDpF
	 O2QrQTDKljTCQ8BFfrOENNJCAVlXRU96MS1SoHwzMvHWlByQtS7WiLTLOlDQK6Aiky
	 olhPyD1drrZVAYp4s+8MhTXAG02PaczJIGWTJTDxgpyeJgXwqx6TENfRkISXqQmxZO
	 p1ANHZHHVNscA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/232] clk: mediatek: Fix error handling in runtime PM setup
Date: Sat, 28 Feb 2026 13:10:37 -0500
Message-ID: <20260228181127.1592657-184-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit aa2ad19210a6a444111bce55e8b69579f29318fb ]

devm_pm_runtime_enable() can fail due to memory allocation. The current
code ignores its return value, and when pm_runtime_resume_and_get() fails,
it returns directly without unmapping the shared_io region.

Add error handling for devm_pm_runtime_enable(). Reorder cleanup labels
to properly unmap shared_io on pm_runtime_resume_and_get() failure.

Fixes: 2f7b1d8b5505 ("clk: mediatek: Do a runtime PM get on controllers during probe")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mtk.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mtk.c b/drivers/clk/mediatek/clk-mtk.c
index c2ca3d7576c22..589f425a2daf2 100644
--- a/drivers/clk/mediatek/clk-mtk.c
+++ b/drivers/clk/mediatek/clk-mtk.c
@@ -489,14 +489,16 @@ int mtk_clk_simple_probe(struct platform_device *pdev)
 
 
 	if (mcd->need_runtime_pm) {
-		devm_pm_runtime_enable(&pdev->dev);
+		r = devm_pm_runtime_enable(&pdev->dev);
+		if (r)
+			goto unmap_io;
 		/*
 		 * Do a pm_runtime_resume_and_get() to workaround a possible
 		 * deadlock between clk_register() and the genpd framework.
 		 */
 		r = pm_runtime_resume_and_get(&pdev->dev);
 		if (r)
-			return r;
+			goto unmap_io;
 	}
 
 	/* Calculate how many clk_hw_onecell_data entries to allocate */
@@ -597,11 +599,11 @@ int mtk_clk_simple_probe(struct platform_device *pdev)
 free_data:
 	mtk_free_clk_data(clk_data);
 free_base:
-	if (mcd->shared_io && base)
-		iounmap(base);
-
 	if (mcd->need_runtime_pm)
 		pm_runtime_put(&pdev->dev);
+unmap_io:
+	if (mcd->shared_io && base)
+		iounmap(base);
 	return r;
 }
 EXPORT_SYMBOL_GPL(mtk_clk_simple_probe);
-- 
2.51.0

