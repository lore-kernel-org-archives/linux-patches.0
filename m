Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E0B1E1DFC;
	Wed, 28 Jan 2026 15:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615235; cv=none; b=DUjx90at87jcXdHMz8WkTN6rQVk8KZz0uYx5uC6K/XQIRrLGIoK0Ja/63u6mK6b+NWfBAcq0+PupMdm6/bG5A5B1HUlF++Knp11DuNueyNH3FmBfWjgipAJzJQos9AxYMEABZ/DldS1wW+2HAqwfu/FR75r8fTuXS/9EmvzBLU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615235; c=relaxed/simple;
	bh=ok79+a6ZSuSbSo4DI47P2WkNttAw0y219xjjDGj3ypU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=foNc8D7zR/sk5oj7pyTQpp7lobnGlLQWcr3TCvQfi1Xat3h+Tz0CEj/U7FO0bbpSzxkHeeSYvzZz5SpivfTgNo1keTINXFA1KdcxVRWf5zms3WZ//MGZjptf6ipz5aOMq5s22MThA6UiWQZ9a25sa+/hl+42yfgX76ESjWbkHIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3W1PYyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3W1PYyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938A4C4CEF7;
	Wed, 28 Jan 2026 15:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615235;
	bh=ok79+a6ZSuSbSo4DI47P2WkNttAw0y219xjjDGj3ypU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3W1PYyTpcduCmHO5PxF6syIOdu6CclBz1+5UJ3Zp61sHC7LQhKhkEMEO2iesuoq2
	 oHsVp+YFhOsuVQzjO5SDEqr06ICMjPYUQ+YxxDYRNlo2A4LdnAvfaSdZM8d4ZnLorQ
	 +usdR059K3C6vXm2aXnUJSeS1fqAA7OVcHsHRDF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alex=20Ram=C3=ADrez?= <lxrmrz732@rocketmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/169] drm/nouveau: implement missing DCB connector types; gracefully handle unknown connectors
Date: Wed, 28 Jan 2026 16:22:49 +0100
Message-ID: <20260128145337.102687609@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Ramírez <lxrmrz732@rocketmail.com>

[ Upstream commit d0bd10792d6cc3725ddee43f03fd6ee234f24844 ]

* Implement missing DCB connectors in uconn.c previously defined in conn.h.
* Replace kernel WARN_ON macro with printk message to more gracefully signify
  an unknown connector was encountered.

With this patch, unknown connectors are explicitly marked with value 0
(DCB_CONNECTOR_VGA) to match the tested current behavior. Although 0xff
(DCB_CONNECTOR_NONE) may be more suitable, I don't want to introduce a
breaking change.

Fixes: 8b7d92cad953 ("drm/nouveau/kms/nv50-: create connectors based on nvkm info")
Link: https://download.nvidia.com/open-gpu-doc/DCB/1/DCB-4.0-Specification.html#_connector_table_entry
Signed-off-by: Alex Ramírez <lxrmrz732@rocketmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
[Lyude: Remove unneeded parenthesis around nvkm_warn()]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20251213005327.9495-3-lxrmrz732@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/nouveau/nvkm/engine/disp/uconn.c  | 73 ++++++++++++++-----
 1 file changed, 53 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/uconn.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/uconn.c
index 2dab6612c4fc8..23d1e5c27bb1e 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/uconn.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/uconn.c
@@ -191,27 +191,60 @@ nvkm_uconn_new(const struct nvkm_oclass *oclass, void *argv, u32 argc, struct nv
 	spin_lock(&disp->client.lock);
 	if (!conn->object.func) {
 		switch (conn->info.type) {
-		case DCB_CONNECTOR_VGA      : args->v0.type = NVIF_CONN_V0_VGA; break;
-		case DCB_CONNECTOR_TV_0     :
-		case DCB_CONNECTOR_TV_1     :
-		case DCB_CONNECTOR_TV_3     : args->v0.type = NVIF_CONN_V0_TV; break;
-		case DCB_CONNECTOR_DMS59_0  :
-		case DCB_CONNECTOR_DMS59_1  :
-		case DCB_CONNECTOR_DVI_I    : args->v0.type = NVIF_CONN_V0_DVI_I; break;
-		case DCB_CONNECTOR_DVI_D    : args->v0.type = NVIF_CONN_V0_DVI_D; break;
-		case DCB_CONNECTOR_LVDS     : args->v0.type = NVIF_CONN_V0_LVDS; break;
-		case DCB_CONNECTOR_LVDS_SPWG: args->v0.type = NVIF_CONN_V0_LVDS_SPWG; break;
-		case DCB_CONNECTOR_DMS59_DP0:
-		case DCB_CONNECTOR_DMS59_DP1:
-		case DCB_CONNECTOR_DP       :
-		case DCB_CONNECTOR_mDP      :
-		case DCB_CONNECTOR_USB_C    : args->v0.type = NVIF_CONN_V0_DP; break;
-		case DCB_CONNECTOR_eDP      : args->v0.type = NVIF_CONN_V0_EDP; break;
-		case DCB_CONNECTOR_HDMI_0   :
-		case DCB_CONNECTOR_HDMI_1   :
-		case DCB_CONNECTOR_HDMI_C   : args->v0.type = NVIF_CONN_V0_HDMI; break;
+		/* VGA */
+		case DCB_CONNECTOR_DVI_A	:
+		case DCB_CONNECTOR_POD_VGA	:
+		case DCB_CONNECTOR_VGA		: args->v0.type = NVIF_CONN_V0_VGA; break;
+
+		/* TV */
+		case DCB_CONNECTOR_TV_0		:
+		case DCB_CONNECTOR_TV_1		:
+		case DCB_CONNECTOR_TV_2		:
+		case DCB_CONNECTOR_TV_SCART	:
+		case DCB_CONNECTOR_TV_SCART_D	:
+		case DCB_CONNECTOR_TV_DTERM	:
+		case DCB_CONNECTOR_POD_TV_3	:
+		case DCB_CONNECTOR_POD_TV_1	:
+		case DCB_CONNECTOR_POD_TV_0	:
+		case DCB_CONNECTOR_TV_3		: args->v0.type = NVIF_CONN_V0_TV; break;
+
+		/* DVI */
+		case DCB_CONNECTOR_DVI_I_TV_1	:
+		case DCB_CONNECTOR_DVI_I_TV_0	:
+		case DCB_CONNECTOR_DVI_I_TV_2	:
+		case DCB_CONNECTOR_DVI_ADC	:
+		case DCB_CONNECTOR_DMS59_0	:
+		case DCB_CONNECTOR_DMS59_1	:
+		case DCB_CONNECTOR_DVI_I	: args->v0.type = NVIF_CONN_V0_DVI_I; break;
+		case DCB_CONNECTOR_TMDS		:
+		case DCB_CONNECTOR_DVI_D	: args->v0.type = NVIF_CONN_V0_DVI_D; break;
+
+		/* LVDS */
+		case DCB_CONNECTOR_LVDS		: args->v0.type = NVIF_CONN_V0_LVDS; break;
+		case DCB_CONNECTOR_LVDS_SPWG	: args->v0.type = NVIF_CONN_V0_LVDS_SPWG; break;
+
+		/* DP */
+		case DCB_CONNECTOR_DMS59_DP0	:
+		case DCB_CONNECTOR_DMS59_DP1	:
+		case DCB_CONNECTOR_DP		:
+		case DCB_CONNECTOR_mDP		:
+		case DCB_CONNECTOR_USB_C	: args->v0.type = NVIF_CONN_V0_DP; break;
+		case DCB_CONNECTOR_eDP		: args->v0.type = NVIF_CONN_V0_EDP; break;
+
+		/* HDMI */
+		case DCB_CONNECTOR_HDMI_0	:
+		case DCB_CONNECTOR_HDMI_1	:
+		case DCB_CONNECTOR_HDMI_C	: args->v0.type = NVIF_CONN_V0_HDMI; break;
+
+		/*
+		 * Dock & unused outputs.
+		 * BNC, SPDIF, WFD, and detached LVDS go here.
+		 */
 		default:
-			WARN_ON(1);
+			nvkm_warn(&disp->engine.subdev,
+				  "unimplemented connector type 0x%02x\n",
+				  conn->info.type);
+			args->v0.type = NVIF_CONN_V0_VGA;
 			ret = -EINVAL;
 			break;
 		}
-- 
2.51.0



