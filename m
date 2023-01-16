Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF44433EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DA1C433D2;
	Mon, 16 Jan 2023 15:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884492;
	bh=udqs3vuQ0CNX9wfM+YX9/Q0Ew6jLRe8a4KEfyjRwNMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBRTLA32INGWec/sSlwuTTdcZ7PnOKBtA/2X47KnWRJmnIZYPjXWPB3d4kY/B22Eb
	 Gvhj76J6vuj+FiWVflWfY+3GToFLPXLLHsTKWSZG2QHwSu7qTnHJtxEjljNyeuCktl
	 K+3eUsd65oJ0RAVpealZEad7V5esi69XhUZNr3rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 6.1 026/183] drm/virtio: Fix GEM handle creation UAF
Date: Mon, 16 Jan 2023 16:49:09 +0100
Message-Id: <20230116154804.472956980@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Clark <robdclark@chromium.org>

commit 52531258318ed59a2dc5a43df2eaf0eb1d65438e upstream.

Userspace can guess the handle value and try to race GEM object creation
with handle close, resulting in a use-after-free if we dereference the
object after dropping the handle's reference.  For that reason, dropping
the handle's reference must be done *after* we are done dereferencing
the object.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Fixes: 62fb7a5e1096 ("virtio-gpu: add 3d/virgl support")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221216233355.542197-2-robdclark@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -358,10 +358,18 @@ static int virtio_gpu_resource_create_io
 		drm_gem_object_release(obj);
 		return ret;
 	}
-	drm_gem_object_put(obj);
 
 	rc->res_handle = qobj->hw_res_handle; /* similiar to a VM address */
 	rc->bo_handle = handle;
+
+	/*
+	 * The handle owns the reference now.  But we must drop our
+	 * remaining reference *after* we no longer need to dereference
+	 * the obj.  Otherwise userspace could guess the handle and
+	 * race closing it from another thread.
+	 */
+	drm_gem_object_put(obj);
+
 	return 0;
 }
 
@@ -723,11 +731,18 @@ static int virtio_gpu_resource_create_bl
 		drm_gem_object_release(obj);
 		return ret;
 	}
-	drm_gem_object_put(obj);
 
 	rc_blob->res_handle = bo->hw_res_handle;
 	rc_blob->bo_handle = handle;
 
+	/*
+	 * The handle owns the reference now.  But we must drop our
+	 * remaining reference *after* we no longer need to dereference
+	 * the obj.  Otherwise userspace could guess the handle and
+	 * race closing it from another thread.
+	 */
+	drm_gem_object_put(obj);
+
 	return 0;
 }
 


