Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812452B9A7;
	Tue, 26 Aug 2025 14:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217311; cv=none; b=rLtOmZrni9xOIQosg1jK6MKkUt2tsd+qX8bq+aXlnu1B+5n7VOX31MJyXIUgqEw5RYTKqKC1OKJbuNfgUvpUoX5yb+/PE1AC7zHKkF6ehNKBv6DpPxgLNY4wy7DtSXv8vg9MKOJ4kSRRo9/dACqb6dzn00EaQywsXF/b4PSq9q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217311; c=relaxed/simple;
	bh=jJ8sdRyzhUnYTAREakBiSz2kdlrZHervtoqpZORKSJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tk/grJpZmeXwYx7uaF7cb1rK9mIl3vuwhK/27qCK7tp8I4Ftr6azGkFD7CRlDs5F9pXd/62kPKvbA4j1aiGd3ICtsecP0caLIkjiMtWI1FmefLjHJ0jkvkZA4FuoxENqpbCaxh+juOA1RCH8XgcA+kZiRjxiD84hi2WXVDMBX/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I06gPPGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I06gPPGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E245C4CEF1;
	Tue, 26 Aug 2025 14:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217311;
	bh=jJ8sdRyzhUnYTAREakBiSz2kdlrZHervtoqpZORKSJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I06gPPGnuy+ouees5831QFMA1y8f+oqcO6iEUf9jpZ/4sswTCNUbvhfxScYtmDU32
	 n2pIQPKDFLI9Ym3wM5YxS0PYuvQIhrA6LC4Xmh/fnQ0RJ2nnrfpliC3Mln4MHXP5ey
	 x10TKnvFXq6MwGOz3dZtYOewxb+Z0unuVGolx4f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/523] drm/rockchip: cleanup fb when drm_gem_fb_afbc_init failed
Date: Tue, 26 Aug 2025 13:05:04 +0200
Message-ID: <20250826110926.865637238@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit 099593a28138b48feea5be8ce700e5bc4565e31d ]

In the function drm_gem_fb_init_with_funcs, the framebuffer (fb)
and its corresponding object ID have already been registered.

So we need to cleanup the drm framebuffer if the subsequent
execution of drm_gem_fb_afbc_init fails.

Directly call drm_framebuffer_put to ensure that all fb related
resources are cleanup.

Fixes: 7707f7227f09 ("drm/rockchip: Add support for afbc")
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250509031607.2542187-1-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
index 3aa37e177667..b386c17e8668 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
@@ -81,16 +81,9 @@ rockchip_fb_create(struct drm_device *dev, struct drm_file *file,
 	}
 
 	if (drm_is_afbc(mode_cmd->modifier[0])) {
-		int ret, i;
-
 		ret = drm_gem_fb_afbc_init(dev, mode_cmd, afbc_fb);
 		if (ret) {
-			struct drm_gem_object **obj = afbc_fb->base.obj;
-
-			for (i = 0; i < info->num_planes; ++i)
-				drm_gem_object_put(obj[i]);
-
-			kfree(afbc_fb);
+			drm_framebuffer_put(&afbc_fb->base);
 			return ERR_PTR(ret);
 		}
 	}
-- 
2.39.5



