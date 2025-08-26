Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74C02FD7DE;
	Tue, 26 Aug 2025 11:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208330; cv=none; b=DYmfbbE8Yfk02llPL6EuhQ3YJP1Wgg6gfeF3ZrK3nlyjzMiCI6Tzz2Vwg8Y9Hu3Facvk99p6Zc7KCE2VqSL2+IvZz9anEhkjeX170cIrY2MvHQI7Bp1xKrKFbbSduczsHG6ahhYSzYSyadexn79oOF2cuWevYFxnmUL63ikme1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208330; c=relaxed/simple;
	bh=8JziwOh8CYddnn72lQjpyqSc+d3P4OC3FNylS92c87o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GB5J4wLXBZLIjurcRYejd8AaWTFEttYV/e0G2h6T3wrk6cnMAg9heg6l+76gy0yLXEhwMyPs8VlkKkk9tX/GpK9XPiONVyJ0iQU/DgzMugy5xoUGtZ8OHAUcKjdDHYUpD51GhJQPP8O9HRDDv7qpOgwAkuBcyxegcS8KtMXMskw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsfqjayy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsfqjayy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3926CC4CEF1;
	Tue, 26 Aug 2025 11:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208330;
	bh=8JziwOh8CYddnn72lQjpyqSc+d3P4OC3FNylS92c87o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsfqjayyAfMTAhWHtOGYvkzuWqMCgqCzsZQ/K03nT47/ZHAdp8Y3+HAIFonJEtagq
	 hH0kBeJKakgI6g53/ODiktHDDo+9Sor3lrygmeDkj0PEfFVYhFpxhUpkaaZ3VibE5m
	 D316T6/Z2AVs2Tfaoxb8Ko+/ZL2mHae92IleXl1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Marc Ranger <jmranger@hotmail.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.12 069/322] mtd: spi-nor: Fix spi_nor_try_unlock_all()
Date: Tue, 26 Aug 2025 13:08:04 +0200
Message-ID: <20250826110917.279596537@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

commit 2e3a7476ec3989e77270b9481e76e137824b17c0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/swp.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/mtd/spi-nor/swp.c
+++ b/drivers/mtd/spi-nor/swp.c
@@ -55,7 +55,6 @@ static u64 spi_nor_get_min_prot_length_s
 static void spi_nor_get_locked_range_sr(struct spi_nor *nor, u8 sr, loff_t *ofs,
 					u64 *len)
 {
-	struct mtd_info *mtd = &nor->mtd;
 	u64 min_prot_len;
 	u8 mask = spi_nor_get_sr_bp_mask(nor);
 	u8 tb_mask = spi_nor_get_sr_tb_mask(nor);
@@ -76,13 +75,13 @@ static void spi_nor_get_locked_range_sr(
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
@@ -157,7 +156,6 @@ static bool spi_nor_is_unlocked_sr(struc
  */
 static int spi_nor_sr_lock(struct spi_nor *nor, loff_t ofs, u64 len)
 {
-	struct mtd_info *mtd = &nor->mtd;
 	u64 min_prot_len;
 	int ret, status_old, status_new;
 	u8 mask = spi_nor_get_sr_bp_mask(nor);
@@ -182,7 +180,7 @@ static int spi_nor_sr_lock(struct spi_no
 		can_be_bottom = false;
 
 	/* If anything above us is unlocked, we can't use 'top' protection */
-	if (!spi_nor_is_locked_sr(nor, ofs + len, mtd->size - (ofs + len),
+	if (!spi_nor_is_locked_sr(nor, ofs + len, nor->params->size - (ofs + len),
 				  status_old))
 		can_be_top = false;
 
@@ -194,11 +192,11 @@ static int spi_nor_sr_lock(struct spi_no
 
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
@@ -247,7 +245,6 @@ static int spi_nor_sr_lock(struct spi_no
  */
 static int spi_nor_sr_unlock(struct spi_nor *nor, loff_t ofs, u64 len)
 {
-	struct mtd_info *mtd = &nor->mtd;
 	u64 min_prot_len;
 	int ret, status_old, status_new;
 	u8 mask = spi_nor_get_sr_bp_mask(nor);
@@ -272,7 +269,7 @@ static int spi_nor_sr_unlock(struct spi_
 		can_be_top = false;
 
 	/* If anything above us is locked, we can't use 'bottom' protection */
-	if (!spi_nor_is_unlocked_sr(nor, ofs + len, mtd->size - (ofs + len),
+	if (!spi_nor_is_unlocked_sr(nor, ofs + len, nor->params->size - (ofs + len),
 				    status_old))
 		can_be_bottom = false;
 
@@ -284,7 +281,7 @@ static int spi_nor_sr_unlock(struct spi_
 
 	/* lock_len: length of region that should remain locked */
 	if (use_top)
-		lock_len = mtd->size - (ofs + len);
+		lock_len = nor->params->size - (ofs + len);
 	else
 		lock_len = ofs;
 


