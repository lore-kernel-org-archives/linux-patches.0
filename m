Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C712263F54;
	Wed, 23 Apr 2025 14:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419945; cv=none; b=k17++8qBW2/MEzr9mU+dFA3VzrHjpBUTV2Dl/cjdbVCNKV8ZIxM83oQ3qTvrGoLxiIcnsndchRnjyWgU84ienylF+9bRwKl35MhheIbTDlgFOT8aBVYsSK5my8fZ9yuQKwnxWSLXOXIpsgjgz/7JcWweIm5d5UR561wJm24hScU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419945; c=relaxed/simple;
	bh=1Y7cfDpjU0HAvY5+vkrHryANsdPwfyEO6CCvSMF/njk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTEuN5uv/qg1R922b80NPrLY+EKDryLNjcVFOeEIOrwokRsZ3NSo5NgrpM9+M1dpnYN5cbZCXbUcP8oX5YiOw8F7zd6nxHDm+LY8s6mhGYL0zF0Y1t1C9cKf57OYzDeEfLgwVyA7J50cGa4vQeETDzs5YlVwbHc4BLd41dVWzmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vi86x0v4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vi86x0v4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0757C4CEE2;
	Wed, 23 Apr 2025 14:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419945;
	bh=1Y7cfDpjU0HAvY5+vkrHryANsdPwfyEO6CCvSMF/njk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vi86x0v4uHYPmTsD5rDfl4h7LmKJCDjeZU89rO5C8F6CK4B4iZaY8xgFgfLDkbUlL
	 iP5/STJkqnEUnCzLS9dfLUMqiDy7NlHyOkrZDp9KgWNrqPL3b0aRV7oAVhUa11Hefv
	 Ay+bSdeQ7PRGhfZ8rmo7OSBXvcy3dsvBmSl4zHWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/393] drm/tests: helpers: Create kunit helper to destroy a drm_display_mode
Date: Wed, 23 Apr 2025 16:38:39 +0200
Message-ID: <20250423142644.220166239@linuxfoundation.org>
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
index 12d58353a54ef..04d98f81c5227 100644
--- a/drivers/gpu/drm/tests/drm_kunit_helpers.c
+++ b/drivers/gpu/drm/tests/drm_kunit_helpers.c
@@ -391,6 +391,28 @@ static void kunit_action_drm_mode_destroy(void *ptr)
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
index 3e5f4a23685ef..07e9a451262b6 100644
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



