Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F81A484258;
	Thu, 20 Aug 2026 17:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248343; cv=none; b=TJRatQFQaPjsLK+tHDuldeOoLsN6c+G+jFdcacLy2/FJDKcQrdtRN5rAyY3NCIOpOLffV32gXiXpmRMlvT8Gjrmsxv5rXyvEcsYp/mkg5kZnaTRGlvQapIAssAnOdmhthgNhiBnMdY46yePVln1yOTlQaRnc/tehxj9iJ3Lncac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248343; c=relaxed/simple;
	bh=cLQVF8PcbhVjnBnEr5vo/CqJIT/7jnjwzpG8K++CptU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgx9b9yozoLjcGg+Xm20y8muLhCEGnMe6SXJUTnCoFkqaKLx2Ufh9w3vb88AlQhTXxhepEMJXt9yZfJThoo9HHXyFAEW49i0ZQtrwixTjRqkhtKwgl71xUYTPaGhMUhgRRwbvtegcI3GezSyR3+7nKp0WOXrhpy2B3LvwT5I4l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IqqS8B8Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IqqS8B8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4990A1F00A3A;
	Thu, 20 Aug 2026 17:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248340;
	bh=NO+teWTNEm3e3oV8PtH5RDuX6h9abCsxsUQ/rs6dPls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IqqS8B8Zfg9RnrRSGW+dTmFCb8qBr/sN8oluT6LglhreJxIW4q5aEfojfQHc2LTx0
	 6A3TjScK/8TTX1zLpL1UPFUc5LmASo+xYmQTlcY/CHe72GFkmRtpa/jQCQHIF+m9lF
	 XcQtykpPOpuFH7ygJD6fwKZ2ZcvNcmA0bjWRoq1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/303] drm/displayid: fix Tiled Display Topology ID size
Date: Thu, 20 Aug 2026 16:55:23 +0200
Message-ID: <20260820145258.934686604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 90c0486a82e27393f9eaf3bb350f51a0bd38cb6b ]

The Tiled Display Topology ID of a DisplayID Tiled Display Topology Data
Block consists of three fields:

- Tiled Display Manufacturer/Vendor ID Field (3 bytes)
- Tiled Display Product ID Code Field (2 bytes)
- Tiled Display Serial Number Field (4 bytes)

i.e. a total of 9 bytes, not 8.

The DisplayID Tiled Display Topology ID is used as the tile group
identifier.

Update both struct displayid_tiled_block topology_id member and struct
drm_tile_group group_data member to full 9 bytes.

The group data was missing the last byte of the serial number. I don't
know whether there are known bug reports that might be linked to this,
but it's plausible the last byte could be the differentiating part for
the tile groups, and fewer tile groups might have been created than
intended.

Fixes: b49b55bd4fba ("drm/displayid: add displayid defines and edid extension (v2)")
Fixes: 138f9ebb9755 ("drm: add tile_group support. (v3)")
Cc: Dave Airlie <airlied@redhat.com>
Cc: stable@vger.kernel.org # v3.19+
Reviewed-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20260610141549.555605-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_connector.c |   12 ++++++------
 include/drm/drm_connector.h     |    6 +++---
 include/drm/drm_displayid.h     |    2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -2902,7 +2902,7 @@ EXPORT_SYMBOL(drm_mode_put_tile_group);
 /**
  * drm_mode_get_tile_group - get a reference to an existing tile group
  * @dev: DRM device
- * @topology: 8-bytes unique per monitor.
+ * @topology_id: 9-byte unique ID per monitor.
  *
  * Use the unique bytes to get a reference to an existing tile group.
  *
@@ -2910,14 +2910,14 @@ EXPORT_SYMBOL(drm_mode_put_tile_group);
  * tile group or NULL if not found.
  */
 struct drm_tile_group *drm_mode_get_tile_group(struct drm_device *dev,
-					       const char topology[8])
+					       const char topology_id[9])
 {
 	struct drm_tile_group *tg;
 	int id;
 
 	mutex_lock(&dev->mode_config.idr_mutex);
 	idr_for_each_entry(&dev->mode_config.tile_idr, tg, id) {
-		if (!memcmp(tg->group_data, topology, 8)) {
+		if (!memcmp(tg->group_data, topology_id, sizeof(tg->group_data))) {
 			if (!kref_get_unless_zero(&tg->refcount))
 				tg = NULL;
 			mutex_unlock(&dev->mode_config.idr_mutex);
@@ -2932,7 +2932,7 @@ EXPORT_SYMBOL(drm_mode_get_tile_group);
 /**
  * drm_mode_create_tile_group - create a tile group from a displayid description
  * @dev: DRM device
- * @topology: 8-bytes unique per monitor.
+ * @topology_id: 9-byte unique ID per monitor.
  *
  * Create a tile group for the unique monitor, and get a unique
  * identifier for the tile group.
@@ -2941,7 +2941,7 @@ EXPORT_SYMBOL(drm_mode_get_tile_group);
  * new tile group or NULL.
  */
 struct drm_tile_group *drm_mode_create_tile_group(struct drm_device *dev,
-						  const char topology[8])
+						  const char topology_id[9])
 {
 	struct drm_tile_group *tg;
 	int ret;
@@ -2951,7 +2951,7 @@ struct drm_tile_group *drm_mode_create_t
 		return NULL;
 
 	kref_init(&tg->refcount);
-	memcpy(tg->group_data, topology, 8);
+	memcpy(tg->group_data, topology_id, sizeof(tg->group_data));
 	tg->dev = dev;
 
 	mutex_lock(&dev->mode_config.idr_mutex);
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -1864,13 +1864,13 @@ struct drm_tile_group {
 	struct kref refcount;
 	struct drm_device *dev;
 	int id;
-	u8 group_data[8];
+	u8 group_data[9];
 };
 
 struct drm_tile_group *drm_mode_create_tile_group(struct drm_device *dev,
-						  const char topology[8]);
+						  const char topology_id[9]);
 struct drm_tile_group *drm_mode_get_tile_group(struct drm_device *dev,
-					       const char topology[8]);
+					       const char topology_id[9]);
 void drm_mode_put_tile_group(struct drm_device *dev,
 			     struct drm_tile_group *tg);
 
--- a/include/drm/drm_displayid.h
+++ b/include/drm/drm_displayid.h
@@ -108,7 +108,7 @@ struct displayid_tiled_block {
 	u8 topo[3];
 	u8 tile_size[4];
 	u8 tile_pixel_bezel[5];
-	u8 topology_id[8];
+	u8 topology_id[9];
 } __packed;
 
 struct displayid_detailed_timings_1 {


