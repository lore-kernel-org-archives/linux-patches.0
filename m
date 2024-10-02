Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC098BEA;
	Wed,  2 Oct 2024 14:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880507; cv=none; b=g7eDLgGXWiii55Xu/jtwFRa5brDXAXOWctJMyDI4STjuKqOIkKmqJpRxmAp6hsRCP5wceopjimhvAkMBTlzs37NTHMoWNLJOY/dmIsTSryZuORIShx9AkxrNGmSVD8a6+uV8Tq1EkSH9CCtX0WzpbhzfCuh2G/SjmuBqU+2qRpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880507; c=relaxed/simple;
	bh=4iQ0lIMISSWWmFq0bZg0T40BPfqyr3RaSDJ83M0qaaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lx4BFQBqKM5GKvY+x8pK65+CCang3FdgCnu9HyLhwMicolSp1iXOUscSPv/1WtxoSRH4HDYIcNwhZXwVeO13tUq18BywaTO//gNNuKd4hiSahuOmMeMe1q8MATHG3wK4fqePUwAWAZNMw9TKlKNRUCVaqKEKzfglYlZaxGN43YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlO2V4Ps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlO2V4Ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E746C4CEC2;
	Wed,  2 Oct 2024 14:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880506;
	bh=4iQ0lIMISSWWmFq0bZg0T40BPfqyr3RaSDJ83M0qaaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlO2V4PsIDcujr3UaK3uLHtGNLUStdiyejP/k6F8wg5Xr6fb/5JCersIJz8V2K6ey
	 bTsaHvvvgSiRlnASKUEuMFuqcmmMTFUrPIq8CXUvuqydpFP9OJNs8xjF+3wYKLGVqJ
	 GyMmM4R5Lb7VcwJ83OyjO91886MDH7Tkrh6zHltI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 483/538] soc: versatile: realview: fix memory leak during device remove
Date: Wed,  2 Oct 2024 15:02:02 +0200
Message-ID: <20241002125811.508179789@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



