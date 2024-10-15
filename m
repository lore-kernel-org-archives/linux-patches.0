Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730A015099D;
	Tue, 15 Oct 2024 11:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992077; cv=none; b=RrYwHWUoRol2gHfIykCPueUteKagBYQTIzdfSJyjLwd1YNoG74wJ1ExyB5ImGL4+PZPgXQTWTYmbdYoJKnD8qWHKlkNpl7eQYhPeXLraqkT2OXOSFQDwSHqIpn8lpD4xXXpUblzjbsqyExXs83WZGiEMkrzeTWw/TOZFIEdA6ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992077; c=relaxed/simple;
	bh=AkGPR3XeI7LSwQUM3axYo68T/g0hxQcrAKtZZXAKv1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phIhuDgfg9mMPnhzegx2C3ldjv1Ta3hwTxxKFzIizzon9QUCbrxf+bT2nZzpAg4LPVduDCwCNP6veYBH4JMARwJW5xWpA0AQ9eiMXBTQpz3zQBkM3xsjWSH3/xnxc3d6gV9kUIZYderGptuG+TLV22tFWmovnlmPiJdbDzWZtdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCQvul9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCQvul9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80A5C4CECE;
	Tue, 15 Oct 2024 11:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992077;
	bh=AkGPR3XeI7LSwQUM3axYo68T/g0hxQcrAKtZZXAKv1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCQvul9Gx4vkyqtFgb3i1PkhuzpI3iwDK5WbcbsaA5VHsmjs7dPRbcj7DBUJgT+hr
	 fZmPneLqPl04B6tliwyoZJCul1wW1NxiRMX66OV288XMxD9Axif6f9wWW+PJD5rb49
	 ylA0twIkSbUCzNDPPwE31VYv2aGLhMLh2upMhhFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 5.15 004/691] drm: omapdrm: Add missing check for alloc_ordered_workqueue
Date: Tue, 15 Oct 2024 13:19:12 +0200
Message-ID: <20241015112440.501965600@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -573,6 +573,10 @@ static int omapdrm_init(struct omap_drm_
 	soc = soc_device_match(omapdrm_soc_devices);
 	priv->omaprev = soc ? (unsigned int)soc->data : 0;
 	priv->wq = alloc_ordered_workqueue("omapdrm", 0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto err_alloc_workqueue;
+	}
 
 	mutex_init(&priv->list_lock);
 	INIT_LIST_HEAD(&priv->obj_list);
@@ -620,6 +624,7 @@ err_cleanup_modeset:
 err_gem_deinit:
 	omap_gem_deinit(ddev);
 	destroy_workqueue(priv->wq);
+err_alloc_workqueue:
 	omap_disconnect_pipelines(ddev);
 	drm_dev_put(ddev);
 	return ret;


