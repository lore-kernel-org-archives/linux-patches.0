Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B02647142A;
	Tue, 21 Jul 2026 19:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662910; cv=none; b=um+jGsJmRSWHLEwMGmkMMbX59Yr/1KR8VsLN3Mw14Wz6HFOPFjyd579+xXx34dXECwQSI17bwgEe7VXR0cqc3cAMprZ89JkrHJCO1CuxCh1xtXmntLQq+2/m/+8XsOUxO0I9KjkXNBOfJNBkoPVlNle/H6ScYyzDLtgmAObE+QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662910; c=relaxed/simple;
	bh=VqZsqvCVIGo4u5/LCiTktkFQHq3YVTRTmf6DLMdgZmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGbndTbPDMblvvdXhpXKywQFN9tpIR69ya0gOggpdJx2Toa0vyKSQJV9bdPO3kbHIRbyK7zj5OdCntBw/QFqJcmkfTE0qx3YUvMm5k+8IpjduOeG/kbhOI/l2w/sfzGKwzNEY3/zZoL6H/Yig3sqjxoVkUF1zi9zQ6N8slQIVME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EO34tPmU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EO34tPmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FCE1F000E9;
	Tue, 21 Jul 2026 19:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662909;
	bh=wcurkVkh80txMp5m+aoBD6Z2IMzT/yNSKAW2yWg7ki0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EO34tPmUIckGh65M6mNqc7XG9E4GxogB8K5x8di7yBgBqy/EA98IGbx0tVPcZzmMq
	 U83n9R36nMsjt5WQ5CFKFmFRCteOPWDnfgExqF8wAXP394AWrFeGwfgFCI5eDEtl4T
	 RT1qZ8qFp0Cw+yUW9y3Fj2mKEx5p5NuSlnFqxrl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0623/1276] drm/edid: fix OOB read in drm_parse_tiled_block()
Date: Tue, 21 Jul 2026 17:17:46 +0200
Message-ID: <20260721152500.049124946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit faaa1e1155833e7d4ce7e3cfaf64c0d636b190db ]

drm_parse_tiled_block() casts the DisplayID block to a
struct displayid_tiled_block and reads the full fixed layout up to
tile->topology_id[7] without checking block->num_bytes. The DisplayID
iterator only validates the declared payload length, so a crafted EDID
can advertise a tiled-display block (tag DATA_BLOCK_TILED_DISPLAY, or
DATA_BLOCK_2_TILED_DISPLAY_TOPOLOGY for v2.0) with a small num_bytes at
the end of a DisplayID extension. The read then runs past the end of the
exact-sized kmemdup()'d EDID allocation, a heap out-of-bounds read.

Reject blocks shorter than the spec's 22-byte tiled payload before
reading the fixed struct, as drm_parse_vesa_mso_data() already does.

  BUG: KASAN: slab-out-of-bounds in drm_edid_connector_update
  Read of size 2 at addr ffff888010077700 by task exploit/147
   dump_stack_lvl (lib/dump_stack.c:94 ...)
   print_report (mm/kasan/report.c:378 ...)
   kasan_report (mm/kasan/report.c:595)
   drm_edid_connector_update (drivers/gpu/drm/drm_edid.c:7581)
   bochs_connector_helper_get_modes (drivers/gpu/drm/tiny/bochs.c:574)
   drm_helper_probe_single_connector_modes (drivers/gpu/drm/drm_probe_helper.c:426)
   status_store (drivers/gpu/drm/drm_sysfs.c:219)
   ...
   vfs_write (fs/read_write.c:595 fs/read_write.c:688)
   ksys_write (fs/read_write.c:740)

Fixes: 40d9b043a89e ("drm/connector: store tile information from displayid (v3)")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patch.msgid.link/20260615184737.899892-1-xmei5@asu.edu
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 9edb3247c767b8..b6f597af0d0a62 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -7421,6 +7421,14 @@ static void drm_parse_tiled_block(struct drm_connector *connector,
 	u8 num_v_tile, num_h_tile;
 	struct drm_tile_group *tg;
 
+	/* tiled block payload per spec: cap 1 + topo 3 + size 4 + bezel 5 + id 9 = 22 */
+	if (block->num_bytes < 22) {
+		drm_dbg_kms(connector->dev,
+			    "[CONNECTOR:%d:%s] Unexpected tiled block size %u\n",
+			    connector->base.id, connector->name, block->num_bytes);
+		return;
+	}
+
 	w = tile->tile_size[0] | tile->tile_size[1] << 8;
 	h = tile->tile_size[2] | tile->tile_size[3] << 8;
 
-- 
2.53.0



