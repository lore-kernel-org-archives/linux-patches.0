Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B8E481B7;
	Mon, 14 Oct 2024 14:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917617; cv=none; b=PODCocGsq4b7k+CasFzzLh5UHJq2hVKvfq5dDQYvdZmEcJpKdj7DMTxgl55rFTJxCG+VA9OjXR6DrNPiZLhBlk9rlGsibw/MBNfxqtLiJdiqITK5WSZVSA/GkHX45S+BbEpAB07Nno7W6K4dboq7ezY+kcyhhUrMHkxRKCvn2Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917617; c=relaxed/simple;
	bh=vBad1yK87Jf6r+dLNtipHk+ajUPgCWMtBJKADNjwxgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRrDEbn0P9BAUCi6ql1QnhP/o59dFsfC9fdqTF5NVea2nUafxnkth/19IB3FyWHnI8quF7qhUehM+u882wSYxXNmwtH/69SgcuiT5gZWKidDvD/mirr//e8cndvvwwwrGophJpfF0Nhz3NJQdRBD2/tvyV8VJfXDllQBrzZP8EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtuShjty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtuShjty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B94FC4CEC7;
	Mon, 14 Oct 2024 14:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917616;
	bh=vBad1yK87Jf6r+dLNtipHk+ajUPgCWMtBJKADNjwxgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtuShjtyJN9338XR/kiDu1klt9+vDQ+6D5JfRsSO8c4Nfivt8Qh0Mm/yuqNWCltVc
	 +Cx8jiyfJZ5l7QZPgIQ+z56Ieazs7OGeJt4XDkYbP0wZiyuymHd/9VWC3cn3n6Fxon
	 gZfp0ELvQ3N8LF+vRC5smUaZexMvYqKHRqtROpLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/798] reset: k210: fix OF node leak in probe() error path
Date: Mon, 14 Oct 2024 16:10:36 +0200
Message-ID: <20241014141221.157356621@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit b14e40f5dc7cd0dd7e958010e6ca9ad32ff2ddad ]

Driver is leaking OF node reference on memory allocation failure.
Acquire the OF node reference after memory allocation to fix this and
keep it simple.

Fixes: 5a2308da9f60 ("riscv: Add Canaan Kendryte K210 reset controller")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20240825-reset-cleanup-scoped-v1-2-03f6d834f8c0@linaro.org
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-k210.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/reset/reset-k210.c b/drivers/reset/reset-k210.c
index 1b6e03522b40d..b0f4546b2b1e5 100644
--- a/drivers/reset/reset-k210.c
+++ b/drivers/reset/reset-k210.c
@@ -91,7 +91,7 @@ static const struct reset_control_ops k210_rst_ops = {
 static int k210_rst_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct device_node *parent_np = of_get_parent(dev->of_node);
+	struct device_node *parent_np;
 	struct k210_rst *ksr;
 
 	dev_info(dev, "K210 reset controller\n");
@@ -100,6 +100,7 @@ static int k210_rst_probe(struct platform_device *pdev)
 	if (!ksr)
 		return -ENOMEM;
 
+	parent_np = of_get_parent(dev->of_node);
 	ksr->map = syscon_node_to_regmap(parent_np);
 	of_node_put(parent_np);
 	if (IS_ERR(ksr->map))
-- 
2.43.0



