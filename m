Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7F126FA77;
	Tue, 12 Aug 2025 19:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025789; cv=none; b=QUbVNwQgcr5sN5knDiYX76s0vW5EOXWgrGxsZ4wkGFiwrskPBbQIhlVZZhgRDRliZ0Uww6bsXuzpDxfq/yLujRTwPQRkXjVq21L4X88Hqgo8tj2IS3L8nvSRoARDizzUFyY0U16H+rTSQ6wsmiIeAHn+d4nKQzaS8p6aPW3k1lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025789; c=relaxed/simple;
	bh=xOCA7CJgc+0RsqcC8p5bpL4HOu6E49l5wYw+PlcVZ9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjPf1wbhXocfRylRVNO/pi3yAllnFZkwhCtkkkDwmfwq56jVWOfVIfE234iimT1RC9w4MHFVOlCcTuyf03G/O8DGSrwFhoecP//Dof62ehxXoTqKBAMvDWtx+/b+TJocvFAGjQVVja+xTfbhJmhBiAjXxLm/+xsUN+6q/whxIs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2XB0vzuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2XB0vzuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823CBC4CEF0;
	Tue, 12 Aug 2025 19:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025789;
	bh=xOCA7CJgc+0RsqcC8p5bpL4HOu6E49l5wYw+PlcVZ9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2XB0vzuROrEq+/m/mXlV/TsEyVGOZZ6+22ied/hwPn4K+2ES/sbpbWFQ60VPqolIU
	 gcE92waoslsvuokYgqbW/w+S21qm9sowvcMO73aYZNK+2qwHqM3YT1l2YqgrnbPaxm
	 YxfSfClkrWAakSQL/tmwP3mMSzm4Q71OXAXxoAfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 143/480] drm/rockchip: vop2: fail cleanly if missing a primary plane for a video-port
Date: Tue, 12 Aug 2025 19:45:51 +0200
Message-ID: <20250812174403.417021162@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index d0f5fea15e21..6b37ce3ee60b 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -2422,6 +2422,10 @@ static int vop2_create_crtcs(struct vop2 *vop2)
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
2.39.5



