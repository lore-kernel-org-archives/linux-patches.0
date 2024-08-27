Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C1344C8C;
	Tue, 27 Aug 2024 14:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770175; cv=none; b=AJ6Nq4K6rTY9cBmegYVE2AkNPkeFluPYx7jFzCWkM2k1Z7nk7vPYBaVlBWd8EgQssGr/t5QoTD2CH10ypd56U/y4cMal2wMk7bM523wKpD60Id8lpPFJUlbHR/TZRAXBPCAHedvnsj6hnfxNgkqY03nlWJ+QHKyTCK2wFh5WBmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770175; c=relaxed/simple;
	bh=/3tk203zi4wM6s8ehTvVePxWCEVClve/4Gzc35f6+Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZYKjQAAZ00wjJEO727Tucvdu8ec3dL0Nw3t7Jwo/tO/SNftdWkzcnA5jPyls8fwiXG/GnTlCGkSBvyzgxGCTNf3zQvJG7L9nM+cqtG3MjABbXkzvI1HZZyGNf6Yam3UZqrj5RdZ65oRszMEDpWcQzD6nwKf0FSnMeLgyDp1/N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzqVF/bU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzqVF/bU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A32C4AF52;
	Tue, 27 Aug 2024 14:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770174;
	bh=/3tk203zi4wM6s8ehTvVePxWCEVClve/4Gzc35f6+Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzqVF/bU4ES/JeBOJeJLltsOeTn7MFHEG00i8wvwP3kfMoa31WQJLUgAoKGuwaFtj
	 XJPUVEDFPv++AuXzjIJD66vUzkO35ZMdrCd7erCS9Q10k2rOJrsd+k+vXh0tmczIS5
	 o44HJaaAsr0U5w2nIolbXA8++Faf+rHQVfkTsJwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/341] drm/rockchip: vop2: clear afbc en and transform bit for cluster window at linear mode
Date: Tue, 27 Aug 2024 16:36:19 +0200
Message-ID: <20240827143849.052000241@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f2a956f973613..d1de12e850e74 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -1260,6 +1260,11 @@ static void vop2_plane_atomic_update(struct drm_plane *plane,
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



