Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33050171A6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC60CC433C7;
	Wed,  9 Aug 2023 11:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578894;
	bh=g3lm+/DoZrAH4e1Xzx69w5OIQX7B068y/Da5UOrfw7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=de0WYLNQz4Nc6k3QPQ/UKE0UppVJGaQ2Zj5rXmVU3b4O5dMJYUQTu4jlZbpb2pdzF
	 VrUTr3zyxw4qCJWLRXNUtAGKksXwbONBaDJ/rJHIKF65hBRhUNsoJyuBkeIHWsDBQr
	 lJeyUaevrhh9VCXW4BmW0j/9G2G5pS4B8DLxQdi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 86/92] drm/imx/ipuv3: Fix front porch adjustment upon hactive aligning
Date: Wed,  9 Aug 2023 12:42:02 +0200
Message-ID: <20230809103636.505554984@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit ee31742bf17636da1304af77b2cb1c29b5dda642 ]

When hactive is not aligned to 8 pixels, it is aligned accordingly and
hfront porch needs to be reduced the same amount. Unfortunately the front
porch is set to the difference rather than reducing it. There are some
Samsung TVs which can't cope with a front porch of instead of 70.

Fixes: 94dfec48fca7 ("drm/imx: Add 8 pixel alignment fix")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20230515072137.116211-1-alexander.stein@ew.tq-group.com
[p.zabel@pengutronix.de: Fixed subject]
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230515072137.116211-1-alexander.stein@ew.tq-group.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3-crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index f7863d6dea804..ba5b16618c237 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -311,7 +311,7 @@ static void ipu_crtc_mode_set_nofb(struct drm_crtc *crtc)
 		dev_warn(ipu_crtc->dev, "8-pixel align hactive %d -> %d\n",
 			 sig_cfg.mode.hactive, new_hactive);
 
-		sig_cfg.mode.hfront_porch = new_hactive - sig_cfg.mode.hactive;
+		sig_cfg.mode.hfront_porch -= new_hactive - sig_cfg.mode.hactive;
 		sig_cfg.mode.hactive = new_hactive;
 	}
 
-- 
2.40.1



