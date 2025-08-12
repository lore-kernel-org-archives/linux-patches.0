Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB1A1DB92A;
	Tue, 12 Aug 2025 18:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023836; cv=none; b=lG1QNT0yDuCg7+UOKGRZriSYOk+A4X2nWnf2xEVKzMfAueog0tVhFqedS1C8YnREBn4ICvNmBY+aAxTmmBfx6NWkWohhEP3hC31xNdZCvfrVP8lwrQLCN/VSAA1HRaOv14rvuEGowf2bx4hDbXi7bDlSOtq87VDM+ln1fHR+qtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023836; c=relaxed/simple;
	bh=8wCYxCQ3Gjq3cKLCXbEpCsc/HDcBuHVoYPsZS2J+yDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCWHNX3Z7ovW7RztiPUE8/8AHE4YulgFrYjJgaLFfOO2UrGsCjpZ5aIgcBSYfWZfMIta75ucerJwGoI88plNAbDMLY63W8Pra32v86IjPFqS3MDvKR+f56Qz3L6G3Jk5K+oekw5s2s0mRMLQgDZ0DTB9yrzzdWsbVOPLFl5RXrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZIsjVdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZIsjVdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09799C4CEF0;
	Tue, 12 Aug 2025 18:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023836;
	bh=8wCYxCQ3Gjq3cKLCXbEpCsc/HDcBuHVoYPsZS2J+yDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZIsjVdK7pbkqfTR7sWyXrViivpaLTBnZNMYTyIul7XhdE4tv+iTjxIgncHP/cerh
	 vd8IHv1BpMm7oAu3122+y7EilX6wjbvIgLdplX4y5egePMS0XWkJ3KhxS6E0SEZfJT
	 5Wp5TKmUfT1DNmFd611CPJB6sdpXQk50euMpgWrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 196/627] drm/rockchip: vop2: fail cleanly if missing a primary plane for a video-port
Date: Tue, 12 Aug 2025 19:28:11 +0200
Message-ID: <20250812173426.730941018@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



