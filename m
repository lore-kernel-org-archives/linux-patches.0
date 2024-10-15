Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98EF1EF926;
	Tue, 15 Oct 2024 11:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992633; cv=none; b=rCtBcdqR7dIwOEaQ+QiXhZfEYE4gRZodkyTRUWzz9URHueHoNGyhAM0Q2Ue3tm6wNzERYrHs1yXXmtU7rI7s/kLV7tC7Y6ypYAqLZfC6qQJS3hQv+D+YqELcV/Hi6R0xobYKjhytJdjSMcXRbOTLziAAHpaLxJcTaLYoIzeEHxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992633; c=relaxed/simple;
	bh=sRLsCKJanEN/IvLF8BvmZNKIpwC/HoCQ+dHps0JMYjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CM59aOArhhMgI3Fouh2JO0EPZdk28RxzzsIUXlF2EpVxbEZuyR9C1ZUt65XMEPMg1M9k2m9UgC81EliFRh08OrVIoMn/3EfOYtcnAdzNwCxC10oho1pWqmZ5qf5EGyB047ITYquHetD5JSd/+bFwRw+px5OOX3JvRpEJQcikcMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiDLxmLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiDLxmLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17540C4CED0;
	Tue, 15 Oct 2024 11:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992633;
	bh=sRLsCKJanEN/IvLF8BvmZNKIpwC/HoCQ+dHps0JMYjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiDLxmLJWQPTqzTT6rGZb3BLvnYUvZC6oMomaXCsxek3grO4uzOq2aKiP/+SzgJqM
	 4aO30tLes3nFaP2DlTOtdpgv8eRCZpRKYDWGRAWqNfwchWobcA0dCkZiF/hibsxQOz
	 NQks4AZtRtlpNNiCy9pwggcC+s6IB5DgwdCtHw9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/691] reset: k210: fix OF node leak in probe() error path
Date: Tue, 15 Oct 2024 13:21:34 +0200
Message-ID: <20241015112446.149232044@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



