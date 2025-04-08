Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABD82686BC;
	Tue,  8 Apr 2025 11:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111372; cv=none; b=TURagG8UECO+SeeYwVPGD/rJbRQhl7cly/O+DUSldtmIfl+shHtHL23/ID+IljhMJPRpxtLnZkyPQmIq5BQwTnSuCjbjPRAP37wxsO/kBEoYS0wrwnc6w0CO6h741PpoVAZhi6aeKcf5yjLOL/PZ4Cb9GuDU7+JKsT9wqqTfSCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111372; c=relaxed/simple;
	bh=1immG/ovlDAijA7UbOQAFCwLajW9aHvmQ5p1g77BAVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoCdakyCC9vCPtQrKA4Du1zqPnQHYqqqGaI2C6ygyRRF4u+CxCKFc1aWLyqiKc3dFtuSQOwr/y7cPoFqjjcrh5UciyEFxoQeqH1HwXt4oHktOJiDVGmEEp9K/FXml3RTW7Uh4bpMuvQyueslvULz/bVYBckvdaju8lbMVBcDJYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1ogEwFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1ogEwFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A4AC4CEE7;
	Tue,  8 Apr 2025 11:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111371;
	bh=1immG/ovlDAijA7UbOQAFCwLajW9aHvmQ5p1g77BAVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1ogEwFvzM9BBu1AsfHi8u8tyCCwxcPEOJuxsEYHhwUCjvBIrn6/gaqG5AHK/FZOc
	 mEXcu4uefeT/XZ+PmiSjtuPL4AF7xYOmryxYsij1diFIcMG/nh3+itbc7yPRS4bDnl
	 KMJsoFTuwrZ1mu/AwNueZgj/sa38khvvBlE4KaMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 408/731] clk: mmp: Fix NULL vs IS_ERR() check
Date: Tue,  8 Apr 2025 12:45:05 +0200
Message-ID: <20250408104923.763233019@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



