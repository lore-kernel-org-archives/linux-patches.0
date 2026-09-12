Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AFB288B9;
	Sat, 12 Sep 2026 16:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230887; cv=none; b=uN/mLER+A78/k1PoKnew237tlTm8IimHctl9vMLKOcFsKa6oaN6chEvwxp4T6ZJ0GFpV0B4q8lzpg3PWGTUe0arQ7aWCtW3Q2IV1I440CbgIAQolPr+bfCkwj47kCbBQQD0hOod0SpCmvnTw4rh6LlaG0Io7gWVv0Aq9Bx/+biU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230887; c=relaxed/simple;
	bh=i7L765b00xHLGo64kDhBEhbUy3DT/J31bEQdvA4X9jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RL7+tAyyn2tJf4QChHtH36QobyiGqLdEqTHpwORmgYVstuR1WW17+viO54dtAtgP0+xIDYs6N90hBvn/FpyC6iF/8fXWOyxdU313gFgry/olm4XwvzBvYYHPyo47as8DmUFrINseYzLDw8uCKXyoeEoTYW67FUJEGtWxONMBhu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNHAuFPp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNHAuFPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1DC1F000FF;
	Sat, 12 Sep 2026 16:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230885;
	bh=4l1RpbPfTD67oajpN74vAc6o3ZDTCEA6NgPPFj3Yi1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNHAuFPpcIp+A2uoA+JW6Y9YSUVawbvK1aI9aOxCXy/nM15HOnQkt2HuaXoWCuhEZ
	 mIeHbuTHM5z+7ibHCwSeomO3Xng6O7vLj2sKmQyvI5zX/SB6P/wrfae5VJ6fbJCXiB
	 Xy8NYDLiAc0CPMy503X1FEZy8AJ/LuXoOGDtEMBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0887/1191] drm/sun4i: crtc: Propagate layer initialization error
Date: Sat, 12 Sep 2026 09:00:15 +0200
Message-ID: <20260912065608.160501056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 7061ff05ed4a3cf16e83f7e3ad09cbd212508a32 ]

sun4i_crtc_init() returns plain NULL when layer initialization fails,
while all its other error paths return an error pointer. The only
caller, sun4i_tcon_bind(), checks the result with IS_ERR() and happily
continues with tcon->crtc set to NULL. sun4i_rgb_init() and
sun4i_lvds_init() then dereference it in drm_crtc_mask(), which
oopses.

Return the error pointer instead.

Fixes: dcd215801b02 ("drm/sun4i: Drop primary layer pointer from sun4i_drv")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/b26a0d427d9dfae9c82e3ca90a67d24d8ece5a28.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_crtc.c b/drivers/gpu/drm/sun4i/sun4i_crtc.c
index c06d7cd453889..49fd3523cdbbc 100644
--- a/drivers/gpu/drm/sun4i/sun4i_crtc.c
+++ b/drivers/gpu/drm/sun4i/sun4i_crtc.c
@@ -208,7 +208,7 @@ struct sun4i_crtc *sun4i_crtc_init(struct drm_device *drm,
 	planes = sunxi_engine_layers_init(drm, engine);
 	if (IS_ERR(planes)) {
 		dev_err(drm->dev, "Couldn't create the planes\n");
-		return NULL;
+		return ERR_CAST(planes);
 	}
 
 	/* find primary and cursor planes for drm_crtc_init_with_planes */
-- 
2.53.0



