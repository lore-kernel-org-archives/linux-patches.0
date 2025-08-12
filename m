Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E249A305E08;
	Tue, 12 Aug 2025 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022236; cv=none; b=XBBJaCzAGiyWk80hvMlBXDcLA01tPkShMKQWmpANWtOm/TU3sMLltOZf+Cu480yqGA/gA17Hpj1zLE6T7p9JCVRHQKSmIeJ3+WSPtuNTak5BoaBVAEb26a++iliyi7Wu+z5eFQbPa/4dSwW5oD8OOP8rtQPoutyKJmZASoGUq54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022236; c=relaxed/simple;
	bh=K98BwRHtJ40uWYE4aKNjZUHwtaUX9/Xd7ZL0apLeUSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZJ0hLVFdyksljCvW5cQ3aWlz7rr9zeUgLQpOIdYh2Nwt4LH+eN5qghxB5eVU/q5VD9PGnfTrFbI4gkn8V616WMxz6/oLYJq5kGjBKn5hNAWj2T7ptUVVonu8f3n/sdE1+9yQvq6ArlmWYueBk0G9f1tkjOlwZ2POzw8oAopJ9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uv6FbTCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uv6FbTCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2275C4CEF0;
	Tue, 12 Aug 2025 18:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022235;
	bh=K98BwRHtJ40uWYE4aKNjZUHwtaUX9/Xd7ZL0apLeUSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uv6FbTCMCal6oovPcuHi8I/Fno1/h5BpXr3ZzOh0orlFBE2HBhvlSXmCdFJJORu8b
	 irKmTSZAT5Dav9aX6AYHzts1m1JMk9iD+kCd0dJA6iR82F8WROI0o+0MuvEV3G+nBZ
	 ZUsc8FE1UZwgHqBgHLWu1dbDgqoykSGP9q+Z1Rxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/369] drm/rockchip: cleanup fb when drm_gem_fb_afbc_init failed
Date: Tue, 12 Aug 2025 19:26:05 +0200
Message-ID: <20250812173017.333612514@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index cfe8b793d344..69ab8d4f289c 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
@@ -52,16 +52,9 @@ rockchip_fb_create(struct drm_device *dev, struct drm_file *file,
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



