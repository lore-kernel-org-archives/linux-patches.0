Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4904FD7A1;
	Thu, 17 Sep 2026 17:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667194; cv=none; b=IulYr9F8mqI3XEleh4n+FVnXLZg94SyOCW5C6QqolBo/hT2v/IsuzS2qiNQksYfrp+QpudrrG8qlKvmaNQ8iuIWviAvnrdQCu7kDn+qs22OWFefJfT+hWdmgQTAadNziil4KpP/9wlZxvMEXcCGCLbASKyHp8rnkLbOckDeHxcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667194; c=relaxed/simple;
	bh=PNYhb8njtGvCsDmFguU3dJQcTrecv5VXcRhLOApmyzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXeNwQk9ewBVm1g9/VzeXnInmfJcyd2PbKiZsvzK0xmV1CHXl7GMEXcrP/s8cjOvp7Ru6NHP+UIc7T1ScJUcm2qCcu8Dc52rf8Ss+rl3go6uAfczMu7wn/4trUaNzDaESyZCWrjbyjqPZd5NNszAuihvyr8oQlPZi0qee1liZlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmcS0yyX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmcS0yyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9601F00893;
	Thu, 17 Sep 2026 17:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667192;
	bh=GF3xt7oio8B51LQd5d/aRJrpzrMKgG9GSVr7CvpjUR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmcS0yyXoE+DMAU8nJp2MHVE6QdIp5HbB5f938VUyQsNvVG2yPW5iik1VA7Fz/AmF
	 JFwAShzbX98MQUO6fM2PMvMkms15606ojeyVcP+zSQWgbdrzXR+TC0I0HUBLNpSRVI
	 kTB9xHPTHHeQ+4B/5C4jckcn5kW644HtNKgxCJEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0004/1102] drm: rz-du: Ensure correct suspend/resume ordering with VSP
Date: Thu, 17 Sep 2026 15:59:07 +0100
Message-ID: <20260917151539.529953499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>

[ Upstream commit c94e765abb051df62b9f7c27116ef9307216c868 ]

The VSP serves as an interface to memory and a compositor to the DU. It
therefore needs to be suspended after and resumed before the DU, to be
properly stopped and restarted in a controlled fashion driven by the DU
driver. This currently works by chance. Avoid relying on luck by
enforcing the correct suspend/resume ordering with device links.

Based on similar work done by Laurent Pinchart for R-Car DU.
commit db5be3a7d6bd ("drm: rcar-du: Ensure correct suspend/resume
ordering with VSP")

Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260330144651.817338-1-tommaso.merciai.xr@bp.renesas.com
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.c | 16 ++++++++++++++++
 drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.c b/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.c
index 8643ff2eec46e..ca7bfc7735f06 100644
--- a/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.c
+++ b/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.c
@@ -20,6 +20,7 @@
 #include <drm/drm_vblank.h>
 
 #include <linux/bitops.h>
+#include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
@@ -293,6 +294,9 @@ static void rzg2l_du_vsp_cleanup(struct drm_device *dev, void *res)
 {
 	struct rzg2l_du_vsp *vsp = res;
 
+	if (vsp->link)
+		device_link_del(vsp->link);
+
 	put_device(vsp->vsp);
 }
 
@@ -317,6 +321,18 @@ int rzg2l_du_vsp_init(struct rzg2l_du_vsp *vsp, struct device_node *np,
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * Enforce suspend/resume ordering between the DU (consumer) and the
+	 * VSP (supplier). The DU will be suspended before and resume after the
+	 * VSP.
+	 */
+	vsp->link = device_link_add(rcdu->dev, vsp->vsp, DL_FLAG_STATELESS);
+	if (!vsp->link) {
+		dev_err(rcdu->dev, "Failed to create device link to VSP %s\n",
+			dev_name(vsp->vsp));
+		return -EINVAL;
+	}
+
 	ret = vsp1_du_init(vsp->vsp);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.h b/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.h
index 322eb80dcbaff..a22aaf0843ed7 100644
--- a/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.h
+++ b/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.h
@@ -15,6 +15,7 @@
 #include <linux/scatterlist.h>
 
 struct device;
+struct device_link;
 struct drm_framebuffer;
 struct rzg2l_du_device;
 struct rzg2l_du_format_info;
@@ -29,6 +30,7 @@ struct rzg2l_du_vsp_plane {
 struct rzg2l_du_vsp {
 	unsigned int index;
 	struct device *vsp;
+	struct device_link *link;
 	struct rzg2l_du_device *dev;
 };
 
-- 
2.53.0



