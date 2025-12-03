Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2457F3074BA;
	Wed,  3 Dec 2025 15:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776651; cv=none; b=QfthP0HQfCR6vxflSTDuGVRPDyqeaWIzuEux7b925R5zwvNBH5QkAwLipwNQ21Y2FZJpdMSlS6uQ5eEo1QKGOWd3hEjVt6OQzb/dY05XhQ3ZKIMGTGaRtM86JxiWomrU385hsKMoOW0mr3YRTqxQocotrO04gbERZLWkVJSp0Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776651; c=relaxed/simple;
	bh=KZkgOL8VO0DtePNTAy33c0FMfYlJeN/lQXRR/XoFfJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQXRldF3yJ427sG0TaEllU5qGWsbNFzJqraT2ZOcCyKNV5IY0ru9910Y08jmL9/mLs1OoIvoTK5yAiYB1bVXA2wV9Y4u1yPdwuJEjfiI9dffKJlmTkkHxt7vjxYfqz1mnwa/30ulDfndC2WG6jhNVo/D3zYayPypYMkBHEdsFDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2CYHAbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2CYHAbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C87C4CEF5;
	Wed,  3 Dec 2025 15:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776651;
	bh=KZkgOL8VO0DtePNTAy33c0FMfYlJeN/lQXRR/XoFfJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2CYHAbiFzKNrQHYidDAbhF9SM5pwyALzRRPD8fLaucP5WO/jWqdP00mUQB5Rc9aG
	 6thhErNTaDgEz8tiAVD//XGBlMVmBiNvWS2/VhQeoAgAYnw7h4wN84zrQ5lZsbmHLn
	 u9eRnpw6cQRsevYxNlwplWpIGAx+ku6WHT0Q2+K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 203/300] mtd: onenand: Pass correct pointer to IRQ handler
Date: Wed,  3 Dec 2025 16:26:47 +0100
Message-ID: <20251203152408.145355700@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 97315e7c901a1de60e8ca9b11e0e96d0f9253e18 ]

This was supposed to pass "onenand" instead of "&onenand" with the
ampersand.  Passing a random stack address which will be gone when the
function ends makes no sense.  However the good thing is that the pointer
is never used, so this doesn't cause a problem at run time.

Fixes: e23abf4b7743 ("mtd: OneNAND: S5PC110: Implement DMA interrupt method")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/onenand/onenand_samsung.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/onenand/onenand_samsung.c b/drivers/mtd/nand/onenand/onenand_samsung.c
index 87b28e397d671..d51d3ff6f0a3c 100644
--- a/drivers/mtd/nand/onenand/onenand_samsung.c
+++ b/drivers/mtd/nand/onenand/onenand_samsung.c
@@ -908,7 +908,7 @@ static int s3c_onenand_probe(struct platform_device *pdev)
 			err = devm_request_irq(&pdev->dev, r->start,
 					       s5pc110_onenand_irq,
 					       IRQF_SHARED, "onenand",
-					       &onenand);
+					       onenand);
 			if (err) {
 				dev_err(&pdev->dev, "failed to get irq\n");
 				return err;
-- 
2.51.0



