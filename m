Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22ABA6FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DE6C433C8;
	Sun, 17 Sep 2023 19:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980505;
	bh=8Z29cEQGLL/WMFoYptKbXIxgoVKWzegYp7l6MCQ8xwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqWN70RR/IJxeiVvTGS37BcOJ15Zc3UgIOZVmm4aBiWgVxCIwUmwPEd6LRuPP+8at
	 fjIfYNuJtjV3dJh76nLahUpFp9EBDnUSRow4vAtHVOjt67NyWvBZ2XnpgqhRowFn+G
	 csE5IZXgGiG+Mb5hqs6XyNNh2OsE5FUolPJhVJhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Marek Vasut <marex@denx.de>
Subject: [PATCH 6.5 212/285] drm/mxsfb: Disable overlay plane in mxsfb_plane_overlay_atomic_disable()
Date: Sun, 17 Sep 2023 21:13:32 +0200
Message-ID: <20230917191058.900150919@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Ying <victor.liu@nxp.com>

commit aa656d48e871a1b062e1bbf9474d8b831c35074c upstream.

When disabling overlay plane in mxsfb_plane_overlay_atomic_update(),
overlay plane's framebuffer pointer is NULL.  So, dereferencing it would
cause a kernel Oops(NULL pointer dereferencing).  Fix the issue by
disabling overlay plane in mxsfb_plane_overlay_atomic_disable() instead.

Fixes: cb285a5348e7 ("drm: mxsfb: Replace mxsfb_get_fb_paddr() with drm_fb_cma_get_gem_addr()")
Cc: stable@vger.kernel.org # 5.19+
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230612092359.784115-1-victor.liu@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mxsfb/mxsfb_kms.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/mxsfb/mxsfb_kms.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_kms.c
@@ -611,6 +611,14 @@ static void mxsfb_plane_overlay_atomic_u
 	writel(ctrl, mxsfb->base + LCDC_AS_CTRL);
 }
 
+static void mxsfb_plane_overlay_atomic_disable(struct drm_plane *plane,
+					       struct drm_atomic_state *state)
+{
+	struct mxsfb_drm_private *mxsfb = to_mxsfb_drm_private(plane->dev);
+
+	writel(0, mxsfb->base + LCDC_AS_CTRL);
+}
+
 static bool mxsfb_format_mod_supported(struct drm_plane *plane,
 				       uint32_t format,
 				       uint64_t modifier)
@@ -626,6 +634,7 @@ static const struct drm_plane_helper_fun
 static const struct drm_plane_helper_funcs mxsfb_plane_overlay_helper_funcs = {
 	.atomic_check = mxsfb_plane_atomic_check,
 	.atomic_update = mxsfb_plane_overlay_atomic_update,
+	.atomic_disable = mxsfb_plane_overlay_atomic_disable,
 };
 
 static const struct drm_plane_funcs mxsfb_plane_funcs = {


