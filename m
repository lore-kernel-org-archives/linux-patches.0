Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56DD3AFB07;
	Sat, 17 Oct 2026 17:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258062; cv=none; b=RvwiV9kfb9ImrR9VoLp0hPK5auBR3/EnRAHHRHxDv2GXAK9MxC6uHMj1mmzMdn5g9yE7egSmUYGxHuYYICqmr2Et0uDAhR2/M/jOpsCTNlX0E6i7Cabwq/nBzdSyx7KrSoOq4OG7C2cYgPjvrTmpJHaDyTHxx2RSzw+TIubjFG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258062; c=relaxed/simple;
	bh=k1SlHxo0sTafvl/w7FA4Jee75xm2JSszgoCgwHjiNuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TeKNKZs5O5p7WQbC3bR5dpNHU2k4F0ke9KrVsGfGWyIk0wVTrBV4BOFBHvBRumZihY9QgBKd7i6QuHzMIvD8cyAQ0BonkPrPwGqk5ffnf5Bj9rZNQFAazsjqg10N5oru4X9cs9pQjzQpKRIQyiXXr57kmLiF/JOjIDBGSGR6YHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vq5vzXB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vq5vzXB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28231F000C4;
	Sat, 17 Oct 2026 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258060;
	bh=c/QYM0VoLiUxEoKUWaODNa7krNYyDRNsz4ogf36a5Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vq5vzXB3VIYm6JqKeew1FkAoqdggZWEYtfmjCXpDPxJ0TT2G+VLb0GErpU6TDEheA
	 1AgMuzoxxBhvNY7jeXPNpQM9mLpUR3YFT/FYdar5R/eNZgarF/FXWhq9D4KqTYnOET
	 q65hyS1m/sGaZ07acs9wb2BfoaxqYSjWLwmSIuqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0760/1674] drm/rockchip: vop2: fail cleanly if missing a primary plane for a video-port
Date: Sat, 17 Oct 2026 17:50:32 +0200
Message-ID: <20261017160450.607965670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit f9f68bf1d0efeadb6c427c9dbb30f307a7def19b ]

Each window of a vop2 is usable by a specific set of video ports, so while
binding the vop2, we look through the list of available windows trying to
find one designated as primary-plane and usable by that specific port.

The code later wants to use drm_crtc_init_with_planes with that found
primary plane, but nothing has checked so far if a primary plane was
actually found.

For whatever reason, the rk3576 vp2 does not have a usable primary window
(if vp0 is also in use) which brought the issue to light and ended in a
null-pointer dereference further down.

As we expect a primary-plane to exist for a video-port, add a check at
the end of the window-iteration and fail probing if none was found.

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Reviewed-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250610212748.1062375-1-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index bd5bce9d8c2cf..89c914bcfbf15 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -2412,6 +2412,10 @@ static int vop2_create_crtcs(struct vop2 *vop2)
 		if (!vp->crtc.port)
 			continue;
 
+		if (!vp->primary_plane)
+			return dev_err_probe(drm->dev, -ENOENT,
+					     "no primary plane for vp %d\n", i);
+
 		plane = &vp->primary_plane->base;
 
 		ret = drm_crtc_init_with_planes(drm, &vp->crtc, plane, NULL,
-- 
2.53.0



