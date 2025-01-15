Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB30F248BA0;
	Wed, 15 Jan 2025 10:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937720; cv=none; b=u/xmpsVQWG6vSBkBOKfmVtPLYi3DOSOehys81mUzDCS8R1VZyH3kfGeEgboC/7tMmoEymKF65S97CbEiX6aPwstbUKCAhVRNhvCLsbGZhT7K+fjPXXPRyfqd80RFSWUOxC5+FoUGBbM7n+q09RZAvCYXFY3C1GmY3GkuBx2Lzj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937720; c=relaxed/simple;
	bh=mKbR9tM6wfOi8z79pB7sT4YCnyxGajkSGC+iwYj9ie0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NU/qu9e0pbZi4+iHQVDFbhcIoPHBzF1OR5o9M/CBPG1Qp6FVcze6tUUPjSmA2SPXnhLQv3PAQNv0sINBULO7R7z1CM1p2iggFhsqJI9Km7RvqEAfPn84Gkq0cK3NTvbDMAVDoKaUdCGPnVJ32WXam4mk7pPKiZIEb55Gyaz4W74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtrtgSwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtrtgSwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0C5C4CEE3;
	Wed, 15 Jan 2025 10:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937720;
	bh=mKbR9tM6wfOi8z79pB7sT4YCnyxGajkSGC+iwYj9ie0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtrtgSwd2sDjLGSBJOQOojcPby9FStj6ZLNYzIrCUZ0k636nRA7tp8n9ezn9ze5Xi
	 wkczLtUphCe3+4COXXJ7p+g/0uK5WlUih9DXuI5spohAr91xnVGGaqsn0lBcN8nB+t
	 +TWeqUK1r05WW5MckvkzQvSVs+2XA7H5HMFlG6jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liankun Yang <liankun.yang@mediatek.com>,
	Guillaume Ranquet <granquet@baylibre.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/92] drm/mediatek: Add return value check when reading DPCD
Date: Wed, 15 Jan 2025 11:36:49 +0100
Message-ID: <20250115103548.767739539@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Liankun Yang <liankun.yang@mediatek.com>

[ Upstream commit 522908140645865dc3e2fac70fd3b28834dfa7be ]

Check the return value of drm_dp_dpcd_readb() to confirm that
AUX communication is successful. To simplify the code, replace
drm_dp_dpcd_readb() and DP_GET_SINK_COUNT() with drm_dp_read_sink_count().

Fixes: f70ac097a2cf ("drm/mediatek: Add MT8195 Embedded DisplayPort driver")
Signed-off-by: Liankun Yang <liankun.yang@mediatek.com>
Reviewed-by: Guillaume Ranquet <granquet@baylibre.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20241218113448.2992-1-liankun.yang@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dp.c b/drivers/gpu/drm/mediatek/mtk_dp.c
index 09a496588b50..6bf50a15c9b4 100644
--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -1952,7 +1952,6 @@ static enum drm_connector_status mtk_dp_bdg_detect(struct drm_bridge *bridge)
 	struct mtk_dp *mtk_dp = mtk_dp_from_bridge(bridge);
 	enum drm_connector_status ret = connector_status_disconnected;
 	bool enabled = mtk_dp->enabled;
-	u8 sink_count = 0;
 
 	if (!mtk_dp->train_info.cable_plugged_in)
 		return ret;
@@ -1974,8 +1973,8 @@ static enum drm_connector_status mtk_dp_bdg_detect(struct drm_bridge *bridge)
 	 * function, we just need to check the HPD connection to check
 	 * whether we connect to a sink device.
 	 */
-	drm_dp_dpcd_readb(&mtk_dp->aux, DP_SINK_COUNT, &sink_count);
-	if (DP_GET_SINK_COUNT(sink_count))
+
+	if (drm_dp_read_sink_count(&mtk_dp->aux) > 0)
 		ret = connector_status_connected;
 
 	if (!enabled) {
-- 
2.39.5



