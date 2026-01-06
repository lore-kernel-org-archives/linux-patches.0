Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1647828C871;
	Tue,  6 Jan 2026 18:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722492; cv=none; b=kkPEIIKXLtJx1/OZERE/11/GSBy40ucps0jW37Kkmula/Sq3Qps5ZXraTGD1O9iTfwUzvTYOSkblSVV/ODI4JKuv2k15hzaKQ0oBYPHvbof4YRf0S06qUgFybMdhh/kVsarVKxl9TZ40di6e0KU0Q+kdPpPKrfC5rdsPDw1d2y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722492; c=relaxed/simple;
	bh=P++wQaAAAljvdhjoTwHgRxGQYwCYZWNV7mABTNgWt58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DI3Qosk3O40p3XS9gTWY/28H0eC02NOJSshRJd7D22BcfZ0xJb7cQLabB2jcr9OhYSKbNp+IN+8TNV3c45v/+rzQ8LxDkXk8GTjmyGpzoDeN79czru8HAfMGc44VnQG+uhX1Bvx+MFJYRnAuDNrSJIN5udgah1fCKae49/kT3GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUA1oJF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUA1oJF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC9EC116C6;
	Tue,  6 Jan 2026 18:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722492;
	bh=P++wQaAAAljvdhjoTwHgRxGQYwCYZWNV7mABTNgWt58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vUA1oJF87L5SfOlB6iwQm86pB3SZpoZ9o2UTmH1VCktN42Ot8xSDykunOZyGwIOp9
	 w21AIfhxSTHMfAIej3HpjuzQfeiOMPbGg+O4Zh/jiQfF71bC8aZCCd0AFVrzX6Et0D
	 Jujq4vTfsPv1ZWEkjU7TSiuDy9HvP10WBi4V+tYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <diederik@cknow-tech.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Dang Huynh <dang.huynh@mainlining.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.18 281/312] drm/rockchip: vop2: Use OVL_LAYER_SEL configuration instead of use win_mask calculate used layers
Date: Tue,  6 Jan 2026 18:05:55 +0100
Message-ID: <20260106170558.018325424@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andy.yan@rock-chips.com>

commit d3fe9aa495854f8d88c69c41a4b31e69424656ad upstream.

When there are multiple Video Ports, and only one of them is working
(for example, VP1 is working while VP0 is not), in this case, the
win_mask of VP0 is 0. However, we have already set the port mux for VP0
according to vp0->nlayers, and at the same time, in the OVL_LAYER_SEL
register, there are windows will also be assigned to layers which will
map to the inactive VPs. In this situation, vp0->win_mask is zero as it
now working, it is more reliable to calculate the used layers based on
the configuration of the OVL_LAYER_SEL register.

Note: as the configuration of OVL_LAYER_SEL is take effect when the
vsync is come, so we use the value backup in vop2->old_layer_sel instead
of read OVL_LAYER_SEL directly.

Fixes: 3e89a8c68354 ("drm/rockchip: vop2: Fix the update of LAYER/PORT select registers when there are multi display output on rk3588/rk3568")
Cc: stable@vger.kernel.org
Reported-by: Diederik de Haas <diederik@cknow-tech.com>
Closes: https://bugs.kde.org/show_bug.cgi?id=511274
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Tested-by: Dang Huynh <dang.huynh@mainlining.org>
Tested-by: Diederik de Haas <diederik@cknow-tech.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20251112085024.2480111-1-andyshrk@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/rockchip_vop2_reg.c |   49 +++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
@@ -1369,6 +1369,25 @@ static const struct vop2_regs_dump rk358
 	},
 };
 
+/*
+ * phys_id is used to identify a main window(Cluster Win/Smart Win, not
+ * include the sub win of a cluster or the multi area) that can do overlay
+ * in main overlay stage.
+ */
+static struct vop2_win *vop2_find_win_by_phys_id(struct vop2 *vop2, uint8_t phys_id)
+{
+	struct vop2_win *win;
+	int i;
+
+	for (i = 0; i < vop2->data->win_size; i++) {
+		win = &vop2->win[i];
+		if (win->data->phys_id == phys_id)
+			return win;
+	}
+
+	return NULL;
+}
+
 static unsigned long rk3568_set_intf_mux(struct vop2_video_port *vp, int id, u32 polflags)
 {
 	struct vop2 *vop2 = vp->vop2;
@@ -1842,15 +1861,31 @@ static void vop2_parse_alpha(struct vop2
 	alpha->dst_alpha_ctrl.bits.factor_mode = ALPHA_SRC_INVERSE;
 }
 
-static int vop2_find_start_mixer_id_for_vp(struct vop2 *vop2, u8 port_id)
+static int vop2_find_start_mixer_id_for_vp(struct vop2_video_port *vp)
 {
-	struct vop2_video_port *vp;
-	int used_layer = 0;
+	struct vop2 *vop2 = vp->vop2;
+	struct vop2_win *win;
+	u32 layer_sel = vop2->old_layer_sel;
+	u32 used_layer = 0;
+	unsigned long win_mask = vp->win_mask;
+	unsigned long phys_id;
+	bool match;
 	int i;
 
-	for (i = 0; i < port_id; i++) {
-		vp = &vop2->vps[i];
-		used_layer += hweight32(vp->win_mask);
+	for (i = 0; i < 31; i += 4) {
+		match = false;
+		for_each_set_bit(phys_id, &win_mask, ROCKCHIP_VOP2_ESMART3) {
+			win = vop2_find_win_by_phys_id(vop2, phys_id);
+			if (win->data->layer_sel_id[vp->id] == ((layer_sel >> i) & 0xf)) {
+				match = true;
+				break;
+			}
+		}
+
+		if (!match)
+			used_layer += 1;
+		else
+			break;
 	}
 
 	return used_layer;
@@ -1935,7 +1970,7 @@ static void vop2_setup_alpha(struct vop2
 	u32 dst_global_alpha = DRM_BLEND_ALPHA_OPAQUE;
 
 	if (vop2->version <= VOP_VERSION_RK3588)
-		mixer_id = vop2_find_start_mixer_id_for_vp(vop2, vp->id);
+		mixer_id = vop2_find_start_mixer_id_for_vp(vp);
 	else
 		mixer_id = 0;
 


