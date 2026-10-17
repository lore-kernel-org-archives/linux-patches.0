Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8172C382F25;
	Sat, 17 Oct 2026 16:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253384; cv=none; b=hvxn+yn/noyF624K/RVcK2+J/UL/ylMpDr78XwmU8D20DwA4FcgWwZMWx0FCMsR7Kg68hYI9c0hwNE3Z221cM71Uxs8JFd8LtJeIQvJgEsJ+R6/LdaVMTfg5h1kw/yYtG6kN3mcVfKYjw5MZEejZfQ4f0DjhlrFF2GjFYo8b1Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253384; c=relaxed/simple;
	bh=xDQz6I1vBpJMipJFB+iw2szAI0fpgGC8kKFT+WDn6Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvERKz5cRf108kUfiofRgZn91nkTaMOC2AvOHXE5oO7qFQruM+bs9mkZTi/FMNrxkqFdKzdQjHfQTnkw+jHMRBuXrz7wa0pk9voV531Wu1zA4r83Iaa9ZBwlZ/8plJEBaUaQyDHG2k17EFdo10zsHHgWoM3oJeSM30G0gKXAjaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3QYsuYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3QYsuYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50E11F000C5;
	Sat, 17 Oct 2026 16:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253382;
	bh=vP+aBYAmPfkwK6f/VZu1hm9mwODuoyFFH63sOenOZp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3QYsuYD6lby5VB9WQbDnP+ySIhyOf5LACLfBkHOiE6AZw86mgMjomQrIdsWKCjIZ
	 kWoGapVa4xS5j2BoCv20aQ5wx6bD4JwSAZDBnhKS03aspbFUkHBUuxvQ3khN4dC30g
	 Q+si3zYRoOmeMSXqOp6mqUi5d+2FFOE2FMXr80eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/869] drm/rockchip: vop2: fail cleanly if missing a primary plane for a video-port
Date: Sat, 17 Oct 2026 17:49:00 +0200
Message-ID: <20261017160039.574029949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b3dcb387fb972..e3a65056c9c56 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -2864,6 +2864,10 @@ static int vop2_create_crtcs(struct vop2 *vop2)
 				break;
 			}
 		}
+
+		if (!vp->primary_plane)
+			return dev_err_probe(drm->dev, -ENOENT,
+					     "no primary plane for vp %d\n", i);
 	}
 
 	/* Register all unused window as overlay plane */
-- 
2.53.0



