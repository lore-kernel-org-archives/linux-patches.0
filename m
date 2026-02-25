Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BB01FE45D;
	Wed, 25 Feb 2026 01:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983438; cv=none; b=mJFu21IgjKUQbHS+F0tYhTzYrOHAjmHx5ZNzKVzH71nNmBFHww4zCDMEs2CLxhTgbaiqVGf/FQQLgVIjk3xf6Gljy51xp3zeJDyl4lSz1IFnAmOZl+PYSa5T1TVxo6s6CHBv34oRyOvMGWYfOO7HLaRNkTh+i1O+/0oXuQIk6eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983438; c=relaxed/simple;
	bh=e7sz+bYu+PrJIpMvWIIcCOM4h+nnsXlCqtsJLdDwmJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUw5mA+fpYwuRvdGZQnaoQzm8VqEOaHmFIdnpMGBGOb4nIY8PAfv3SB8E784TdgAZe4Lkwy15Pkom8N2szmESD/DTBMdsdBb7S/mJAlFUIvX79RyO4AqH/T3seRiVJvS9OX5Dr8Ex0xryQbNKCRYLQtwnR0B3O8s/b/AX0dEBlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BL9ZTQGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BL9ZTQGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA59C19423;
	Wed, 25 Feb 2026 01:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983438;
	bh=e7sz+bYu+PrJIpMvWIIcCOM4h+nnsXlCqtsJLdDwmJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BL9ZTQGepIkbavnrlQCKqFtfdGu3u/erSeGvj55dpXZCu9vC2KGT6/ssz8/iYLtIB
	 aZScuojZjy0J2cXbm6Zz6XpyUELPEZgXI4YGBJ6BqaluhF71LR9PEuTDgDP0BsEoqC
	 NbJYv9UKh6i4wmPdbpSzdGyK7pt818AMN/seUiG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 556/781] clk: mediatek: Fix error handling in runtime PM setup
Date: Tue, 24 Feb 2026 17:21:05 -0800
Message-ID: <20260225012413.439298056@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 19cd27941747a..deafe55a96cb1 100644
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



