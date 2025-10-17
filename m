Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B745F2F12D0;
	Fri, 17 Oct 2025 15:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714533; cv=none; b=obgJJz3leDDMwNowLUsEH66xv8K0vlK1GQDrPRFVJxVhRDmNGBqQi4dEtRMAcpMMMSs2mWsSQcrRkSMrAjQFnVkNHyRfli4IWRatnqS4PgJ/pc1PitxxQWOfaaeggJSC8yb5g0+NN26jKeLGC6u8//iNYgaV9OgXE96zafGzRBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714533; c=relaxed/simple;
	bh=DkEElDBggeAklQ/LFOwp2z3Iqwsbpma1tvpM4afwKmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhtuPZmxIcG3hCx/3Xa7PxDBVFUlw/urOOE9AtsSUxsy/hEHTAY/LazSSPfxgnoxzo6x5fzLS2O2MLgVkGchGquXzvlJd6UUhjZLSEcmrB3n92p669QdZyk1yxSxKd9WKy5zHSVx4rta2WKG/9xnV0JBrkiskSAs/y5uirwR0AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y40LnADH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y40LnADH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352F5C4CEE7;
	Fri, 17 Oct 2025 15:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714533;
	bh=DkEElDBggeAklQ/LFOwp2z3Iqwsbpma1tvpM4afwKmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y40LnADHIgEGyhJFh5cMnd8/2MAGauZ0DZE/VH9VeLWSeyFfKfDVsXOlqtjd4AymJ
	 DOhR1yRrbjqmzHBh7RYWaFot0NnM/1xee+Mlu6tba16pmR/luVcGgIyU9L7iWOj9HI
	 cZTpd0uhn+Q0urWny4L37EXLRHiVgC017abXeEyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.12 171/277] memory: samsung: exynos-srom: Fix of_iomap leak in exynos_srom_probe
Date: Fri, 17 Oct 2025 16:52:58 +0200
Message-ID: <20251017145153.371168815@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Ni <zhen.ni@easystack.cn>

commit 6744085079e785dae5f7a2239456135407c58b25 upstream.

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


