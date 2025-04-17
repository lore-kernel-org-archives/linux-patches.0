Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796048462;
	Thu, 17 Apr 2025 18:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915210; cv=none; b=MWDg9JmIABLKiHAYR0E0eN1egGJwmuQgxAXL7s3yW9xCCBBiwUaF6WF2bfh/Et5y2Ajf7fgX+Qp/EA2pbGUHX9WY7Jassznoh7hXGyU07Fnd67hj6DXXbTO/dNablET4JeW9/NSq6es1adh0g6O70h3ioLCtxt9LprsmctKD0mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915210; c=relaxed/simple;
	bh=tkUViCoUAXEiqqBkNenO5l9wG/9Lhr10TKzA2Lt+8bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daJ0UEcTUHx05iYVxLuWid3K3bUtG/M1Zx5hKQNUJqWM9C+NkG8U8e4qLAhHrPExLqWgz/XDt77X7k2yGZu5cSw7+X0cHPVMvnD+Sv1PVsaBOA5wAhdhCUgafXy6L+PtkqpMAVk13t1GjpzTcfI5WHEiY2aTKFd81/aLvtKhG4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EN3LKfru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EN3LKfru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EDDC4CEE4;
	Thu, 17 Apr 2025 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915210;
	bh=tkUViCoUAXEiqqBkNenO5l9wG/9Lhr10TKzA2Lt+8bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EN3LKfruKnxTED7vE220OgfgldySQwQiL6sqlbaa9nrQK9mmFulXsDX2OuSlB/Ci1
	 lGZ0l9MhPCaNYhTTeZ6jJHVbd8ulG4OVlv+btcXtjfD/ecnEhUs+D/lLrelZkbLB52
	 JZj1cJCfsiC0I4kiGJC43QJ316VJU12ZHTkS3zRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@mailbox.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/393] drm/tests: modes: Fix drm_display_mode memory leak
Date: Thu, 17 Apr 2025 19:47:15 +0200
Message-ID: <20250417175108.643506021@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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



