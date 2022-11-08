Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145BD15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD7CC433D6;
	Tue,  8 Nov 2022 14:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916712;
	bh=ym2Khj71xrzmcmSBJNzLdZlzTcxcV2YaVd9XtzyjjWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vc0mHsCK1h2a5/KBt8OD3DDuG7Faik7CQlbFcmmINoKSZzaP6X5J6J4MtsCSTHAQx
	 dW1gO6He+JL69EOOwwiuGD4erJd2F0c08wVmShabf0jZyyp/D7DBTy6P6lReR+gTz4
	 holDUDCtlJewn9q0GX6xh+VJr+hUFyVsA+bGyiSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 109/197] drm/rockchip: dw_hdmi: filter regulator -EPROBE_DEFER error messages
Date: Tue,  8 Nov 2022 14:39:07 +0100
Message-Id: <20221108133359.807764039@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aurelien Jarno <aurelien@aurel32.net>

[ Upstream commit bfab00b94bd8569cdb84a6511d6615e6a8104e9c ]

When the avdd-0v9 or avdd-1v8 supply are not yet available, EPROBE_DEFER
is returned by rockchip_hdmi_parse_dt(). This causes the following error
message to be printed multiple times:

    dwhdmi-rockchip fe0a0000.hdmi: [drm:dw_hdmi_rockchip_bind [rockchipdrm]] *ERROR* Unable to parse OF data

Fix that by not printing the message when rockchip_hdmi_parse_dt()
returns -EPROBE_DEFER.

Fixes: ca80c4eb4b01 ("drm/rockchip: dw_hdmi: add regulator support")
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220926203752.5430-1-aurelien@aurel32.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
index c14f88893868..2f4b8f64cbad 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -565,7 +565,8 @@ static int dw_hdmi_rockchip_bind(struct device *dev, struct device *master,
 
 	ret = rockchip_hdmi_parse_dt(hdmi);
 	if (ret) {
-		DRM_DEV_ERROR(hdmi->dev, "Unable to parse OF data\n");
+		if (ret != -EPROBE_DEFER)
+			DRM_DEV_ERROR(hdmi->dev, "Unable to parse OF data\n");
 		return ret;
 	}
 
-- 
2.35.1



