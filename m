Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2A232D42B;
	Sat, 30 May 2026 16:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160003; cv=none; b=nZ7hr8MlFer5FVUjLi76c12Y+tj0x/KDiGJmTSW2uM+SGiLAK0GFW9uuFvSVNIF8hgCWtcZYG3yMD6jRFK605gV0qPbV981iuNVP8ssNOE5PQiYLs3QpYKxgk2oU3lNl8OFuLQAag7sVIwcHf+nUbNZNuNk275v8EsTpdqSgQGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160003; c=relaxed/simple;
	bh=WQ73ENz03Z0feadYVHqqWFd+62QeeK6LRZaF97L4u+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0Y0KtlbDqHCaIztvYRt7eQuVsmVgbrNXOukZ3ONLxkzy60FgfmwyXet6UdkG3VbZG9MO3i9NH/BFT7imedZJWIe2ykUGc6ysqkD+QYLFkbardOdbHWimF9tECugCIRfDWYBfzwmDiPugQ9rPbylvh2nSMJccsNSpCCAXCbMyyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgFpw9wO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgFpw9wO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BC41F00893;
	Sat, 30 May 2026 16:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160002;
	bh=SJFHK4EVTsU39Yhjn/Vagg52oyLXuIaLO/IncmYYzqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LgFpw9wOd5o4D7P8BGRN6EnDWW4b5JJPIVUMcLlpHF9qjdpEu9wr2fMK48yPVUpVc
	 lSQVl6dKN3ULXJLEVzvJc2GuaPGPxY5m2DcpWb5UUfnP/gjxF6udzDW2qDbT8/SMUk
	 /cBgg/22CZhXd1oDzE3z5SKITCqroD59TMOI636c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.1 218/969] drm/arcpgu: fix device node leak
Date: Sat, 30 May 2026 17:55:42 +0200
Message-ID: <20260530160306.473244374@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -248,7 +248,8 @@ DEFINE_DRM_GEM_DMA_FOPS(arcpgu_drm_ops);
 static int arcpgu_load(struct arcpgu_drm_private *arcpgu)
 {
 	struct platform_device *pdev = to_platform_device(arcpgu->drm.dev);
-	struct device_node *encoder_node = NULL, *endpoint_node = NULL;
+	struct device_node *encoder_node __free(device_node) = NULL;
+	struct device_node *endpoint_node = NULL;
 	struct drm_connector *connector = NULL;
 	struct drm_device *drm = &arcpgu->drm;
 	struct resource *res;


