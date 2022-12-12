Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CC228ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5831C433EF;
	Mon, 12 Dec 2022 13:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850934;
	bh=vEPvDKrkASEh3Lpr0wJltEAz2Wx2L3wei8SMyfF3M7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxOtdR1UBriWvo4VfCkyDsca2ZuBAbnePASq3meoEOI+3/fdP0wjBIfD1VyZ5ruoE
	 cDCyJXbuiVnqMwFtmy2TKoj5nekazCNd0c5zQm0DzvRQ9kIeNe03RNm9kkBE79Ys2L
	 rriVw/iJZX91Ttyxqr5BBmSnWpw7wmY3tQNXZZXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiqi Zhang <eddy.zhang@rock-chips.com>,
	Douglas Anderson <dianders@chromium.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/106] drm/bridge: ti-sn65dsi86: Fix output polarity setting bug
Date: Mon, 12 Dec 2022 14:10:11 +0100
Message-Id: <20221212130927.850759159@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qiqi Zhang <eddy.zhang@rock-chips.com>

[ Upstream commit 8c115864501fc09932cdfec53d9ec1cde82b4a28 ]

According to the description in ti-sn65dsi86's datasheet:

CHA_HSYNC_POLARITY:
0 = Active High Pulse. Synchronization signal is high for the sync
pulse width. (default)
1 = Active Low Pulse. Synchronization signal is low for the sync
pulse width.

CHA_VSYNC_POLARITY:
0 = Active High Pulse. Synchronization signal is high for the sync
pulse width. (Default)
1 = Active Low Pulse. Synchronization signal is low for the sync
pulse width.

We should only set these bits when the polarity is negative.

Fixes: a095f15c00e2 ("drm/bridge: add support for sn65dsi86 bridge driver")
Signed-off-by: Qiqi Zhang <eddy.zhang@rock-chips.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221125104558.84616-1-eddy.zhang@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 1a58481037b3..77a447a3fb1d 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -621,9 +621,9 @@ static void ti_sn_bridge_set_video_timings(struct ti_sn_bridge *pdata)
 		&pdata->bridge.encoder->crtc->state->adjusted_mode;
 	u8 hsync_polarity = 0, vsync_polarity = 0;
 
-	if (mode->flags & DRM_MODE_FLAG_PHSYNC)
+	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
 		hsync_polarity = CHA_HSYNC_POLARITY;
-	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
+	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
 		vsync_polarity = CHA_VSYNC_POLARITY;
 
 	ti_sn_bridge_write_u16(pdata, SN_CHA_ACTIVE_LINE_LENGTH_LOW_REG,
-- 
2.35.1



