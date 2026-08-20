Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B1836B92A;
	Thu, 20 Aug 2026 15:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238463; cv=none; b=NpZ56kChBqblT1g8AfnX5AMdiNDmkF+xdOv6F2uMLSZqzQH0VamcytRagX9nggAjLkY/aeChadp+cHpeZDR2tspzJHDTkcansXxuxnBdJadjoM4DQMcXprqYkAmMK9Q2zFVza4xCVBE/t/1m9dbKq5crTHT0d7csIghZ402U3qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238463; c=relaxed/simple;
	bh=BSXhIY/bJRuaJ4l4kkvjE8u1v7kcWb/laZYF14k2AvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQ+lnP8YcxjXl92U0n8ALjbxJgkrmZXXJVj83QOUe8AXqSbiy2RqHD8t+DxNbEWnpfLk+xkVSI2ab5tMBkekOXnVYGkMqISuVM/O35ZUx6o5UPfiS5NBbIKVMIYSsVKmuRlR+sidwbHGpGuHh8rrBOoVgLJ7J/AOccdViVkA32M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vccDlzJU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vccDlzJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBC51F000E9;
	Thu, 20 Aug 2026 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238462;
	bh=yOmJBdj7lHM7LVI9EEVza4/t4xMa05ykQp0uq867B4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vccDlzJUqydYMkCkGLoRbT/o0ddoiEYu/cghMIV/CcPR6YVibcOVJzR1T5YkSwVeV
	 daFU2Lz7/da+O5JRYbOADq5uU68OYnH+SveXNoqKGuZ4zx0c5VkuETIYhXH5iDqIVy
	 0WED5rR/752gkvxuiz9Mo4HNBOYyftLNEdBPy9Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Adam Thiede <me@adamthiede.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 157/228] drm/mediatek: mtk_dsi: Enable HS clock only at pre-enable
Date: Thu, 20 Aug 2026 16:54:59 +0200
Message-ID: <20260820145249.429397751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 3e191eddbdcb8bf7beb1e9b58209073bd5450719 ]

Commit 76255024cadb ("drm/mediatek: mtk_dsi: enable hs clock
during pre-enable") rightfully moves the HS clock enablement to
before atomic_enable(), but it's moving it to mtk_dsi_poweron(),
which is not only called in the .atomic_pre_enable() callback
for the DRM bridge, but also in the MediaTek DRM's .ddp_start()
callback, which happens way before the bridge ones.

The HS clock enablement should be done at just the right time,
otherwise some bridge chips (or some Display Driver ICs) may
not work correctly: this is seen at least with a Parade DSI to
eDP bridge (PS8640) on the MT8173 Elm Chromebook.

This resolves a regression that was seen on the aforementioned
machine, which was happening only after a suspend-resume cycle.

Cc: <stable@vger.kernel.org> # 7.1.x
Fixes: 76255024cadb ("drm/mediatek: mtk_dsi: enable hs clock during pre-enable")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Adam Thiede <me@adamthiede.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20260728153145.578404-1-angelogioacchino.delregno@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -743,8 +743,6 @@ static int mtk_dsi_poweron(struct mtk_ds
 	mtk_dsi_set_vm_cmd(dsi);
 	mtk_dsi_config_vdo_timing(dsi);
 	mtk_dsi_set_interrupt_enable(dsi);
-	mtk_dsi_lane_ready(dsi);
-	mtk_dsi_clk_hs_mode(dsi, 1);
 
 	return 0;
 err_disable_engine_clk:
@@ -858,6 +856,9 @@ static void mtk_dsi_bridge_atomic_pre_en
 	ret = mtk_dsi_poweron(dsi);
 	if (ret < 0)
 		drm_err(drm, "failed to power on dsi\n");
+
+	mtk_dsi_lane_ready(dsi);
+	mtk_dsi_clk_hs_mode(dsi, 1);
 }
 
 static void mtk_dsi_bridge_atomic_post_disable(struct drm_bridge *bridge,


