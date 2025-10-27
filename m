Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0704E32BF33;
	Mon, 27 Oct 2025 18:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590881; cv=none; b=e3OoNuK2QrLWNOUStGUYrBAGP3iW/iIDkTFMMels8cxOSA9PK1KPI+fCof8nBfP4GL79D64WJu85Ofr+cE42J0zPbHwGq6m5KYK61HMuI6RbkNQjo4OL+ikIZPcKBut828U4LS7KztQ+cZRGqzYJK5ViW5CLOMN/Eqb5MhVML94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590881; c=relaxed/simple;
	bh=GxF3HPAJbRqb7c0gn0oFm9yrKpV9UKcVlJmN87gvoF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyHdmjxr3Lk3lf0qOvB6QrRCkTkji9reSH913dy1VtlfHwzP2XU2frghoJRk5wjZcBBe5VcLutrwoHzB6s7wOKSIg0r4z48CxO+Gvvs2e0K7BnswA4bvRg1TtSuHmktOCrOO7hydnR13bdZAVCho55cdxyWIv9mYvUAZCEYvUXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPkgvXn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPkgvXn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458D3C4CEF1;
	Mon, 27 Oct 2025 18:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590879;
	bh=GxF3HPAJbRqb7c0gn0oFm9yrKpV9UKcVlJmN87gvoF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPkgvXn0jXLzcu/JSIXNJg+lQDspd/sh0TpYgoMGqXkEvlUUT+sUcA1qyXVxmilg+
	 j189vT8+tDi6RXC8Sgeyp2EvPZNSd07zl4uRQM6F+neuAWgj5vb3kZvcdpegk8nqh3
	 jaLsWnSmY59iKlbARCyg1PPio/JAbxFgooTtpcwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 210/224] memory: samsung: exynos-srom: Fix of_iomap leak in exynos_srom_probe
Date: Mon, 27 Oct 2025 19:35:56 +0100
Message-ID: <20251027183514.382092010@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Ni <zhen.ni@easystack.cn>

[ Upstream commit 6744085079e785dae5f7a2239456135407c58b25 ]

The of_platform_populate() call at the end of the function has a
possible failure path, causing a resource leak.

Replace of_iomap() with devm_platform_ioremap_resource() to ensure
automatic cleanup of srom->reg_base.

This issue was detected by smatch static analysis:
drivers/memory/samsung/exynos-srom.c:155 exynos_srom_probe()warn:
'srom->reg_base' from of_iomap() not released on lines: 155.

Fixes: 8ac2266d8831 ("memory: samsung: exynos-srom: Add support for bank configuration")
Cc: stable@vger.kernel.org
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Link: https://lore.kernel.org/r/20250806025538.306593-1-zhen.ni@easystack.cn
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memory/samsung/exynos-srom.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/memory/samsung/exynos-srom.c
+++ b/drivers/memory/samsung/exynos-srom.c
@@ -121,20 +121,18 @@ static int exynos_srom_probe(struct plat
 		return -ENOMEM;
 
 	srom->dev = dev;
-	srom->reg_base = of_iomap(np, 0);
-	if (!srom->reg_base) {
+	srom->reg_base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(srom->reg_base)) {
 		dev_err(&pdev->dev, "iomap of exynos srom controller failed\n");
-		return -ENOMEM;
+		return PTR_ERR(srom->reg_base);
 	}
 
 	platform_set_drvdata(pdev, srom);
 
 	srom->reg_offset = exynos_srom_alloc_reg_dump(exynos_srom_offsets,
 						      ARRAY_SIZE(exynos_srom_offsets));
-	if (!srom->reg_offset) {
-		iounmap(srom->reg_base);
+	if (!srom->reg_offset)
 		return -ENOMEM;
-	}
 
 	for_each_child_of_node(np, child) {
 		if (exynos_srom_configure_bank(srom, child)) {


