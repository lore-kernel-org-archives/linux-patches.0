Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0308133066C;
	Mon, 29 Dec 2025 16:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025130; cv=none; b=DL4mHYc1Kgi428ACr7Gp6GOe7S9h0DP1KbGa0YPVaq+09riAtNDJhEWIQ0u+rhiYDei8MxAf9gSh5H0L03HGFW9HRFKuBSMyPEKxZt0BstN4L2ukTouthGwzcSXgNNU77PALS4IeCvwQXCgLUIziFQPqw1HwK+rlBXmrZ8moPA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025130; c=relaxed/simple;
	bh=vcBmnIjrIttE8snEE5D5fXXjRbpqsV2ix5xgy34Y0ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eDWxQsoSPFT8U0IAVWjS1uMYMNMPtZBnOO/wzSQX7oSHUDarJKKT/SfBf8bmQQnSlXUSv8l57pm4RGuwYlNck/hV/spksIGSJT7EAKrRavGAbo0hCLUZVFiIX7wjj6l4WFDIIVwmgrO+nln2bsyE7GiXzs3axHaH04nscrfJS04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmyrjVvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmyrjVvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DADC4CEF7;
	Mon, 29 Dec 2025 16:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025129;
	bh=vcBmnIjrIttE8snEE5D5fXXjRbpqsV2ix5xgy34Y0ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmyrjVvOFfMvGyBNuTNH4TMzqjKkwR5T4svcLBBLIUFFZYTNRHDv71dakXamMFNoD
	 NL+laf1CA4anv/q5ycoF3ysEs6Lv/rQvHkL4UdO/mXYSvFT/kRFwQ1YopL7mrsF9pf
	 eH3yipiuzyAcT7ZyOiUXX5tka6QKZDdfIPOEHHBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 105/430] drm/tests: hdmi: Handle drm_kunit_helper_enable_crtc_connector() returning EDEADLK
Date: Mon, 29 Dec 2025 17:08:27 +0100
Message-ID: <20251229160728.233497727@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit fe27e709d91fb645182751b602cb88966b4a1bb6 ]

Fedora/CentOS/RHEL CI is reporting intermittent failures while running
the KUnit tests present in drm_hdmi_state_helper_test.c [1].

While the specific test causing the failure change between runs, all of
them are caused by drm_kunit_helper_enable_crtc_connector() returning
-EDEADLK. The error trace always follow this structure:

    # <test name>: ASSERTION FAILED at
    # drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c:<line>
    Expected ret == 0, but
        ret == -35 (0xffffffffffffffdd)

As documented, if the drm_kunit_helper_enable_crtc_connector() function
returns -EDEADLK (-35), the entire atomic sequence must be restarted.

Handle this error code for all function calls.

Closes: https://datawarehouse.cki-project.org/issue/4039  [1]
Fixes: 6a5c0ad7e08e ("drm/tests: hdmi_state_helpers: Switch to new helper")
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Link: https://patch.msgid.link/20251104102258.10026-1-jose.exposito89@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/tests/drm_hdmi_state_helper_test.c    | 143 ++++++++++++++++++
 1 file changed, 143 insertions(+)

diff --git a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
index 8bd412735000..70f9aa702143 100644
--- a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
+++ b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
@@ -257,10 +257,16 @@ static void drm_test_check_broadcast_rgb_crtc_mode_changed(struct kunit *test)
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
@@ -326,10 +332,16 @@ static void drm_test_check_broadcast_rgb_crtc_mode_not_changed(struct kunit *tes
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
@@ -397,10 +409,16 @@ static void drm_test_check_broadcast_rgb_auto_cea_mode(struct kunit *test)
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
@@ -457,10 +475,17 @@ static void drm_test_check_broadcast_rgb_auto_cea_mode_vic_1(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	crtc = priv->crtc;
+
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     mode,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
@@ -518,10 +543,16 @@ static void drm_test_check_broadcast_rgb_full_cea_mode(struct kunit *test)
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
@@ -580,10 +611,17 @@ static void drm_test_check_broadcast_rgb_full_cea_mode_vic_1(struct kunit *test)
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	crtc = priv->crtc;
+
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     mode,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
@@ -643,10 +681,16 @@ static void drm_test_check_broadcast_rgb_limited_cea_mode(struct kunit *test)
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
@@ -705,10 +749,17 @@ static void drm_test_check_broadcast_rgb_limited_cea_mode_vic_1(struct kunit *te
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	crtc = priv->crtc;
+
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     mode,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
@@ -870,10 +921,16 @@ static void drm_test_check_output_bpc_crtc_mode_changed(struct kunit *test)
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
@@ -946,10 +1003,16 @@ static void drm_test_check_output_bpc_crtc_mode_not_changed(struct kunit *test)
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
@@ -1022,10 +1085,16 @@ static void drm_test_check_output_bpc_dvi(struct kunit *test)
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	conn_state = conn->state;
@@ -1069,10 +1138,16 @@ static void drm_test_check_tmds_char_rate_rgb_8bpc(struct kunit *test)
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	conn_state = conn->state;
@@ -1118,10 +1193,16 @@ static void drm_test_check_tmds_char_rate_rgb_10bpc(struct kunit *test)
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	conn_state = conn->state;
@@ -1167,10 +1248,16 @@ static void drm_test_check_tmds_char_rate_rgb_12bpc(struct kunit *test)
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	conn_state = conn->state;
@@ -1218,10 +1305,16 @@ static void drm_test_check_hdmi_funcs_reject_rate(struct kunit *test)
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	/* You shouldn't be doing that at home. */
@@ -1292,10 +1385,16 @@ static void drm_test_check_max_tmds_rate_bpc_fallback_rgb(struct kunit *test)
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
 	conn_state = conn->state;
@@ -1440,10 +1539,16 @@ static void drm_test_check_max_tmds_rate_bpc_fallback_ignore_yuv422(struct kunit
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
 	conn_state = conn->state;
@@ -1669,10 +1774,17 @@ static void drm_test_check_output_bpc_format_vic_1(struct kunit *test)
 	drm_modeset_acquire_init(&ctx, 0);
 
 	crtc = priv->crtc;
+
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     mode,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
 	conn_state = conn->state;
@@ -1736,10 +1848,16 @@ static void drm_test_check_output_bpc_format_driver_rgb_only(struct kunit *test)
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
 	conn_state = conn->state;
@@ -1805,10 +1923,16 @@ static void drm_test_check_output_bpc_format_display_rgb_only(struct kunit *test
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
 	conn_state = conn->state;
@@ -1865,10 +1989,16 @@ static void drm_test_check_output_bpc_format_driver_8bpc_only(struct kunit *test
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
 	conn_state = conn->state;
@@ -1927,10 +2057,16 @@ static void drm_test_check_output_bpc_format_display_8bpc_only(struct kunit *tes
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
 	conn_state = conn->state;
@@ -1970,10 +2106,17 @@ static void drm_test_check_disable_connector(struct kunit *test)
 
 	drm = &priv->drm;
 	crtc = priv->crtc;
+
+retry_conn_enable:
 	ret = drm_kunit_helper_enable_crtc_connector(test, drm,
 						     crtc, conn,
 						     preferred,
 						     &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_conn_enable;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
-- 
2.51.0



