Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85E447CC97;
	Thu, 20 Aug 2026 16:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244228; cv=none; b=laKs2i3ZlqXJJTs+ROrMpg0wnTQwOm1afh+iFSwP/ZfcAleagU1WSb3TTitOGXZ1DKiwaVxn+pObeyUel6kSe+QNqU1VtZHX2+cxk6D4frpOQz7VfkzBK2zqQln9ph3tju9AGdg6WodMB1GjSfjJ/hYkRyD4BBwobnYRSwmleoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244228; c=relaxed/simple;
	bh=3II8YewloEe0+ZM+rjbuwnqoFcsKVC9UVRXMKHKcDjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSvWA+ak+S8AgCc0VRosXnbsZeIBifatSd6AY+HjazTdrj0qnyc3y2syVhqwLntzrSVCudwgGR4xDOkksSlGz5r6ZPZBrl7VZGJxGV4WoN9uEOldWhAdErRwXeiiv/2w1VjVGvTyr9PS6XlIn/TJ+rK/ONMDUBosZ0oFm6QdCBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqfiEJJw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqfiEJJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009071F000E9;
	Thu, 20 Aug 2026 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244225;
	bh=KxsXS/+xIp5MrF0/w5m3p1cM4oq62gdvDifFcJhiitY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqfiEJJw4ZYInh5mi12VdefjFA1vjmK9t4DVai3WnhlfzbTBKN6c/Gv9/ON99ftIS
	 bXxf/6mf8Y+bTLm8+DdflToK1nkRGuRQnKyHKX+2+O7zqlRMFwxSb8xCPh0knbc6Nu
	 oy/4cgAJGEzM5Aqb3hi5qkFP6FpFAp1B4aE0y1GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Michael Walle <michael@walle.cc>,
	Pratyush Yadav <p.yadav@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/235] mtd: spi-nor: Move Software Write Protection logic out of the core
Date: Thu, 20 Aug 2026 16:55:29 +0200
Message-ID: <20260820145219.276412934@linuxfoundation.org>
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

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit c4c795105f2924c80752c30ffd3c7029a8e0ef28 ]

It makes the core file a bit smaller and provides better separation
between the Software Write Protection features and the core logic.
All the next generic software write protection features (e.g. Individual
Block Protection) will reside in swp.c.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Reviewed-by: Michael Walle <michael@walle.cc>
Acked-by: Pratyush Yadav <p.yadav@ti.com>
Link: https://lore.kernel.org/r/20210322075131.45093-2-tudor.ambarus@microchip.com
Stable-dep-of: e1d456b26bf2 ("mtd: spi-nor: swp: Improve locking user experience")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/Makefile |    2 
 drivers/mtd/spi-nor/core.c   |  406 -----------------------------------------
 drivers/mtd/spi-nor/core.h   |    5 
 drivers/mtd/spi-nor/swp.c    |  421 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 431 insertions(+), 403 deletions(-)
 create mode 100644 drivers/mtd/spi-nor/swp.c

--- a/drivers/mtd/spi-nor/Makefile
+++ b/drivers/mtd/spi-nor/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-spi-nor-objs			:= core.o sfdp.o
+spi-nor-objs			:= core.o sfdp.o swp.o
 spi-nor-objs			+= atmel.o
 spi-nor-objs			+= catalyst.o
 spi-nor-objs			+= eon.o
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -276,7 +276,7 @@ int spi_nor_write_disable(struct spi_nor
  *
  * Return: 0 on success, -errno otherwise.
  */
-static int spi_nor_read_sr(struct spi_nor *nor, u8 *sr)
+int spi_nor_read_sr(struct spi_nor *nor, u8 *sr)
 {
 	int ret;
 
@@ -1550,376 +1550,6 @@ erase_err:
 	return ret;
 }
 
-static u8 spi_nor_get_sr_bp_mask(struct spi_nor *nor)
-{
-	u8 mask = SR_BP2 | SR_BP1 | SR_BP0;
-
-	if (nor->flags & SNOR_F_HAS_SR_BP3_BIT6)
-		return mask | SR_BP3_BIT6;
-
-	if (nor->flags & SNOR_F_HAS_4BIT_BP)
-		return mask | SR_BP3;
-
-	return mask;
-}
-
-static u8 spi_nor_get_sr_tb_mask(struct spi_nor *nor)
-{
-	if (nor->flags & SNOR_F_HAS_SR_TB_BIT6)
-		return SR_TB_BIT6;
-	else
-		return SR_TB_BIT5;
-}
-
-static u64 spi_nor_get_min_prot_length_sr(struct spi_nor *nor)
-{
-	unsigned int bp_slots, bp_slots_needed;
-	u8 mask = spi_nor_get_sr_bp_mask(nor);
-
-	/* Reserved one for "protect none" and one for "protect all". */
-	bp_slots = (1 << hweight8(mask)) - 2;
-	bp_slots_needed = ilog2(nor->info->n_sectors);
-
-	if (bp_slots_needed > bp_slots)
-		return nor->info->sector_size <<
-			(bp_slots_needed - bp_slots);
-	else
-		return nor->info->sector_size;
-}
-
-static void spi_nor_get_locked_range_sr(struct spi_nor *nor, u8 sr, loff_t *ofs,
-					uint64_t *len)
-{
-	struct mtd_info *mtd = &nor->mtd;
-	u64 min_prot_len;
-	u8 mask = spi_nor_get_sr_bp_mask(nor);
-	u8 tb_mask = spi_nor_get_sr_tb_mask(nor);
-	u8 bp, val = sr & mask;
-
-	if (nor->flags & SNOR_F_HAS_SR_BP3_BIT6 && val & SR_BP3_BIT6)
-		val = (val & ~SR_BP3_BIT6) | SR_BP3;
-
-	bp = val >> SR_BP_SHIFT;
-
-	if (!bp) {
-		/* No protection */
-		*ofs = 0;
-		*len = 0;
-		return;
-	}
-
-	min_prot_len = spi_nor_get_min_prot_length_sr(nor);
-	*len = min_prot_len << (bp - 1);
-
-	if (*len > mtd->size)
-		*len = mtd->size;
-
-	if (nor->flags & SNOR_F_HAS_SR_TB && sr & tb_mask)
-		*ofs = 0;
-	else
-		*ofs = mtd->size - *len;
-}
-
-/*
- * Return 1 if the entire region is locked (if @locked is true) or unlocked (if
- * @locked is false); 0 otherwise
- */
-static int spi_nor_check_lock_status_sr(struct spi_nor *nor, loff_t ofs,
-					uint64_t len, u8 sr, bool locked)
-{
-	loff_t lock_offs;
-	uint64_t lock_len;
-
-	if (!len)
-		return 1;
-
-	spi_nor_get_locked_range_sr(nor, sr, &lock_offs, &lock_len);
-
-	if (locked)
-		/* Requested range is a sub-range of locked range */
-		return (ofs + len <= lock_offs + lock_len) && (ofs >= lock_offs);
-	else
-		/* Requested range does not overlap with locked range */
-		return (ofs >= lock_offs + lock_len) || (ofs + len <= lock_offs);
-}
-
-static int spi_nor_is_locked_sr(struct spi_nor *nor, loff_t ofs, uint64_t len,
-				u8 sr)
-{
-	return spi_nor_check_lock_status_sr(nor, ofs, len, sr, true);
-}
-
-static int spi_nor_is_unlocked_sr(struct spi_nor *nor, loff_t ofs, uint64_t len,
-				  u8 sr)
-{
-	return spi_nor_check_lock_status_sr(nor, ofs, len, sr, false);
-}
-
-/*
- * Lock a region of the flash. Compatible with ST Micro and similar flash.
- * Supports the block protection bits BP{0,1,2}/BP{0,1,2,3} in the status
- * register
- * (SR). Does not support these features found in newer SR bitfields:
- *   - SEC: sector/block protect - only handle SEC=0 (block protect)
- *   - CMP: complement protect - only support CMP=0 (range is not complemented)
- *
- * Support for the following is provided conditionally for some flash:
- *   - TB: top/bottom protect
- *
- * Sample table portion for 8MB flash (Winbond w25q64fw):
- *
- *   SEC  |  TB   |  BP2  |  BP1  |  BP0  |  Prot Length  | Protected Portion
- *  --------------------------------------------------------------------------
- *    X   |   X   |   0   |   0   |   0   |  NONE         | NONE
- *    0   |   0   |   0   |   0   |   1   |  128 KB       | Upper 1/64
- *    0   |   0   |   0   |   1   |   0   |  256 KB       | Upper 1/32
- *    0   |   0   |   0   |   1   |   1   |  512 KB       | Upper 1/16
- *    0   |   0   |   1   |   0   |   0   |  1 MB         | Upper 1/8
- *    0   |   0   |   1   |   0   |   1   |  2 MB         | Upper 1/4
- *    0   |   0   |   1   |   1   |   0   |  4 MB         | Upper 1/2
- *    X   |   X   |   1   |   1   |   1   |  8 MB         | ALL
- *  ------|-------|-------|-------|-------|---------------|-------------------
- *    0   |   1   |   0   |   0   |   1   |  128 KB       | Lower 1/64
- *    0   |   1   |   0   |   1   |   0   |  256 KB       | Lower 1/32
- *    0   |   1   |   0   |   1   |   1   |  512 KB       | Lower 1/16
- *    0   |   1   |   1   |   0   |   0   |  1 MB         | Lower 1/8
- *    0   |   1   |   1   |   0   |   1   |  2 MB         | Lower 1/4
- *    0   |   1   |   1   |   1   |   0   |  4 MB         | Lower 1/2
- *
- * Returns negative on errors, 0 on success.
- */
-static int spi_nor_sr_lock(struct spi_nor *nor, loff_t ofs, uint64_t len)
-{
-	struct mtd_info *mtd = &nor->mtd;
-	u64 min_prot_len;
-	int ret, status_old, status_new;
-	u8 mask = spi_nor_get_sr_bp_mask(nor);
-	u8 tb_mask = spi_nor_get_sr_tb_mask(nor);
-	u8 pow, val;
-	loff_t lock_len;
-	bool can_be_top = true, can_be_bottom = nor->flags & SNOR_F_HAS_SR_TB;
-	bool use_top;
-
-	ret = spi_nor_read_sr(nor, nor->bouncebuf);
-	if (ret)
-		return ret;
-
-	status_old = nor->bouncebuf[0];
-
-	/* If nothing in our range is unlocked, we don't need to do anything */
-	if (spi_nor_is_locked_sr(nor, ofs, len, status_old))
-		return 0;
-
-	/* If anything below us is unlocked, we can't use 'bottom' protection */
-	if (!spi_nor_is_locked_sr(nor, 0, ofs, status_old))
-		can_be_bottom = false;
-
-	/* If anything above us is unlocked, we can't use 'top' protection */
-	if (!spi_nor_is_locked_sr(nor, ofs + len, mtd->size - (ofs + len),
-				  status_old))
-		can_be_top = false;
-
-	if (!can_be_bottom && !can_be_top)
-		return -EINVAL;
-
-	/* Prefer top, if both are valid */
-	use_top = can_be_top;
-
-	/* lock_len: length of region that should end up locked */
-	if (use_top)
-		lock_len = mtd->size - ofs;
-	else
-		lock_len = ofs + len;
-
-	if (lock_len == mtd->size) {
-		val = mask;
-	} else {
-		min_prot_len = spi_nor_get_min_prot_length_sr(nor);
-		pow = ilog2(lock_len) - ilog2(min_prot_len) + 1;
-		val = pow << SR_BP_SHIFT;
-
-		if (nor->flags & SNOR_F_HAS_SR_BP3_BIT6 && val & SR_BP3)
-			val = (val & ~SR_BP3) | SR_BP3_BIT6;
-
-		if (val & ~mask)
-			return -EINVAL;
-
-		/* Don't "lock" with no region! */
-		if (!(val & mask))
-			return -EINVAL;
-	}
-
-	status_new = (status_old & ~mask & ~tb_mask) | val;
-
-	/* Disallow further writes if WP pin is asserted */
-	status_new |= SR_SRWD;
-
-	if (!use_top)
-		status_new |= tb_mask;
-
-	/* Don't bother if they're the same */
-	if (status_new == status_old)
-		return 0;
-
-	/* Only modify protection if it will not unlock other areas */
-	if ((status_new & mask) < (status_old & mask))
-		return -EINVAL;
-
-	return spi_nor_write_sr_and_check(nor, status_new);
-}
-
-/*
- * Unlock a region of the flash. See spi_nor_sr_lock() for more info
- *
- * Returns negative on errors, 0 on success.
- */
-static int spi_nor_sr_unlock(struct spi_nor *nor, loff_t ofs, uint64_t len)
-{
-	struct mtd_info *mtd = &nor->mtd;
-	u64 min_prot_len;
-	int ret, status_old, status_new;
-	u8 mask = spi_nor_get_sr_bp_mask(nor);
-	u8 tb_mask = spi_nor_get_sr_tb_mask(nor);
-	u8 pow, val;
-	loff_t lock_len;
-	bool can_be_top = true, can_be_bottom = nor->flags & SNOR_F_HAS_SR_TB;
-	bool use_top;
-
-	ret = spi_nor_read_sr(nor, nor->bouncebuf);
-	if (ret)
-		return ret;
-
-	status_old = nor->bouncebuf[0];
-
-	/* If nothing in our range is locked, we don't need to do anything */
-	if (spi_nor_is_unlocked_sr(nor, ofs, len, status_old))
-		return 0;
-
-	/* If anything below us is locked, we can't use 'top' protection */
-	if (!spi_nor_is_unlocked_sr(nor, 0, ofs, status_old))
-		can_be_top = false;
-
-	/* If anything above us is locked, we can't use 'bottom' protection */
-	if (!spi_nor_is_unlocked_sr(nor, ofs + len, mtd->size - (ofs + len),
-				    status_old))
-		can_be_bottom = false;
-
-	if (!can_be_bottom && !can_be_top)
-		return -EINVAL;
-
-	/* Prefer top, if both are valid */
-	use_top = can_be_top;
-
-	/* lock_len: length of region that should remain locked */
-	if (use_top)
-		lock_len = mtd->size - (ofs + len);
-	else
-		lock_len = ofs;
-
-	if (lock_len == 0) {
-		val = 0; /* fully unlocked */
-	} else {
-		min_prot_len = spi_nor_get_min_prot_length_sr(nor);
-		pow = ilog2(lock_len) - ilog2(min_prot_len) + 1;
-		val = pow << SR_BP_SHIFT;
-
-		if (nor->flags & SNOR_F_HAS_SR_BP3_BIT6 && val & SR_BP3)
-			val = (val & ~SR_BP3) | SR_BP3_BIT6;
-
-		/* Some power-of-two sizes are not supported */
-		if (val & ~mask)
-			return -EINVAL;
-	}
-
-	status_new = (status_old & ~mask & ~tb_mask) | val;
-
-	/* Don't protect status register if we're fully unlocked */
-	if (lock_len == 0)
-		status_new &= ~SR_SRWD;
-
-	if (!use_top)
-		status_new |= tb_mask;
-
-	/* Don't bother if they're the same */
-	if (status_new == status_old)
-		return 0;
-
-	/* Only modify protection if it will not lock other areas */
-	if ((status_new & mask) > (status_old & mask))
-		return -EINVAL;
-
-	return spi_nor_write_sr_and_check(nor, status_new);
-}
-
-/*
- * Check if a region of the flash is (completely) locked. See spi_nor_sr_lock()
- * for more info.
- *
- * Returns 1 if entire region is locked, 0 if any portion is unlocked, and
- * negative on errors.
- */
-static int spi_nor_sr_is_locked(struct spi_nor *nor, loff_t ofs, uint64_t len)
-{
-	int ret;
-
-	ret = spi_nor_read_sr(nor, nor->bouncebuf);
-	if (ret)
-		return ret;
-
-	return spi_nor_is_locked_sr(nor, ofs, len, nor->bouncebuf[0]);
-}
-
-static const struct spi_nor_locking_ops spi_nor_sr_locking_ops = {
-	.lock = spi_nor_sr_lock,
-	.unlock = spi_nor_sr_unlock,
-	.is_locked = spi_nor_sr_is_locked,
-};
-
-static int spi_nor_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
-{
-	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	int ret;
-
-	ret = spi_nor_lock_and_prep(nor);
-	if (ret)
-		return ret;
-
-	ret = nor->params->locking_ops->lock(nor, ofs, len);
-
-	spi_nor_unlock_and_unprep(nor);
-	return ret;
-}
-
-static int spi_nor_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
-{
-	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	int ret;
-
-	ret = spi_nor_lock_and_prep(nor);
-	if (ret)
-		return ret;
-
-	ret = nor->params->locking_ops->unlock(nor, ofs, len);
-
-	spi_nor_unlock_and_unprep(nor);
-	return ret;
-}
-
-static int spi_nor_is_locked(struct mtd_info *mtd, loff_t ofs, uint64_t len)
-{
-	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	int ret;
-
-	ret = spi_nor_lock_and_prep(nor);
-	if (ret)
-		return ret;
-
-	ret = nor->params->locking_ops->is_locked(nor, ofs, len);
-
-	spi_nor_unlock_and_unprep(nor);
-	return ret;
-}
-
 /**
  * spi_nor_sr1_bit6_quad_enable() - Set the Quad Enable BIT(6) in the Status
  * Register 1.
@@ -2858,7 +2488,7 @@ static void spi_nor_late_init_params(str
 	 * the default ones.
 	 */
 	if (nor->flags & SNOR_F_HAS_LOCK && !nor->params->locking_ops)
-		nor->params->locking_ops = &spi_nor_sr_locking_ops;
+		spi_nor_init_default_locking_ops(nor);
 }
 
 /**
@@ -2937,30 +2567,6 @@ static int spi_nor_quad_enable(struct sp
 	return nor->params->quad_enable(nor);
 }
 
-/**
- * spi_nor_try_unlock_all() - Tries to unlock the entire flash memory array.
- * @nor:	pointer to a 'struct spi_nor'.
- *
- * Some SPI NOR flashes are write protected by default after a power-on reset
- * cycle, in order to avoid inadvertent writes during power-up. Backward
- * compatibility imposes to unlock the entire flash memory array at power-up
- * by default.
- *
- * Unprotecting the entire flash array will fail for boards which are hardware
- * write-protected. Thus any errors are ignored.
- */
-static void spi_nor_try_unlock_all(struct spi_nor *nor)
-{
-	int ret;
-
-	if (!(nor->flags & SNOR_F_HAS_LOCK))
-		return;
-
-	ret = spi_nor_unlock(&nor->mtd, 0, nor->params->size);
-	if (ret)
-		dev_dbg(nor->dev, "Failed to unlock the entire flash memory array\n");
-}
-
 static int spi_nor_init(struct spi_nor *nor)
 {
 	int err;
@@ -3212,12 +2818,6 @@ int spi_nor_scan(struct spi_nor *nor, co
 	mtd->_get_device = spi_nor_get_device;
 	mtd->_put_device = spi_nor_put_device;
 
-	if (nor->params->locking_ops) {
-		mtd->_lock = spi_nor_lock;
-		mtd->_unlock = spi_nor_unlock;
-		mtd->_is_locked = spi_nor_is_locked;
-	}
-
 	if (info->flags & USE_FSR)
 		nor->flags |= SNOR_F_USE_FSR;
 	if (info->flags & SPI_NOR_HAS_TB) {
@@ -3264,6 +2864,8 @@ int spi_nor_scan(struct spi_nor *nor, co
 	if (ret)
 		return ret;
 
+	spi_nor_register_locking_ops(nor);
+
 	/* Send all the required SPI flash commands to initialize device */
 	ret = spi_nor_init(nor);
 	if (ret)
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -409,6 +409,7 @@ void spi_nor_unlock_and_unprep(struct sp
 int spi_nor_sr1_bit6_quad_enable(struct spi_nor *nor);
 int spi_nor_sr2_bit1_quad_enable(struct spi_nor *nor);
 int spi_nor_sr2_bit7_quad_enable(struct spi_nor *nor);
+int spi_nor_read_sr(struct spi_nor *nor, u8 *sr);
 int spi_nor_write_sr_and_check(struct spi_nor *nor, u8 sr1);
 
 int spi_nor_xread_sr(struct spi_nor *nor, u8 *sr);
@@ -435,6 +436,10 @@ int spi_nor_post_bfpt_fixups(struct spi_
 			     const struct sfdp_bfpt *bfpt,
 			     struct spi_nor_flash_parameter *params);
 
+void spi_nor_init_default_locking_ops(struct spi_nor *nor);
+void spi_nor_try_unlock_all(struct spi_nor *nor);
+void spi_nor_register_locking_ops(struct spi_nor *nor);
+
 static struct spi_nor __maybe_unused *mtd_to_spi_nor(struct mtd_info *mtd)
 {
 	return mtd->priv;
--- /dev/null
+++ b/drivers/mtd/spi-nor/swp.c
@@ -0,0 +1,421 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * SPI NOR Software Write Protection logic.
+ *
+ * Copyright (C) 2005, Intec Automation Inc.
+ * Copyright (C) 2014, Freescale Semiconductor, Inc.
+ */
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/spi-nor.h>
+
+#include "core.h"
+
+static u8 spi_nor_get_sr_bp_mask(struct spi_nor *nor)
+{
+	u8 mask = SR_BP2 | SR_BP1 | SR_BP0;
+
+	if (nor->flags & SNOR_F_HAS_SR_BP3_BIT6)
+		return mask | SR_BP3_BIT6;
+
+	if (nor->flags & SNOR_F_HAS_4BIT_BP)
+		return mask | SR_BP3;
+
+	return mask;
+}
+
+static u8 spi_nor_get_sr_tb_mask(struct spi_nor *nor)
+{
+	if (nor->flags & SNOR_F_HAS_SR_TB_BIT6)
+		return SR_TB_BIT6;
+	else
+		return SR_TB_BIT5;
+}
+
+static u64 spi_nor_get_min_prot_length_sr(struct spi_nor *nor)
+{
+	unsigned int bp_slots, bp_slots_needed;
+	u8 mask = spi_nor_get_sr_bp_mask(nor);
+
+	/* Reserved one for "protect none" and one for "protect all". */
+	bp_slots = (1 << hweight8(mask)) - 2;
+	bp_slots_needed = ilog2(nor->info->n_sectors);
+
+	if (bp_slots_needed > bp_slots)
+		return nor->info->sector_size <<
+			(bp_slots_needed - bp_slots);
+	else
+		return nor->info->sector_size;
+}
+
+static void spi_nor_get_locked_range_sr(struct spi_nor *nor, u8 sr, loff_t *ofs,
+					uint64_t *len)
+{
+	struct mtd_info *mtd = &nor->mtd;
+	u64 min_prot_len;
+	u8 mask = spi_nor_get_sr_bp_mask(nor);
+	u8 tb_mask = spi_nor_get_sr_tb_mask(nor);
+	u8 bp, val = sr & mask;
+
+	if (nor->flags & SNOR_F_HAS_SR_BP3_BIT6 && val & SR_BP3_BIT6)
+		val = (val & ~SR_BP3_BIT6) | SR_BP3;
+
+	bp = val >> SR_BP_SHIFT;
+
+	if (!bp) {
+		/* No protection */
+		*ofs = 0;
+		*len = 0;
+		return;
+	}
+
+	min_prot_len = spi_nor_get_min_prot_length_sr(nor);
+	*len = min_prot_len << (bp - 1);
+
+	if (*len > mtd->size)
+		*len = mtd->size;
+
+	if (nor->flags & SNOR_F_HAS_SR_TB && sr & tb_mask)
+		*ofs = 0;
+	else
+		*ofs = mtd->size - *len;
+}
+
+/*
+ * Return 1 if the entire region is locked (if @locked is true) or unlocked (if
+ * @locked is false); 0 otherwise
+ */
+static int spi_nor_check_lock_status_sr(struct spi_nor *nor, loff_t ofs,
+					uint64_t len, u8 sr, bool locked)
+{
+	loff_t lock_offs;
+	uint64_t lock_len;
+
+	if (!len)
+		return 1;
+
+	spi_nor_get_locked_range_sr(nor, sr, &lock_offs, &lock_len);
+
+	if (locked)
+		/* Requested range is a sub-range of locked range */
+		return (ofs + len <= lock_offs + lock_len) && (ofs >= lock_offs);
+	else
+		/* Requested range does not overlap with locked range */
+		return (ofs >= lock_offs + lock_len) || (ofs + len <= lock_offs);
+}
+
+static int spi_nor_is_locked_sr(struct spi_nor *nor, loff_t ofs, uint64_t len,
+				u8 sr)
+{
+	return spi_nor_check_lock_status_sr(nor, ofs, len, sr, true);
+}
+
+static int spi_nor_is_unlocked_sr(struct spi_nor *nor, loff_t ofs, uint64_t len,
+				  u8 sr)
+{
+	return spi_nor_check_lock_status_sr(nor, ofs, len, sr, false);
+}
+
+/*
+ * Lock a region of the flash. Compatible with ST Micro and similar flash.
+ * Supports the block protection bits BP{0,1,2}/BP{0,1,2,3} in the status
+ * register
+ * (SR). Does not support these features found in newer SR bitfields:
+ *   - SEC: sector/block protect - only handle SEC=0 (block protect)
+ *   - CMP: complement protect - only support CMP=0 (range is not complemented)
+ *
+ * Support for the following is provided conditionally for some flash:
+ *   - TB: top/bottom protect
+ *
+ * Sample table portion for 8MB flash (Winbond w25q64fw):
+ *
+ *   SEC  |  TB   |  BP2  |  BP1  |  BP0  |  Prot Length  | Protected Portion
+ *  --------------------------------------------------------------------------
+ *    X   |   X   |   0   |   0   |   0   |  NONE         | NONE
+ *    0   |   0   |   0   |   0   |   1   |  128 KB       | Upper 1/64
+ *    0   |   0   |   0   |   1   |   0   |  256 KB       | Upper 1/32
+ *    0   |   0   |   0   |   1   |   1   |  512 KB       | Upper 1/16
+ *    0   |   0   |   1   |   0   |   0   |  1 MB         | Upper 1/8
+ *    0   |   0   |   1   |   0   |   1   |  2 MB         | Upper 1/4
+ *    0   |   0   |   1   |   1   |   0   |  4 MB         | Upper 1/2
+ *    X   |   X   |   1   |   1   |   1   |  8 MB         | ALL
+ *  ------|-------|-------|-------|-------|---------------|-------------------
+ *    0   |   1   |   0   |   0   |   1   |  128 KB       | Lower 1/64
+ *    0   |   1   |   0   |   1   |   0   |  256 KB       | Lower 1/32
+ *    0   |   1   |   0   |   1   |   1   |  512 KB       | Lower 1/16
+ *    0   |   1   |   1   |   0   |   0   |  1 MB         | Lower 1/8
+ *    0   |   1   |   1   |   0   |   1   |  2 MB         | Lower 1/4
+ *    0   |   1   |   1   |   1   |   0   |  4 MB         | Lower 1/2
+ *
+ * Returns negative on errors, 0 on success.
+ */
+static int spi_nor_sr_lock(struct spi_nor *nor, loff_t ofs, uint64_t len)
+{
+	struct mtd_info *mtd = &nor->mtd;
+	u64 min_prot_len;
+	int ret, status_old, status_new;
+	u8 mask = spi_nor_get_sr_bp_mask(nor);
+	u8 tb_mask = spi_nor_get_sr_tb_mask(nor);
+	u8 pow, val;
+	loff_t lock_len;
+	bool can_be_top = true, can_be_bottom = nor->flags & SNOR_F_HAS_SR_TB;
+	bool use_top;
+
+	ret = spi_nor_read_sr(nor, nor->bouncebuf);
+	if (ret)
+		return ret;
+
+	status_old = nor->bouncebuf[0];
+
+	/* If nothing in our range is unlocked, we don't need to do anything */
+	if (spi_nor_is_locked_sr(nor, ofs, len, status_old))
+		return 0;
+
+	/* If anything below us is unlocked, we can't use 'bottom' protection */
+	if (!spi_nor_is_locked_sr(nor, 0, ofs, status_old))
+		can_be_bottom = false;
+
+	/* If anything above us is unlocked, we can't use 'top' protection */
+	if (!spi_nor_is_locked_sr(nor, ofs + len, mtd->size - (ofs + len),
+				  status_old))
+		can_be_top = false;
+
+	if (!can_be_bottom && !can_be_top)
+		return -EINVAL;
+
+	/* Prefer top, if both are valid */
+	use_top = can_be_top;
+
+	/* lock_len: length of region that should end up locked */
+	if (use_top)
+		lock_len = mtd->size - ofs;
+	else
+		lock_len = ofs + len;
+
+	if (lock_len == mtd->size) {
+		val = mask;
+	} else {
+		min_prot_len = spi_nor_get_min_prot_length_sr(nor);
+		pow = ilog2(lock_len) - ilog2(min_prot_len) + 1;
+		val = pow << SR_BP_SHIFT;
+
+		if (nor->flags & SNOR_F_HAS_SR_BP3_BIT6 && val & SR_BP3)
+			val = (val & ~SR_BP3) | SR_BP3_BIT6;
+
+		if (val & ~mask)
+			return -EINVAL;
+
+		/* Don't "lock" with no region! */
+		if (!(val & mask))
+			return -EINVAL;
+	}
+
+	status_new = (status_old & ~mask & ~tb_mask) | val;
+
+	/* Disallow further writes if WP pin is asserted */
+	status_new |= SR_SRWD;
+
+	if (!use_top)
+		status_new |= tb_mask;
+
+	/* Don't bother if they're the same */
+	if (status_new == status_old)
+		return 0;
+
+	/* Only modify protection if it will not unlock other areas */
+	if ((status_new & mask) < (status_old & mask))
+		return -EINVAL;
+
+	return spi_nor_write_sr_and_check(nor, status_new);
+}
+
+/*
+ * Unlock a region of the flash. See spi_nor_sr_lock() for more info
+ *
+ * Returns negative on errors, 0 on success.
+ */
+static int spi_nor_sr_unlock(struct spi_nor *nor, loff_t ofs, uint64_t len)
+{
+	u64 min_prot_len;
+	int ret, status_old, status_new;
+	u8 mask = spi_nor_get_sr_bp_mask(nor);
+	u8 tb_mask = spi_nor_get_sr_tb_mask(nor);
+	u8 pow, val;
+	loff_t lock_len;
+	bool can_be_top = true, can_be_bottom = nor->flags & SNOR_F_HAS_SR_TB;
+	bool use_top;
+
+	ret = spi_nor_read_sr(nor, nor->bouncebuf);
+	if (ret)
+		return ret;
+
+	status_old = nor->bouncebuf[0];
+
+	/* If nothing in our range is locked, we don't need to do anything */
+	if (spi_nor_is_unlocked_sr(nor, ofs, len, status_old))
+		return 0;
+
+	/* If anything below us is locked, we can't use 'top' protection */
+	if (!spi_nor_is_unlocked_sr(nor, 0, ofs, status_old))
+		can_be_top = false;
+
+	/* If anything above us is locked, we can't use 'bottom' protection */
+	if (!spi_nor_is_unlocked_sr(nor, ofs + len, nor->params->size - (ofs + len),
+				    status_old))
+		can_be_bottom = false;
+
+	if (!can_be_bottom && !can_be_top)
+		return -EINVAL;
+
+	/* Prefer top, if both are valid */
+	use_top = can_be_top;
+
+	/* lock_len: length of region that should remain locked */
+	if (use_top)
+		lock_len = nor->params->size - (ofs + len);
+	else
+		lock_len = ofs;
+
+	if (lock_len == 0) {
+		val = 0; /* fully unlocked */
+	} else {
+		min_prot_len = spi_nor_get_min_prot_length_sr(nor);
+		pow = ilog2(lock_len) - ilog2(min_prot_len) + 1;
+		val = pow << SR_BP_SHIFT;
+
+		if (nor->flags & SNOR_F_HAS_SR_BP3_BIT6 && val & SR_BP3)
+			val = (val & ~SR_BP3) | SR_BP3_BIT6;
+
+		/* Some power-of-two sizes are not supported */
+		if (val & ~mask)
+			return -EINVAL;
+	}
+
+	status_new = (status_old & ~mask & ~tb_mask) | val;
+
+	/* Don't protect status register if we're fully unlocked */
+	if (lock_len == 0)
+		status_new &= ~SR_SRWD;
+
+	if (!use_top)
+		status_new |= tb_mask;
+
+	/* Don't bother if they're the same */
+	if (status_new == status_old)
+		return 0;
+
+	/* Only modify protection if it will not lock other areas */
+	if ((status_new & mask) > (status_old & mask))
+		return -EINVAL;
+
+	return spi_nor_write_sr_and_check(nor, status_new);
+}
+
+/*
+ * Check if a region of the flash is (completely) locked. See spi_nor_sr_lock()
+ * for more info.
+ *
+ * Returns 1 if entire region is locked, 0 if any portion is unlocked, and
+ * negative on errors.
+ */
+static int spi_nor_sr_is_locked(struct spi_nor *nor, loff_t ofs, uint64_t len)
+{
+	int ret;
+
+	ret = spi_nor_read_sr(nor, nor->bouncebuf);
+	if (ret)
+		return ret;
+
+	return spi_nor_is_locked_sr(nor, ofs, len, nor->bouncebuf[0]);
+}
+
+static const struct spi_nor_locking_ops spi_nor_sr_locking_ops = {
+	.lock = spi_nor_sr_lock,
+	.unlock = spi_nor_sr_unlock,
+	.is_locked = spi_nor_sr_is_locked,
+};
+
+void spi_nor_init_default_locking_ops(struct spi_nor *nor)
+{
+	nor->params->locking_ops = &spi_nor_sr_locking_ops;
+}
+
+static int spi_nor_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
+{
+	struct spi_nor *nor = mtd_to_spi_nor(mtd);
+	int ret;
+
+	ret = spi_nor_lock_and_prep(nor);
+	if (ret)
+		return ret;
+
+	ret = nor->params->locking_ops->lock(nor, ofs, len);
+
+	spi_nor_unlock_and_unprep(nor);
+	return ret;
+}
+
+static int spi_nor_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
+{
+	struct spi_nor *nor = mtd_to_spi_nor(mtd);
+	int ret;
+
+	ret = spi_nor_lock_and_prep(nor);
+	if (ret)
+		return ret;
+
+	ret = nor->params->locking_ops->unlock(nor, ofs, len);
+
+	spi_nor_unlock_and_unprep(nor);
+	return ret;
+}
+
+static int spi_nor_is_locked(struct mtd_info *mtd, loff_t ofs, uint64_t len)
+{
+	struct spi_nor *nor = mtd_to_spi_nor(mtd);
+	int ret;
+
+	ret = spi_nor_lock_and_prep(nor);
+	if (ret)
+		return ret;
+
+	ret = nor->params->locking_ops->is_locked(nor, ofs, len);
+
+	spi_nor_unlock_and_unprep(nor);
+	return ret;
+}
+
+/**
+ * spi_nor_try_unlock_all() - Tries to unlock the entire flash memory array.
+ * @nor:	pointer to a 'struct spi_nor'.
+ *
+ * Some SPI NOR flashes are write protected by default after a power-on reset
+ * cycle, in order to avoid inadvertent writes during power-up. Backward
+ * compatibility imposes to unlock the entire flash memory array at power-up
+ * by default.
+ *
+ * Unprotecting the entire flash array will fail for boards which are hardware
+ * write-protected. Thus any errors are ignored.
+ */
+void spi_nor_try_unlock_all(struct spi_nor *nor)
+{
+	int ret;
+
+	if (!(nor->flags & SNOR_F_HAS_LOCK))
+		return;
+
+	ret = spi_nor_unlock(&nor->mtd, 0, nor->params->size);
+	if (ret)
+		dev_dbg(nor->dev, "Failed to unlock the entire flash memory array\n");
+}
+
+void spi_nor_register_locking_ops(struct spi_nor *nor)
+{
+	struct mtd_info *mtd = &nor->mtd;
+
+	if (!nor->params->locking_ops)
+		return;
+
+	mtd->_lock = spi_nor_lock;
+	mtd->_unlock = spi_nor_unlock;
+	mtd->_is_locked = spi_nor_is_locked;
+}


