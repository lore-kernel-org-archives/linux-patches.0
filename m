Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27F413DB92;
	Tue, 27 Feb 2024 14:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042751; cv=none; b=pQNBJNPSduBAZDVr69lwGptGfYWlb/q50gTGH8eIhtWVibjJuZJx1Kcviwvyx/kdrBks/gIuymFmDZMSFGDs2yoTpeVeLA7Ixcc8WkzrXaV0e6+/yEI9BSPy6adUq2uRsNtqkQs8YNSJwzE2ageYoSfwaACbgHDbnibrXISlIrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042751; c=relaxed/simple;
	bh=TblqQRu4uBA8YtzkIxxcx8H8ZrKKghcs0vczS/+uvpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPXgDoIysfhaXVxQKYkGMHguqHHozZQOEQy2wLdrZoUgETn/5FQQOmf5oCqcpqrWgjJNbkYOeOV8nyQ7TBlc08LjtfOUjKz+l+5nL8GP+NK5erI2nDTvQwlIEEkHGMxbFv5p6eo6JTcV26kFdpLVBg6+PafLdLWRt130KFPcQKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkc1A+FP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkc1A+FP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0921BC433C7;
	Tue, 27 Feb 2024 14:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042751;
	bh=TblqQRu4uBA8YtzkIxxcx8H8ZrKKghcs0vczS/+uvpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkc1A+FPU7IjuKwfVVB6pJyrHDCCh1cWAyok6CkXIwESOpOqHPKtc8yVifISI/VNc
	 MA5572cFcu7ZvcP9agC5VqT/WMzA0CD+7XfuvViBG1e4zMakbbTQnuWUgzVctMK4oh
	 fSJPlLkxnjdB3JdIeyOc+DwRfVqoADO9Quz4178o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Dhruva Gole <d-gole@ti.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/245] mtd: rawnand: sunxi: Fix the size of the last OOB region
Date: Tue, 27 Feb 2024 14:24:56 +0100
Message-ID: <20240227131618.728355277@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 34569d869532b54d6e360d224a0254dcdd6a1785 ]

The previous code assigned to the wrong structure member.

Fixes: c66811e6d350 ("mtd: nand: sunxi: switch to mtd_ooblayout_ops")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Acked-By: Dhruva Gole <d-gole@ti.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221229181526.53766-6-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index ea953e31933eb..e03dcdd8bd589 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -1609,7 +1609,7 @@ static int sunxi_nand_ooblayout_free(struct mtd_info *mtd, int section,
 	if (section < ecc->steps)
 		oobregion->length = 4;
 	else
-		oobregion->offset = mtd->oobsize - oobregion->offset;
+		oobregion->length = mtd->oobsize - oobregion->offset;
 
 	return 0;
 }
-- 
2.43.0



