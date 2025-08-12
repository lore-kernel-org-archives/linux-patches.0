Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18F786331;
	Tue, 12 Aug 2025 17:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020609; cv=none; b=rDK/GW5bS9Ou+VV/0zrzojJo0cO6KzZ4dOL4NUl0A2g5Uwd+WHBopPddWAJVs7lqrF1da+O3USTDfVrlxA5z7VQaHXw2kKsGrEhah/Ta4aHsXY44yDql+CR5sMe9VLAbvXq4Tk1UAyBy5iawabvxsWd+GR2Oc35zLo99rq6mmGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020609; c=relaxed/simple;
	bh=1zMscYCaod19EM4wqE1S3oan6fFitUnH//UTi2khAiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ue3WEIs1pBJ8MXLkLVZnPfrbmY7C6Wy9iy0lwtUqRMhuK4NpI6Ah1cVDCyDP8TDdrxcHotfk20oZ2L1jo4cl9/1oWjgxFfCDVGKMvjneQyCamyXDyMJ6LG6W/X4FIWuGyViWpj1pnoATZ93zqQykDYv22yrhQF/99erx4JlbfHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vk+Hsair; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vk+Hsair"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B833C4CEF0;
	Tue, 12 Aug 2025 17:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020609;
	bh=1zMscYCaod19EM4wqE1S3oan6fFitUnH//UTi2khAiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vk+HsairQdCvQ6r6LCwlKIoFbJuGe4G2GJJLMg+nUgzTxrjNIelPHji/FGb5r2G9o
	 4FjdP24FqBgx9S/vEX/5h0ch6hjg+ovcdCpUJ0kolJLh6LjJEz6HlySZ8/NJTmMwFL
	 gvq5KwE/KgWoRw1auCug4kE4Ao0LNMZAfcLh5jx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/253] drm/rockchip: cleanup fb when drm_gem_fb_afbc_init failed
Date: Tue, 12 Aug 2025 19:28:05 +0200
Message-ID: <20250812172952.858667512@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 092bf863110b..9545ee64a90a 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
@@ -82,16 +82,9 @@ rockchip_fb_create(struct drm_device *dev, struct drm_file *file,
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



