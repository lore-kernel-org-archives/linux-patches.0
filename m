Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F95C3D8104;
	Wed, 20 May 2026 17:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296757; cv=none; b=jEkOzo2K3feqFd5G0mOYHx32iLm1ya+QC/YW+F5TQTU8ZmBPfUKpWR3pkRgHJXXwKGunkvLcnymO/mb4IgZi2JKxsW+DandiGfPnVkQLsJ7612+g5USx9USWd69mQrskCqDIEvzgerekM5CMa/2GcKqL5vtM2DKS0gFQ0ptlXoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296757; c=relaxed/simple;
	bh=ChLxA/W9cBQXWNuRydn6KxlHyxnmn+Q385dZp2n9vxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ty9ye3uPMV6YUoXMxYyrC8b5kCVBxbKX1zLb27hWEcuezfTEJf0ErVY/78zGqdoT5g1TnH3dho6aEPO+EAV1OJ84vzLvIz6jZcIV6HpHob3CP/O9CxdbasReVwqPHTOEkY/96TKK8ZHTN23G2MZKllySPi+WK9NBac04Bq73bTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJXZxnVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJXZxnVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BC01F000E9;
	Wed, 20 May 2026 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296756;
	bh=Gq4PHINNAks04CQP5uGH0rpgEQ/9t1ythEANsJ1NR/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BJXZxnVw4uSTkz8syqO6IjblIfjazGh11q56FkXeUIEm7c4mDZHO2oNF2fRv//EK4
	 q5SPAapmP9KZgty7ZqJEqgCMMPxzs2rjvr1LJcS3dpvjUH2PiZgFX6ZLMyHsvCjKh7
	 nUdHcvUhELeW8DKF5wgt0ErB3CuKdw+osJAnhvbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0921/1146] mtd: spinand: winbond: Set the packed page read flag to W35N02/04JW
Date: Wed, 20 May 2026 18:19:31 +0200
Message-ID: <20260520162209.082785838@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 8d655748aba1b603c54053a20322401dc1e5d782 ]

Both W35N02JW and W35N04JW diverge from W35N01JW when it comes to the
"data read" operation in ODTR mode. In order to stuff more address
bits (up to 18), the second command byte is replaced by the most
significant address bits, keeping the number of address bytes to 2.

Fixes: 44a2f49b9bdc ("mtd: spinand: winbond: W35N octal DTR support")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/winbond.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/spi/winbond.c b/drivers/mtd/nand/spi/winbond.c
index ad22774096e61..ea62fecea661d 100644
--- a/drivers/mtd/nand/spi/winbond.c
+++ b/drivers/mtd/nand/spi/winbond.c
@@ -518,7 +518,7 @@ static const struct spinand_info winbond_spinand_table[] = {
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_octal_variants,
 					      &write_cache_octal_variants,
 					      &update_cache_octal_variants),
-		     0,
+		     SPINAND_ODTR_PACKED_PAGE_READ,
 		     SPINAND_INFO_VENDOR_OPS(&winbond_w35_ops),
 		     SPINAND_ECCINFO(&w35n01jw_ooblayout, NULL),
 		     SPINAND_CONFIGURE_CHIP(w35n0xjw_vcr_cfg)),
@@ -529,7 +529,7 @@ static const struct spinand_info winbond_spinand_table[] = {
 		     SPINAND_INFO_OP_VARIANTS(&read_cache_octal_variants,
 					      &write_cache_octal_variants,
 					      &update_cache_octal_variants),
-		     0,
+		     SPINAND_ODTR_PACKED_PAGE_READ,
 		     SPINAND_INFO_VENDOR_OPS(&winbond_w35_ops),
 		     SPINAND_ECCINFO(&w35n01jw_ooblayout, NULL),
 		     SPINAND_CONFIGURE_CHIP(w35n0xjw_vcr_cfg)),
-- 
2.53.0



