Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCBF3FF1D5;
	Fri, 15 May 2026 15:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860774; cv=none; b=ZQzZUUwuHaqKRL4SuwdftdTRK9soh4AozgHAgroo6jfMIbbwEHVOe8Isdj57jqzSv5S+JZ/KzhxaJd32l0Ts0SnFYlMJ2b0eAibxwv+J4L9LHV+qvuNJ+SFRVXbRFlUwDWNv11BDQfLmO+6bofXoo53CBC5TBaojju51Gpvac2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860774; c=relaxed/simple;
	bh=8rUm8zxIwbfe9H+3ia4yufm2TPXSFZYNVGZrqz4J5aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXgxDGx5iORyRJdTbkzRRhEdvr7blrw+9pBc1ThpVN/G7OEyRA72gOSf81+SrB7OIMRd+oCtSnyXtF2twtNp7+Dlv69uSla1ayyie3gC0A6RyevBHICt+tvOwRDSI1vaOU3ndkhJ6IAyaciTxEFQ9ylzXMhv3/5kJZlYMFv8dxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBLaOvmg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBLaOvmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA79DC2BCB0;
	Fri, 15 May 2026 15:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860774;
	bh=8rUm8zxIwbfe9H+3ia4yufm2TPXSFZYNVGZrqz4J5aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBLaOvmgxQjOAxOliyPiOQCN+Q+JQbbmnXBvBC+FJjEx2piaqmgomTggQjb9ULNg6
	 1iVawQ3fuRdTctmsFiuKtgIKrslIlp7cu7V1oGI0zDAJD1A6Xv+eQEDbrTTLqDiZW0
	 B4haewsYm7ksxcqC0GGwzkIACcjiqAGH5dOEO4oA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.6 075/474] drm/arcpgu: fix device node leak
Date: Fri, 15 May 2026 17:43:04 +0200
Message-ID: <20260515154716.663282569@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


