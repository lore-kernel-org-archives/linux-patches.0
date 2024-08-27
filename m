Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A221C7B9D;
	Tue, 27 Aug 2024 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772241; cv=none; b=VmVKBo3YWoarf7ykEczLRGoYVG87h1gJRAsy6egssfCTrhwyJegia3UZ365BHYuC5OnjidPf0STqS0MhFFgic6KKs18EjfOCNsDy5yixzLFCO/Rougc0SlenZ3aEJyYNDo1jAvwm2x5JL8yDR5/fHhZOj/One2b9pdi24UZhYlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772241; c=relaxed/simple;
	bh=CcBanGG4zmLAbuMqW+S4zCevLlqJ9FRO5h9RYrtWuIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0s+Ah5ATI3EA1/UETJXE6hxNGpEcEegD6hnc+u4P4KzbNLi8SQ5RhdAEeqQDIgng+g0/tkIK7Ir9waFggXpP8I/37s+/BL+ezgBLfSU2GTkYnepaGIENc3fgXYIsl+tad6moLA8QXdpITdajOGVdehGTkzenstlVcIDBy2brnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=he+3y/gr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="he+3y/gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AF8C61064;
	Tue, 27 Aug 2024 15:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772240;
	bh=CcBanGG4zmLAbuMqW+S4zCevLlqJ9FRO5h9RYrtWuIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=he+3y/grTM5Gm75kec9nb3DAj6h4D/sPzsFJPS0/bc0yEx3iwEOfftz69uOIUAt5v
	 Jdx4GldZyQMYX88YzikUR47vqIQC61WQULkmbW4CeDq5a4TgzlZkmbQgsQYdAIUxKc
	 GkILLdUlnPoQd3ZpJM7WnhFUPw2936+zNVRARihg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/321] drm/rockchip: vop2: clear afbc en and transform bit for cluster window at linear mode
Date: Tue, 27 Aug 2024 16:37:43 +0200
Message-ID: <20240827143844.133700501@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 20529a68307feed00dd3d431d3fff0572616b0f2 ]

The enable bit and transform offset of cluster windows should be
cleared when it work at linear mode, or we may have a iommu fault
issue on rk3588 which cluster windows switch between afbc and linear
mode.

As the cluster windows of rk3568 only supports afbc format
so is therefore not affected.

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20231211115741.1784954-1-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 80b8c83342840..a6071464a543f 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -1258,6 +1258,11 @@ static void vop2_plane_atomic_update(struct drm_plane *plane,
 		vop2_win_write(win, VOP2_WIN_AFBC_ROTATE_270, rotate_270);
 		vop2_win_write(win, VOP2_WIN_AFBC_ROTATE_90, rotate_90);
 	} else {
+		if (vop2_cluster_window(win)) {
+			vop2_win_write(win, VOP2_WIN_AFBC_ENABLE, 0);
+			vop2_win_write(win, VOP2_WIN_AFBC_TRANSFORM_OFFSET, 0);
+		}
+
 		vop2_win_write(win, VOP2_WIN_YRGB_VIR, DIV_ROUND_UP(fb->pitches[0], 4));
 	}
 
-- 
2.43.0



