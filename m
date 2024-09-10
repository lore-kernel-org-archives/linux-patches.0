Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A50C18C036;
	Tue, 10 Sep 2024 10:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963415; cv=none; b=a1z2eOV2Rjr78zw/5k84qHg+7WjBFCMoByf57LJ9HmwHCUILLGKPers4lJ02UTj2HdgDWnSC45If8XBjGSOitEe7P2Lp5nFNyNEwVZouIFyT6VVpITLQxJhYAo0pjgmbEGfKLdVY7f3NhXrHW6+e/In7qFivEb+1sZnWZIMv1Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963415; c=relaxed/simple;
	bh=VpaXhrOf75cnTk2Y77Ev2/QD3IvEK1Q1SdKiyGwGIhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuUlfVg3ly3Pe0PDWV3X++YYGBxKjNQBTcyKbWXBLeIBhFLUYklHp375pf2GFjgTX8RqLEXny9rrOYWR+I8yufyyocMbzJBcRPhx3Inj9Jq53r/H/wx3UFzqYg22qJKjssTGv09C+jYszsTh5NAcyVQrOE+cTQrYC7cXBzieCNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gas5EtmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gas5EtmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EC9C4CEC3;
	Tue, 10 Sep 2024 10:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963415;
	bh=VpaXhrOf75cnTk2Y77Ev2/QD3IvEK1Q1SdKiyGwGIhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gas5EtmVAmdbjz00HrwnnyDGaMQ/Uu1Rsc/KiEQnaT8enc6UYy1G8z95DBVsHCeh5
	 XzYHd278CrxX7fZHzym1mibYjOl/5IlSgHsgdOc1Ludi8ziU3KvtVIGTcHZFDsb759
	 JiIws2nxDJbfN2ke+9wV5cqA4LmxhlGHtfUQbt9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoran Liu <liuhaoran14@163.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/214] drm/meson: plane: Add error handling
Date: Tue, 10 Sep 2024 11:31:11 +0200
Message-ID: <20240910092600.775576825@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 44aa52629443..c17abaf9b54d 100644
--- a/drivers/gpu/drm/meson/meson_plane.c
+++ b/drivers/gpu/drm/meson/meson_plane.c
@@ -533,6 +533,7 @@ int meson_plane_create(struct meson_drm *priv)
 	struct meson_plane *meson_plane;
 	struct drm_plane *plane;
 	const uint64_t *format_modifiers = format_modifiers_default;
+	int ret;
 
 	meson_plane = devm_kzalloc(priv->drm->dev, sizeof(*meson_plane),
 				   GFP_KERNEL);
@@ -547,12 +548,16 @@ int meson_plane_create(struct meson_drm *priv)
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



