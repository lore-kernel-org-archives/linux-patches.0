Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F531D0434;
	Wed,  2 Oct 2024 13:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875766; cv=none; b=baALik6XtbCy3RGEqarOnozMUWX5LHQ5duqztyFnjlLB2igp69gLXIZ3e84IGNKioiyGK1CFgBT/bugtHcCcH+QippU69GwTVGxcSatBhfR0FYBK4ZHa0AGrnVn+e1dw062RwBoZIKg7SCuv6ol+jGhX7a88Dr5mCcRzDhRkYvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875766; c=relaxed/simple;
	bh=2wyHWscCWaos7MiR3p3BVBlMDB0pKMOoCOxDnuVxkxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kuv0CWLop5Q/0D1N/jNV4I1Xoy9XYQhbnUd7viSC6A1tuWAJwZMzgc5GHFrBGXsNc4NbA5sUaOIWKx3sCwGE4IIGO4igSjXm2Q40GXprOsYDCMfc5AH83UY7nwU7xKKfjD2+QAgwJiciHQc+HVQehFjZHNR02idcvcZ6xzV8P08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A52IaBqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A52IaBqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A287EC4CEC5;
	Wed,  2 Oct 2024 13:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875766;
	bh=2wyHWscCWaos7MiR3p3BVBlMDB0pKMOoCOxDnuVxkxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A52IaBqDKwXJ+fnmfn82SxVnUoN3k2ri5/VPplI0n7nrSZzQBJp7zIR5kO6cs9x3c
	 NvL0Rl0qsfdjXX8obQ4szC1wjLEpxCPRJa0JsV36Dt3mMUTLj4GVhC0CxuE/Rg66Eo
	 tvBICZqP29qJ4N9IJqsIrDGIvy3HIAYheHl9+55w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 213/695] drm/rockchip: dw_hdmi: Fix reading EDID when using a forced mode
Date: Wed,  2 Oct 2024 14:53:31 +0200
Message-ID: <20241002125830.965323863@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



