Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA37D13FD9F;
	Thu, 11 Apr 2024 10:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831450; cv=none; b=JH4fYmQVWeG8YjbvF1UNrYrFPEOy69lGEr2AuEJzkY26rRpr0IEhicD+YyJf3JmSPSX7MyZLASrW5z8gxlKr/ASd1EuD0uWORF1qm8yCsfVqowAqW1ifJ5+3maqLEvn+ubr3jruYNmtYUo0G55WhtS05wYMVG24Dl4fAnzdftj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831450; c=relaxed/simple;
	bh=vvagAIgqYxshGgVQFz23oENnCkc4hXEZrbiQQloHn2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=szUnl6p4v0Yi6bxjjwjn0SyX/Gx/pIjhFCckQaqpa0XrRZsNUVUjEdW5550aqlck2BLf2+z/wtPeDc+MCZHMg9+Sgx/K1SZjio05Tn0JwTSgrWZ9PYcBpaBreihsh+O0lb+1fKFvyQQQH0tfYSTeKo6Tt5EuC2GW2QXAh65lwxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+CuWCem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+CuWCem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F20FC433F1;
	Thu, 11 Apr 2024 10:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831450;
	bh=vvagAIgqYxshGgVQFz23oENnCkc4hXEZrbiQQloHn2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+CuWCemDTPJIJRSL+HZELhTYo/3Nx9hYklNYsGedrYdDg27gW/Ttv3T1GxVQJDmD
	 Dw7K7UMHxqhTbjyh61RkQ87RNPBLdByAlJKtJUReHyP6mw+eSj19NJHSzISBEFmnTv
	 1lFa/W9qamqHiILoHDXx2hOQu2d2rH4J+9SyG3ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Dave Airlie <airlied@redhat.com>,
	Huang Rui <ray.huang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/294] drm/vmwgfx: stop using ttm_bo_create v2
Date: Thu, 11 Apr 2024 11:52:56 +0200
Message-ID: <20240411095436.035513656@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit b254557cb244e2c18e59ee1cc2293128c52d2473 ]

Implement in the driver instead since it is the only user of that function.

v2: fix usage of ttm_bo_init_reserved

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Link: https://patchwork.freedesktop.org/patch/391614/?series=81973&rev=1
Stable-dep-of: 517621b70600 ("drm/vmwgfx: Fix possible null pointer derefence with invalid contexts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c         | 43 ++++++++++++++++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c     |  6 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h        |  4 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c |  8 ++--
 4 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
index 813f1b1480941..c8ca09f0e6274 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -487,6 +487,49 @@ static void vmw_user_bo_destroy(struct ttm_buffer_object *bo)
 	ttm_prime_object_kfree(vmw_user_bo, prime);
 }
 
+/**
+ * vmw_bo_create_kernel - Create a pinned BO for internal kernel use.
+ *
+ * @dev_priv: Pointer to the device private struct
+ * @size: size of the BO we need
+ * @placement: where to put it
+ * @p_bo: resulting BO
+ *
+ * Creates and pin a simple BO for in kernel use.
+ */
+int vmw_bo_create_kernel(struct vmw_private *dev_priv, unsigned long size,
+			 struct ttm_placement *placement,
+			 struct ttm_buffer_object **p_bo)
+{
+	unsigned npages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	struct ttm_operation_ctx ctx = { false, false };
+	struct ttm_buffer_object *bo;
+	size_t acc_size;
+	int ret;
+
+	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
+	if (unlikely(!bo))
+		return -ENOMEM;
+
+	acc_size = ttm_round_pot(sizeof(*bo));
+	acc_size += ttm_round_pot(npages * sizeof(void *));
+	acc_size += ttm_round_pot(sizeof(struct ttm_tt));
+	ret = ttm_bo_init_reserved(&dev_priv->bdev, bo, size,
+				   ttm_bo_type_device, placement, 0,
+				   &ctx, acc_size, NULL, NULL, NULL);
+	if (unlikely(ret))
+		goto error_free;
+
+	ttm_bo_pin(bo);
+	ttm_bo_unreserve(bo);
+	*p_bo = bo;
+
+	return 0;
+
+error_free:
+	kfree(bo);
+	return ret;
+}
 
 /**
  * vmw_bo_init - Initialize a vmw buffer object
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
index 3b41cf63110ad..9a9fe10d829b8 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf.c
@@ -1245,9 +1245,9 @@ int vmw_cmdbuf_set_pool_size(struct vmw_cmdbuf_man *man,
 		    !dev_priv->has_mob)
 			return -ENOMEM;
 
-		ret = ttm_bo_create(&dev_priv->bdev, size, ttm_bo_type_device,
-				    &vmw_mob_ne_placement, 0, false,
-				    &man->cmd_space);
+		ret = vmw_bo_create_kernel(dev_priv, size,
+					   &vmw_mob_placement,
+					   &man->cmd_space);
 		if (ret)
 			return ret;
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index 0a79c57c7db64..e6af950c40370 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -845,6 +845,10 @@ extern void vmw_bo_get_guest_ptr(const struct ttm_buffer_object *buf,
 				 SVGAGuestPtr *ptr);
 extern void vmw_bo_pin_reserved(struct vmw_buffer_object *bo, bool pin);
 extern void vmw_bo_bo_free(struct ttm_buffer_object *bo);
+extern int vmw_bo_create_kernel(struct vmw_private *dev_priv,
+				unsigned long size,
+				struct ttm_placement *placement,
+				struct ttm_buffer_object **p_bo);
 extern int vmw_bo_init(struct vmw_private *dev_priv,
 		       struct vmw_buffer_object *vmw_bo,
 		       size_t size, struct ttm_placement *placement,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
index 73116ec70ba59..8abeef691ad29 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
@@ -817,11 +817,9 @@ int vmw_bo_create_and_populate(struct vmw_private *dev_priv,
 	struct ttm_buffer_object *bo;
 	int ret;
 
-	ret = ttm_bo_create(&dev_priv->bdev, bo_size,
-			    ttm_bo_type_device,
-			    &vmw_sys_ne_placement,
-			    0, false, &bo);
-
+	ret = vmw_bo_create_kernel(dev_priv, bo_size,
+				   &vmw_sys_placement,
+				   &bo);
 	if (unlikely(ret != 0))
 		return ret;
 
-- 
2.43.0



