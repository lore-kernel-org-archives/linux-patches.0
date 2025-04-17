Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B872566FF;
	Thu, 17 Apr 2025 17:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912481; cv=none; b=WmBtJoucp8+mMCQ13fZA1MHiR2ob+ZaNMn52e9bP+uSGF7expWRSW6l1zVfI5ihDKbC2L+T5aX/AVLCXPGTyQIfYEzfO70bbRVp9gSPeBwcyabtIc4gfF111a+nDUix/uiKM114Ql0ERxj5MGQyRUMFh19UIYre3VMlSkjUWPAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912481; c=relaxed/simple;
	bh=R9iLK3N+RibuY06V/TnrYTYevm6Yn4vUVSkfRFQlrrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0AekW6DkaEtx+bUI14MlPVSpiFFu7E6fyJZvDEOIM4H6ZzN1RctZGssGBVSxz6Ycn+m4+xgfNjXA8rb8mQvJByEo1wD5Lb7494dR+xGg5+Ku7AYk6EVxTM8NFAn8hPCKMtKbGL9H5Tc31rybs1RS8i0l4D7AXW8N9TafGVp6kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjLFIukK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjLFIukK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB618C4CEE4;
	Thu, 17 Apr 2025 17:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912481;
	bh=R9iLK3N+RibuY06V/TnrYTYevm6Yn4vUVSkfRFQlrrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjLFIukKLMavEaxmqIBHMp8WmO73RiVPORT+vpCShOzVSMJQSLBTkt3PMax8hubMA
	 RFAwquywzN3yZ76dxUVpIm2wm+dyS4SjUV6cPrYHUjuCy5bnV6Rs+ubBDqXBisoCbR
	 WYLG2vDpVukleGdQVCK38ehyVSD+Mmf1ifGbN7i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 024/449] drm/tests: helpers: Create kunit helper to destroy a drm_display_mode
Date: Thu, 17 Apr 2025 19:45:12 +0200
Message-ID: <20250417175118.972139618@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit 13c1d5f3a7fa7b55a26e73bb9e95342374a489b2 ]

A number of test suites call functions that expect the returned
drm_display_mode to be destroyed eventually.

However, none of the tests called drm_mode_destroy, which results in a
memory leak.

Since drm_mode_destroy takes two pointers as argument, we can't use a
kunit wrapper. Let's just create a helper every test suite can use.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250408-drm-kunit-drm-display-mode-memleak-v1-1-996305a2e75a@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Stable-dep-of: 70f29ca3117a ("drm/tests: cmdline: Fix drm_display_mode memory leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_kunit_helpers.c | 22 ++++++++++++++++++++++
 include/drm/drm_kunit_helpers.h           |  3 +++
 2 files changed, 25 insertions(+)

diff --git a/drivers/gpu/drm/tests/drm_kunit_helpers.c b/drivers/gpu/drm/tests/drm_kunit_helpers.c
index 3c0b7824c0be3..922c4b6ed1dc9 100644
--- a/drivers/gpu/drm/tests/drm_kunit_helpers.c
+++ b/drivers/gpu/drm/tests/drm_kunit_helpers.c
@@ -319,6 +319,28 @@ static void kunit_action_drm_mode_destroy(void *ptr)
 	drm_mode_destroy(NULL, mode);
 }
 
+/**
+ * drm_kunit_add_mode_destroy_action() - Add a drm_destroy_mode kunit action
+ * @test: The test context object
+ * @mode: The drm_display_mode to destroy eventually
+ *
+ * Registers a kunit action that will destroy the drm_display_mode at
+ * the end of the test.
+ *
+ * If an error occurs, the drm_display_mode will be destroyed.
+ *
+ * Returns:
+ * 0 on success, an error code otherwise.
+ */
+int drm_kunit_add_mode_destroy_action(struct kunit *test,
+				      struct drm_display_mode *mode)
+{
+	return kunit_add_action_or_reset(test,
+					 kunit_action_drm_mode_destroy,
+					 mode);
+}
+EXPORT_SYMBOL_GPL(drm_kunit_add_mode_destroy_action);
+
 /**
  * drm_kunit_display_mode_from_cea_vic() - return a mode for CEA VIC for a KUnit test
  * @test: The test context object
diff --git a/include/drm/drm_kunit_helpers.h b/include/drm/drm_kunit_helpers.h
index afdd46ef04f70..c835f113055dc 100644
--- a/include/drm/drm_kunit_helpers.h
+++ b/include/drm/drm_kunit_helpers.h
@@ -120,6 +120,9 @@ drm_kunit_helper_create_crtc(struct kunit *test,
 			     const struct drm_crtc_funcs *funcs,
 			     const struct drm_crtc_helper_funcs *helper_funcs);
 
+int drm_kunit_add_mode_destroy_action(struct kunit *test,
+				      struct drm_display_mode *mode);
+
 struct drm_display_mode *
 drm_kunit_display_mode_from_cea_vic(struct kunit *test, struct drm_device *dev,
 				    u8 video_code);
-- 
2.39.5



