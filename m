Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624C61D1F4C;
	Wed,  2 Oct 2024 14:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878511; cv=none; b=gDoZykf73obzoHAwnoWGiGmjv1o7LnTlRDHppFCLohs/UI3dH845WyIJ+0T8OUpRcYTrUV5Lq1V78qNZyQTz1bA1I5QaDYi+8tqcHdAhAYGnnJo/gD1uSPVE5BoSHdRcwOAxzGsM9INDWLw4mw19e8Rr7P1/gdAbVX9886VyS7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878511; c=relaxed/simple;
	bh=NQbJTZBTKNTTv/7t3bfk8Firio3m9GtAkr8jRWu433k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7Ri7nGPeWw4ReEVXVAi7QCfwXSHpVc/cuCHKLGDkIbrNf1dtFqmrjv7t/ARLOshP7tS9emtO/GHMESdHcq6nA8Nyuu5BfzJKpl5U7tgmmzd3vUEIFvbt1vo2RXaT6WUk0VbR3ocXGDCJUkXBZMWsSd52ECuq3i7I5baVX1dLU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2txCbMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2txCbMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7639C4CECD;
	Wed,  2 Oct 2024 14:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878511;
	bh=NQbJTZBTKNTTv/7t3bfk8Firio3m9GtAkr8jRWu433k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2txCbMIW650EDRscQFx+YHgS1HKWc96+NjiXOpUx7AuBGwpY+x2OjzS4yGGovcRM
	 Fxn0bB/1z7njrLNFFzgobZ3ui8D9EpFstFsoPOORMycN3R/hB2zoap1hP8FDAUzm9t
	 ke+rihbmJ+Sy67qomjdx6sUaAKz5urP9HQTZ+R2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 407/634] spi: airoha: fix dirmap_{read,write} operations
Date: Wed,  2 Oct 2024 14:58:27 +0200
Message-ID: <20241002125827.174053501@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



