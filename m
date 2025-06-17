Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F32B2ECE80;
	Tue, 17 Jun 2025 15:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175406; cv=none; b=ny5qHYVSsO5kvz0NpFiYXzCVok+2D4g9ikX2wVOjlw32CvNpck4YM/Lp0ytpdmOYVM1H3E5E7v8eczeuZ27RXf8Vx7/7lm/eiyqiY87jt5zmpFj6Wp8qMG841ToQqFzv0cLgr5HCLgYU+Uj2WPgap91d7AS7rsYE7ZMbl9XlSXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175406; c=relaxed/simple;
	bh=40l6X3GVXdB8jON9QlgvzVWoNUS2oV9gW+FIKT2dIj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BeQXNdNJ+xT73KeQDY2r8EkhdYLbDvUYF2LAopcQ9nw88ZJUk/nWi3fKP5F9rnAuVLeLWPEz0yrth8Nuriw5QFTaAKaRfMpUk4neuGOs1hRb4tVv/q3qFca6D94kflJuK8Be9iGeWXolYuJS9PzbVevWVhdtOR8w8Lx9ZHIoh48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KV0ofUFo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KV0ofUFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4ECC4CEE3;
	Tue, 17 Jun 2025 15:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175406;
	bh=40l6X3GVXdB8jON9QlgvzVWoNUS2oV9gW+FIKT2dIj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KV0ofUFoJPXH92FA86E4u1p0txwh6cLGK2omld/5fnKaK0OmipLzd5N3sGie5PisG
	 pHtD7N1NigIIaDVmz7YpXf6BxRsiDpaTs41kCKkpBh3YKF55CPJWOSSSB/3bXwMZlY
	 /T1QPjLCdniLKhyy8tqQ58p08A4IQmho871iK2fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 085/780] EDAC/bluefield: Dont use bluefield_edac_readl() result on error
Date: Tue, 17 Jun 2025 17:16:33 +0200
Message-ID: <20250617152454.978875659@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit ea3b0b7f541b9511abe2b89547c95458804f38e2 ]

The bluefield_edac_readl() routine returns an uninitialized result on error
paths. In those cases the calling routine should not use the uninitialized
result. The driver should simply log the error, and then return early.

Fixes: e41967575474 ("EDAC/bluefield: Use Arm SMC for EMI access on BlueField-2")
Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Shravan Kumar Ramani <shravankr@nvidia.com>
Link: https://lore.kernel.org/20250318214747.12271-1-davthompson@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/bluefield_edac.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/bluefield_edac.c b/drivers/edac/bluefield_edac.c
index 4942a240c30f2..ae3bb7afa103e 100644
--- a/drivers/edac/bluefield_edac.c
+++ b/drivers/edac/bluefield_edac.c
@@ -199,8 +199,10 @@ static void bluefield_gather_report_ecc(struct mem_ctl_info *mci,
 	 * error without the detailed information.
 	 */
 	err = bluefield_edac_readl(priv, MLXBF_SYNDROM, &dram_syndrom);
-	if (err)
+	if (err) {
 		dev_err(priv->dev, "DRAM syndrom read failed.\n");
+		return;
+	}
 
 	serr = FIELD_GET(MLXBF_SYNDROM__SERR, dram_syndrom);
 	derr = FIELD_GET(MLXBF_SYNDROM__DERR, dram_syndrom);
@@ -213,20 +215,26 @@ static void bluefield_gather_report_ecc(struct mem_ctl_info *mci,
 	}
 
 	err = bluefield_edac_readl(priv, MLXBF_ADD_INFO, &dram_additional_info);
-	if (err)
+	if (err) {
 		dev_err(priv->dev, "DRAM additional info read failed.\n");
+		return;
+	}
 
 	err_prank = FIELD_GET(MLXBF_ADD_INFO__ERR_PRANK, dram_additional_info);
 
 	ecc_dimm = (err_prank >= 2 && priv->dimm_ranks[0] <= 2) ? 1 : 0;
 
 	err = bluefield_edac_readl(priv, MLXBF_ERR_ADDR_0, &edea0);
-	if (err)
+	if (err) {
 		dev_err(priv->dev, "Error addr 0 read failed.\n");
+		return;
+	}
 
 	err = bluefield_edac_readl(priv, MLXBF_ERR_ADDR_1, &edea1);
-	if (err)
+	if (err) {
 		dev_err(priv->dev, "Error addr 1 read failed.\n");
+		return;
+	}
 
 	ecc_dimm_addr = ((u64)edea1 << 32) | edea0;
 
@@ -250,8 +258,10 @@ static void bluefield_edac_check(struct mem_ctl_info *mci)
 		return;
 
 	err = bluefield_edac_readl(priv, MLXBF_ECC_CNT, &ecc_count);
-	if (err)
+	if (err) {
 		dev_err(priv->dev, "ECC count read failed.\n");
+		return;
+	}
 
 	single_error_count = FIELD_GET(MLXBF_ECC_CNT__SERR_CNT, ecc_count);
 	double_error_count = FIELD_GET(MLXBF_ECC_CNT__DERR_CNT, ecc_count);
-- 
2.39.5



