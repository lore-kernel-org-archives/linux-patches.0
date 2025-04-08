Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B4720CCD8;
	Tue,  8 Apr 2025 12:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114624; cv=none; b=l4lL2fsm+gjv1l3gXauFglzcMP+65YD9YcxCGLVSRS0x6QmKa3ZMjGA02+oZewgKFYBrrne0ZX4tU4Rnh5bvVpqLUSoBXsclO9Y/4zyEUNKGglocu+y5SE7rkiiP4JJaqRB7xeV3WVWkUotF+7ceswNCDBFNDPozL4+2Wtixtpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114624; c=relaxed/simple;
	bh=p64EEF2KPU/vewILuD7KuP9JqbnFh/jMvI0P1ke2zBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1fBpd9MxZipvfBlBp74cqah0Eky5IlkEjz6bF1LYe4KQ5Zdf917I9mHkklQlisLzepL966bV9kR6NM7j7oY5gWhFcUv2o/+qU4jXK/f/dw3VD0z2SG7KTAElvTxGCBY1DSNAdFFDKXbvxaFObcvAiXO9SsI4xb19T882Tc69Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SrbUZtrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SrbUZtrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0640AC4CEE5;
	Tue,  8 Apr 2025 12:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114623;
	bh=p64EEF2KPU/vewILuD7KuP9JqbnFh/jMvI0P1ke2zBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrbUZtrfeHyTAOlyoGEEb5ElNY2RqRD5rt2JtFpSXR9Z0nn/oushlQUk8G9SXBsF9
	 KsIffn2fyCgwhy8wUuybatLl8ZppbG6HYF4ce0kMnLjXfGu6L2807R9ieV0YqjCLBK
	 VVNoJhYGUKvfaJM785hvsIXumBJwomkFxfusz0fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 176/499] clk: mmp: Fix NULL vs IS_ERR() check
Date: Tue,  8 Apr 2025 12:46:28 +0200
Message-ID: <20250408104855.563905832@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 00153c64a72d336cc61f4141e5be53b49b7797e1 ]

The devm_kzalloc() function returns NULL on error, not error pointers.
Fix the check.

Fixes: 03437e857b0a ("clk: mmp: Add Marvell PXA1908 APMU driver")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20250307064708.209511-1-hanchunchao@inspur.com
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mmp/clk-pxa1908-apmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mmp/clk-pxa1908-apmu.c b/drivers/clk/mmp/clk-pxa1908-apmu.c
index 8cfb1258202f6..d3a070687fc5b 100644
--- a/drivers/clk/mmp/clk-pxa1908-apmu.c
+++ b/drivers/clk/mmp/clk-pxa1908-apmu.c
@@ -87,8 +87,8 @@ static int pxa1908_apmu_probe(struct platform_device *pdev)
 	struct pxa1908_clk_unit *pxa_unit;
 
 	pxa_unit = devm_kzalloc(&pdev->dev, sizeof(*pxa_unit), GFP_KERNEL);
-	if (IS_ERR(pxa_unit))
-		return PTR_ERR(pxa_unit);
+	if (!pxa_unit)
+		return -ENOMEM;
 
 	pxa_unit->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(pxa_unit->base))
-- 
2.39.5



