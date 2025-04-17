Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615432550C2;
	Thu, 17 Apr 2025 18:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913849; cv=none; b=LdyUcU/jOQBbAUc7QvKFhOe4Pbj5nw66AWqk9KpsRxJ2q7ATFdHpC+ortN0YMqRxjmePl8WCszUolcvnTS50Ki6eVvFqdzsbtlcJPX61KusaR+Ee3wwAkccHzOFW++mF/KcZiTXuuZ2j/bFztYlpMeLfo+tZkzIMX6QmXKjyP9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913849; c=relaxed/simple;
	bh=oH7NXlwmno11KMK8DoREU7QSEBKeUkUGFXhDKIC8xFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLHc0P758+R23UTdI6yWkSP4xxOJDZWDg6CNGuUH2oKmIC8gJK6Bwy/jkcQdw1gA57SmXUCpgkQnzTC+awVzelXo+mD9jx23ck4FDF+0h0UZUv3Sjry3cFjardViF5JAKkzJ4WbbbmB6sFwGgbTl1PnxjDhaBDAnfuAUCNRW7cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrJunlLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrJunlLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D63C4CEE4;
	Thu, 17 Apr 2025 18:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913849;
	bh=oH7NXlwmno11KMK8DoREU7QSEBKeUkUGFXhDKIC8xFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrJunlLkk1bO6NCB0vUnEBz+VuneHf3alvKQWER6eTGZn1Ks1LiFkt5yICX/aFHzj
	 i25Z+QXlGyOhmKOfizPg3qV/ZBpNlt+iYRbtdqxjP+4ofnz15f+PyC+3TyDyNDGM64
	 ECqazZ/vl3K2PrA/F9KvWxrUSh7OPTj8za3xKS+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@mailbox.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 023/414] drm/tests: modes: Fix drm_display_mode memory leak
Date: Thu, 17 Apr 2025 19:46:21 +0200
Message-ID: <20250417175112.350153613@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 6ed51f99e133c..7ba646d87856f 100644
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



