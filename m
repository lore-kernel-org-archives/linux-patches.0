Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C933446B0;
	Fri, 21 Nov 2025 13:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733501; cv=none; b=LaQVk5TTJUJZKDkH/ia7Tif/VcFstWdr/p7mOahmGCw5dOwsXCP39GOfcngLw3eFn2J4WObTFKWvHTN3yHlzVJp3YzX6LWma2dSAwdHyxc64KCswHfV5HFls00I8bp3FuICoGXcDgEJB6BfjRlt47PLAvLUbHZgl5bsCckxBgLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733501; c=relaxed/simple;
	bh=0D4i7AZj5JxWOUUxc0F4WTj18CYWuW+3TpUY7a9w7bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FS2fSsU++3OLIUTg8ngnKDmK4BIvw1xqgsLvneGv1JXvkdUERIyVoF3EcLESXiMwo/0yP5e4vNdgljoK0qkZZ6NzMQI8qIhJxAiBE7ExjV9MEkvM5DXFJFEIaJy5RdXZHz/sviB++UL1aQd0iyg5y5fShT3GClCzrfhZNbrZVX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMHs6EM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMHs6EM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E92BC4CEF1;
	Fri, 21 Nov 2025 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733500;
	bh=0D4i7AZj5JxWOUUxc0F4WTj18CYWuW+3TpUY7a9w7bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMHs6EM7VDA2TxqvRkIUhmdakxAdQI+U9lBhtBGdMb5sXeaw+iYHjP1jU0Ok5hVTJ
	 FnrN+2IfawRtj4TAhW79iShtPMlOFzNQsgqY6kMfoCGJiq1HFeDgewxy7m4RtYTTSK
	 G4OF33kxdvgH/ntzrKX8LGhNaZ6eWoG3mX29YBl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 488/529] pmdomain: samsung: plug potential memleak during probe
Date: Fri, 21 Nov 2025 14:13:07 +0100
Message-ID: <20251121130248.371574956@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit 90c82941adf1986364e0f82c35cf59f2bf5f6a1d upstream.

of_genpd_add_provider_simple() could fail, in which case this code
leaks the domain name, pd->pd.name.

Use devm_kstrdup_const() to plug this leak. As a side-effect, we can
simplify existing error handling.

Fixes: c09a3e6c97f0 ("soc: samsung: pm_domains: Convert to regular platform driver")
Cc: stable@vger.kernel.org
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/samsung/exynos-pm-domains.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/pmdomain/samsung/exynos-pm-domains.c
+++ b/drivers/pmdomain/samsung/exynos-pm-domains.c
@@ -92,13 +92,14 @@ static const struct of_device_id exynos_
 	{ },
 };
 
-static const char *exynos_get_domain_name(struct device_node *node)
+static const char *exynos_get_domain_name(struct device *dev,
+					  struct device_node *node)
 {
 	const char *name;
 
 	if (of_property_read_string(node, "label", &name) < 0)
 		name = kbasename(node->full_name);
-	return kstrdup_const(name, GFP_KERNEL);
+	return devm_kstrdup_const(dev, name, GFP_KERNEL);
 }
 
 static int exynos_pd_probe(struct platform_device *pdev)
@@ -115,15 +116,13 @@ static int exynos_pd_probe(struct platfo
 	if (!pd)
 		return -ENOMEM;
 
-	pd->pd.name = exynos_get_domain_name(np);
+	pd->pd.name = exynos_get_domain_name(dev, np);
 	if (!pd->pd.name)
 		return -ENOMEM;
 
 	pd->base = of_iomap(np, 0);
-	if (!pd->base) {
-		kfree_const(pd->pd.name);
+	if (!pd->base)
 		return -ENODEV;
-	}
 
 	pd->pd.power_off = exynos_pd_power_off;
 	pd->pd.power_on = exynos_pd_power_on;


