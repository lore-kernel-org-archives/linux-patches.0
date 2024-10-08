Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94331DE2AE;
	Tue,  8 Oct 2024 12:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390639; cv=none; b=pypVs6SHo0JvHYak80OoDvm/sbaFl2UHYvwFw9qouox5IvgzmReV57GQV8l86SXd4On6g75SGmfVJsvWBUjMZi35wvm1gFT5gSY1iQ+pEXMnyNCBpM6ShPr/pdBJRdbJ09arlvzM9UqdW1CcS/90k7R7Tg8r6jyl45QAAc5uyRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390639; c=relaxed/simple;
	bh=h945IO/nieyf3RpdYeBhnbtCNCcQeFY7BPqjQXW9DJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGCktvMYBEv7bgosxEnIi9NmnYpIXcNmBwcNQk4t5X9myHQh6McX+dZEvRaWZLxYJY6zleHfdw0QaVX0egQJ79WifQMcSWUIAfWHa2RkV6j7viVF1ENNFgah7L83aE7JjA0ytD3I/R2fZSJvyA/boP3s5+nshVllmWynPdFcDkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQp/Chuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQp/Chuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37684C4CEC7;
	Tue,  8 Oct 2024 12:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390639;
	bh=h945IO/nieyf3RpdYeBhnbtCNCcQeFY7BPqjQXW9DJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQp/Chuc5x5r1Y3SLNbrjz2n5XMlsY5Q4OdZkvpgC6ad9YqvOS+k8KFTbQiDKGfyH
	 Ahe5gWXa0q7W0o64rJiOuA4ViSvtMs2p39cM6BtulmAWVAYcg2zcx9r9bc+GBYxm1g
	 wkYXU08Ak6DMJuV63TbJZysH1wRdIxbjJIsqI+9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.10 347/482] drm: omapdrm: Add missing check for alloc_ordered_workqueue
Date: Tue,  8 Oct 2024 14:06:50 +0200
Message-ID: <20241008115702.080546417@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


