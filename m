Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2917D47D94D;
	Thu, 20 Aug 2026 16:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244364; cv=none; b=l26J73kA9CTxOBOetTRKKg2TD4zndO/xZpzJYpu1fxF73tqpb4QRKsSVco0lrjmpqdXRwQGBjyVrvlKqqUxMhC6HLllQF7j2A+LNed0Nl1M6d+jjjHOPxveAoFSWXUNk+3RELIv5SLo1fp52vovazSWs0RSiW9hFb+/uFxU5kRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244364; c=relaxed/simple;
	bh=nqyCZ70SzjDBB3e07vTdok5i0zDPH1st3ekuiqwsSRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ab7lWq8ncw8Afj0aQXBAX/IEYnq1EOJ1Fi3xsKB7KChPZLpRCizMdrouZMjGgf4Zy2h6T+uwYXdX+9s6tickE6HMjTXgvpR/PSkMyDTif8zhbV1NCFYZ38ip02oGz+C6by36vXeTmOj83fi0rC/rwVItpjYhhGOUtgULOXvSa0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrnSzwHb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrnSzwHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D541F000E9;
	Thu, 20 Aug 2026 16:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244363;
	bh=hFmJkkFdlJJ9eTO4K/jtY3btYEq+8sS8zq7psHQZ0S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrnSzwHb+Rtl/Xp47a7rDY3xDiT8QfOdI3PMYOgA6rL8lLQKdzYM8hpCM8PRW+BMP
	 IS7JBd9UVwam5QeIYTbcXQW6cTljd0rVM6G4rbFlbHrh/M9mtk79RwAXL9Zzzqa4ab
	 +laZ8rzG9EcYDvi7sC1V0NoWvGds+liO+DIA0Pjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Marc Ranger <jmranger@hotmail.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/235] mtd: spi-nor: Fix spi_nor_try_unlock_all()
Date: Thu, 20 Aug 2026 16:55:30 +0200
Message-ID: <20260820145219.308645096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 2e3a7476ec3989e77270b9481e76e137824b17c0 ]

Commit ff67592cbdfc ("mtd: spi-nor: Introduce spi_nor_set_mtd_info()")
moved all initialization of the mtd fields at the end of spi_nor_scan().
Normally, the mtd info is only needed for the mtd ops on the device,
with one exception: spi_nor_try_unlock_all(), which will also make use
of the mtd->size parameter. With that commit, the size will always be
zero because it is not initialized. Fix that by not using the size of
the mtd_info struct, but use the size from struct spi_nor_flash_parameter.

Fixes: ff67592cbdfc ("mtd: spi-nor: Introduce spi_nor_set_mtd_info()")
Cc: stable@vger.kernel.org
Reported-by: Jean-Marc Ranger <jmranger@hotmail.com>
Closes: https://lore.kernel.org/all/DM6PR06MB561177323DC5207E34AF2A06C547A@DM6PR06MB5611.namprd06.prod.outlook.com/
Tested-by: Jean-Marc Ranger <jmranger@hotmail.com>
Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Link: https://lore.kernel.org/r/20250701140426.2355182-1-mwalle@kernel.org
Stable-dep-of: e1d456b26bf2 ("mtd: spi-nor: swp: Improve locking user experience")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/swp.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/mtd/spi-nor/swp.c
+++ b/drivers/mtd/spi-nor/swp.c
@@ -50,7 +50,6 @@ static u64 spi_nor_get_min_prot_length_s
 static void spi_nor_get_locked_range_sr(struct spi_nor *nor, u8 sr, loff_t *ofs,
 					uint64_t *len)
 {
-	struct mtd_info *mtd = &nor->mtd;
 	u64 min_prot_len;
 	u8 mask = spi_nor_get_sr_bp_mask(nor);
 	u8 tb_mask = spi_nor_get_sr_tb_mask(nor);
@@ -71,13 +70,13 @@ static void spi_nor_get_locked_range_sr(
 	min_prot_len = spi_nor_get_min_prot_length_sr(nor);
 	*len = min_prot_len << (bp - 1);
 
-	if (*len > mtd->size)
-		*len = mtd->size;
+	if (*len > nor->params->size)
+		*len = nor->params->size;
 
 	if (nor->flags & SNOR_F_HAS_SR_TB && sr & tb_mask)
 		*ofs = 0;
 	else
-		*ofs = mtd->size - *len;
+		*ofs = nor->params->size - *len;
 }
 
 /*
@@ -150,7 +149,6 @@ static int spi_nor_is_unlocked_sr(struct
  */
 static int spi_nor_sr_lock(struct spi_nor *nor, loff_t ofs, uint64_t len)
 {
-	struct mtd_info *mtd = &nor->mtd;
 	u64 min_prot_len;
 	int ret, status_old, status_new;
 	u8 mask = spi_nor_get_sr_bp_mask(nor);
@@ -175,7 +173,7 @@ static int spi_nor_sr_lock(struct spi_no
 		can_be_bottom = false;
 
 	/* If anything above us is unlocked, we can't use 'top' protection */
-	if (!spi_nor_is_locked_sr(nor, ofs + len, mtd->size - (ofs + len),
+	if (!spi_nor_is_locked_sr(nor, ofs + len, nor->params->size - (ofs + len),
 				  status_old))
 		can_be_top = false;
 
@@ -187,11 +185,11 @@ static int spi_nor_sr_lock(struct spi_no
 
 	/* lock_len: length of region that should end up locked */
 	if (use_top)
-		lock_len = mtd->size - ofs;
+		lock_len = nor->params->size - ofs;
 	else
 		lock_len = ofs + len;
 
-	if (lock_len == mtd->size) {
+	if (lock_len == nor->params->size) {
 		val = mask;
 	} else {
 		min_prot_len = spi_nor_get_min_prot_length_sr(nor);


