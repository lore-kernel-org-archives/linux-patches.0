Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC40315785;
	Mon,  4 May 2026 14:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904581; cv=none; b=mPOc+KszjA6Hv+lR4k1hr86fQg8e/LKqHfmEqZDio2F5UBRRKY/lMRt+YD+nvTmRfXBrWZTBM77+emTaVZ9Y5exNbYZQPH+Hg4e+7Y2M8RcBN20mDwskwF41AneXGjBv4R2LLTRUzzGISsUUvgorAKSaLu1n6kktdBkir5WLyXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904581; c=relaxed/simple;
	bh=A5q/6YS05nWRUfHaxhfP4T5SOeZiBFRd+9BvWDU6ZHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Htawua8ye2eMD7y6TLbw1JX9Hqrt39kQlyuKmVbD+mUEe8WZNfgFEa9/wBFNareywlAvBbffZ5UsTWgS7AmgYtIwK9XxI8hCu1YQva299PRy/nPemIqy5hTcDwBE9YLh/hiUSKlhXH0hU+E/9eu1Enxsy8EXmnVgI2agI3lNit4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMzt85Ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMzt85Ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3371C2BCB8;
	Mon,  4 May 2026 14:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904581;
	bh=A5q/6YS05nWRUfHaxhfP4T5SOeZiBFRd+9BvWDU6ZHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMzt85QlZoauTcvk636eTf/aiMkSijfdw+22D7d6T98nGrnZ+TvJUvDzL21PhNS+6
	 aFlI+Wgv0xiaCmQSiRQ2Al81rGrN501LgS5HdVE5Y2cgNcGDztCdTJ50orTuTMmc0N
	 Lnxe0FIL6CyGihoYjeS0N9XcOk9jSnV/0YHzcGf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.12 093/215] drm/arcpgu: fix device node leak
Date: Mon,  4 May 2026 15:51:52 +0200
Message-ID: <20260504135133.555039739@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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


