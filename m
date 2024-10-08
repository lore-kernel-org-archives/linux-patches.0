Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F9917F4FF;
	Tue,  8 Oct 2024 13:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392411; cv=none; b=snxgfWBGCFGOcegVKoy1qLOOPNIFaPnINKMWs8hGgr1iU4/nxXZNAVxL4wmDDIEWyCIrRzcWuZX3Sde9hqC5OzX4wEccbtlZxYJEbBHB3iBlOqHlr0XP1KGDgihNGjtJeGREZZyXEDs1JEnq/QP7IBYTCL39CUF5gfqIWMHpFLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392411; c=relaxed/simple;
	bh=aase+ZI3eOf0ARkNZwxwAxT6gHvSDS9I70q1NeKUnuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaiBG5hy2ZPGiEpodjQYYn9UOvbKO1louMArL89UJ3Amu23mpGha2d3mceH6yvZ+2DeaF/ie3U4CDFGIqW5W/VWtT1UOKJ/qvoah5WUE4VuC4MwEtqjFZ4xle17iwCSeckVP/410GYsP3BiOtEKJAmvNsGcUBVueWWGJuD5sQJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4GjLPb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4GjLPb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88ED9C4CEC7;
	Tue,  8 Oct 2024 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392411;
	bh=aase+ZI3eOf0ARkNZwxwAxT6gHvSDS9I70q1NeKUnuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4GjLPb8D7e/zUcxoN0fpGsjoDlVvcSP9e1S+Kl0dPiZk+vtxLg/5GtRVdL5T2tuG
	 wJ8Xk5fFjaLvAbHHBivnMxcAK2KEuJbizajsGUAJh7TBNveITopKT8pnwB/FfGLhCt
	 AcodoUtbAA1Y/0QKrHJrznsllHVTDBtDR+FtzEn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.11 406/558] drm: omapdrm: Add missing check for alloc_ordered_workqueue
Date: Tue,  8 Oct 2024 14:07:16 +0200
Message-ID: <20241008115718.255009876@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit e794b7b9b92977365c693760a259f8eef940c536 upstream.

As it may return NULL pointer and cause NULL pointer dereference. Add check
for the return value of alloc_ordered_workqueue.

Cc: stable@vger.kernel.org
Fixes: 2f95bc6d324a ("drm: omapdrm: Perform initialization/cleanup at probe/remove time")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240808061336.2796729-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/omapdrm/omap_drv.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/omapdrm/omap_drv.c
+++ b/drivers/gpu/drm/omapdrm/omap_drv.c
@@ -695,6 +695,10 @@ static int omapdrm_init(struct omap_drm_
 	soc = soc_device_match(omapdrm_soc_devices);
 	priv->omaprev = soc ? (uintptr_t)soc->data : 0;
 	priv->wq = alloc_ordered_workqueue("omapdrm", 0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto err_alloc_workqueue;
+	}
 
 	mutex_init(&priv->list_lock);
 	INIT_LIST_HEAD(&priv->obj_list);
@@ -753,6 +757,7 @@ err_gem_deinit:
 	drm_mode_config_cleanup(ddev);
 	omap_gem_deinit(ddev);
 	destroy_workqueue(priv->wq);
+err_alloc_workqueue:
 	omap_disconnect_pipelines(ddev);
 	drm_dev_put(ddev);
 	return ret;


