Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2506FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF02FC433EF;
	Tue, 10 Jan 2023 18:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374661;
	bh=j1WvO70Pg2EFn4KmvJ4S33yhxRpbrPQthKjGMxFVn94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuUDL5ocIXGuvzMsGovNg9d2pUe8XRr0VC+71PoFfogGvc/W9S779ssNzdzLrGf1+
	 ZQyc2A+qRwuUg2f4PfPmcXV/freYgG4zbXHnEzrKC7OmPWsSCI3oqJsynfUhBItbBW
	 4zalf9m59MxwWTjDobwKXnMFB/vSS86z7QuA+ljU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/159] drm/virtio: Fix memory leak in virtio_gpu_object_create()
Date: Tue, 10 Jan 2023 19:03:58 +0100
Message-Id: <20230110180021.167187566@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit a764da46cd15f8b40292d2c0b29c4bf9a3e66c7e ]

The virtio_gpu_object_shmem_init() will alloc memory and save it in
@ents, so when virtio_gpu_array_alloc() fails, this memory should be
freed, this patch fixes it.

Fixes: e7fef0923303 ("drm/virtio: Simplify error handling of virtio_gpu_object_create()")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221109091905.55451-1-xiujianfeng@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_object.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
index 8d7728181de0..c7e74cf13022 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -184,7 +184,7 @@ int virtio_gpu_object_create(struct virtio_gpu_device *vgdev,
 	struct virtio_gpu_object_array *objs = NULL;
 	struct drm_gem_shmem_object *shmem_obj;
 	struct virtio_gpu_object *bo;
-	struct virtio_gpu_mem_entry *ents;
+	struct virtio_gpu_mem_entry *ents = NULL;
 	unsigned int nents;
 	int ret;
 
@@ -210,7 +210,7 @@ int virtio_gpu_object_create(struct virtio_gpu_device *vgdev,
 		ret = -ENOMEM;
 		objs = virtio_gpu_array_alloc(1);
 		if (!objs)
-			goto err_put_id;
+			goto err_free_entry;
 		virtio_gpu_array_add_obj(objs, &bo->base.base);
 
 		ret = virtio_gpu_array_lock_resv(objs);
@@ -239,6 +239,8 @@ int virtio_gpu_object_create(struct virtio_gpu_device *vgdev,
 
 err_put_objs:
 	virtio_gpu_array_put_free(objs);
+err_free_entry:
+	kvfree(ents);
 err_put_id:
 	virtio_gpu_resource_id_put(vgdev, bo->hw_res_handle);
 err_free_gem:
-- 
2.35.1



