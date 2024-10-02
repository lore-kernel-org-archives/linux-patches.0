Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5EE1D043E;
	Wed,  2 Oct 2024 14:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877771; cv=none; b=OvwvpqCRj8S4w2txYjisJ8LGveb/kYV1uViYva+WZpyZ+qJcxNyCQStzpIXGPJmiKD+jfxWfMIQs02FCNqeGETQh0pBq1u6R9R/HA6S78s0GD+zvfkOH7naxV6cWsx3cnx/REGd3XeFsG8t5uA43T3E7pVwpODMspgciIKmWdlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877771; c=relaxed/simple;
	bh=EwTO7CfBZ9tBsA0/hCvguoorqmpQv1EjtXQ2LvaOqDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkDJbe5tzSJ9sjIiocsrJKx1Tw8OTUKr57O6Rsgy33gTb048dEpley7RY7qYItS1muxhp1ToJIgSc0MGXsAAMIR704q8snpcD8IsHVnO4f1ctSRBy0UgF47ifWEwbY75Wl/GyUrQdOUi9HDt/CnYQkT+QocUPo2QRQTsSPaCwIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5ugapE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5ugapE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA2FC4CED3;
	Wed,  2 Oct 2024 14:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877770;
	bh=EwTO7CfBZ9tBsA0/hCvguoorqmpQv1EjtXQ2LvaOqDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5ugapE2D9BNgzmYsM2F3JCb2vMkLOl/skCCrkNfM99YIOHPK0L0osykKrlntdzVW
	 4GMrc4QzdCWDYD+xAnKz8bBcPIj+PE355qj1l2sDRgH3lfH+ITJeDjwyEsvzhfxfuU
	 mZoixgs9kHspC+ECl5J9apwbIMa+xANtQZ/nknfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 188/634] drm/rockchip: dw_hdmi: Fix reading EDID when using a forced mode
Date: Wed,  2 Oct 2024 14:54:48 +0200
Message-ID: <20241002125818.527246513@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit a5d024541ec466f428e6c514577d511a40779c7b ]

EDID cannot be read on RK3328 until after read_hpd has been called and
correct io voltage has been configured based on connection status.

When a forced mode is used, e.g. video=1920x1080@60e, the connector
detect ops, that in turn normally calls the read_hpd, never gets called.

This result in reading EDID to fail in connector get_modes ops.

Call dw_hdmi_rk3328_read_hpd at end of dw_hdmi_rk3328_setup_hpd to
correct io voltage and allow reading EDID after setup_hpd.

Fixes: 1c53ba8f22a1 ("drm/rockchip: dw_hdmi: add dw-hdmi support for the rk3328")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240615170417.3134517-5-jonas@kwiboo.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
index fe33092abbe7d..aae48e906af11 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -434,6 +434,8 @@ static void dw_hdmi_rk3328_setup_hpd(struct dw_hdmi *dw_hdmi, void *data)
 		HIWORD_UPDATE(RK3328_HDMI_SDAIN_MSK | RK3328_HDMI_SCLIN_MSK,
 			      RK3328_HDMI_SDAIN_MSK | RK3328_HDMI_SCLIN_MSK |
 			      RK3328_HDMI_HPD_IOE));
+
+	dw_hdmi_rk3328_read_hpd(dw_hdmi, data);
 }
 
 static const struct dw_hdmi_phy_ops rk3228_hdmi_phy_ops = {
-- 
2.43.0



