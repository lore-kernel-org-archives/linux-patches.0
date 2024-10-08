Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611C21DED7A;
	Tue,  8 Oct 2024 13:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393788; cv=none; b=XjvLObCEETnvuRVCl/JthX4sFi6afJS/PusGtttgfmU6y21Qh3xbIHiCeR0NA5zLlrEM4hJh+bz42oZjFIrzN0XTmiPA2uM3ODt2j3LX07KqhNFDdukYiprqjdTI6rHxWCg7qXJ9jXqDAWsSY3r7XzlK9GL56OSVG3leVSrps/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393788; c=relaxed/simple;
	bh=Vy+tfQX9nE4tl0QmTHaFFNonIOjsOB/v8CyV/RbC4tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTYqTDhDCV5DEEJt1/SSAAiiW9n53mMvP5G7wmKcNwwLWOf+524CNI60wq+ddWWpKFc/cwhHtmMmqulyyU8CoCZkh1YNSIfzLcvnfKocxgEZzzxNx0t/wVX3ZbcX/sXC9pdJUUXCBBIwRAplG89Ox4XSMZDkkkX0fRlamMkDDuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqUCbgaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqUCbgaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B130C4CEC7;
	Tue,  8 Oct 2024 13:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393788;
	bh=Vy+tfQX9nE4tl0QmTHaFFNonIOjsOB/v8CyV/RbC4tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqUCbgaV+V89LC11v5R9VZu6+Sk95pwBTwSrA1XvDNKi/f4b5tPpEFznefMG9aacp
	 Z6kK0sX6R77sY8lbc42tNDTJOSHexVbKKri8go2Qcxz5Th27Z/d/YkAoXdbCI8vOrf
	 2oyh6qLO4myHzcx7GXNOm22Id8RzxnytnaqAxyGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.6 254/386] drm: omapdrm: Add missing check for alloc_ordered_workqueue
Date: Tue,  8 Oct 2024 14:08:19 +0200
Message-ID: <20241008115639.389323132@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


