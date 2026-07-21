Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF4943C063;
	Tue, 21 Jul 2026 22:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673953; cv=none; b=uUlHIkP+wtfPwLY5SaIUDyJLp2LvPtqG614PfPNnEoR0Pcc2WnYVfTgCwPdAB+6vyU0rkM4hE8E1ilv+Td9A63hlQsV/2mOy+PvdhNoiZT9hDCMdNFFl2vyyJPfOmBl9g//FKrK6KcXj1zDhWjEuRSVCDBOY0ahL2zrTifdOiH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673953; c=relaxed/simple;
	bh=NPY93MboMv3rM49hVhUf5pyeWNLnU1RmUFA5GkcVlNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4cJhcNNwCNifaGlzMIvbsKYFlzCwq/P12U/zWu5Q1CqsqTEALWxdxhUHoh7kOydvPAGBs86fus0HWYnNxLZ78HvtfpFeQG6XZPk73JHSwhfdboXSd6YegvOsZzkfAXmoCz4ytzb7vvdEenKuvhqLmTulupyPns2ynErGyl6QjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5ZdIYx9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5ZdIYx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76DC1F000E9;
	Tue, 21 Jul 2026 22:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673951;
	bh=a9EM8n2DTEJy8WrzXpBPnNms7/Viq2bHudx7lop2dzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5ZdIYx9XgMLOu/4xWQwp4RGs8WGTn8k9OVR+3FTLO1LuGb8S8HfeChkXgr7na8Wu
	 e9DfNMhXMYnllP7camwNiu0GlM6F/0tpw0Atq0jKMYPOFpy1HAZ4GnSxx0RzJPgnYn
	 ZOyBIWQVcr0qWQn+Pd9D7IRLbjCHi4/Zev8CZCqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 355/699] drm/edid: fix OOB read in drm_parse_tiled_block()
Date: Tue, 21 Jul 2026 17:21:54 +0200
Message-ID: <20260721152403.700695520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
index c3b4a84a9f911d..268791a29828a1 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5896,6 +5896,14 @@ static void drm_parse_tiled_block(struct drm_connector *connector,
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



