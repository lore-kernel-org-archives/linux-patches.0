Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B8C25F785;
	Thu, 17 Apr 2025 18:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915141; cv=none; b=VQXywmOjYRzovljOwEkfqPggqHOI80QkSydUAn0itAF/1JCKKVuTZgzroofcCQbNuDDV+67CSPjskVj5mZVpnz+blYZQL3DOW8deymuzdbTmsjZPmVoLieJj/n5VNudP3IMfraFC8EjNUfw7cWtFG/CW5xggUKTtE+JpWBQNOkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915141; c=relaxed/simple;
	bh=6UHw0PuPEAPreJLm6QLmNiZqFRJ2P9HLbJOGWh7qp/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qF0bC3OWTGlwG+bTObcsm6H951FGd/T3peqQap7n/deiUltOdZKWUiqlOT+PF0MvCxa9mWN0Who6zz4BDkjAEoGVeHMQ+FG4hSOOGL0v0eEYfau0347kx2SCEpSd+0GGuCBp951ZxDnC1hZ5lnW/IueYLAs/Hh6OdRVaYfyl/pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3RTUWda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3RTUWda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D770CC4CEE4;
	Thu, 17 Apr 2025 18:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915141;
	bh=6UHw0PuPEAPreJLm6QLmNiZqFRJ2P9HLbJOGWh7qp/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3RTUWdav0Qjnl1m5TovozZvUpwj2wbeSNRtlYqYCnD7N8qY0GiTerAJ5NRIIiyQw
	 FoekJW+C0gs2VEp9VzXVsRyeyhyhDuDlLgViKAd8BOwz+FS/I95vuUqGehYcy39QqN
	 uXUC/dVob8umPHqWx369ZwuTturt5UL2QBblStRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/393] drm/tests: helpers: Create kunit helper to destroy a drm_display_mode
Date: Thu, 17 Apr 2025 19:47:13 +0200
Message-ID: <20250417175108.563109293@linuxfoundation.org>
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



