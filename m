Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A082C861
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHmnc6Nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB2CC433C8;
	Wed, 15 Nov 2023 19:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076303;
	bh=HKZjmemUDG9mLF+H3cItu2xXzaC1YNePTv5OPUcuFAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHmnc6NbHC4SydqcTdCxcZdxIh1pxiCsxqfnH1xaMHqN13gY59uirorJAFVbPzBeZ
	 hU39YoKFVqtxzPK15aauxLCUZdwELx018YoEYtyG3LLk7xqfORveYJwYKgZIcDQsAe
	 0j5AoGCgbOGHKa7/N0e+7NfYABZ3csSx81yVqr3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 206/550] drm/rockchip: vop: Fix call to crtc reset helper
Date: Wed, 15 Nov 2023 14:13:10 -0500
Message-ID: <20231115191615.055853795@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 5aacd290837828c089a83ac9795c74c4c9e2c923 ]

Allocation of crtc_state may fail in vop_crtc_reset, causing an invalid
pointer to be passed to __drm_atomic_helper_crtc_reset.

Fix this by adding a NULL check of crtc_state, similar to other drivers.

Fixes: 01e2eaf40c9d ("drm/rockchip: Convert to using __drm_atomic_helper_crtc_reset() for reset.")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230621223311.2239547-4-jonas@kwiboo.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index 1f88a94d002af..5b7b7b6deed9e 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -1641,7 +1641,10 @@ static void vop_crtc_reset(struct drm_crtc *crtc)
 	if (crtc->state)
 		vop_crtc_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &crtc_state->base);
+	if (crtc_state)
+		__drm_atomic_helper_crtc_reset(crtc, &crtc_state->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 #ifdef CONFIG_DRM_ANALOGIX_DP
-- 
2.42.0



