Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86B61C07FF;
	Tue, 15 Oct 2024 13:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997669; cv=none; b=YP+nKihkYY3afYb2Do7Fhv4TBfhH6Byw/Y7jvC6uCaHveSraKli3TeiXeXrLqDm7hf6xNHwwHC0CHkwD/d/cP1pTC52eSU0QtcZEO90M2PEne0HB8fRaTQWGZbWXe6SjoHuwXIkmAyPO3KysQ2U1ZAtl3DwuSOmh7W3DOVPq+7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997669; c=relaxed/simple;
	bh=h1ta34HChSGHLk0qPf1b30taXdtLSBZKplXtCFU1fFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ds9eWrBGWYC74JXHIeJHLuoP6tix3aLeNzWuqB9OGJMXgEA7mvA+aB839sjHyKf2Yu0weOY/yQEOMJQJ6O1V02SIX4G0nTfgu//r9HUfslPvoUrNi6DBZC5OZFoZkypfyds4bYvFdgAcKpZMj/rzLkCEu3M7+CvRkqcRtaOzShA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkPAfALU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkPAfALU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E51C4CEC6;
	Tue, 15 Oct 2024 13:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997669;
	bh=h1ta34HChSGHLk0qPf1b30taXdtLSBZKplXtCFU1fFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkPAfALUtuTsOuEdXTjscPD8vXpxWFkUUN4KQiY2/788vWUIj2W9Pk0swWTQf6CRp
	 mc/wXGMFV9yiJYanIp+cWougpFkq3fairzUI3Z9lxIj7owitzTtjnIVvtvPkeuPIFT
	 SNm/KKdDIAvHiyW6AEH0Idj/f2iDJJX1ueu6TbQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/518] soc: versatile: realview: fix memory leak during device remove
Date: Tue, 15 Oct 2024 14:42:35 +0200
Message-ID: <20241015123926.678573105@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c6876d232d8fd..d304ee69287af 100644
--- a/drivers/soc/versatile/soc-realview.c
+++ b/drivers/soc/versatile/soc-realview.c
@@ -93,7 +93,7 @@ static int realview_soc_probe(struct platform_device *pdev)
 	if (IS_ERR(syscon_regmap))
 		return PTR_ERR(syscon_regmap);
 
-	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+	soc_dev_attr = devm_kzalloc(&pdev->dev, sizeof(*soc_dev_attr), GFP_KERNEL);
 	if (!soc_dev_attr)
 		return -ENOMEM;
 
@@ -106,10 +106,9 @@ static int realview_soc_probe(struct platform_device *pdev)
 	soc_dev_attr->family = "Versatile";
 	soc_dev_attr->custom_attr_group = realview_groups[0];
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



