Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B27D528;
	Sun,  7 Sep 2025 20:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276864; cv=none; b=gR9l0WJHkxNoEE9HJY87s2snfYT4TmNjudV+vZ5DiObENyA7J1vVIKz2AA7dJzOE6wlgbq7xDgIC0j+geS/Wpj6smk3Q8dIar3w7EoR4hsy1vwV/woavXZ1xVvwjx2zwdUOUCaZ+372tYEkyJ6Y/LhQKmP7cTo7sOS23ykZcTMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276864; c=relaxed/simple;
	bh=tt1jpZ8UhDgyFP5dfgDjVIHCFfREALUrILsU5YdTIVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhezkGsayURBcTBgWAcB6a1svpN/0t/3kwA5wtJX6LirnKgZrCkl+ibGXmcY6Gv3QQD2oEVmD2lrX+Qj7Z8D1RSGZ93gvXjzxyG+kt+YgmE6iF8rj48MKHWa9bMFF0ZRJoNvGYyhAbuf68Azhz2KrlWCtCFL1or29kLZnTyr6ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGevOuxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGevOuxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B114C4CEF0;
	Sun,  7 Sep 2025 20:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276864;
	bh=tt1jpZ8UhDgyFP5dfgDjVIHCFfREALUrILsU5YdTIVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGevOuxCl3tHcku9sxQQ6eCP+MOgzNzmVhlNbfXSBOp1rHT2ViMKCtyXyP4Y+CrSv
	 OcSbMMmskB+r96fQhXGmNjE8Wl20F9OXlRU3IlfUd9JJvFkzZUJ8mv1hga2SAmc4+t
	 SQOppwD6iEvCK6c8B344rSmL08TrIXC+CTy1u2dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Andy Yan <andy.yan@rock-chips.com>,
	Piotr Zalewski <pZ010001011111@proton.me>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/175] drm/rockchip: vop2: make vp registers nonvolatile
Date: Sun,  7 Sep 2025 21:56:48 +0200
Message-ID: <20250907195615.203313380@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Zalewski <pZ010001011111@proton.me>

[ Upstream commit a52dffaa46c2c5ff0b311c4dc1288581f7b9109e ]

Make video port registers nonvolatile. As DSP_CTRL register is written
to twice due to gamma LUT enable bit which is set outside of the main
DSP_CTRL initialization within atomic_enable (for rk356x case it is also
necessary to always disable gamma LUT before writing a new LUT) there is
a chance that DSP_CTRL value read-out in gamma LUT init/update code is
not the one which was written by the preceding DSP_CTRL initialization
code within atomic_enable. This might result in misconfigured DSP_CTRL
which leads to no visual output[1]. Since DSP_CTRL write takes effect
after VSYNC[1] the issue is not always present. When tested on Pinetab2
with kernel 6.14 it happenes only when DRM is compiled as a module[1].
In order to confirm that it is a timing issue I inserted 18ms udelay
before vop2_crtc_atomic_try_set_gamma in atomic enable and compiled DRM
as module - this has also fixed the issue.

[1] https://lore.kernel.org/linux-rockchip/562b38e5.a496.1975f09f983.Coremail.andyshrk@163.com/

Reported-by: Diederik de Haas <didi.debian@cknow.org>
Closes: https://lore.kernel.org/linux-rockchip/DAEVDSTMWI1E.J454VZN0R9MA@cknow.org/
Suggested-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
Tested-by: Diederik de Haas <didi.debian@cknow.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250706083629.140332-2-pZ010001011111@proton.me
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 5d7df4c3b08c4..bb936964d9211 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -3153,12 +3153,13 @@ static int vop2_win_init(struct vop2 *vop2)
 }
 
 /*
- * The window registers are only updated when config done is written.
- * Until that they read back the old value. As we read-modify-write
- * these registers mark them as non-volatile. This makes sure we read
- * the new values from the regmap register cache.
+ * The window and video port registers are only updated when config
+ * done is written. Until that they read back the old value. As we
+ * read-modify-write these registers mark them as non-volatile. This
+ * makes sure we read the new values from the regmap register cache.
  */
 static const struct regmap_range vop2_nonvolatile_range[] = {
+	regmap_reg_range(RK3568_VP0_CTRL_BASE, RK3588_VP3_CTRL_BASE + 255),
 	regmap_reg_range(0x1000, 0x23ff),
 };
 
-- 
2.50.1



