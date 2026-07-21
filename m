Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C343544AB99;
	Tue, 21 Jul 2026 22:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672007; cv=none; b=Yl+OrZYhYMqdVDFotCvbtPxGLbeRtqG36069SJrC56fEDzHhV2e6mleyk8ji0HV9+RoM5LrG/jevhpDYdIcUFGRUREdgJjYR0O3fE9wyMlLVkWBv9lL9DdYjg4JaMc7YzBWDknZb1Ia81puk9VIO/XH+3BMO5WUgGcEwQqT8sb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672007; c=relaxed/simple;
	bh=AezqsyJDDr5cI6akfPj98V9zoqFGKumXcO0qEuFKY18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eycm+gMuOLcykws6lCBWbTWsz4BXUTkSRU+F3BOndQ1XU+UPSPCL+f/4JsqQLz6RIokf/stPJQ3DOo9g2ifyGNtn3Ful9RN1FDxlywmCQOxrXzruxZYKu/pYSjhZ8aIxclK/BU8k6Bub6KZt9wRvmroUdNjXG2Mthi9w5r2Wv2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQxmS2M2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQxmS2M2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9571F000E9;
	Tue, 21 Jul 2026 22:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672002;
	bh=fNZBXj44ehBmi6DGb4CQ0I17FZKm7NBHP+DgBenqiEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQxmS2M2ICUMAY0a7YsTh3mtV+La+KE6x1CQEwa8DZk6eFcd5zMGQ6o+LTcfz27xz
	 XcyAS8cCOgBPrDiz6LBA8IXYJkdJH9l0tAL/aCxHwwKplz1tYbpRuwRgP2I0wIyJio
	 8B73KksblCkBalRaarsagwVb0F/5G6kSwUnjgEH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 461/843] drm/edid: fix OOB read in drm_parse_tiled_block()
Date: Tue, 21 Jul 2026 17:21:36 +0200
Message-ID: <20260721152416.401695455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f067dcbc7cf196..49bb2d9d92435b 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5934,6 +5934,14 @@ static void drm_parse_tiled_block(struct drm_connector *connector,
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



