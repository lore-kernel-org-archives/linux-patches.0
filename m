Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C136F1E0DBB;
	Wed,  6 Nov 2024 13:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898212; cv=none; b=eCG39c94ohEpSMs9Cu248cZSkmqAEVRQXDTA3x41JE+Uhw3Yd8gORgwwi5izKAydL8NcaBdmz91zBXdsG/8NnTWIRK0ZoALL9YKI0MztJp7ADpKoBXM599jBdGq6BOhd1xg4Eu2s2kzVnqSDfPZIfb516lP0FE1Pki+qK6iI2CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898212; c=relaxed/simple;
	bh=hOthEvUI0ZdzNtH/51u+vFtu8RJ8GASfQVm1mlr0KBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tT6sFon1KYPTkqE7XahKWZ65QGSoNXxNbPLnch/hKKTdJABCwwOBeptZWx7H/Sr5NA5EhODSXJJx65TU5VpG35rfFYmnQxzoUga8rMGnPX1gydnxQAiegNFWpoWkllAZlN5WviuAZUdQ5wvRbWTdZhztxqd8eghHGjY/r7VjQFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+8kIDq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+8kIDq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A7EC4CED3;
	Wed,  6 Nov 2024 13:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898212;
	bh=hOthEvUI0ZdzNtH/51u+vFtu8RJ8GASfQVm1mlr0KBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+8kIDq9cUj9FsU5/CjalMULsITnTC2q8HjsirgvopPjKUnCYemY9/HR/hKIJjA5F
	 M1rXxx6v9OzhJEMoQqpsgKW7mpp10vYkR3k/NNyGT7PvchK2DOcXuUWWu2EfVY4T2R
	 hIIEAHC8nzH5iYFPtq4fzjNZsE5wbtbdj2a5rOPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 163/462] soc: versatile: realview: fix memory leak during device remove
Date: Wed,  6 Nov 2024 13:00:56 +0100
Message-ID: <20241106120335.547770759@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 1c4f26a41f9d052f334f6ae629e01f598ed93508 ]

If device is unbound, the memory allocated for soc_dev_attr should be
freed to prevent leaks.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/20240825-soc-dev-fixes-v1-2-ff4b35abed83@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c774f2564c00 ("soc: versatile: realview: fix soc_dev leak during device remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/versatile/soc-realview.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/versatile/soc-realview.c b/drivers/soc/versatile/soc-realview.c
index 9471353dd8c38..60947a5161e4c 100644
--- a/drivers/soc/versatile/soc-realview.c
+++ b/drivers/soc/versatile/soc-realview.c
@@ -91,7 +91,7 @@ static int realview_soc_probe(struct platform_device *pdev)
 	if (IS_ERR(syscon_regmap))
 		return PTR_ERR(syscon_regmap);
 
-	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+	soc_dev_attr = devm_kzalloc(&pdev->dev, sizeof(*soc_dev_attr), GFP_KERNEL);
 	if (!soc_dev_attr)
 		return -ENOMEM;
 
@@ -103,10 +103,9 @@ static int realview_soc_probe(struct platform_device *pdev)
 	soc_dev_attr->machine = "RealView";
 	soc_dev_attr->family = "Versatile";
 	soc_dev = soc_device_register(soc_dev_attr);
-	if (IS_ERR(soc_dev)) {
-		kfree(soc_dev_attr);
+	if (IS_ERR(soc_dev))
 		return -ENODEV;
-	}
+
 	ret = regmap_read(syscon_regmap, REALVIEW_SYS_ID_OFFSET,
 			  &realview_coreid);
 	if (ret)
-- 
2.43.0



