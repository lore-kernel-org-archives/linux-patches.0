Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EA327CB12;
	Wed, 23 Apr 2025 14:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419911; cv=none; b=hKiySHC5Nk5QQ2io+pfW4nNazeOBxvK2TjRaBT8U41JsTc7V6aXjLhA30EwCq0gF8ppcz+Hf5B82FOXBfJ7p1TkPwDQWvi1ZMRuwnFPESvASmtEqQt0s+wIsyuCE928pV0Ih51+MHUuGlW0+MvEDUxjkkmAw72fBAtgsz4Qv5MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419911; c=relaxed/simple;
	bh=M3GAoz6T8kYCDchUegzO10kloQOqcvBl0XWg9te5/fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y1bAwl8n7yEbUVvLJm1Qv3gz1VUV6jfQ9GA4TXKi66FkLP2uawxjpICwNkaqJCGDXWjFoILGRmro/9ZdvRWejiRpJdkqr3udk6UNqkxezHUgDlvWXY7VaOPx5iis+7i7pFSBd0KYOru5qPJlX9+Ymwdx4ZK6gD118eI4ORM0Q/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XeMvcgiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XeMvcgiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD428C4CEE2;
	Wed, 23 Apr 2025 14:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419911;
	bh=M3GAoz6T8kYCDchUegzO10kloQOqcvBl0XWg9te5/fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeMvcgiNiNIlt6DG1tRS+jq+HSU+v3NLZJoxr2gAniZxHazwEOWeazKgR8o4S+kfu
	 stiO5RoAUfGWSEHjwxngvgxeKdcshgnWGxeyj2Uy0evNv5uSa9y0fG8Sl+qb415TLc
	 Dx3rAgQr6lFrvjjVJb9rTM0DE3fZPVAxj8G4K4o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/393] drm/tests: Add helper to create mock plane
Date: Wed, 23 Apr 2025 16:38:35 +0200
Message-ID: <20250423142644.058866773@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit 7a48da0febd5113d9de6f51592a09825ebd8415c ]

We're going to need a full-blown, functional, KMS device to test more
components of the atomic modesetting infrastructure.

Let's add a new helper to create a dumb, mocked, primary plane. By
default, it will create a linear XRGB8888 plane, using the default
helpers.

Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240222-kms-hdmi-connector-state-v7-3-8f4af575fce2@kernel.org
Stable-dep-of: 70f29ca3117a ("drm/tests: cmdline: Fix drm_display_mode memory leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_kunit_helpers.c | 85 +++++++++++++++++++++++
 include/drm/drm_kunit_helpers.h           | 11 +++
 2 files changed, 96 insertions(+)

diff --git a/drivers/gpu/drm/tests/drm_kunit_helpers.c b/drivers/gpu/drm/tests/drm_kunit_helpers.c
index 272a3ba46d602..e0778a7ec2608 100644
--- a/drivers/gpu/drm/tests/drm_kunit_helpers.c
+++ b/drivers/gpu/drm/tests/drm_kunit_helpers.c
@@ -3,6 +3,7 @@
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_drv.h>
+#include <drm/drm_fourcc.h>
 #include <drm/drm_kunit_helpers.h>
 #include <drm/drm_managed.h>
 
@@ -236,5 +237,89 @@ drm_kunit_helper_atomic_state_alloc(struct kunit *test,
 }
 EXPORT_SYMBOL_GPL(drm_kunit_helper_atomic_state_alloc);
 
+static const uint32_t default_plane_formats[] = {
+	DRM_FORMAT_XRGB8888,
+};
+
+static const uint64_t default_plane_modifiers[] = {
+	DRM_FORMAT_MOD_LINEAR,
+	DRM_FORMAT_MOD_INVALID
+};
+
+static const struct drm_plane_helper_funcs default_plane_helper_funcs = {
+};
+
+static const struct drm_plane_funcs default_plane_funcs = {
+	.atomic_destroy_state	= drm_atomic_helper_plane_destroy_state,
+	.atomic_duplicate_state	= drm_atomic_helper_plane_duplicate_state,
+	.reset			= drm_atomic_helper_plane_reset,
+};
+
+/**
+ * drm_kunit_helper_create_primary_plane - Creates a mock primary plane for a KUnit test
+ * @test: The test context object
+ * @drm: The device to alloc the plane for
+ * @funcs: Callbacks for the new plane. Optional.
+ * @helper_funcs: Helpers callbacks for the new plane. Optional.
+ * @formats: array of supported formats (DRM_FORMAT\_\*). Optional.
+ * @num_formats: number of elements in @formats
+ * @modifiers: array of struct drm_format modifiers terminated by
+ *             DRM_FORMAT_MOD_INVALID. Optional.
+ *
+ * This allocates and initializes a mock struct &drm_plane meant to be
+ * part of a mock device for a KUnit test.
+ *
+ * Resources will be cleaned up automatically.
+ *
+ * @funcs will default to the default helpers implementations.
+ * @helper_funcs will default to an empty implementation. @formats will
+ * default to XRGB8888 only. @modifiers will default to a linear
+ * modifier only.
+ *
+ * Returns:
+ * A pointer to the new plane, or an ERR_PTR() otherwise.
+ */
+struct drm_plane *
+drm_kunit_helper_create_primary_plane(struct kunit *test,
+				      struct drm_device *drm,
+				      const struct drm_plane_funcs *funcs,
+				      const struct drm_plane_helper_funcs *helper_funcs,
+				      const uint32_t *formats,
+				      unsigned int num_formats,
+				      const uint64_t *modifiers)
+{
+	struct drm_plane *plane;
+
+	if (!funcs)
+		funcs = &default_plane_funcs;
+
+	if (!helper_funcs)
+		helper_funcs = &default_plane_helper_funcs;
+
+	if (!formats || !num_formats) {
+		formats = default_plane_formats;
+		num_formats = ARRAY_SIZE(default_plane_formats);
+	}
+
+	if (!modifiers)
+		modifiers = default_plane_modifiers;
+
+	plane = __drmm_universal_plane_alloc(drm,
+					     sizeof(struct drm_plane), 0,
+					     0,
+					     funcs,
+					     formats,
+					     num_formats,
+					     default_plane_modifiers,
+					     DRM_PLANE_TYPE_PRIMARY,
+					     NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, plane);
+
+	drm_plane_helper_add(plane, helper_funcs);
+
+	return plane;
+}
+EXPORT_SYMBOL_GPL(drm_kunit_helper_create_primary_plane);
+
 MODULE_AUTHOR("Maxime Ripard <maxime@cerno.tech>");
 MODULE_LICENSE("GPL");
diff --git a/include/drm/drm_kunit_helpers.h b/include/drm/drm_kunit_helpers.h
index 3ae19892229db..38667d624aa8c 100644
--- a/include/drm/drm_kunit_helpers.h
+++ b/include/drm/drm_kunit_helpers.h
@@ -10,6 +10,8 @@
 #include <kunit/test.h>
 
 struct drm_device;
+struct drm_plane_funcs;
+struct drm_plane_helper_funcs;
 struct kunit;
 
 struct device *drm_kunit_helper_alloc_device(struct kunit *test);
@@ -99,4 +101,13 @@ drm_kunit_helper_atomic_state_alloc(struct kunit *test,
 				    struct drm_device *drm,
 				    struct drm_modeset_acquire_ctx *ctx);
 
+struct drm_plane *
+drm_kunit_helper_create_primary_plane(struct kunit *test,
+				      struct drm_device *drm,
+				      const struct drm_plane_funcs *funcs,
+				      const struct drm_plane_helper_funcs *helper_funcs,
+				      const uint32_t *formats,
+				      unsigned int num_formats,
+				      const uint64_t *modifiers);
+
 #endif // DRM_KUNIT_HELPERS_H_
-- 
2.39.5



