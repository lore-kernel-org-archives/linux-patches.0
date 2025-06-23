Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243B41EDA0F;
	Mon, 23 Jun 2025 21:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713967; cv=none; b=NUim0lEICBvdGhLTpNPuStKTe4vSoITwqW+HIkKIuwAv5cjuCslX4VGttIVKovD24mvoEK2rVOw/ripyKopWA22S7tfe9oIn7zEhxgg9fO6s9sEjGdgOEIxeb5Ma15l7PxDl3J44G8Gg8vlTs6Zog1j1AZjTSlKjOQmHI5Au2vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713967; c=relaxed/simple;
	bh=fUI+JvsBevozwK5FPiWLuZu29IFjyRaWqxOvt7ebNEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1AYkCea5Io0mHmH7E4zTb9xQzh+oQzyIeHFLCZuZSSqctzeruoTJeQvvTVBb+Sena1kSlwIp1d2zTFd733wyZN0IG41rMjbt8g8P6KXs4kr5AXMo6+0TAsmNEmoRuTRxLpGQfHbzMv9Dp2cVqOqM6fjBcf5A/9JDNNFI8BgYxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrwbNdAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrwbNdAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CA0C4CEED;
	Mon, 23 Jun 2025 21:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713967;
	bh=fUI+JvsBevozwK5FPiWLuZu29IFjyRaWqxOvt7ebNEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrwbNdAF3lOVr1UxokiTXx+MDzPZJOGh4icuPsRo82YoZlAfIN24e+xinnti854R5
	 SQl3TWFtRCMxwMlfpNySifPUi5d+Q4A6d7Pl2aor21+HltiHdk0mdwSASlRoz6bOZC
	 8s64AYSm0+MOqt1nyDekTvAo0NWMr4xinLc1WL5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Arkhipov <m.arhipov@rosa.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/508] mtd: nand: ecc-mxic: Fix use of uninitialized variable ret
Date: Mon, 23 Jun 2025 15:03:02 +0200
Message-ID: <20250623130648.659081708@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Arkhipov <m.arhipov@rosa.ru>

[ Upstream commit d95846350aac72303036a70c4cdc69ae314aa26d ]

If ctx->steps is zero, the loop processing ECC steps is skipped,
and the variable ret remains uninitialized. It is later checked
and returned, which leads to undefined behavior and may cause
unpredictable results in user space or kernel crashes.

This scenario can be triggered in edge cases such as misconfigured
geometry, ECC engine misuse, or if ctx->steps is not validated
after initialization.

Initialize ret to zero before the loop to ensure correct and safe
behavior regardless of the ctx->steps value.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 48e6633a9fa2 ("mtd: nand: mxic-ecc: Add Macronix external ECC engine support")
Signed-off-by: Mikhail Arkhipov <m.arhipov@rosa.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/ecc-mxic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/ecc-mxic.c b/drivers/mtd/nand/ecc-mxic.c
index 6b487ffe2f2dc..e8bbe009c04e8 100644
--- a/drivers/mtd/nand/ecc-mxic.c
+++ b/drivers/mtd/nand/ecc-mxic.c
@@ -614,7 +614,7 @@ static int mxic_ecc_finish_io_req_external(struct nand_device *nand,
 {
 	struct mxic_ecc_engine *mxic = nand_to_mxic(nand);
 	struct mxic_ecc_ctx *ctx = nand_to_ecc_ctx(nand);
-	int nents, step, ret;
+	int nents, step, ret = 0;
 
 	if (req->mode == MTD_OPS_RAW)
 		return 0;
-- 
2.39.5



