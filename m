Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A42518D65E;
	Thu,  5 Sep 2024 09:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530278; cv=none; b=tCQVgRCmsv++BZEScCG17Loyj2rjPRcWg+s4QvCOA2X32lwpEb4Mi/PntnPimSWSJcTYYIbnimBkkdwswyUCdXCT0tdctHTaRJlq+IC9okYc0P/CDz8ctFOOe/ZbSqY5MzYgs0z131d+NtAYovVXETIlfyBSZFEEYpSLnWSWxYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530278; c=relaxed/simple;
	bh=F7WqWebCNdzFgXb/j0Eufd7l+ZIG4e4v3R0EKXbZYf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIa5lv9u9jBtRU6PaXC9M1SAMwJIRn83I3axcC19BBuHBjINRvgPNFg3cXgLVO90yy3mxOhqH+vnDR+v70UOb8VxjVIdrB5hjCoBxeaEVglnyU8q95SDdDGSimpggNOx+AfkCqkjFvziOjiLhizuzOfKTmH6dY/Wog1Czsmcvg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsAV5Nv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsAV5Nv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCE5C4CEC3;
	Thu,  5 Sep 2024 09:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530277;
	bh=F7WqWebCNdzFgXb/j0Eufd7l+ZIG4e4v3R0EKXbZYf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zsAV5Nv4HcVWQzVBp0ZSdZ3H7LEGO2L+1iLjQV4Jk7rW59444bwUqYbcmnu6e+3X4
	 CHfsF2jIwhtr1J/jjFJj/l4uDpo022P4eNjtj8kEHu/rj5OAdWRrTuL7e0Cs3QcS+p
	 YsbEfTpMBLXRV9r2H8gHw0L6OQZntdZLniQ2B1UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoran Liu <liuhaoran14@163.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/132] drm/meson: plane: Add error handling
Date: Thu,  5 Sep 2024 11:41:36 +0200
Message-ID: <20240905093726.467711338@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



