Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AFB29CE7;
	Wed,  2 Oct 2024 13:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877141; cv=none; b=n/3jS9opVtH1LHX1CnU5rpBNe32SarPFi0YsUWWB9P8xn8LSVG4GoWPMHo/yUJ3uSx+N/xMKIMRD3ikAO58ZhpJKbTrL/wMLER9QvIip7C+QjV6eiY5uQl7m2FksfW74EUJiWelTXH0d0ArXD20S6DyZEQIZdxi7vq/dNMel7SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877141; c=relaxed/simple;
	bh=jJKV48uNLl+13YX23yE80sei8GzIF92w8m05xqkZCsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovPLdfyreVlrejmq5DIp9QU/tzC8jUOWnvrV5JgHpoHNJjfjLauzWIDQYsgVAiUEM8CmDu28923TgCkVt8XYHF5QQpCZwL5F/HHz5NuLTzQfHARsfy8AL0VUjemdZPYGdP7Gt61znppMTiKYv5xUsDmCGUNayz7SBjnekXZIAHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YI/fx7Jg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YI/fx7Jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB97C4CEC2;
	Wed,  2 Oct 2024 13:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877141;
	bh=jJKV48uNLl+13YX23yE80sei8GzIF92w8m05xqkZCsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YI/fx7JgvaPLXImp7fucQh95bQvGzxdi8n1e+GgqhPhV21uwCsP4CWc9JlDCI52tF
	 V1AtbycI1BkphUJchUZQmlkTrm/Ir1lySBnAJE8fOvYNGC5qqAk+dkvuNICXo5O/77
	 fleU+USSj4UCdXQjtL4hzmLhNmNZhzQmThJjYTfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 661/695] soc: versatile: realview: fix memory leak during device remove
Date: Wed,  2 Oct 2024 15:00:59 +0200
Message-ID: <20241002125848.894421411@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



