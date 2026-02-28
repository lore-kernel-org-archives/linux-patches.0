Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0617934252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301889; cv=none; b=FtFCUDctp01Xg8iSJHtqqxUwxQCQt2uCUOBtrd7l1FJVi55n88KTVwWBvu61z/G78MinwTIjN0QFS9uM09EsPb1NumffnljqLhjmRG4gjuc+Rj8ySlIeMH/TtC43LF3dkbBjCfSHBekKHmeLcavtn2agfMhXOUd/RX3Jx1MNLWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301889; c=relaxed/simple;
	bh=9zTQbO4gHA2QdlAnO3HfEHvV2R24PPp4ljue5Cr6SyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3VLvuho65PqhQdJBBGt2JSQxGRHYL3FaRkyn55meyxZ4RqXhngzjKUZ/otxnvzS5NxvAJ6v2QHFqEEDE6Z9wGlfLOq07Us8RNJ5Sw4t/z96Gh/KFAjIQxwMbCGetbQtb02l/rnGTL6K4NzJQnu/Gs0NK9bUWcU1YdJweYBX3wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hNwSlc6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hNwSlc6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540D2C19423;
	Sat, 28 Feb 2026 18:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301888;
	bh=9zTQbO4gHA2QdlAnO3HfEHvV2R24PPp4ljue5Cr6SyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNwSlc6CscPGZbk98BAmgY63DbSckl4bI4jPhm4ZQnd/DxxHMm4HpO/D0aja0jOKF
	 RnikhhwnhSX2sYxBZjswZgSoyQSuEZL0t0axlW440vQfVYtkxiJJpnkdKl1W4cI98J
	 pzhE3kqnK7kyrPuC6BPtOw0GtE0MZuwSscuAtoNvyxeHCW2nhqke3B7VOgXC93wxMn
	 VT3emDvzLj3MqeVFZqtPrjY2Lck/YWgYScmlgU6rJkhK5ZSpbxIt3FVVcR8d9DZRff
	 0fVKbeiKphN65unQIo2TyshNMQP0ifFWQGSaebaJ2r6e7oRPHdusW0rlb75nPEjEM9
	 wcAYabMpBToqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 315/385] clk: mediatek: Fix error handling in runtime PM setup
Date: Sat, 28 Feb 2026 12:58:57 -0500
Message-ID: <20260228180011.1568201-315-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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

