Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2085C46AA89;
	Tue, 21 Jul 2026 15:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648027; cv=none; b=q0zm7TxaR7Ljx8Fw13hSDZNbzRuVl4nm+Vl8ss57Ed7SNfcNeGiU/8kPtoEQWL84u2g3UOPoNQkT0Al1Fn6zAGABIjCxvnuxHb81PqLsZ6/oxPXW2jaeBL/e8M+RYh90nq7YCFkLDJuPjVHacx21oAXkyWGSZsqmtrTsuSfCZ6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648027; c=relaxed/simple;
	bh=nDBeI71tuJw/Y10IiFlcjAZ1vN4Hgpby1nYtdcJIfNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWQMRYzeXAKZ0Kyl9/6+eMv30ZT2Jlzno+GhCLxnB5XTcom10CNX8iLHdBuQzpVQJaEwunkerh98M8PUPUdvfld0nUVEUGuETzzUVND+zul8uE9UaqK4j/KBHK4DvPufBuBcPAJrcr3m8A9W0w5lvp5jh5B7MLhEsoD/x2V0Wl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpDyQri9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpDyQri9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB341F000E9;
	Tue, 21 Jul 2026 15:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648026;
	bh=g4uvP15ld5YnhYF17sq9+qA34K74h/aeYfkxbaH67RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qpDyQri9SPgf+FAR58Dn89gepGqXqsMSdWSbnrU98JSR7Hg6Cmy7BL9xa0BbthtKR
	 FQRwVC4axnwFSbXOqlaYjHtvDIaqpa4CBJt5TlWODkva9NrxL2P4AzBereZ2tRuhkB
	 K91E7V3L0QUNlCA58aOKtg7AJ6nU/s6OWaTIuJtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0045/2077] drm/rockchip: inno-hdmi: Switch to drmm_kzalloc()
Date: Tue, 21 Jul 2026 16:55:18 +0200
Message-ID: <20260721152553.749413809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 3cc50e7f73fcf79f28660b9d91566b13cb62e520 ]

Driver makes use of drmm_encoder_init() to initialize the encoder and
automatically handle the cleanup by registering drm_encoder_cleanup()
with drmm_add_action().

However, the internal structure containing the encoder part gets
allocated with devm_kzalloc(), which happens while component_bind_all()
is being called from Rockchip DRM driver.  The component framework
further ensures it is deallocated as part of releasing all the resources
claimed during bind, which is triggered from component_unbind_all().

When the reference to the DRM device gets eventually dropped via
drm_dev_put() in rockchip_drm_unbind(), drmm_encoder_alloc_release()
attempts to access the now released encoder structure, leading to
use-after-free.

Ensure driver's internal structure is still reachable on encoder cleanup
by switching from a device-managed allocation to a drm-managed one.

Fixes: 969325a2597e ("drm/rockchip: inno-hdmi: Convert to drm bridge")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260310-drm-rk-fixes-v2-1-645ecfb43f49@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/inno_hdmi-rockchip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/inno_hdmi-rockchip.c b/drivers/gpu/drm/rockchip/inno_hdmi-rockchip.c
index 97c20500f79012..28e6fb09aae735 100644
--- a/drivers/gpu/drm/rockchip/inno_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/inno_hdmi-rockchip.c
@@ -14,6 +14,7 @@
 
 #include <drm/bridge/inno_hdmi.h>
 #include <drm/drm_bridge_connector.h>
+#include <drm/drm_managed.h>
 #include <drm/drm_of.h>
 
 #include "rockchip_drm_drv.h"
@@ -90,7 +91,7 @@ static int inno_hdmi_rockchip_bind(struct device *dev, struct device *master, vo
 	const struct inno_hdmi_plat_data *plat_data;
 	int ret;
 
-	hdmi = devm_kzalloc(dev, sizeof(*hdmi), GFP_KERNEL);
+	hdmi = drmm_kzalloc(drm, sizeof(*hdmi), GFP_KERNEL);
 	if (!hdmi)
 		return -ENOMEM;
 
-- 
2.53.0



