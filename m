Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF061E04B3;
	Wed,  6 Nov 2024 13:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898489; cv=none; b=iTW3X2Jln7qpS2Q+syCmijzFMcAjOZ0Mo6vJNFL27EfIfAnCIQBSR9gOiOFhaGQPg30eBc4lO8eNIvJ00kWolUxG/FHrlL9N0jxDGmo36tqXDjZJhJstJ7huDJXqaNcFD+1zojellqXDP4AXAgJnWp9nZvmf8wTbetU/WV62E+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898489; c=relaxed/simple;
	bh=oU0khV34IWmbDlKpIuWk4OMF7Z2fqWEhc+btVs3Waw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzP4apFf75NG29mrdxwow7lTcyLmRo5T5MgFgpfJR6RdI/wQSP0kz3qUtEq/VY3lPL5i3nDy6dG55pSHTXVaXP+reYpI7vPK3h2PTLLnMSxsLofNgoiZJ90ziwvuqZ0yXlOsgheUM+pmsAU/AbSA8VQ/HsoeSxxOMbdwtO40F3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRtzNqys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRtzNqys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D76C4CECD;
	Wed,  6 Nov 2024 13:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898488;
	bh=oU0khV34IWmbDlKpIuWk4OMF7Z2fqWEhc+btVs3Waw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRtzNqysnBN8Udte3cjbecVsqs4VyAqLb65vXAl8RWbPpw3QiQ89f+k0oHDhi/2nl
	 QZea1Fg01XvgNnH5BmTjJsURVeRiLT6aTVGorOJRDEsjliV+fEv2lB62U12kkVLWQD
	 Z8JbrVds7tY0oQR/0uAEgpBIAyKvHAnIYQVVvhVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 5.4 255/462] drm: omapdrm: Add missing check for alloc_ordered_workqueue
Date: Wed,  6 Nov 2024 13:02:28 +0100
Message-ID: <20241106120337.823627764@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -580,6 +580,10 @@ static int omapdrm_init(struct omap_drm_
 	soc = soc_device_match(omapdrm_soc_devices);
 	priv->omaprev = soc ? (unsigned int)soc->data : 0;
 	priv->wq = alloc_ordered_workqueue("omapdrm", 0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto err_alloc_workqueue;
+	}
 
 	mutex_init(&priv->list_lock);
 	INIT_LIST_HEAD(&priv->obj_list);
@@ -633,6 +637,7 @@ err_cleanup_modeset:
 err_gem_deinit:
 	omap_gem_deinit(ddev);
 	destroy_workqueue(priv->wq);
+err_alloc_workqueue:
 	omap_disconnect_pipelines(ddev);
 	omap_crtc_pre_uninit(priv);
 	drm_dev_put(ddev);


