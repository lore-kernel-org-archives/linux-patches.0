Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5777F35F19
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWMng0Z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E23BC433C8;
	Wed, 15 Nov 2023 19:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076305;
	bh=iwhLVqGkVcXz7TqvgQw1BeATiXDmumuLdszGA6Vyc1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWMng0Z9VVjR3QJGi1Hi3PSheAlRRpqgzSxmW10L4jzr+4zkvYcoWQHQHhgQTU7Vr
	 cABqMxLpJhyAi2IamVLfIS7d95YSzi/WcPaUcF9tybUH1B09A+S0u/Qgvzl/hL9Ry5
	 o8xC4ywx1lfmgRkUuFY1c8OVXgy+EOtcSobpxK8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 207/550] drm/rockchip: vop2: Dont crash for invalid duplicate_state
Date: Wed, 15 Nov 2023 14:13:11 -0500
Message-ID: <20231115191615.125098510@linuxfoundation.org>
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

[ Upstream commit 342f7e4967d02b0ec263b15916304fc54841b608 ]

It's possible for users to try to duplicate the CRTC state even when the
state doesn't exist. drm_atomic_helper_crtc_duplicate_state() (and other
users of __drm_atomic_helper_crtc_duplicate_state()) already guard this
with a WARN_ON() instead of crashing, so let's do that here too.

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230621223311.2239547-5-jonas@kwiboo.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index ca73b8ccc29f4..f725487d02ef3 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -2099,11 +2099,13 @@ static void vop2_crtc_reset(struct drm_crtc *crtc)
 
 static struct drm_crtc_state *vop2_crtc_duplicate_state(struct drm_crtc *crtc)
 {
-	struct rockchip_crtc_state *vcstate, *old_vcstate;
+	struct rockchip_crtc_state *vcstate;
 
-	old_vcstate = to_rockchip_crtc_state(crtc->state);
+	if (WARN_ON(!crtc->state))
+		return NULL;
 
-	vcstate = kmemdup(old_vcstate, sizeof(*old_vcstate), GFP_KERNEL);
+	vcstate = kmemdup(to_rockchip_crtc_state(crtc->state),
+			  sizeof(*vcstate), GFP_KERNEL);
 	if (!vcstate)
 		return NULL;
 
-- 
2.42.0



