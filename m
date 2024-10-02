Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFAB1D0787;
	Wed,  2 Oct 2024 13:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876442; cv=none; b=KGIICOWuF9WHh5/WNVQzc6ZUd+VEtokaOrSr0rrvO/qnzlA5qIAVzAnP0k5sw0v4/bFpwn/AGxpInBP0p8peGNdHTQldHTa8Gz8xJSeKVW+XHPc9/CAAUv6ptQrt65DUGaW4uD3yOJoQ2RpW8ZKvChIFm4rAJTvSqxyTiwNo6HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876442; c=relaxed/simple;
	bh=vC5vfwY0GNW0FZ0JVUMVMIHBeJKLi0gsi9CmaiNHl3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHdeq4Dq+AIB9Q33pr31wfQPr0FAgCePIFv2WAJT3DY20X12N8ias/HhvDJKQd3O3cd5TG7asx8En0UGO5NnzKW89DcZT+XKT+glXsYSzZIohPsAi0bqtr0ox7gKN9pgeWGg5SplWQFvn+buCAwFeaomAaPE3HHMMcIaIZGUznk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phNyPyoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phNyPyoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A936FC4CECD;
	Wed,  2 Oct 2024 13:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876442;
	bh=vC5vfwY0GNW0FZ0JVUMVMIHBeJKLi0gsi9CmaiNHl3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phNyPyoKbewdUhvds9Vs6gLACB229QyleRUoFqHY1k4NkOc5Drdm7YhTR6l8n071h
	 xHTfXh11iu6JCBtfUn3PxDAuXAHtWiZmiLyHr6i1+eNBTfZfWlfTgBal8y2FP/UC9R
	 dPtIrYS1INrLTefX1vVQWkvrXHnHc7UY4DZ7febk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 445/695] spi: airoha: fix dirmap_{read,write} operations
Date: Wed,  2 Oct 2024 14:57:23 +0200
Message-ID: <20241002125840.218661510@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 2e6bbfe7b0c0607001b784082c2685b134174fac ]

SPI_NFI_READ_FROM_CACHE_DONE bit must be written at the end of
dirmap_read operation even if it is already set.
In the same way, SPI_NFI_LOAD_TO_CACHE_DONE bit must be written at the
end of dirmap_write operation even if it is already set.
For this reason use regmap_write_bits() instead of regmap_set_bits().
This patch fixes mtd_pagetest kernel module test.

Fixes: a403997c1201 ("spi: airoha: add SPI-NAND Flash controller driver")
Tested-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20240913-airoha-spi-fixes-v1-1-de2e74ed4664@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-airoha-snfi.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-airoha-snfi.c b/drivers/spi/spi-airoha-snfi.c
index 9d97ec98881cc..be3e4ac42153e 100644
--- a/drivers/spi/spi-airoha-snfi.c
+++ b/drivers/spi/spi-airoha-snfi.c
@@ -739,8 +739,13 @@ static ssize_t airoha_snand_dirmap_read(struct spi_mem_dirmap_desc *desc,
 	if (err)
 		return err;
 
-	err = regmap_set_bits(as_ctrl->regmap_nfi, REG_SPI_NFI_SNF_STA_CTL1,
-			      SPI_NFI_READ_FROM_CACHE_DONE);
+	/*
+	 * SPI_NFI_READ_FROM_CACHE_DONE bit must be written at the end
+	 * of dirmap_read operation even if it is already set.
+	 */
+	err = regmap_write_bits(as_ctrl->regmap_nfi, REG_SPI_NFI_SNF_STA_CTL1,
+				SPI_NFI_READ_FROM_CACHE_DONE,
+				SPI_NFI_READ_FROM_CACHE_DONE);
 	if (err)
 		return err;
 
@@ -870,8 +875,13 @@ static ssize_t airoha_snand_dirmap_write(struct spi_mem_dirmap_desc *desc,
 	if (err)
 		return err;
 
-	err = regmap_set_bits(as_ctrl->regmap_nfi, REG_SPI_NFI_SNF_STA_CTL1,
-			      SPI_NFI_LOAD_TO_CACHE_DONE);
+	/*
+	 * SPI_NFI_LOAD_TO_CACHE_DONE bit must be written at the end
+	 * of dirmap_write operation even if it is already set.
+	 */
+	err = regmap_write_bits(as_ctrl->regmap_nfi, REG_SPI_NFI_SNF_STA_CTL1,
+				SPI_NFI_LOAD_TO_CACHE_DONE,
+				SPI_NFI_LOAD_TO_CACHE_DONE);
 	if (err)
 		return err;
 
-- 
2.43.0



