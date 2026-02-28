Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EEF36C9CE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302218; cv=none; b=DhuqcZjPQ5UfN3jxyT8iwVXWX+YZRUSE9sGZSixCeY5lrKgsjCncarlL59WJ1N6DsfnUX3LPBkE8Z6MxffQK3wmQoaE9oQE4+RpD8/KisQOAcw2uOtfctruTTPvelNanm9ieip8JBJ8JKpXuPUraJmK/enq3QsD8YhMsGFaevKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302218; c=relaxed/simple;
	bh=9zTQbO4gHA2QdlAnO3HfEHvV2R24PPp4ljue5Cr6SyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaUx+CXIx8W7EnP8eJwbtrH0b5+9VmaZ6xl6B8W6bpOfP/fcJKVH/KZmVq31FO5mLeRiDm4syJRmlae8pxlYSExI1gkmxSfz50184ISnCozV9AwmThAUfOF2Gv34CGLYCxLg4ZQocbUM4qD3TVcl3sAOXE3h0hdMQL1gvKXkYfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qakgls6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qakgls6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D506AC19424;
	Sat, 28 Feb 2026 18:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302218;
	bh=9zTQbO4gHA2QdlAnO3HfEHvV2R24PPp4ljue5Cr6SyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qakgls6PGCrdfTdvoVoo3VTEQQg06jIyPOpvPEjhDMn9Ym+kLvKLybgdnTOCwGno4
	 XwjxhKb9qRPYinmGZovcy/ReZS+K7dwqApjp+rP+fZbIJs0s+2lUxf2ksMeDUcAtPo
	 A1EnnuNFeV99AlgPnm182WAdMS4Co2JENRzTKm0afXakO1FaYebRrFI80MRg6zgHYO
	 /Nu9JweD+3AGY69pPViMqL+1zzldUNzylrSj2TxMoisens3G09zihP6FCp46pv2cG1
	 h7MM0XxoywHRZODDhYKVTFPNsbsLkN1to/MxfGPWAfOTok5pEmhU9NSA7tWsiyrifF
	 FUtAchK5cPYbA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 225/283] clk: mediatek: Fix error handling in runtime PM setup
Date: Sat, 28 Feb 2026 13:06:07 -0500
Message-ID: <20260228180709.1583486-225-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index ba1d1c495bc2b..644e5a854f2b6 100644
--- a/drivers/clk/mediatek/clk-mtk.c
+++ b/drivers/clk/mediatek/clk-mtk.c
@@ -497,14 +497,16 @@ static int __mtk_clk_simple_probe(struct platform_device *pdev,
 
 
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
@@ -618,11 +620,11 @@ static int __mtk_clk_simple_probe(struct platform_device *pdev,
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
 
-- 
2.51.0

