Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88F1257435;
	Tue, 12 Aug 2025 17:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020999; cv=none; b=OITgPr80txPDpBsXVwwBvaUXUZR6A6n9PtYQtfUhmzRgRg2Zn+zrPs6f0divUprkfTijC1LSOVdaBcw1H6l+Ika5O8fXuXzmQvel2kndJpsBbDtezCjSbVrH6+0a8p70mMMTxAmnh1vTbQ8rij0PRgsXilkwZmJIh/tVUrbaLTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020999; c=relaxed/simple;
	bh=2gC9RhaPbm7VHgMzhoZosk5ZAuzrIMcRVWDhj3qUPU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BB9NSwWwGhm/Bibrtl1pe7rKlt7SCnq5cTVKq4kUnSoSUTUdr1hEaxvw/lqFUQiQuB3Zf9bX/8nJ2O6KpKufAO+Qn6HaKA2+4EwGcE41KYAQ90zUW7NyV8G33TAFp5bYh/jroA0r6AMeo+pV8nWKo4n/Pq7P1LMRtohPNaycIn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ub8Ze1NI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ub8Ze1NI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338B5C4CEF0;
	Tue, 12 Aug 2025 17:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020999;
	bh=2gC9RhaPbm7VHgMzhoZosk5ZAuzrIMcRVWDhj3qUPU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ub8Ze1NIj/u1olESKShE9YGEI7qCbpErOjYYQGjsNbQYzLsKaPaI5TS70nQGPamcy
	 9YnRDLJi/dyKac83AVY/p2iU+gV14oouSht786it9LAQpmQofqKihrN2ur5ZY/80Lo
	 iqfGJecMqVFTC2ElieJuQJFgHXcalBEY74xML8oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/262] drm/rockchip: cleanup fb when drm_gem_fb_afbc_init failed
Date: Tue, 12 Aug 2025 19:27:16 +0200
Message-ID: <20250812172955.021978092@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



