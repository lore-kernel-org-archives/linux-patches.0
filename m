Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609C14F5DED;
	Thu, 17 Sep 2026 17:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665583; cv=none; b=qVGIO8Iww6EAcsuiqlWEIXg11ty8xsqEpqw6+4kj4eDXNiugnMGhrIyYpGZyMnFIhDWq1JJVj0Az+Uk3FO2xn4W3p0sOoH75JNGbmHmpGNGw2pdTD+i2KinC/SZOTfTGfj23wSyPp749j15sh95/coipwEQhklXKbHFuV4PepWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665583; c=relaxed/simple;
	bh=DZpPihwYJmS/Nxuyc8k7Ior0RYCx4mtDS3NKAC8lPD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rL26YAYDrEbzIzjrJB91EgwglWpFvsejss+kAOvhF1f5iG+8FvCcAOcchaEsom/nSfqlokVAqGWw5ldpFkHaKxNYZk+1BolA/so//gZm7CiRlWkRtMjaZne8fYpvGMtQU4Uw7WQVACDOeLg2h1meG7iBSEm9Its9GSnj7MOVBCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LheFmQLi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LheFmQLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27071F000FF;
	Thu, 17 Sep 2026 17:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665581;
	bh=NvkckaVDH9eJpNDTvdPFpjTmODzjU7Xy+VAgZVAzYzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LheFmQLi16ydT/40oWLwEifYNjwSXsw7Bk49bUZG5hdaXtf4Kg+52BSJQ4RfiQY/a
	 bA6Aaa3dDkfzPzRbpQ3i0uPb5zaYSa7CJiYI9mrMCB+MDEOwUWQiDcSVk+n7eGr3AR
	 NX+2UZe/9WnnPAa0bLLTYy4opGq5/km9Gx7VZi4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Paunovic <royalnet026@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0752/1250] drm/rockchip: dw_dp: Select DRM_BRIDGE_CONNECTOR
Date: Thu, 17 Sep 2026 16:09:07 +0100
Message-ID: <20260917151612.261253623@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Paunovic <royalnet026@gmail.com>

[ Upstream commit c83e3e806d4c115f1dad9ef756db4cd91448a262 ]

dw_dp-rockchip.c calls drm_bridge_connector_init(), but ROCKCHIP_DW_DP
does not select DRM_BRIDGE_CONNECTOR. A configuration with
ROCKCHIP_DW_DP as the only enabled Rockchip output option fails to
link:

  aarch64-linux-gnu-ld: drivers/gpu/drm/rockchip/dw_dp-rockchip.o: in function `dw_dp_rockchip_bind':
  dw_dp-rockchip.c:(.text+0x1d4): undefined reference to `drm_bridge_connector_init'

Five other Rockchip encoder options that call
drm_bridge_connector_init() (ROCKCHIP_ANALOGIX_DP, ROCKCHIP_CDN_DP,
ROCKCHIP_DW_HDMI_QP, ROCKCHIP_LVDS, ROCKCHIP_RGB) already select it,
which masks the gap in any configuration that enables one of them.
ROCKCHIP_INNO_HDMI is covered through its DRM_INNO_HDMI core option.

The same change was posted by Marius Dinu in March and dropped when
the failure stopped reproducing in his build. The failure is
configuration-dependent - any other enabled option that selects
DRM_BRIDGE_CONNECTOR hides it - and it still reproduces on current
drm-misc-next with the configuration described above.

Select DRM_BRIDGE_CONNECTOR like the other users do.

Fixes: d68ba7bac955 ("drm/rockchip: Add RK3588 DPTX output support")
Link: https://lore.kernel.org/r/aneNCDU12OzG99UX@venus # ack to handle this apart from the dw-dp series
Link: https://lore.kernel.org/r/20260319155051.1944-1-m95d+git@psihoexpert.ro # earlier submission by Marius Dinu
Signed-off-by: Igor Paunovic <royalnet026@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260813144019.12089-2-royalnet026@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
index b7b025814e72b..10d8a569a8d16 100644
--- a/drivers/gpu/drm/rockchip/Kconfig
+++ b/drivers/gpu/drm/rockchip/Kconfig
@@ -64,6 +64,7 @@ config ROCKCHIP_CDN_DP
 
 config ROCKCHIP_DW_DP
 	bool "Rockchip specific extensions for Synopsys DW DP"
+	select DRM_BRIDGE_CONNECTOR
 	help
 	  This selects support for Rockchip SoC specific extensions
 	  to enable Synopsys DesignWare Cores based DisplayPort transmit
-- 
2.53.0



