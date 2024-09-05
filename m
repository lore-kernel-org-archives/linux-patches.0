Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C231494DB;
	Thu,  5 Sep 2024 10:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530626; cv=none; b=OwUOOznm4GGrgZfNJSHU9FBdkfn33CAXUv/ZWggx/aARTzXgnTI0dtx9lafLLTirzjTVJo+92rTwR6858bKM2cYK934qH8bRyMmumH1sdfFEFFNMelphAoNFxBcSam64oX4szBQ4fAwkxkROlNjpuFpszDKOAY1AAMLrXSzDWOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530626; c=relaxed/simple;
	bh=o1x1PvcrPH9zushxbeufDEXriHFD1FiYmTTIyM5g4Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oicyaCOXDz+HVlFbZE5oVd9cxQtKn7GelQUQzi82CikbCanNrn2ULdxKobGV1ObCTg9TuJPxIfVo+tRDSD2h6owZ2YF82lnUeL2CI1qH8FYaTVbWdij6ZYPqqNGQ878pE1aHTfs9BbyMKZL7lwsrKkGackG5Pgfv5+hJucBRCqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEGZMcVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEGZMcVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6459AC4CEC3;
	Thu,  5 Sep 2024 10:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530625;
	bh=o1x1PvcrPH9zushxbeufDEXriHFD1FiYmTTIyM5g4Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEGZMcVacQxX0R0SEvay/c/kcyXlxU7kgn+0M0v4yUlE8hQxTJo0/2guEp0rjE/UR
	 cN137YZN2lbnaIXBXDfV/eSX1QA5qV8C7woxhr8RrdqZxRWgRCQW8KRMYUo26tBJ3c
	 7XYLtBGu/N9GSsvKPeVu2U5a8zg5yncQErD7ZVU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoran Liu <liuhaoran14@163.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/101] drm/meson: plane: Add error handling
Date: Thu,  5 Sep 2024 11:41:54 +0200
Message-ID: <20240905093719.337222184@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoran Liu <liuhaoran14@163.com>

[ Upstream commit 3c28b239620e249b68beeca17f429e317fa6b8d4 ]

This patch adds robust error handling to the meson_plane_create
function in drivers/gpu/drm/meson/meson_plane.c. The function
previously lacked proper handling for potential failure scenarios
of the drm_universal_plane_init call.

Signed-off-by: Haoran Liu <liuhaoran14@163.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20231129113405.33057-1-liuhaoran14@163.com
[narmstrong: fixe the commit subject]
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231129113405.33057-1-liuhaoran14@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_plane.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_plane.c b/drivers/gpu/drm/meson/meson_plane.c
index 815dfe30492b..b43ac61201f3 100644
--- a/drivers/gpu/drm/meson/meson_plane.c
+++ b/drivers/gpu/drm/meson/meson_plane.c
@@ -534,6 +534,7 @@ int meson_plane_create(struct meson_drm *priv)
 	struct meson_plane *meson_plane;
 	struct drm_plane *plane;
 	const uint64_t *format_modifiers = format_modifiers_default;
+	int ret;
 
 	meson_plane = devm_kzalloc(priv->drm->dev, sizeof(*meson_plane),
 				   GFP_KERNEL);
@@ -548,12 +549,16 @@ int meson_plane_create(struct meson_drm *priv)
 	else if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_G12A))
 		format_modifiers = format_modifiers_afbc_g12a;
 
-	drm_universal_plane_init(priv->drm, plane, 0xFF,
-				 &meson_plane_funcs,
-				 supported_drm_formats,
-				 ARRAY_SIZE(supported_drm_formats),
-				 format_modifiers,
-				 DRM_PLANE_TYPE_PRIMARY, "meson_primary_plane");
+	ret = drm_universal_plane_init(priv->drm, plane, 0xFF,
+					&meson_plane_funcs,
+					supported_drm_formats,
+					ARRAY_SIZE(supported_drm_formats),
+					format_modifiers,
+					DRM_PLANE_TYPE_PRIMARY, "meson_primary_plane");
+	if (ret) {
+		devm_kfree(priv->drm->dev, meson_plane);
+		return ret;
+	}
 
 	drm_plane_helper_add(plane, &meson_plane_helper_funcs);
 
-- 
2.43.0



