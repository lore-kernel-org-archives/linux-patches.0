Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B822A32142E;
	Mon, 27 Oct 2025 18:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591343; cv=none; b=Zt1IycBFF+q1L8JLc9IJnTr81ZyyY9dK6CMepWqoYBos5EvYtwf2rQH4DrkrRV95mnRXivHli234wtciRiA8SjQye0Vdmz+pTuMn3B4ldC7jvTnODM6dunj7zr05xIBzmyZiOO0De9NSYNJ2pq9ny7J86AoHaMcQ66bNQO2xjXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591343; c=relaxed/simple;
	bh=gHN4dv+OzzV4ha0Xp7/WkDOMjJj8iNlRRZ1WksJ3QK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bX2IDa5w/yn07+2/UyT9jFZiGdI+CnUZWPnmkVgWDbs+SrKhSE//Hi2k0MFwc8NrKT0QXalaH2SGq3k3vz1V7zYvo+agu/GTVlUZrYi2ZlxpmaAfsLBC1MVnYOEGBpHjZRiicyqxBtcaN4eMYyu4zLwTggtvWK5NBy9O0rR6CR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsioIU3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsioIU3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD97BC4CEF1;
	Mon, 27 Oct 2025 18:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591343;
	bh=gHN4dv+OzzV4ha0Xp7/WkDOMjJj8iNlRRZ1WksJ3QK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsioIU3x3Ap4iKSGmC6u8J0ttRJlx4LfOs3ATY/Avzq06/dSs9lQrThzT4RbhPWAC
	 0X+4/eAHYccKlNXmB9klp4RuECVbrmfZO8yXDklqqzMbkKLVl0uvOy1DCJCL4ohY4p
	 wOx3OnTFYxGIV6oX809EcevlmzGGGx2L2LeO82bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.10 153/332] memory: samsung: exynos-srom: Fix of_iomap leak in exynos_srom_probe
Date: Mon, 27 Oct 2025 19:33:26 +0100
Message-ID: <20251027183528.671782154@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


