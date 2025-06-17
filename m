Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6431A5B9D;
	Tue, 17 Jun 2025 16:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178419; cv=none; b=ptwnKmT9uJZaJC/9Ay0ndWCjdTDyWrt1E9EQZiGmy46U/y6abbjvkjS0yGl3SH5IzsbFMVNErnVDysZTOyqmk7/2tu9sNpNqd2WwedtDzDCErnz7eyZc8UgY2WUcCCJKsMkObydJkU/ZRZrAR8Munt3YBt2iJKZOjWFVCjNNRkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178419; c=relaxed/simple;
	bh=enbiqWEtjmyXc4G65fwvQEY0bUSEudFWt3IXAy1el4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbMVTmrW1bdWCMhrMGAsCqgOOavBQFw5Vfw6lIwidDft5xg6sY8REOUENs8Z89444j21VFNUWmZeubPwLJV/igu82Uz44J5zmvVIeczXniX3g+nGZfSYF9y7tx0RGSwOVxapFHuNIruhmfbxzKmn1mjIjPlJNF4Afb0saL9PX6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqVEuBLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqVEuBLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14586C4CEE3;
	Tue, 17 Jun 2025 16:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178419;
	bh=enbiqWEtjmyXc4G65fwvQEY0bUSEudFWt3IXAy1el4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqVEuBLlnZ7mEKvpBeV3yyTsTzL0ZXNgb9JjdUtJLQlhg75hsK7C7ybq2h6CrnC0W
	 7fBfkYzVo45t8xDzjzPm3jAGEa8zmRu+epCLlqJBVD8HDj1tAvQJ6AesJvjT6QM80P
	 oRGzeT9ZqQiGf5JCVxtrL0d68ZYxattSopwXUmCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 457/780] mfd: exynos-lpass: Fix an error handling path in exynos_lpass_probe()
Date: Tue, 17 Jun 2025 17:22:45 +0200
Message-ID: <20250617152510.086579484@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 484f0f59f09edd1f6fa63703c12eb30d72a519ac ]

If an error occurs after a successful regmap_init_mmio(), regmap_exit()
should be called as already done in the .remove() function.

Switch to devm_regmap_init_mmio() to avoid the leak and simplify the
.remove() function.

Fixes: c414df12bdf7 ("mfd: exynos-lpass: Add missing remove() function")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/38414eecb1096840946756ae86887aea2a489c1b.1745247209.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/exynos-lpass.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/exynos-lpass.c b/drivers/mfd/exynos-lpass.c
index 6a585173230b1..6b95927e99be7 100644
--- a/drivers/mfd/exynos-lpass.c
+++ b/drivers/mfd/exynos-lpass.c
@@ -122,8 +122,8 @@ static int exynos_lpass_probe(struct platform_device *pdev)
 	if (IS_ERR(lpass->sfr0_clk))
 		return PTR_ERR(lpass->sfr0_clk);
 
-	lpass->top = regmap_init_mmio(dev, base_top,
-					&exynos_lpass_reg_conf);
+	lpass->top = devm_regmap_init_mmio(dev, base_top,
+					   &exynos_lpass_reg_conf);
 	if (IS_ERR(lpass->top)) {
 		dev_err(dev, "LPASS top regmap initialization failed\n");
 		return PTR_ERR(lpass->top);
@@ -145,7 +145,6 @@ static void exynos_lpass_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		exynos_lpass_disable(lpass);
-	regmap_exit(lpass->top);
 }
 
 static int __maybe_unused exynos_lpass_suspend(struct device *dev)
-- 
2.39.5



