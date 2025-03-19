Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4601C5F26;
	Wed, 19 Mar 2025 14:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395064; cv=none; b=DRWS7wwwmwQ2jcO21GESu5zUMdocv/TQKMb+OPVtGxvL36ZAW8MiAqs11mSX/y1Penxro/NwIkh4MSq/H0GIyimzpvE1iWm9bxjgkHj1CVhiZPGmeCK8wGJUbYfgwb3Xd1EWu2b3S/gUkW4/ayZpd8PEoXtea42QihQiFrmzvOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395064; c=relaxed/simple;
	bh=+ebAWWW1RYZcUY4k+8WfuOF0W/hMAn3wCnDksQtlZtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVok8R5he46vATMMUTV6zaI2YbyJo1lrio8HSEzg52K+Ya1lzMU6ef2dpNWLQ223cZzYVRGgyTZ7Wmr4mN6EB7VgfzfFzLKTc/d2LgcWbPRpKBdCnwWVwYgCytLlo8wGkdV0qG/WLop7HJR7oIrWkAQRSDZiw4yATpgdnD8bdwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VreW+NXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VreW+NXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A015CC4CEE4;
	Wed, 19 Mar 2025 14:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395064;
	bh=+ebAWWW1RYZcUY4k+8WfuOF0W/hMAn3wCnDksQtlZtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VreW+NXkWlt2ihwzqYRkOsf6LjbvIO0hwAVRktd1d/4DNObnQF9trVV5XB5ddGKzF
	 JoVwfmuGDq1gLt7dcBkoahbQwIuVbteRCsR4ktuQ5ez1eyoL3Ma+RCa4sGT+fVlozR
	 BpmtWdbN3kTvauHIQXKCuWLnlpSGMF2hMvUWUZ9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/231] drm/tests: hdmi: Reorder DRM entities variables assignment
Date: Wed, 19 Mar 2025 07:29:53 -0700
Message-ID: <20250319143029.310228310@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit 6b6bfd63e1626ceedc738b2a06505aa5b46c1481 ]

The tests all deviate slightly in how they assign their local pointers
to DRM entities. This makes refactoring pretty difficult, so let's just
move the assignment as soon as the entities are allocated.

Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20250129-test-kunit-v2-3-fe59c43805d5@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/tests/drm_hdmi_state_helper_test.c    | 81 ++++++++++---------
 1 file changed, 42 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
index 4e7369caa7369..1dfd346c6fb39 100644
--- a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
+++ b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
@@ -258,15 +258,16 @@ static void drm_test_check_broadcast_rgb_crtc_mode_changed(struct kunit *test)
 						     8);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
+	conn = &priv->connector;
+
 	ctx = drm_kunit_helper_acquire_ctx_alloc(test);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
 
-	conn = &priv->connector;
 	preferred = find_preferred_mode(conn);
 	KUNIT_ASSERT_NOT_NULL(test, preferred);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
@@ -321,15 +322,16 @@ static void drm_test_check_broadcast_rgb_crtc_mode_not_changed(struct kunit *tes
 						     8);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
+	conn = &priv->connector;
+
 	ctx = drm_kunit_helper_acquire_ctx_alloc(test);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
 
-	conn = &priv->connector;
 	preferred = find_preferred_mode(conn);
 	KUNIT_ASSERT_NOT_NULL(test, preferred);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
@@ -384,6 +386,8 @@ static void drm_test_check_broadcast_rgb_auto_cea_mode(struct kunit *test)
 						     8);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	KUNIT_ASSERT_TRUE(test, conn->display_info.is_hdmi);
 
@@ -394,8 +398,6 @@ static void drm_test_check_broadcast_rgb_auto_cea_mode(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, preferred);
 	KUNIT_ASSERT_NE(test, drm_match_cea_mode(preferred), 1);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
@@ -495,6 +497,8 @@ static void drm_test_check_broadcast_rgb_full_cea_mode(struct kunit *test)
 						     8);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	KUNIT_ASSERT_TRUE(test, conn->display_info.is_hdmi);
 
@@ -505,8 +509,6 @@ static void drm_test_check_broadcast_rgb_full_cea_mode(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, preferred);
 	KUNIT_ASSERT_NE(test, drm_match_cea_mode(preferred), 1);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
@@ -610,6 +612,8 @@ static void drm_test_check_broadcast_rgb_limited_cea_mode(struct kunit *test)
 						     8);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	KUNIT_ASSERT_TRUE(test, conn->display_info.is_hdmi);
 
@@ -620,8 +624,6 @@ static void drm_test_check_broadcast_rgb_limited_cea_mode(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, preferred);
 	KUNIT_ASSERT_NE(test, drm_match_cea_mode(preferred), 1);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
@@ -727,6 +729,8 @@ static void drm_test_check_output_bpc_crtc_mode_changed(struct kunit *test)
 						     10);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	ret = set_connector_edid(test, conn,
 				 test_edid_hdmi_1080p_rgb_yuv_dc_max_200mhz,
@@ -739,8 +743,6 @@ static void drm_test_check_output_bpc_crtc_mode_changed(struct kunit *test)
 	preferred = find_preferred_mode(conn);
 	KUNIT_ASSERT_NOT_NULL(test, preferred);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
@@ -801,6 +803,8 @@ static void drm_test_check_output_bpc_crtc_mode_not_changed(struct kunit *test)
 						     10);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	ret = set_connector_edid(test, conn,
 				 test_edid_hdmi_1080p_rgb_yuv_dc_max_200mhz,
@@ -813,8 +817,6 @@ static void drm_test_check_output_bpc_crtc_mode_not_changed(struct kunit *test)
 	preferred = find_preferred_mode(conn);
 	KUNIT_ASSERT_NOT_NULL(test, preferred);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
@@ -872,6 +874,8 @@ static void drm_test_check_output_bpc_dvi(struct kunit *test)
 						     12);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	ret = set_connector_edid(test, conn,
 				 test_edid_dvi_1080p,
@@ -887,8 +891,6 @@ static void drm_test_check_output_bpc_dvi(struct kunit *test)
 	preferred = find_preferred_mode(conn);
 	KUNIT_ASSERT_NOT_NULL(test, preferred);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
@@ -919,6 +921,8 @@ static void drm_test_check_tmds_char_rate_rgb_8bpc(struct kunit *test)
 						     8);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	ret = set_connector_edid(test, conn,
 				 test_edid_hdmi_1080p_rgb_max_200mhz,
@@ -932,8 +936,6 @@ static void drm_test_check_tmds_char_rate_rgb_8bpc(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, preferred);
 	KUNIT_ASSERT_FALSE(test, preferred->flags & DRM_MODE_FLAG_DBLCLK);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
@@ -966,6 +968,8 @@ static void drm_test_check_tmds_char_rate_rgb_10bpc(struct kunit *test)
 						     10);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	ret = set_connector_edid(test, conn,
 				 test_edid_hdmi_1080p_rgb_yuv_dc_max_340mhz,
@@ -979,8 +983,6 @@ static void drm_test_check_tmds_char_rate_rgb_10bpc(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, preferred);
 	KUNIT_ASSERT_FALSE(test, preferred->flags & DRM_MODE_FLAG_DBLCLK);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
@@ -1013,6 +1015,8 @@ static void drm_test_check_tmds_char_rate_rgb_12bpc(struct kunit *test)
 						     12);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	ret = set_connector_edid(test, conn,
 				 test_edid_hdmi_1080p_rgb_yuv_dc_max_340mhz,
@@ -1026,8 +1030,6 @@ static void drm_test_check_tmds_char_rate_rgb_12bpc(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, preferred);
 	KUNIT_ASSERT_FALSE(test, preferred->flags & DRM_MODE_FLAG_DBLCLK);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
@@ -1064,15 +1066,16 @@ static void drm_test_check_hdmi_funcs_reject_rate(struct kunit *test)
 						     8);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
+	conn = &priv->connector;
+
 	ctx = drm_kunit_helper_acquire_ctx_alloc(test);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
 
-	conn = &priv->connector;
 	preferred = find_preferred_mode(conn);
 	KUNIT_ASSERT_NOT_NULL(test, preferred);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
@@ -1120,6 +1123,8 @@ static void drm_test_check_max_tmds_rate_bpc_fallback(struct kunit *test)
 						     12);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	ret = set_connector_edid(test, conn,
 				 test_edid_hdmi_1080p_rgb_yuv_dc_max_200mhz,
@@ -1143,8 +1148,6 @@ static void drm_test_check_max_tmds_rate_bpc_fallback(struct kunit *test)
 	rate = drm_hdmi_compute_mode_clock(preferred, 10, HDMI_COLORSPACE_RGB);
 	KUNIT_ASSERT_LT(test, rate, info->max_tmds_clock * 1000);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
@@ -1189,6 +1192,8 @@ static void drm_test_check_max_tmds_rate_format_fallback(struct kunit *test)
 						     12);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	ret = set_connector_edid(test, conn,
 				 test_edid_hdmi_1080p_rgb_yuv_dc_max_200mhz,
@@ -1215,8 +1220,6 @@ static void drm_test_check_max_tmds_rate_format_fallback(struct kunit *test)
 	rate = drm_hdmi_compute_mode_clock(preferred, 12, HDMI_COLORSPACE_YUV422);
 	KUNIT_ASSERT_LT(test, rate, info->max_tmds_clock * 1000);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
@@ -1312,6 +1315,8 @@ static void drm_test_check_output_bpc_format_driver_rgb_only(struct kunit *test)
 						     12);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	ret = set_connector_edid(test, conn,
 				 test_edid_hdmi_1080p_rgb_yuv_dc_max_200mhz,
@@ -1343,8 +1348,6 @@ static void drm_test_check_output_bpc_format_driver_rgb_only(struct kunit *test)
 	rate = drm_hdmi_compute_mode_clock(preferred, 12, HDMI_COLORSPACE_YUV422);
 	KUNIT_ASSERT_LT(test, rate, info->max_tmds_clock * 1000);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
@@ -1379,6 +1382,8 @@ static void drm_test_check_output_bpc_format_display_rgb_only(struct kunit *test
 						     12);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	ret = set_connector_edid(test, conn,
 				 test_edid_hdmi_1080p_rgb_max_200mhz,
@@ -1410,8 +1415,6 @@ static void drm_test_check_output_bpc_format_display_rgb_only(struct kunit *test
 	rate = drm_hdmi_compute_mode_clock(preferred, 12, HDMI_COLORSPACE_YUV422);
 	KUNIT_ASSERT_LT(test, rate, info->max_tmds_clock * 1000);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
@@ -1445,6 +1448,8 @@ static void drm_test_check_output_bpc_format_driver_8bpc_only(struct kunit *test
 						     8);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	ret = set_connector_edid(test, conn,
 				 test_edid_hdmi_1080p_rgb_yuv_dc_max_340mhz,
@@ -1468,8 +1473,6 @@ static void drm_test_check_output_bpc_format_driver_8bpc_only(struct kunit *test
 	rate = drm_hdmi_compute_mode_clock(preferred, 12, HDMI_COLORSPACE_RGB);
 	KUNIT_ASSERT_LT(test, rate, info->max_tmds_clock * 1000);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
@@ -1505,6 +1508,8 @@ static void drm_test_check_output_bpc_format_display_8bpc_only(struct kunit *tes
 						     12);
 	KUNIT_ASSERT_NOT_NULL(test, priv);
 
+	drm = &priv->drm;
+	crtc = priv->crtc;
 	conn = &priv->connector;
 	ret = set_connector_edid(test, conn,
 				 test_edid_hdmi_1080p_rgb_max_340mhz,
@@ -1528,8 +1533,6 @@ static void drm_test_check_output_bpc_format_display_8bpc_only(struct kunit *tes
 	rate = drm_hdmi_compute_mode_clock(preferred, 12, HDMI_COLORSPACE_RGB);
 	KUNIT_ASSERT_LT(test, rate, info->max_tmds_clock * 1000);
 
-	drm = &priv->drm;
-	crtc = priv->crtc;
 	ret = light_up_connector(test, drm, crtc, conn, preferred, ctx);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
-- 
2.39.5



