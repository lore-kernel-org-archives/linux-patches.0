Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAF2381D6;
	Fri, 24 Nov 2023 18:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTBIhCbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E07C433C8;
	Fri, 24 Nov 2023 18:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850197;
	bh=K4JhJN6LNeMUdrkBh6f5NskHpSSmKibSaOBUvOmqrek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTBIhCbQ9byI8qFM59bU4bPcmjj4liriCnbATnLnGyM/kI43i6fAqHmPtJFl8saA/
	 wbaSodFnBCRO4s58INY+aJyrcNRic3p+iYAB7sUMkQPTlAiYHwpOShTu1GN2HAp+xP
	 uE/bKdPZ4uSkxrGYjO9zC3XubkEdxtvlJCXJ73Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Ranquet <granquet@baylibre.com>,
	Bo-Chen Chen <rex-bc.chen@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	dri-devel@lists.freedesktop.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Jani Nikula <jani.nikula@intel.com>,
	Chen-Yu Tsai <wenst@chromium.org>
Subject: [PATCH 6.6 460/530] drm/mediatek/dp: fix memory leak on ->get_edid callback audio detection
Date: Fri, 24 Nov 2023 17:50:26 +0000
Message-ID: <20231124172042.082336579@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit dab12fa8d2bd3868cf2de485ed15a3feef28a13d upstream.

The sads returned by drm_edid_to_sad() needs to be freed.

Fixes: e71a8ebbe086 ("drm/mediatek: dp: Audio support for MT8195")
Cc: Guillaume Ranquet <granquet@baylibre.com>
Cc: Bo-Chen Chen <rex-bc.chen@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mediatek@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: <stable@vger.kernel.org> # v6.1+
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20230914155317.2511876-1-jani.nikula@intel.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_dp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -2034,7 +2034,6 @@ static struct edid *mtk_dp_get_edid(stru
 	bool enabled = mtk_dp->enabled;
 	struct edid *new_edid = NULL;
 	struct mtk_dp_audio_cfg *audio_caps = &mtk_dp->info.audio_cur_cfg;
-	struct cea_sad *sads;
 
 	if (!enabled) {
 		drm_atomic_bridge_chain_pre_enable(bridge, connector->state->state);
@@ -2053,7 +2052,11 @@ static struct edid *mtk_dp_get_edid(stru
 	}
 
 	if (new_edid) {
+		struct cea_sad *sads;
+
 		audio_caps->sad_count = drm_edid_to_sad(new_edid, &sads);
+		kfree(sads);
+
 		audio_caps->detect_monitor = drm_detect_monitor_audio(new_edid);
 	}
 


