Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D231946BC;
	Tue, 26 Aug 2025 13:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215705; cv=none; b=pJS127Adp7k2RS46Jcc/TX9mL+mIX/P+bMasJ6FwoovwhBTiU7Rra0NOjFjdQf0bNjxtsra++67FWmE+rWPwSf4bVGEjkjuwbfrB5WdM0jNN2xgTvUOsUBnj2tzSuKwD5kf6s1cs8E/q507lKyoZezycfXKilG/lN22Cpgq+TOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215705; c=relaxed/simple;
	bh=zu1mTLOEA9tRj62l4g2/suy6OKH/JhK+um0IveYVFa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJT3aHYZ118AuATKylbFFSF/cHlEuGu6frtMBFmgA90HZgzUl5nAZM8dI9KxniUDaznwUoFQ/rwqBGdOk3SkDBIgM9GzZr0Nl9hwtcdQOuXMaflflrmP5Bs15xd+1y2f4WQ4jfwWI2Kz9sx7AngHPaf/ecY1lkNyhIYTdHOH86k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqvfrEGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqvfrEGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEF2C113D0;
	Tue, 26 Aug 2025 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215705;
	bh=zu1mTLOEA9tRj62l4g2/suy6OKH/JhK+um0IveYVFa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqvfrEGSS4BolQeIV1ffTPRyycHJB/gp0L+6fCWyByHMdt37SVdwIn2lEIpvSNJDa
	 KgnTVhQl6u+6R5vS03rsjeZXNwzITUt7ep4DoSL6gxz3O2x+i8II4+6Ezc4UI+gqJX
	 gUkXRXhqTzFjAZAXfBrkSpfxZvXjIThEgg4u+7JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/644] drm/rockchip: cleanup fb when drm_gem_fb_afbc_init failed
Date: Tue, 26 Aug 2025 13:03:46 +0200
Message-ID: <20250826110949.850684303@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



