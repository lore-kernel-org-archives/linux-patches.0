Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D491547F3;
	Mon, 14 Oct 2024 14:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916105; cv=none; b=ZPQ7cHhZ8x59m9BfX1VJFpk0rL3lGTuQyE/ijRK4DYvig1c3D783NPTyVGSw090FaVPf5lwmiCgmk5pEKOFFlpsleeW4E9QOG+9Xy8SFKA5kZNaJhuyNJo2xQkkl4QGsRaOXXD5yt6FEyG1sEEwudGPGTKwYV4DcRXviH8SrzwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916105; c=relaxed/simple;
	bh=qJgXf3dkE2neOJQhK7JE1PfSuS0RTaaWFUyhHdNBW6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oq8L6hz0FU1S/73BaKCx2vPadUTAVXOv4qm3DFx+9mUmj2+4JAcaWB2islodfeIf+jahQuuy7jQ8ab2dtDB7UShpk+GaMbyS+8eHnPI3vdRM1hykMRPjoeFFG3V+n5Q6CP1X7+Jiu40sEzgAi11V70aaPVNk+DcZ/bZmvgVLS48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLO4yMBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLO4yMBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EC4C4CEC3;
	Mon, 14 Oct 2024 14:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916104;
	bh=qJgXf3dkE2neOJQhK7JE1PfSuS0RTaaWFUyhHdNBW6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zLO4yMBw+cqcrR0kuH9d8MJE0tDVvGJIYAwgdxgWfOU6ZBQxFxqxET71lZr3cbs0M
	 887UUTvIdiDLis6eLOXbAsSzxml9RIE9GJ/xKQgi24nsMZmz2bOWYPrzS1R0DLbTXk
	 PgHcaz3OAyvPH/o8iS2Z3wTgLR4yYM0TesEKL+mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 085/214] ice: fix memleak in ice_init_tx_topology()
Date: Mon, 14 Oct 2024 16:19:08 +0200
Message-ID: <20241014141048.307303573@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit c188afdc36113760873ec78cbc036f6b05f77621 ]

Fix leak of the FW blob (DDP pkg).

Make ice_cfg_tx_topo() const-correct, so ice_init_tx_topology() can avoid
copying whole FW blob. Copy just the topology section, and only when
needed. Reuse the buffer allocated for the read of the current topology.

This was found by kmemleak, with the following trace for each PF:
    [<ffffffff8761044d>] kmemdup_noprof+0x1d/0x50
    [<ffffffffc0a0a480>] ice_init_ddp_config+0x100/0x220 [ice]
    [<ffffffffc0a0da7f>] ice_init_dev+0x6f/0x200 [ice]
    [<ffffffffc0a0dc49>] ice_init+0x29/0x560 [ice]
    [<ffffffffc0a10c1d>] ice_probe+0x21d/0x310 [ice]

Constify ice_cfg_tx_topo() @buf parameter.
This cascades further down to few more functions.

Fixes: cc5776fe1832 ("ice: Enable switching default Tx scheduler topology")
CC: Larysa Zaremba <larysa.zaremba@intel.com>
CC: Jacob Keller <jacob.e.keller@intel.com>
CC: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
CC: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ddp.c  | 58 +++++++++++------------
 drivers/net/ethernet/intel/ice/ice_ddp.h  |  4 +-
 drivers/net/ethernet/intel/ice/ice_main.c |  8 +---
 3 files changed, 31 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ddp.c b/drivers/net/ethernet/intel/ice/ice_ddp.c
index f182179529b7d..6b60b7c4de093 100644
--- a/drivers/net/ethernet/intel/ice/ice_ddp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ddp.c
@@ -31,7 +31,7 @@ static const struct ice_tunnel_type_scan tnls[] = {
  * Verifies various attributes of the package file, including length, format
  * version, and the requirement of at least one segment.
  */
-static enum ice_ddp_state ice_verify_pkg(struct ice_pkg_hdr *pkg, u32 len)
+static enum ice_ddp_state ice_verify_pkg(const struct ice_pkg_hdr *pkg, u32 len)
 {
 	u32 seg_count;
 	u32 i;
@@ -57,13 +57,13 @@ static enum ice_ddp_state ice_verify_pkg(struct ice_pkg_hdr *pkg, u32 len)
 	/* all segments must fit within length */
 	for (i = 0; i < seg_count; i++) {
 		u32 off = le32_to_cpu(pkg->seg_offset[i]);
-		struct ice_generic_seg_hdr *seg;
+		const struct ice_generic_seg_hdr *seg;
 
 		/* segment header must fit */
 		if (len < off + sizeof(*seg))
 			return ICE_DDP_PKG_INVALID_FILE;
 
-		seg = (struct ice_generic_seg_hdr *)((u8 *)pkg + off);
+		seg = (void *)pkg + off;
 
 		/* segment body must fit */
 		if (len < off + le32_to_cpu(seg->seg_size))
@@ -119,13 +119,13 @@ static enum ice_ddp_state ice_chk_pkg_version(struct ice_pkg_ver *pkg_ver)
  *
  * This helper function validates a buffer's header.
  */
-static struct ice_buf_hdr *ice_pkg_val_buf(struct ice_buf *buf)
+static const struct ice_buf_hdr *ice_pkg_val_buf(const struct ice_buf *buf)
 {
-	struct ice_buf_hdr *hdr;
+	const struct ice_buf_hdr *hdr;
 	u16 section_count;
 	u16 data_end;
 
-	hdr = (struct ice_buf_hdr *)buf->buf;
+	hdr = (const struct ice_buf_hdr *)buf->buf;
 	/* verify data */
 	section_count = le16_to_cpu(hdr->section_count);
 	if (section_count < ICE_MIN_S_COUNT || section_count > ICE_MAX_S_COUNT)
@@ -165,8 +165,8 @@ static struct ice_buf_table *ice_find_buf_table(struct ice_seg *ice_seg)
  * unexpected value has been detected (for example an invalid section count or
  * an invalid buffer end value).
  */
-static struct ice_buf_hdr *ice_pkg_enum_buf(struct ice_seg *ice_seg,
-					    struct ice_pkg_enum *state)
+static const struct ice_buf_hdr *ice_pkg_enum_buf(struct ice_seg *ice_seg,
+						  struct ice_pkg_enum *state)
 {
 	if (ice_seg) {
 		state->buf_table = ice_find_buf_table(ice_seg);
@@ -1800,9 +1800,9 @@ int ice_update_pkg(struct ice_hw *hw, struct ice_buf *bufs, u32 count)
  * success it returns a pointer to the segment header, otherwise it will
  * return NULL.
  */
-static struct ice_generic_seg_hdr *
+static const struct ice_generic_seg_hdr *
 ice_find_seg_in_pkg(struct ice_hw *hw, u32 seg_type,
-		    struct ice_pkg_hdr *pkg_hdr)
+		    const struct ice_pkg_hdr *pkg_hdr)
 {
 	u32 i;
 
@@ -1813,11 +1813,9 @@ ice_find_seg_in_pkg(struct ice_hw *hw, u32 seg_type,
 
 	/* Search all package segments for the requested segment type */
 	for (i = 0; i < le32_to_cpu(pkg_hdr->seg_count); i++) {
-		struct ice_generic_seg_hdr *seg;
+		const struct ice_generic_seg_hdr *seg;
 
-		seg = (struct ice_generic_seg_hdr
-			       *)((u8 *)pkg_hdr +
-				  le32_to_cpu(pkg_hdr->seg_offset[i]));
+		seg = (void *)pkg_hdr + le32_to_cpu(pkg_hdr->seg_offset[i]);
 
 		if (le32_to_cpu(seg->seg_type) == seg_type)
 			return seg;
@@ -2354,12 +2352,12 @@ ice_get_set_tx_topo(struct ice_hw *hw, u8 *buf, u16 buf_size,
  *
  * Return: zero when update was successful, negative values otherwise.
  */
-int ice_cfg_tx_topo(struct ice_hw *hw, u8 *buf, u32 len)
+int ice_cfg_tx_topo(struct ice_hw *hw, const void *buf, u32 len)
 {
-	u8 *current_topo, *new_topo = NULL;
-	struct ice_run_time_cfg_seg *seg;
-	struct ice_buf_hdr *section;
-	struct ice_pkg_hdr *pkg_hdr;
+	u8 *new_topo = NULL, *topo __free(kfree) = NULL;
+	const struct ice_run_time_cfg_seg *seg;
+	const struct ice_buf_hdr *section;
+	const struct ice_pkg_hdr *pkg_hdr;
 	enum ice_ddp_state state;
 	u16 offset, size = 0;
 	u32 reg = 0;
@@ -2375,15 +2373,13 @@ int ice_cfg_tx_topo(struct ice_hw *hw, u8 *buf, u32 len)
 		return -EOPNOTSUPP;
 	}
 
-	current_topo = kzalloc(ICE_AQ_MAX_BUF_LEN, GFP_KERNEL);
-	if (!current_topo)
+	topo = kzalloc(ICE_AQ_MAX_BUF_LEN, GFP_KERNEL);
+	if (!topo)
 		return -ENOMEM;
 
-	/* Get the current Tx topology */
-	status = ice_get_set_tx_topo(hw, current_topo, ICE_AQ_MAX_BUF_LEN, NULL,
-				     &flags, false);
-
-	kfree(current_topo);
+	/* Get the current Tx topology flags */
+	status = ice_get_set_tx_topo(hw, topo, ICE_AQ_MAX_BUF_LEN, NULL, &flags,
+				     false);
 
 	if (status) {
 		ice_debug(hw, ICE_DBG_INIT, "Get current topology is failed\n");
@@ -2419,7 +2415,7 @@ int ice_cfg_tx_topo(struct ice_hw *hw, u8 *buf, u32 len)
 		goto update_topo;
 	}
 
-	pkg_hdr = (struct ice_pkg_hdr *)buf;
+	pkg_hdr = (const struct ice_pkg_hdr *)buf;
 	state = ice_verify_pkg(pkg_hdr, len);
 	if (state) {
 		ice_debug(hw, ICE_DBG_INIT, "Failed to verify pkg (err: %d)\n",
@@ -2428,7 +2424,7 @@ int ice_cfg_tx_topo(struct ice_hw *hw, u8 *buf, u32 len)
 	}
 
 	/* Find runtime configuration segment */
-	seg = (struct ice_run_time_cfg_seg *)
+	seg = (const struct ice_run_time_cfg_seg *)
 	      ice_find_seg_in_pkg(hw, SEGMENT_TYPE_ICE_RUN_TIME_CFG, pkg_hdr);
 	if (!seg) {
 		ice_debug(hw, ICE_DBG_INIT, "5 layer topology segment is missing\n");
@@ -2461,8 +2457,10 @@ int ice_cfg_tx_topo(struct ice_hw *hw, u8 *buf, u32 len)
 		return -EIO;
 	}
 
-	/* Get the new topology buffer */
-	new_topo = ((u8 *)section) + offset;
+	/* Get the new topology buffer, reuse current topo copy mem */
+	static_assert(ICE_PKG_BUF_SIZE == ICE_AQ_MAX_BUF_LEN);
+	new_topo = topo;
+	memcpy(new_topo, (u8 *)section + offset, size);
 
 update_topo:
 	/* Acquire global lock to make sure that set topology issued
diff --git a/drivers/net/ethernet/intel/ice/ice_ddp.h b/drivers/net/ethernet/intel/ice/ice_ddp.h
index 622543f08b431..00840e5a10779 100644
--- a/drivers/net/ethernet/intel/ice/ice_ddp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ddp.h
@@ -430,7 +430,7 @@ struct ice_pkg_enum {
 	u32 buf_idx;
 
 	u32 type;
-	struct ice_buf_hdr *buf;
+	const struct ice_buf_hdr *buf;
 	u32 sect_idx;
 	void *sect;
 	u32 sect_type;
@@ -454,6 +454,6 @@ u16 ice_pkg_buf_get_active_sections(struct ice_buf_build *bld);
 void *ice_pkg_enum_section(struct ice_seg *ice_seg, struct ice_pkg_enum *state,
 			   u32 sect_type);
 
-int ice_cfg_tx_topo(struct ice_hw *hw, u8 *buf, u32 len);
+int ice_cfg_tx_topo(struct ice_hw *hw, const void *buf, u32 len);
 
 #endif
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ea780d468579f..a06dcf8367db0 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4548,16 +4548,10 @@ ice_init_tx_topology(struct ice_hw *hw, const struct firmware *firmware)
 	u8 num_tx_sched_layers = hw->num_tx_sched_layers;
 	struct ice_pf *pf = hw->back;
 	struct device *dev;
-	u8 *buf_copy;
 	int err;
 
 	dev = ice_pf_to_dev(pf);
-	/* ice_cfg_tx_topo buf argument is not a constant,
-	 * so we have to make a copy
-	 */
-	buf_copy = kmemdup(firmware->data, firmware->size, GFP_KERNEL);
-
-	err = ice_cfg_tx_topo(hw, buf_copy, firmware->size);
+	err = ice_cfg_tx_topo(hw, firmware->data, firmware->size);
 	if (!err) {
 		if (hw->num_tx_sched_layers > num_tx_sched_layers)
 			dev_info(dev, "Tx scheduling layers switching feature disabled\n");
-- 
2.43.0



