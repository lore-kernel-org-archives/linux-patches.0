Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8CF1DF969;
	Wed,  6 Nov 2024 12:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896405; cv=none; b=FmM5vDFd9+LrVEKLjV9SUXsGEd4goIWXXgs3zVeGedBP7djkJmQ1KZBuEtK6gZbWXm6Nl+SDjxHZdNhZK/qC1VE8DMvXfNjIBjqQbDcFhtb3tfMhvgSj0zlwfQ8iaL4TJwNjrhR7YaJ4XliqKgysGAkXexmlaiI1AUa76vVJ0xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896405; c=relaxed/simple;
	bh=GmnFEJ2x1/lk4ThH3O6tXAi3lZf3ptwtp3iaijJT/D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhUoTBhxOGW/l9+zXVe/4Uqo2+zjZfI2bW2bxsg5/0vBNhVSEykIZjvZb/zdpADhK35S4JiOBjQGa9iyFNObaL5VEMnLxo1HlM7dizWtjH3UJJQXdQZWCiUqn/E6P33dEloI3bViM6K38kX+7fSTuI2B00yQkYkx1tiasa66gYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDHyK5LG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDHyK5LG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9796C4CECD;
	Wed,  6 Nov 2024 12:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896405;
	bh=GmnFEJ2x1/lk4ThH3O6tXAi3lZf3ptwtp3iaijJT/D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDHyK5LGlqUesYUI4e7+SReq+XWeL1m4YZYfp8FjtOna18jmAwzGLvPOM63RANso8
	 mrwqKv1DmlNIDUUcEbz1FnJ2kYhx7jixtTEK259SesLDEGsQL+NySSDSiP0YTTL1Ha
	 4pyc8w2A4xMv4aSR5caSrQkr+zgmJeGdz15W1fX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 190/245] drm/tests: helpers: Add helper for drm_display_mode_from_cea_vic()
Date: Wed,  6 Nov 2024 13:04:03 +0100
Message-ID: <20241106120323.922581270@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 926163342a2e ("drm/connector: hdmi: Fix memory leak in drm_display_mode_from_cea_vic()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_kunit_helpers.c | 42 +++++++++++++++++++++++
 include/drm/drm_kunit_helpers.h           |  4 +++
 2 files changed, 46 insertions(+)

diff --git a/drivers/gpu/drm/tests/drm_kunit_helpers.c b/drivers/gpu/drm/tests/drm_kunit_helpers.c
index aa62719dab0e4..04a6b8cc62ac6 100644
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
@@ -311,6 +312,47 @@ drm_kunit_helper_create_crtc(struct kunit *test,
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
 MODULE_DESCRIPTION("KUnit test suite helper functions");
 MODULE_LICENSE("GPL");
diff --git a/include/drm/drm_kunit_helpers.h b/include/drm/drm_kunit_helpers.h
index e7cc17ee4934a..afdd46ef04f70 100644
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
2.43.0



