Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705785674E;
	Wed, 23 Apr 2025 14:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419929; cv=none; b=EzAYYDVnmM1xoM5CXW1PBFk9+oy4YqAj/UFY/o3rTS6gNObdiT+L/L9oaCgrBYNJOVb+zL/opvJqpjPK7R5YHN5Z79u98EhJ8BYIXbC6A6jt5ED75cPqjb0E+fUtgV//cpseFwJp4XSY34CXw3QRO9eiWfibbV02aeDGn/Kvrh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419929; c=relaxed/simple;
	bh=w52cHdtaQ/a2EmCwXuIN1wXw0vbMOMZEKC6W2/XjuTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbktBllr88IuodVg9H5VCjGVORtZErOtCoOGnNw2JbYu8eBCpAteTziUEcBvglxOYsqJ7pbHm2fGE86YpYtB6UBvVyIQmb7PgUFjYGyyzU2rWEwSppAWclMrOHxbwZ158vGgYFpW27F+o75oEDAimtx2PB7KF8lO2lpf+qJyvOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1ucUwFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1ucUwFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04354C4CEE2;
	Wed, 23 Apr 2025 14:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419929;
	bh=w52cHdtaQ/a2EmCwXuIN1wXw0vbMOMZEKC6W2/XjuTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1ucUwFR53x6/HKXcuTfKsJvEp1zEQzWQ/Iq+QR8nk6kT9FCgXQs8ct/IHCum+p9S
	 Rc3jlQydm5zDq8Atq2mX97MPi3oK2dWhq/Cex/6Hu71AOaL345MSmCL4kyRq74yId6
	 Nb4a2DkzDSMYaMHsclleRAHVT11eHVDbJzro4Puk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/393] drm/tests: helpers: Add helper for drm_display_mode_from_cea_vic()
Date: Wed, 23 Apr 2025 16:38:37 +0200
Message-ID: <20250423142644.140793487@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit caa714f86699bcfb01aa2d698db12d91af7d0d81 ]

As Maxime suggested, add a new helper
drm_kunit_display_mode_from_cea_vic(), it can replace the direct call
of drm_display_mode_from_cea_vic(), and it will help solving
the `mode` memory leaks.

Acked-by: Maxime Ripard <mripard@kernel.org>
Suggested-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241030023504.530425-2-ruanjinjie@huawei.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Stable-dep-of: 70f29ca3117a ("drm/tests: cmdline: Fix drm_display_mode memory leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_kunit_helpers.c | 42 +++++++++++++++++++++++
 include/drm/drm_kunit_helpers.h           |  4 +++
 2 files changed, 46 insertions(+)

diff --git a/drivers/gpu/drm/tests/drm_kunit_helpers.c b/drivers/gpu/drm/tests/drm_kunit_helpers.c
index ca513235b5e2a..9a35b2cf6a032 100644
--- a/drivers/gpu/drm/tests/drm_kunit_helpers.c
+++ b/drivers/gpu/drm/tests/drm_kunit_helpers.c
@@ -3,6 +3,7 @@
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_drv.h>
+#include <drm/drm_edid.h>
 #include <drm/drm_fourcc.h>
 #include <drm/drm_kunit_helpers.h>
 #include <drm/drm_managed.h>
@@ -383,5 +384,46 @@ drm_kunit_helper_create_crtc(struct kunit *test,
 }
 EXPORT_SYMBOL_GPL(drm_kunit_helper_create_crtc);
 
+static void kunit_action_drm_mode_destroy(void *ptr)
+{
+	struct drm_display_mode *mode = ptr;
+
+	drm_mode_destroy(NULL, mode);
+}
+
+/**
+ * drm_kunit_display_mode_from_cea_vic() - return a mode for CEA VIC
+					   for a KUnit test
+ * @test: The test context object
+ * @dev: DRM device
+ * @video_code: CEA VIC of the mode
+ *
+ * Creates a new mode matching the specified CEA VIC for a KUnit test.
+ *
+ * Resources will be cleaned up automatically.
+ *
+ * Returns: A new drm_display_mode on success or NULL on failure
+ */
+struct drm_display_mode *
+drm_kunit_display_mode_from_cea_vic(struct kunit *test, struct drm_device *dev,
+				    u8 video_code)
+{
+	struct drm_display_mode *mode;
+	int ret;
+
+	mode = drm_display_mode_from_cea_vic(dev, video_code);
+	if (!mode)
+		return NULL;
+
+	ret = kunit_add_action_or_reset(test,
+					kunit_action_drm_mode_destroy,
+					mode);
+	if (ret)
+		return NULL;
+
+	return mode;
+}
+EXPORT_SYMBOL_GPL(drm_kunit_display_mode_from_cea_vic);
+
 MODULE_AUTHOR("Maxime Ripard <maxime@cerno.tech>");
 MODULE_LICENSE("GPL");
diff --git a/include/drm/drm_kunit_helpers.h b/include/drm/drm_kunit_helpers.h
index 6e99627edf458..3e5f4a23685ef 100644
--- a/include/drm/drm_kunit_helpers.h
+++ b/include/drm/drm_kunit_helpers.h
@@ -120,4 +120,8 @@ drm_kunit_helper_create_crtc(struct kunit *test,
 			     const struct drm_crtc_funcs *funcs,
 			     const struct drm_crtc_helper_funcs *helper_funcs);
 
+struct drm_display_mode *
+drm_kunit_display_mode_from_cea_vic(struct kunit *test, struct drm_device *dev,
+				    u8 video_code);
+
 #endif // DRM_KUNIT_HELPERS_H_
-- 
2.39.5



