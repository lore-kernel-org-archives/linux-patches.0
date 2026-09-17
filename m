Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1C150B435;
	Thu, 17 Sep 2026 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665585; cv=none; b=OTBfOckl19kKj4nRNhPIjsmQtXL0YqjXWBngOZExtARoh2SuCl6JWKKjqQi7DVVvjYtbvQTxh8BqAdvFQCE3W4P4s8ISQGx6f4wpGiTbWOg8yhLlfiKJvzdAybfY6PiFCNOmJaUbXQWrN+cGHyJ0eCkO1+LvUVXMwBRCaXBpGMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665585; c=relaxed/simple;
	bh=dXz8zm3jcREAGCYSCpMm94QdHrfqlbUTYec920Mpq/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RU0EEH/5MODdJaVIyJ+CHz7mR6k61ZUcpGkHvOagY7vGOJkYe1rAFSQNDgiQtzslxtXjSXUz7TmYpgpz5KD9I8oWMVdvFqAxiaM/ZfizZdr8VEzQiIutHmoC8WwdqHf1fEavwQZTZbInlMk7Aj4tRoVhV6zDXtYAnRgO4m8CYjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppJ1dhr7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppJ1dhr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68ED1F000FF;
	Thu, 17 Sep 2026 17:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665584;
	bh=w1PKHGxVPADFjLehqW1NUXfNrs/uq+Eu3QJhmwSKtXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppJ1dhr7ddZGij9Uyjp2d7KI9AOI0TpExT5i7cg5g34zBAXchdlnjQ6B6hJ7cN5Xo
	 23867TC2UGAaBsXLePtuj+cDT6DOy25ffFaFOb3wfbfQ4RwEjHNGsH9pl3ggU4Z2sP
	 s4sMeLLjT+vqBiwATrV8O/8V2c3oipptUCzhUCnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Paunovic <royalnet026@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0753/1250] drm/rockchip: rk3066_hdmi: Add missing Kconfig selects
Date: Thu, 17 Sep 2026 16:09:08 +0100
Message-ID: <20260917151612.287434816@linuxfoundation.org>
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

[ Upstream commit d72aa5cf045a69d5fd433cde5dd4e113d9558fd1 ]

rk3066_hdmi.c calls drm_bridge_connector_init(), but
ROCKCHIP_RK3066_HDMI selects neither DRM_BRIDGE_CONNECTOR nor
DRM_DISPLAY_HELPER, whose module carries the bridge-connector code. A
configuration with ROCKCHIP_RK3066_HDMI as the only enabled Rockchip
output option fails to link:

  aarch64-linux-gnu-ld: drivers/gpu/drm/rockchip/rk3066_hdmi.o: in function `rk3066_hdmi_bind':
  rk3066_hdmi.c:(.text+0x7a4): undefined reference to `drm_bridge_connector_init'
  aarch64-linux-gnu-ld: drivers/gpu/drm/rockchip/rk3066_hdmi.o: in function `rk3066_hdmi_bridge_atomic_enable':
  rk3066_hdmi.c:(.text+0xe74): undefined reference to `drm_atomic_helper_connector_hdmi_update_infoframes'

Select both, like ROCKCHIP_CDN_DP, ROCKCHIP_LVDS and ROCKCHIP_RGB do.
DRM_BRIDGE_CONNECTOR in turn selects DRM_DISPLAY_HDMI_STATE_HELPER,
which resolves the second symbol.

Fixes: 57d6811e8a6d ("drm/rockchip: rk3066_hdmi: switch to drm bridge")
Signed-off-by: Igor Paunovic <royalnet026@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260813144019.12089-3-royalnet026@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
index 10d8a569a8d16..7a942b5e89657 100644
--- a/drivers/gpu/drm/rockchip/Kconfig
+++ b/drivers/gpu/drm/rockchip/Kconfig
@@ -142,6 +142,8 @@ config ROCKCHIP_RGB
 config ROCKCHIP_RK3066_HDMI
 	bool "Rockchip specific extensions for RK3066 HDMI"
 	depends on DRM_ROCKCHIP
+	select DRM_DISPLAY_HELPER
+	select DRM_BRIDGE_CONNECTOR
 	help
 	  This selects support for Rockchip SoC specific extensions
 	  for the RK3066 HDMI driver. If you want to enable
-- 
2.53.0



