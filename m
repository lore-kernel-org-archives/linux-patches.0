Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA72A481DD;
	Sat, 30 May 2026 17:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160986; cv=none; b=UuAzpP3I2K+xiPtCZNiWCSz+Loy1ZC3NE3H/8zGGtymfK0OMrRVXpfKBwG585ZHHhVLgNRPzR2slKcD2yw39YrPu8sKTOXhC0vK23uOSdwgXqA0MZ+HKaH1cqNZ/Ux8D2gokpgxjB4UEedwJ5MoeuNYRHdE/rnuzY0H2GzuVWn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160986; c=relaxed/simple;
	bh=q4o2QLWwS13uNJGWsitdZbWAjS+PJnG5ckZL52arGo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5T9moq9Fezu4bYNvIO4TeaplnS0k4eRPk/OJiCsiZbzl0SVm1CvbbYoSzAekPPJUrEgzC8tOx3P7TFLfMp9h6SH0R1NCz3USROHUfYYZoqn/smqtNDfAoeykciJfxk9rJ4oDfbnc00kQGgxG6khvmNgUG+ndwc+V7ROk5mgHvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zh1L2ykD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zh1L2ykD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF48A1F00893;
	Sat, 30 May 2026 17:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160985;
	bh=S/8Gl+jvrtxi3txN7Kdv6hr7ysd/GLjmHKoSf293NRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zh1L2ykDbxP/M7PCUKUNQU6iVxJ+7BgNhaj2vw0Rlinvje6ctgs2gU6UTjQo/a1Ir
	 5kdBHFsfwtY035yYkRO0u3GqtFmwfvpKbADyha4Q/eSvi01EYaxasTxdjmJgW3hksx
	 N1lumuqATS0AQXcB2Qnl2pmagLQxhv/v6e5+3x64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 492/969] drm/sun4i: backend: fix error pointer dereference
Date: Sat, 30 May 2026 18:00:16 +0200
Message-ID: <20260530160313.902763184@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 06277983eca4a31d3c2114fa33d99a6e82484b11 ]

The function drm_atomic_get_plane_state() can return an error pointer
and is not checked for it. Add error pointer check.

Detected by Smatch:
drivers/gpu/drm/sun4i/sun4i_backend.c:496 sun4i_backend_atomic_check() error:
'plane_state' dereferencing possible ERR_PTR()

Fixes: 96180dde23b79 ("drm/sun4i: backend: Add a custom atomic_check for the frontend")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/20260217014801.60760-1-ethantidmore06@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_backend.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun4i_backend.c b/drivers/gpu/drm/sun4i/sun4i_backend.c
index 38070fc261f3a..d4fd621e33158 100644
--- a/drivers/gpu/drm/sun4i/sun4i_backend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_backend.c
@@ -488,6 +488,9 @@ static int sun4i_backend_atomic_check(struct sunxi_engine *engine,
 	drm_for_each_plane_mask(plane, drm, crtc_state->plane_mask) {
 		struct drm_plane_state *plane_state =
 			drm_atomic_get_plane_state(state, plane);
+		if (IS_ERR(plane_state))
+			return PTR_ERR(plane_state);
+
 		struct sun4i_layer_state *layer_state =
 			state_to_sun4i_layer_state(plane_state);
 		struct drm_framebuffer *fb = plane_state->fb;
-- 
2.53.0



