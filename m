Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292DD4C10DD;
	Thu, 17 Sep 2026 15:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659347; cv=none; b=DUJRYz05si2Gt0GUw4egmA8HAwGYSxjeQ2pFri+raY58q8PuImbotB+JX1Sqcnlaf+SJO38bB7d3K1B4KTzWK4qSF1n2oPClu7trzDj3NitjHs7UpJKzy1Oo37Jg9miVOgqeX69E78RJAn2ZzcTuU+aKjAmiu9Z6v1QTzg5NNRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659347; c=relaxed/simple;
	bh=Dn0PSUHnT+ShRVqnCtejAvLusqAY9rlOqLJqPOP/gys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/DsyPYVP9lxbX6IpDX16hxZuyjCdyB28tN6qspfxG51ViDgmJzfwbKgLLIqjjReoh8xcz75G6bJfKcd+b8tyokqMc9ogWHirhhmUqos2lei9Ek5BaddwNap3vbZ61YxxbW4YRJccO75HndCbQkSfTYZwE69IsS2uY5Oab8iQ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWJxOqP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWJxOqP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281C61F0089A;
	Thu, 17 Sep 2026 15:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659341;
	bh=9z38mQkoO2exhC9MLRv1IZmL+c+6XylOt+vTpWu7qKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wWJxOqP3imgBwSqMyt1TBmVlCdnDnPrLaDrLvXMpU//1AqQFg+a+BQUs+swh8h0dC
	 bmIyErgf4SaH4Nz5p/Nt0qHRONC411g3bbpmm5k2O2+4B7uzZFDs3vREJBzA+msrNO
	 PA0d/o9aHZaiUEeUH3e/j6XAjVgDPVEq3KrUU8kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Paunovic <royalnet026@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 224/733] drm/rockchip: dw_dp: Select DRM_BRIDGE_CONNECTOR
Date: Thu, 17 Sep 2026 16:08:52 +0100
Message-ID: <20260917151356.793553766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index e7f49fe845eae..697c0748eecae 100644
--- a/drivers/gpu/drm/rockchip/Kconfig
+++ b/drivers/gpu/drm/rockchip/Kconfig
@@ -68,6 +68,7 @@ config ROCKCHIP_CDN_DP
 
 config ROCKCHIP_DW_DP
 	bool "Rockchip specific extensions for Synopsys DW DP"
+	select DRM_BRIDGE_CONNECTOR
 	help
 	  This selects support for Rockchip SoC specific extensions
 	  to enable Synopsys DesignWare Cores based DisplayPort transmit
-- 
2.53.0



