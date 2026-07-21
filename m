Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B556F46AA76;
	Tue, 21 Jul 2026 15:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648029; cv=none; b=ORCoiDl2/Fofc1QtODi4l4PUfz3sZBkv6rwjAS3uScf6uH3GV0cDZ2/skkOp5wcj7b79ZQje4yTaSv9rXpzr8+j/Vk0rd3bAv6C624ecDt3K4Q89gWvMj/pdj5Z+F1oJn/Ig1ZhLf9zWYefJ/nnuCFzhU72sXH54vtPmsS3Tue4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648029; c=relaxed/simple;
	bh=hNyjBGabwFgMx7gOOKYv3nLAoet+9WnCsEA50QnR+LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoGyHjL2T4J0vdND1miHs3CfVX8XeysYK8jL/ywqjzXorza6DKkkvsoL0G2+KVCmfqS3risx/Bijlv2OI1JdONtwaG6zwsLImVHCnhpfWWP4p5mnacb07Uhv/rz6NjqChtcAlsSTHce7Lu8/0eH3yl9O9CaoG19rKbPRnEqHEFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AMH+xmL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AMH+xmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266E71F00A3A;
	Tue, 21 Jul 2026 15:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648028;
	bh=JDS1UoRgXyyp93XxIToC97W9XAe//5RJp9fUUNIY1jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2AMH+xmLeZ4g/+RlMCF5lk08F+mjaibcKH0DIxHQ6JS3DMbek00zLmGqxl9zRXSVl
	 jJC/xSAbNHcelOAUS8tngFozfk0b7T7Wz/W6iG+CLoY3XVmWEFNBDR4sWC3vF6Pssn
	 32IhUK4be9mxpvkp4Hr9UzXdmwFnMMo3r1lL+tl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0046/2077] drm/rockchip: dw_dp: Switch to drmm_kzalloc()
Date: Tue, 21 Jul 2026 16:55:19 +0200
Message-ID: <20260721152553.774115020@linuxfoundation.org>
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
index dac3d202971eda..532af476d250a5 100644
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



