Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A303AB482;
	Sat, 30 May 2026 17:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163317; cv=none; b=XOedQWlxndFesOaa4h0UZQjJ4cT+18Q5X+QvaVIpCcnyUbl1meJPEMedqo0ATRTF/bAz5kk7rN9g/J2NFq+arR2fsHHOLlsmqJZ+2lczoSTYTj0s5lStPj16RsWd/24FS0zxenNz+rJplTHHX+NZwA5jSiZzhBioeWQgOytvhCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163317; c=relaxed/simple;
	bh=w0sisKJp8+bZk/QGGrY9P6bYzrbAcrLSrOz6jR6nI2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPbL3FUoyaPIABf4qbz3TY0mQI6UcNcqGawJPCxgnjVgQ4FRaAcjpOOaSnfS/7xuNO6Eq5JSA/WVhcqe2A24AGPb46axflukQS3rcq+cwQiQjUjDOOo5ZRfsyQPfwRawwqWLKkJAy5ZPumOhYhKNjfdYTwcjrnonxyxtZklyQ8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOQsGeRy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOQsGeRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CD81F00893;
	Sat, 30 May 2026 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163316;
	bh=aC5QsmzGlieSElXFnos8+H/e4wJEL4a5Acbp2X1XFag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOQsGeRyk+z5Bottu/0U13Bu8zZlGve1DFgNT3Tn7H9NA+P5NsrM+QtF0Mdm79vz5
	 A+HbRYNlmUzMy/lsd1HRTVkeeIykkoXq1+5YEPV6LJhpK3dwCk3JJoiFfWLZlBXQEw
	 VGSqTOFCpo84bQlxya4Q91x17ibmYZ7I3M5n0WFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 5.15 221/776] drm/arcpgu: fix device node leak
Date: Sat, 30 May 2026 17:58:55 +0200
Message-ID: <20260530160246.234100367@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

commit ad3ac32a3893a2bbcad545efc005a8e4e7ecf10c upstream.

This function gets a device_node reference via
of_graph_get_remote_port_parent() and stores it in encoder_node, but never
puts that reference. Add it.

There used to be a of_node_put(encoder_node) but it has been removed by
mistake during a rework in commit 3ea66a794fdc ("drm/arc: Inline
arcpgu_drm_hdmi_init").

Fixes: 3ea66a794fdc ("drm/arc: Inline arcpgu_drm_hdmi_init")
Cc: stable@vger.kernel.org
Reviewed-by: Louis Chauvet <louis.chauvet@bootlin.com>
Link: https://patch.msgid.link/20260402-drm-arcgpu-fix-device-node-leak-v2-1-d773cf754ae5@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/arcpgu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/tiny/arcpgu.c
+++ b/drivers/gpu/drm/tiny/arcpgu.c
@@ -245,7 +245,8 @@ DEFINE_DRM_GEM_CMA_FOPS(arcpgu_drm_ops);
 static int arcpgu_load(struct arcpgu_drm_private *arcpgu)
 {
 	struct platform_device *pdev = to_platform_device(arcpgu->drm.dev);
-	struct device_node *encoder_node = NULL, *endpoint_node = NULL;
+	struct device_node *encoder_node __free(device_node) = NULL;
+	struct device_node *endpoint_node = NULL;
 	struct drm_connector *connector = NULL;
 	struct drm_device *drm = &arcpgu->drm;
 	struct resource *res;


