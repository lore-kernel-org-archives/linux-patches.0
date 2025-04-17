Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E9C257AC7;
	Thu, 17 Apr 2025 17:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912490; cv=none; b=uMqw31mGlTAvzL2yXKPNZsIG/StEqxLTtCxMbmQo7dARJfYcBOiCalT026APGIHe+j1c4P12TBaoA/UwA05gPlQuF03tgUp1WSZBPukkRGAaXI3I2yly8OvRIUm4PIgH5Z5G9hAOrmVE7Ohw0TU2fQxlTTj2f3HDKuiLnJ+OdWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912490; c=relaxed/simple;
	bh=nP34VzsK53H8NwChPptx9NVUx1EMxYdY2bSljFkZN9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asHsGYtS5LDJbJcOY5f0qBV+jom9Xe4ci0xYqQJ2y49n1vOv0oFkb0L60P3hVU8Z6AqYzSjyG6iuogqKQWgB5R+8N7bOqLvVmueo+I9j7Yq3gSZCfFw9rtMs5Q2gZRvhP70cJLC1442pzFcpuRyI0cpdgtkoqYXApUymGFmmcD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7WeGM+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7WeGM+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFC5C4CEE7;
	Thu, 17 Apr 2025 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912490;
	bh=nP34VzsK53H8NwChPptx9NVUx1EMxYdY2bSljFkZN9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7WeGM+JVZELk7vMtd58QopiwYbkjlzs3LBXMvvme4tnT0yXLEN0bGRG7h2nWhRen
	 CdvzoBL1SaAKHDwJqmoavZoEXNXRusT0/Wuub1BY4pmY/gtMwEtB/2oXCZ2TbHiv+t
	 4Le1WN3srj1OCfKjcxFDbzFTstsIasuy9yqlGXSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@mailbox.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 027/449] drm/tests: probe-helper: Fix drm_display_mode memory leak
Date: Thu, 17 Apr 2025 19:45:15 +0200
Message-ID: <20250417175119.093338006@linuxfoundation.org>
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

[ Upstream commit 8b6f2e28431b2f9f84073bff50353aeaf25559d0 ]

drm_analog_tv_mode() and its variants return a drm_display_mode that
needs to be destroyed later one. The
drm_test_connector_helper_tv_get_modes_check() test never does however,
which leads to a memory leak.

Let's make sure it's freed.

Reported-by: Philipp Stanner <phasta@mailbox.org>
Closes: https://lore.kernel.org/dri-devel/a7655158a6367ac46194d57f4b7433ef0772a73e.camel@mailbox.org/
Fixes: 1e4a91db109f ("drm/probe-helper: Provide a TV get_modes helper")
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250408-drm-kunit-drm-display-mode-memleak-v1-7-996305a2e75a@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_probe_helper_test.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tests/drm_probe_helper_test.c b/drivers/gpu/drm/tests/drm_probe_helper_test.c
index bc09ff38aca18..db0e4f5df275e 100644
--- a/drivers/gpu/drm/tests/drm_probe_helper_test.c
+++ b/drivers/gpu/drm/tests/drm_probe_helper_test.c
@@ -98,7 +98,7 @@ drm_test_connector_helper_tv_get_modes_check(struct kunit *test)
 	struct drm_connector *connector = &priv->connector;
 	struct drm_cmdline_mode *cmdline = &connector->cmdline_mode;
 	struct drm_display_mode *mode;
-	const struct drm_display_mode *expected;
+	struct drm_display_mode *expected;
 	size_t len;
 	int ret;
 
@@ -134,6 +134,9 @@ drm_test_connector_helper_tv_get_modes_check(struct kunit *test)
 
 		KUNIT_EXPECT_TRUE(test, drm_mode_equal(mode, expected));
 		KUNIT_EXPECT_TRUE(test, mode->type & DRM_MODE_TYPE_PREFERRED);
+
+		ret = drm_kunit_add_mode_destroy_action(test, expected);
+		KUNIT_ASSERT_EQ(test, ret, 0);
 	}
 
 	if (params->num_expected_modes >= 2) {
@@ -145,6 +148,9 @@ drm_test_connector_helper_tv_get_modes_check(struct kunit *test)
 
 		KUNIT_EXPECT_TRUE(test, drm_mode_equal(mode, expected));
 		KUNIT_EXPECT_FALSE(test, mode->type & DRM_MODE_TYPE_PREFERRED);
+
+		ret = drm_kunit_add_mode_destroy_action(test, expected);
+		KUNIT_ASSERT_EQ(test, ret, 0);
 	}
 
 	mutex_unlock(&priv->drm->mode_config.mutex);
-- 
2.39.5



