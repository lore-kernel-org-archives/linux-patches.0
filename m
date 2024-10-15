Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4BE13F435;
	Tue, 15 Oct 2024 13:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998109; cv=none; b=rUwF774ToYKblLmEhR4qnTDT2xaILa+M/I/+uI5OLpb/JfB6vLo64DWX8QUmgYdWy2izlCYSdSSfr6HTiBrdd+BM5L0QLvn6906ZkOkeN1QDnvFytf9RaSKw8+JM9ibKxJH0DhP/waneHixR5zWkTF0OwV1oyPpwgwVftpAQWOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998109; c=relaxed/simple;
	bh=qVlvmx+shsuB+uIheQh9O937LDNmQchpJ30jRBhDHGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOO3iMAHySLdHM76bj7sWiMtYBtBALG1cfqLlDsxb2JzTLvEFoBGSuke4oM20FnF6ZvrfEx6UWhtUyMy5+TuMZuQozysH4xYm8kAXQ1HFl2/5M9Hhmw0sbItxsECR+JuGp8T2tK/eTfGestEfa7AgOPJwQsBwx9ezwkNiSJ1564=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8xNUYoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8xNUYoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913B5C4CEC6;
	Tue, 15 Oct 2024 13:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998109;
	bh=qVlvmx+shsuB+uIheQh9O937LDNmQchpJ30jRBhDHGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8xNUYoySPzeQCtmnvw0rjCw5jxbc6z/ixj3gvD3tfbL+YSbRj0ibpe3oJtpBliOl
	 iD8f5ezhyGtVrDT2HQvj0MKTtL2XHIXOf+GYQLo3F/50q0m5pB0j2UMcPddnSw6v9R
	 GrP07n9BdTQhp0V5/5OTWxmeNsam09tXhTOK2c38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 5.10 382/518] drm: omapdrm: Add missing check for alloc_ordered_workqueue
Date: Tue, 15 Oct 2024 14:44:46 +0200
Message-ID: <20241015123931.714509353@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -600,6 +600,10 @@ static int omapdrm_init(struct omap_drm_
 	soc = soc_device_match(omapdrm_soc_devices);
 	priv->omaprev = soc ? (unsigned int)soc->data : 0;
 	priv->wq = alloc_ordered_workqueue("omapdrm", 0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto err_alloc_workqueue;
+	}
 
 	mutex_init(&priv->list_lock);
 	INIT_LIST_HEAD(&priv->obj_list);
@@ -649,6 +653,7 @@ err_cleanup_modeset:
 err_gem_deinit:
 	omap_gem_deinit(ddev);
 	destroy_workqueue(priv->wq);
+err_alloc_workqueue:
 	omap_disconnect_pipelines(ddev);
 	omap_crtc_pre_uninit(priv);
 	drm_dev_put(ddev);


