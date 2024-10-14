Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F4E1ADFF9;
	Mon, 14 Oct 2024 15:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919275; cv=none; b=SdByqtDCSa36Iaov7JpZvv2T+Y7bR5SlXptDYY+uuDJQkCUibFSWRwxCEpjJIMpxuukcckkzAZ8OnxH4PyMGp0I/AczQ8Q4XbaRFmKS9O9kPPEq1hm/yZm32MSwyRbM6sFfxFwbECJZVIoueyIJm2Z46CUp/kcw1mQP+BWTXMFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919275; c=relaxed/simple;
	bh=tGsVlAygse4FP7Hej5uhanizTNFRJdkVOZcwRv/Kl84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZV1ce3r7P0Zy+lT1Y+Q3g7rhgZYBdOQPLypDyWo1bFGg0aM+RJMOfVhtw2wZkF0p1ZS6yHhc9RSJ+4vUX/HmSJz6Je5hvsYT2qd7oZryCXrYRWTGUZLqwEIKLB9Jdk6Z16J1j1Rdm/fAoIO8VbESBragShovhPkFmbiUHtngoC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07F4q2mv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07F4q2mv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982BEC4CED0;
	Mon, 14 Oct 2024 15:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919275;
	bh=tGsVlAygse4FP7Hej5uhanizTNFRJdkVOZcwRv/Kl84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07F4q2mvS85CJE7w/20fT9j6/iTox4aXd9sBECDIInTUDtaEs+dN5nPLVm1x7ENQk
	 XBgW97p7wKz02Lljd6lsHYQJDzWNAXtCtRIFxbh3hLZskSzrFO9qdvxgwgllf4UxsP
	 WOZ3nI9l5EItxlc28MnCLLUiQPs1Z9kgNyg6ZP4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.1 561/798] drm: omapdrm: Add missing check for alloc_ordered_workqueue
Date: Mon, 14 Oct 2024 16:18:35 +0200
Message-ID: <20241014141240.038852663@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -746,6 +746,10 @@ static int omapdrm_init(struct omap_drm_
 	soc = soc_device_match(omapdrm_soc_devices);
 	priv->omaprev = soc ? (uintptr_t)soc->data : 0;
 	priv->wq = alloc_ordered_workqueue("omapdrm", 0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto err_alloc_workqueue;
+	}
 
 	mutex_init(&priv->list_lock);
 	INIT_LIST_HEAD(&priv->obj_list);
@@ -808,6 +812,7 @@ err_gem_deinit:
 	drm_mode_config_cleanup(ddev);
 	omap_gem_deinit(ddev);
 	destroy_workqueue(priv->wq);
+err_alloc_workqueue:
 	omap_disconnect_pipelines(ddev);
 	drm_dev_put(ddev);
 	return ret;


