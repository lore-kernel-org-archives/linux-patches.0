Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151F14087C;
	Mon, 14 Oct 2024 14:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917722; cv=none; b=TsPBqYtjOePkdROF14a6gPapdT2ys0lUw0oiPaAxY68+E/oli3IL1JpEPPjjCnQk3FuF60XNvgDgFMmfYYUAcgFZGpZnRnESkcBbztI2j7WXgOIXcVk9xabR1bDd4PJ+NOB0ZVOmhNogY4OrBG2DZTOcpynYv4+aBiqkU/KPvXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917722; c=relaxed/simple;
	bh=8zZJ92lSfbLdt848oupPn79rsbDqMfQ4tFscoiTfNZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUZ0VJSkyzzbtXjKv8ryHnH0GCWykuaOYtxxbrAccj6ZsJnUNKebu62dmh8hkPMm9rXDSv+wczIBhbvz4qW8Ghc5THdPoexK4BzNo7FXtQfaXuyg7SPNPPhZJL0usLHVZHzdzZz+qL/j9sEbO2QdT0XdyFOBK1g9eFHl5rZG/QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNZZR28P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNZZR28P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A581C4CEC3;
	Mon, 14 Oct 2024 14:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917722;
	bh=8zZJ92lSfbLdt848oupPn79rsbDqMfQ4tFscoiTfNZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNZZR28PqcG8v5Vsn6NWERIxMvgD4OwcQOl+ZkBPDRb5FeeeqnnwOC66nU+KUJeHS
	 hcZK7N9S8ybgdgrNhvgG0ybsGd+hd5ji+p/xIt0YoMuEuugnE5ZkqXO/pqmd4B+mkc
	 mWpHQZs+sc2f5CooNBPNrVgGKFU4BTyDTOTU5xfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/798] drm/rockchip: dw_hdmi: Fix reading EDID when using a forced mode
Date: Mon, 14 Oct 2024 16:11:08 +0200
Message-ID: <20241014141222.404074737@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index ae857bf8bd624..566f2942f24ae 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -410,6 +410,8 @@ static void dw_hdmi_rk3328_setup_hpd(struct dw_hdmi *dw_hdmi, void *data)
 		HIWORD_UPDATE(RK3328_HDMI_SDAIN_MSK | RK3328_HDMI_SCLIN_MSK,
 			      RK3328_HDMI_SDAIN_MSK | RK3328_HDMI_SCLIN_MSK |
 			      RK3328_HDMI_HPD_IOE));
+
+	dw_hdmi_rk3328_read_hpd(dw_hdmi, data);
 }
 
 static const struct dw_hdmi_phy_ops rk3228_hdmi_phy_ops = {
-- 
2.43.0



