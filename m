Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8A92798E6;
	Tue, 27 May 2025 17:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365836; cv=none; b=hQioOwYOnDLyhEbEsChDW7Y1G9FkS0h61Yl7ljwaTGMZAMF8rT1hSYndvklThVWe+FSJ5beN5RQxOeWhVeZUWWyOSEgl7EgugZ72DmIbnKQ8f14UDCyAJKgnKUqOn7cQyXeaEt9TvFo/oxG3HU48K3TwMcT0E4/TJcOPrUKhleM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365836; c=relaxed/simple;
	bh=LsERmwYXHy0uTssGmFM9/Ovka9KADOhnZjr3/mmyHsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xp7ERtXZ6Qxy76HOp5soPDHp6XeFLjaKmJuNMxuLDHr+1Lvg59NViRNpU4p2AbPgQmM9JeFsFn81VEN+WGv0Ijpi34IkqR42cRe9IgD5aXOHT9tQJGmFxsY2piqa1AbuAdKHy80IN0e8KWZNKkGR7o1/lSod9fli9OoE2f6IoIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyNZrlOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyNZrlOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435CCC4CEE9;
	Tue, 27 May 2025 17:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365835;
	bh=LsERmwYXHy0uTssGmFM9/Ovka9KADOhnZjr3/mmyHsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PyNZrlOYRk2h/4+Wi5p3ATqG/k9bV6R7DfVpRvKpyukRou5XiuW3L2kn2XhWDAtBI
	 7TSoJuH/rmtySB1qed6s8Msjhi1E6odHvURbJntUAp0WKUrSGzVX8vZrM8tDsj0rC4
	 2rJ6R3zgBnPzVH8YkHBzI6UaTEoM/SSje+YPPJmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 504/626] drm: Add valid clones check
Date: Tue, 27 May 2025 18:26:37 +0200
Message-ID: <20250527162505.449368662@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jessica Zhang <quic_jesszhan@quicinc.com>

[ Upstream commit 41b4b11da02157c7474caf41d56baae0e941d01a ]

Check that all encoders attached to a given CRTC are valid
possible_clones of each other.

Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241216-concurrent-wb-v4-3-fe220297a7f0@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_helper.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 32902f77f00dd..40e4e1b6c9110 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -574,6 +574,30 @@ mode_valid(struct drm_atomic_state *state)
 	return 0;
 }
 
+static int drm_atomic_check_valid_clones(struct drm_atomic_state *state,
+					 struct drm_crtc *crtc)
+{
+	struct drm_encoder *drm_enc;
+	struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state,
+									  crtc);
+
+	drm_for_each_encoder_mask(drm_enc, crtc->dev, crtc_state->encoder_mask) {
+		if (!drm_enc->possible_clones) {
+			DRM_DEBUG("enc%d possible_clones is 0\n", drm_enc->base.id);
+			continue;
+		}
+
+		if ((crtc_state->encoder_mask & drm_enc->possible_clones) !=
+		    crtc_state->encoder_mask) {
+			DRM_DEBUG("crtc%d failed valid clone check for mask 0x%x\n",
+				  crtc->base.id, crtc_state->encoder_mask);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * drm_atomic_helper_check_modeset - validate state object for modeset changes
  * @dev: DRM device
@@ -745,6 +769,10 @@ drm_atomic_helper_check_modeset(struct drm_device *dev,
 		ret = drm_atomic_add_affected_planes(state, crtc);
 		if (ret != 0)
 			return ret;
+
+		ret = drm_atomic_check_valid_clones(state, crtc);
+		if (ret != 0)
+			return ret;
 	}
 
 	/*
-- 
2.39.5



