Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21582D5436;
	Tue, 21 Jul 2026 17:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655571; cv=none; b=YkNgyxzY5groDoY8i0/2R7PYswHCqYwm0tQvE4HN2C9+6hC9qICaRDKzPDyjNysbobbATcc9zmrBNPbiBXm30Ndr8MnWXWzdydwHnNcwcY3fXm7SzjGEPNu0KZVPuH4MDkwTrMBqW3Fwih9+70Svx6BHpXzvDkiosIm+oXEWHX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655571; c=relaxed/simple;
	bh=30o8H7pqZ3EnSy3+wQt4U6NwHQbjlHkwGsCeWCeo7V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ye0HoXpxnbuZpOPK+OAfXacoQYv735KQkyy+yRo/Qkv1Vm8X7lC3zEw6ka7bRi/ybLfhMLUrdoU2PPqGT4k6a6G7uTwd9/y0DpbwsH8kzhnqJuY1XW7lcZw6UGFSDTlUlGE+lkPK0WaMkWdCLUfqRAKvdcCwJWtmw19I3sB+Dcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6vv74yc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6vv74yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABF41F000E9;
	Tue, 21 Jul 2026 17:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655570;
	bh=3PHoXL65CpaTj0S4+1lodbK184lPZ+JcLQ3PrOT1qfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6vv74ycfybVhT+OR6wbyVoCO8VeqCgv1ztoZz1RXqTJk8NKtsfAPlSAtvpmbHj8a
	 toAtBfSejErkXk7kyci58sOno0E/ZVFgSPW4wHdtxj3W2QkUva+fjA/5Q+ZK+sLmat
	 ItdCr/m0j/azPHUwERE/KENw2wx0PkgKeVr7qrzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0060/1611] drm/rockchip: dw_dp: Switch to drmm_kzalloc()
Date: Tue, 21 Jul 2026 17:02:56 +0200
Message-ID: <20260721152516.180550623@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit ed9da8d23020352ad24c528db09b5acdd78b81fd ]

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

Fixes: d68ba7bac955 ("drm/rockchip: Add RK3588 DPTX output support")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260310-drm-rk-fixes-v2-2-645ecfb43f49@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_dp-rockchip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/dw_dp-rockchip.c b/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
index 25ab4e46301e8d..98d97e0f3cf4fe 100644
--- a/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_dp-rockchip.c
@@ -13,6 +13,7 @@
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_bridge.h>
 #include <drm/drm_bridge_connector.h>
+#include <drm/drm_managed.h>
 #include <drm/drm_of.h>
 #include <drm/drm_print.h>
 #include <drm/drm_probe_helper.h>
@@ -82,7 +83,7 @@ static int dw_dp_rockchip_bind(struct device *dev, struct device *master, void *
 	struct drm_connector *connector;
 	int ret;
 
-	dp = devm_kzalloc(dev, sizeof(*dp), GFP_KERNEL);
+	dp = drmm_kzalloc(drm_dev, sizeof(*dp), GFP_KERNEL);
 	if (!dp)
 		return -ENOMEM;
 
-- 
2.53.0



