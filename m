Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AD623D298;
	Wed, 23 Apr 2025 14:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419968; cv=none; b=pgYdWb4oH89QiBlWcUJybYRNAcafblwGn+Q3Ul2ILpj1C0wO1C5+w/y+4Jk5eo/HntRaKACD5jO541jECGu6o46vyrAcGQHVV45Iyfw5aXhszxL2Kv4xEk2t3KwYRQ0wHxPuaogD1lIcSGRYuxSQSknbr2RIpTvSmRHJgLtYCaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419968; c=relaxed/simple;
	bh=yrTjEN22SJbIWDsx5MSbOxrqqVrUMPcVce23kA6cUQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vd9errlqDwgju6utwt5/vYLu5ob0UfhcKaNx4FTY8WwfCYBpz211eR88Nq1GJbTSlCTNFqCJGZ61thkx7C9UCntukkfx4p6bkoxPHRS5JV+gxFv/1lV6k+kwFbiFo2mjudZ0WmDUIIFuBI1wr6iF8XydTfI7aY73hhtnMLbH0Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWqEChVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWqEChVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F2DC4CEE2;
	Wed, 23 Apr 2025 14:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419968;
	bh=yrTjEN22SJbIWDsx5MSbOxrqqVrUMPcVce23kA6cUQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWqEChVOjw9OGqM4KBU7JaH14mVf8Sr6OtpGUi7W4ZnLmWVJPlbyR32NxJy5uIj8p
	 4ObRYiVIPNQPzObdFsMTUwnR9q7y0FNFaBF3drh6yKiFVnXQaqHe5a0fnOs+E/lQoD
	 fko2Md7SPHRG241d72HSeohqHNVu03m6w0EfsjNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@mailbox.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/393] drm/tests: modes: Fix drm_display_mode memory leak
Date: Wed, 23 Apr 2025 16:38:41 +0200
Message-ID: <20250423142644.307848403@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit d34146340f95cd9bf06d4ce71cca72127dc0b7cd ]

drm_analog_tv_mode() and its variants return a drm_display_mode that
needs to be destroyed later one. The drm_modes_analog_tv tests never
do however, which leads to a memory leak.

Let's make sure it's freed.

Reported-by: Philipp Stanner <phasta@mailbox.org>
Closes: https://lore.kernel.org/dri-devel/a7655158a6367ac46194d57f4b7433ef0772a73e.camel@mailbox.org/
Fixes: 4fcd238560ee ("drm/modes: Add a function to generate analog display modes")
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250408-drm-kunit-drm-display-mode-memleak-v1-5-996305a2e75a@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_modes_test.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/tests/drm_modes_test.c b/drivers/gpu/drm/tests/drm_modes_test.c
index 1e9f63fbfead3..e23067252d18a 100644
--- a/drivers/gpu/drm/tests/drm_modes_test.c
+++ b/drivers/gpu/drm/tests/drm_modes_test.c
@@ -40,6 +40,7 @@ static void drm_test_modes_analog_tv_ntsc_480i(struct kunit *test)
 {
 	struct drm_test_modes_priv *priv = test->priv;
 	struct drm_display_mode *mode;
+	int ret;
 
 	mode = drm_analog_tv_mode(priv->drm,
 				  DRM_MODE_TV_MODE_NTSC,
@@ -47,6 +48,9 @@ static void drm_test_modes_analog_tv_ntsc_480i(struct kunit *test)
 				  true);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
+	ret = drm_kunit_add_mode_destroy_action(test, mode);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
 	KUNIT_EXPECT_EQ(test, drm_mode_vrefresh(mode), 60);
 	KUNIT_EXPECT_EQ(test, mode->hdisplay, 720);
 
@@ -70,6 +74,7 @@ static void drm_test_modes_analog_tv_ntsc_480i_inlined(struct kunit *test)
 {
 	struct drm_test_modes_priv *priv = test->priv;
 	struct drm_display_mode *expected, *mode;
+	int ret;
 
 	expected = drm_analog_tv_mode(priv->drm,
 				      DRM_MODE_TV_MODE_NTSC,
@@ -77,9 +82,15 @@ static void drm_test_modes_analog_tv_ntsc_480i_inlined(struct kunit *test)
 				      true);
 	KUNIT_ASSERT_NOT_NULL(test, expected);
 
+	ret = drm_kunit_add_mode_destroy_action(test, expected);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
 	mode = drm_mode_analog_ntsc_480i(priv->drm);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
+	ret = drm_kunit_add_mode_destroy_action(test, mode);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
 	KUNIT_EXPECT_TRUE(test, drm_mode_equal(expected, mode));
 }
 
@@ -87,6 +98,7 @@ static void drm_test_modes_analog_tv_pal_576i(struct kunit *test)
 {
 	struct drm_test_modes_priv *priv = test->priv;
 	struct drm_display_mode *mode;
+	int ret;
 
 	mode = drm_analog_tv_mode(priv->drm,
 				  DRM_MODE_TV_MODE_PAL,
@@ -94,6 +106,9 @@ static void drm_test_modes_analog_tv_pal_576i(struct kunit *test)
 				  true);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
+	ret = drm_kunit_add_mode_destroy_action(test, mode);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
 	KUNIT_EXPECT_EQ(test, drm_mode_vrefresh(mode), 50);
 	KUNIT_EXPECT_EQ(test, mode->hdisplay, 720);
 
@@ -117,6 +132,7 @@ static void drm_test_modes_analog_tv_pal_576i_inlined(struct kunit *test)
 {
 	struct drm_test_modes_priv *priv = test->priv;
 	struct drm_display_mode *expected, *mode;
+	int ret;
 
 	expected = drm_analog_tv_mode(priv->drm,
 				      DRM_MODE_TV_MODE_PAL,
@@ -124,9 +140,15 @@ static void drm_test_modes_analog_tv_pal_576i_inlined(struct kunit *test)
 				      true);
 	KUNIT_ASSERT_NOT_NULL(test, expected);
 
+	ret = drm_kunit_add_mode_destroy_action(test, expected);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
 	mode = drm_mode_analog_pal_576i(priv->drm);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
+	ret = drm_kunit_add_mode_destroy_action(test, mode);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
 	KUNIT_EXPECT_TRUE(test, drm_mode_equal(expected, mode));
 }
 
-- 
2.39.5



