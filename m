Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131C833A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301890; cv=none; b=UfsnL2+U+tX64U4CaLSdGzxqNB2+x3fxZ7lowjykGDUsKcjlzEMdNP8U72nmdUuJLsZKDrikBFBO/XDIzC0H6sszRABr6q22aPMfiacyuJIIOIa68LwjWg0yzi0MD86PebQo9K4Nn+8XWKuSNw1ylwJet/RvO+hmO5gv6asSxs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301890; c=relaxed/simple;
	bh=ehGs6MM5a2Ty25yIgXUqH4rbmpnJ2MCg6fd9pqlBnwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i22oHdy27+u8RoEXxy+iui3j42gPtxmWQoUHbvbQJhsK/NMe6B/DHETE+iL6lxdJcJ0h3NqLYU9aDFxaXwmfVxf++5QuVAzElgqSYT388C1pnpObWlty+y0hk9+tUOmWEn3shAFAPCNKz6064yH1AzA7jdaq1dhaMkufacNKKpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qcDTSmJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qcDTSmJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EC5C19423;
	Sat, 28 Feb 2026 18:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301889;
	bh=ehGs6MM5a2Ty25yIgXUqH4rbmpnJ2MCg6fd9pqlBnwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcDTSmJ0LZNJVaeRXhnqJbAGtCPOc+/ug/83BnziteGim0r8Auqs90NBqitXpXwW3
	 rNTTXT11IRWm/unmbHMzRJlooRoQyFhnlZGdNGwv+IvuVzdnEBkm8Wa/DV/G9acG5c
	 ZFgMk88x1/qz4dGVMNAnG4kpWPgnjHLWfIumPoU0g1BbLuegqCBvIAhWOJpdoVBr2Z
	 eq/vFkWWm4DrxeZLY3KvWj46nlCdw5xIJUHFcw44z8Uox/nFmi/PskbIxWXT7DLfZ/
	 HuniKMdgoPYMrSFd1jtb89ksn5PXyfz19OaoDjLfc7B8wDLzJ5tZU4vP4bRm8AhGB2
	 pOSxFYW/tBTjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 316/385] interconnect: mediatek: Don't hijack parent device
Date: Sat, 28 Feb 2026 12:58:58 -0500
Message-ID: <20260228180011.1568201-316-sashal@kernel.org>
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

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit 510f8214440c553e81774c5822437ccf154e9e38 ]

If the intention is that users of the interconnect declare their
relationship to the child icc_emi node of the dvfsrc controller, then
this code never worked. That's because it uses the parent dvfsrc device
as the device it passes to the interconnect core framework, which means
all the OF parsing is broken.

Use the actual device instead, and pass the dvfsrc parent into the
dvfsrc calls.

Fixes: b45293799f75 ("interconnect: mediatek: Add MediaTek MT8183/8195 EMI Interconnect driver")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Link: https://lore.kernel.org/r/20251124-mt8196-dvfsrc-v2-12-d9c1334db9f3@collabora.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/mediatek/icc-emi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/interconnect/mediatek/icc-emi.c b/drivers/interconnect/mediatek/icc-emi.c
index 7da740b5fa8d6..182aa2b0623af 100644
--- a/drivers/interconnect/mediatek/icc-emi.c
+++ b/drivers/interconnect/mediatek/icc-emi.c
@@ -40,7 +40,7 @@ static int mtk_emi_icc_set(struct icc_node *src, struct icc_node *dst)
 	if (unlikely(!src->provider))
 		return -EINVAL;
 
-	dev = src->provider->dev;
+	dev = src->provider->dev->parent;
 
 	switch (node->ep) {
 	case 0:
@@ -97,7 +97,7 @@ int mtk_emi_icc_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
-	provider->dev = pdev->dev.parent;
+	provider->dev = dev;
 	provider->set = mtk_emi_icc_set;
 	provider->aggregate = mtk_emi_icc_aggregate;
 	provider->xlate = of_icc_xlate_onecell;
-- 
2.51.0

