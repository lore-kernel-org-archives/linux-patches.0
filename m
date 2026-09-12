Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4992EEE60;
	Sat, 12 Sep 2026 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224839; cv=none; b=hW2nzTJVXw1zhZHeO8X5WyYOEB+UZ0Ra3D4qQFLuOaBYetNJT4tSjpzd2aLs1reoVGhmEgKeBguEoLgU1zt80WBpdMv88qtW5KF6HIkqwFdj1++JMqNzHY10NCCiBKModgzt9Zinu7HGsvHfb8UOlziot5BlYN49hZJ1BmPRxPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224839; c=relaxed/simple;
	bh=ZcEcJgOx9WlIWwyL38SjHutmoNGtKnY71/6bQL4qb5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1pYt6bvLaP2Zxv++Oyi6p4GlEnuALn2Pwj96g5ZXQxTexWqMbaC9f2nvR3ZyP0qgV/rha5zIRqQWEj74OCM7dSD5hNKnBAe3EwT0WJM4zAE5Zy2QfF43jwJiXB+rzcXa5duXr92/+zMMMWW1DWr+n1BQ2l39WrpSaW0E579QBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDsou6pL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDsou6pL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6081F000FF;
	Sat, 12 Sep 2026 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224837;
	bh=C4sYDoFU+p9xNdZsICsZMNMh/CtmAj2+yoD9xsQ16g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HDsou6pL5yLGx4aGooqN2UalHtySH+z9GEBflCE5vXBihrB5lt/f9E85JhETz2owa
	 i+/PTgW6Y6TP8lUO8bBix3m3pHEFMckn5BUxgtmAPo67zsJf8+o36bz463jA5VFx9Z
	 peFlvpmhIKdTprYVcXIomWbKA3Z8+oFn48WKQjB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1074/1424] drm/sun4i: crtc: Propagate layer initialization error
Date: Sat, 12 Sep 2026 08:58:26 +0200
Message-ID: <20260912065631.354844402@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



