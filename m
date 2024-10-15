Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7400D1E7C02;
	Tue, 15 Oct 2024 11:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992620; cv=none; b=Fux/wNuB3qlilMZwSf7Sq7jnUlRDXx24ixvGxhODhIjUYU/k8jZ0Zkyp2cP49PoP9UAgvV9c467KPupcIB0AdCcPLOlSOYgUlC4u5n0alBXLWYhOR3tojk9VDZnUEsxcFMXzoT+Dbj3gcgkA1TMXLagCdwfmoXH0BmDoYTnYg/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992620; c=relaxed/simple;
	bh=B7DC2eYPrXTlf6iTYfj++Kq6qCEMvcKHY+o8v7COF1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUY/wivVa/7FLG3J1dPOw9StUngaqwo3qzEVIOvt59uhmdctYou2Iba4QbNy7L6Jr+nVCSulhRT+nBdm1UVW9PFKzped8EcMnEcT7qwMgkrHNBeKe4dDsE2odin4AGOpOG72M6KydPx99y8NUY2BYcl9zFlM2nK55+DhJcFWaSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWvff4g+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWvff4g+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7455BC4CED2;
	Tue, 15 Oct 2024 11:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992619;
	bh=B7DC2eYPrXTlf6iTYfj++Kq6qCEMvcKHY+o8v7COF1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWvff4g+IPiHCIPh/WKuyDO2SHbu7YXW0lus0zFaDARSxWPrNN7HM3K6QvDQfVSH5
	 Pdt6ax6cAbMqO6gZ9OaSKUHQPcVqXTvHz56A6mP0YDGI1/cFW9EeUEZ3MX99VkqhwX
	 A7wGbPQ6XgJa4F6623/YkALs1WlHs9ej+yCOJJgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 169/691] drm/rockchip: dw_hdmi: Fix reading EDID when using a forced mode
Date: Tue, 15 Oct 2024 13:21:57 +0200
Message-ID: <20241015112447.075468185@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8677c82716784..9e1c34af53909 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -389,6 +389,8 @@ static void dw_hdmi_rk3328_setup_hpd(struct dw_hdmi *dw_hdmi, void *data)
 		HIWORD_UPDATE(RK3328_HDMI_SDAIN_MSK | RK3328_HDMI_SCLIN_MSK,
 			      RK3328_HDMI_SDAIN_MSK | RK3328_HDMI_SCLIN_MSK |
 			      RK3328_HDMI_HPD_IOE));
+
+	dw_hdmi_rk3328_read_hpd(dw_hdmi, data);
 }
 
 static const struct dw_hdmi_phy_ops rk3228_hdmi_phy_ops = {
-- 
2.43.0



