Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE11279DB6;
	Tue, 12 Aug 2025 19:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025638; cv=none; b=qpSI6XqGI9cE1hCJ8At/ZM1kPhXe7uGqOvfVYoq+1ZkLPMHtbmYj65bQHkcy29QFl4q1FWlWod9sDiNC7edakHc/+jehm8TSMTNm3ckD7UzsvyswVwLtM2cLGqKvQOTasKkP0RHSCscNDgaZHROjzE4lAIfzQDjRA9UcZUTXB/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025638; c=relaxed/simple;
	bh=Yp+8wKnCrXKeEfNZFe2Jn4Wn6Xp+X+V8r6qBlt9W2eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arum2yV4TXus2eW+6eIm9N1ZjrJyXuVtAImzL+SvdlimZmnMzv0W9sqmfiGxJQS2OqeJYrFUfsO+z8nQ1jx4kJ51e6rMWESASSC+Ercg+Wta4Fd4PIfWXZLsfGrJ3d4qtTH5ESBx+7B0xXcoAqq4pqOHJwpPfFQ0JQdjIPU/2Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiHzIUxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiHzIUxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C177EC4CEF0;
	Tue, 12 Aug 2025 19:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025638;
	bh=Yp+8wKnCrXKeEfNZFe2Jn4Wn6Xp+X+V8r6qBlt9W2eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JiHzIUxARDX4HVt5gm8lHbGNAd3Qypoi2jWCGAhlnYM3bReZor3HgXQHe2fiS9xC5
	 BFs+PUFFTq74TZ0XP8Lxh0oMW6ASGP9xyUG0Va88i4PgeP5l+rfqG7uKNbHXyPedOX
	 Uf2qCBDt2GsFXYK1MOPLPbHajUsRwppiz7GoWAkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <lumag@kernel.org>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 100/480] drm/connector: hdmi: Evaluate limited range after computing format
Date: Tue, 12 Aug 2025 19:45:08 +0200
Message-ID: <20250812174401.588533505@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 21f627139652dd8329a88e281df6600f3866d238 ]

Evaluating the requirement to use a limited RGB quantization range
involves a verification of the output format, among others, but this is
currently performed before actually computing the format, hence relying
on the old connector state.

Move the call to hdmi_is_limited_range() after hdmi_compute_config() to
ensure the verification is done on the updated output format.

Fixes: 027d43590649 ("drm/connector: hdmi: Add RGB Quantization Range to the connector state")
Reviewed-by: Dmitry Baryshkov <lumag@kernel.org>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/r/20250527-hdmi-conn-yuv-v5-1-74c9c4a8ac0c@collabora.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_hdmi_state_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/display/drm_hdmi_state_helper.c b/drivers/gpu/drm/display/drm_hdmi_state_helper.c
index c205f37da1e1..6bc96d5d1ab9 100644
--- a/drivers/gpu/drm/display/drm_hdmi_state_helper.c
+++ b/drivers/gpu/drm/display/drm_hdmi_state_helper.c
@@ -506,12 +506,12 @@ int drm_atomic_helper_connector_hdmi_check(struct drm_connector *connector,
 	if (!new_conn_state->crtc || !new_conn_state->best_encoder)
 		return 0;
 
-	new_conn_state->hdmi.is_limited_range = hdmi_is_limited_range(connector, new_conn_state);
-
 	ret = hdmi_compute_config(connector, new_conn_state, mode);
 	if (ret)
 		return ret;
 
+	new_conn_state->hdmi.is_limited_range = hdmi_is_limited_range(connector, new_conn_state);
+
 	ret = hdmi_generate_infoframes(connector, new_conn_state);
 	if (ret)
 		return ret;
-- 
2.39.5



