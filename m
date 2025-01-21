Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17401E9B38;
	Tue, 21 Jan 2025 17:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482050; cv=none; b=pVgMiyIAdbn/z/qIcEPoGS4vw/SgEKHJcVZSVPjEdk83IAPm1gEHQX0X0rF6S6dXONyPOTBsoYIzEjaI13QmtaBOsRPL4LpzKKBK9mel7F2wGlfB0QKPVE0ztekGFpM2fuMql8CW2le4L3MGDPdAuwsUALK+RZOLelU/hFVQSiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482050; c=relaxed/simple;
	bh=z/ok41YhEHhjSX8OZIhD+XHjUFu3RlDTBMoSa3FLW2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwGWbbBdXqDYW8EJaFYt79hTC90x2/o2qMNMOey4QMU1M/xQSgR/9raBfy8theg4PNypr5tRwve374G8f4RVzKcFul0HDG19mmPKHtzKdXc8MuWJ3kojB9BoecQ5OwEUjax9rJu2r5hENzWibZiqcVl5Y/Ld35aZMzptVQUkqAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gfj/oUnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gfj/oUnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20B9C4CEDF;
	Tue, 21 Jan 2025 17:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482049;
	bh=z/ok41YhEHhjSX8OZIhD+XHjUFu3RlDTBMoSa3FLW2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gfj/oUnxAeMHYG60rYXFA60fBV9JCv6GARwlPu65HcBgPLy1GssZIgFPPT5uEgoXb
	 o1RnQW/bVDLQyxyYpsIuvk7NCQP9BAf1ls0HN1COvHKDeXBXzkzDdncpIprKfzdAHc
	 i5425dGVUqUpzM/ILRhHptdtyqPIiGm2W9Lh1VHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 17/72] drm/vmwgfx: Add new keep_resv BO param
Date: Tue, 21 Jan 2025 18:51:43 +0100
Message-ID: <20250121174524.090299000@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit b7d40627813799870e72729c6fc979a8a40d9ba6 ]

Adds a new BO param that keeps the reservation locked after creation.
This removes the need to re-reserve the BO after creation which is a
waste of cycles.

This also fixes a bug in vmw_prime_import_sg_table where the imported
reservation is unlocked twice.

Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Fixes: b32233acceff ("drm/vmwgfx: Fix prime import/export")
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250110185335.15301-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c         | 3 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.h         | 3 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c        | 7 ++-----
 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c        | 1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c     | 7 ++-----
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c | 5 ++---
 6 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
index fdc34283eeb97..ec6ca264ce11f 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -412,7 +412,8 @@ static int vmw_bo_init(struct vmw_private *dev_priv,
 
 	if (params->pin)
 		ttm_bo_pin(&vmw_bo->tbo);
-	ttm_bo_unreserve(&vmw_bo->tbo);
+	if (!params->keep_resv)
+		ttm_bo_unreserve(&vmw_bo->tbo);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
index 156ea612fc2a4..a3ac61b991bf6 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.h
@@ -53,8 +53,9 @@ struct vmw_bo_params {
 	u32 domain;
 	u32 busy_domain;
 	enum ttm_bo_type bo_type;
-	size_t size;
 	bool pin;
+	bool keep_resv;
+	size_t size;
 	struct dma_resv *resv;
 	struct sg_table *sg;
 };
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index bea576434e475..4655c266924fe 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -399,7 +399,8 @@ static int vmw_dummy_query_bo_create(struct vmw_private *dev_priv)
 		.busy_domain = VMW_BO_DOMAIN_SYS,
 		.bo_type = ttm_bo_type_kernel,
 		.size = PAGE_SIZE,
-		.pin = true
+		.pin = true,
+		.keep_resv = true,
 	};
 
 	/*
@@ -411,10 +412,6 @@ static int vmw_dummy_query_bo_create(struct vmw_private *dev_priv)
 	if (unlikely(ret != 0))
 		return ret;
 
-	ret = ttm_bo_reserve(&vbo->tbo, false, true, NULL);
-	BUG_ON(ret != 0);
-	vmw_bo_pin_reserved(vbo, true);
-
 	ret = ttm_bo_kmap(&vbo->tbo, 0, 1, &map);
 	if (likely(ret == 0)) {
 		result = ttm_kmap_obj_virtual(&map, &dummy);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
index d6bcaf078b1f4..0dc3dacc5beee 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
@@ -163,6 +163,7 @@ struct drm_gem_object *vmw_prime_import_sg_table(struct drm_device *dev,
 		.bo_type = ttm_bo_type_sg,
 		.size = attach->dmabuf->size,
 		.pin = false,
+		.keep_resv = true,
 		.resv = attach->dmabuf->resv,
 		.sg = table,
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
index a01ca3226d0af..7fb1c88bcc475 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
@@ -896,7 +896,8 @@ int vmw_compat_shader_add(struct vmw_private *dev_priv,
 		.busy_domain = VMW_BO_DOMAIN_SYS,
 		.bo_type = ttm_bo_type_device,
 		.size = size,
-		.pin = true
+		.pin = true,
+		.keep_resv = true,
 	};
 
 	if (!vmw_shader_id_ok(user_key, shader_type))
@@ -906,10 +907,6 @@ int vmw_compat_shader_add(struct vmw_private *dev_priv,
 	if (unlikely(ret != 0))
 		goto out;
 
-	ret = ttm_bo_reserve(&buf->tbo, false, true, NULL);
-	if (unlikely(ret != 0))
-		goto no_reserve;
-
 	/* Map and copy shader bytecode. */
 	ret = ttm_bo_kmap(&buf->tbo, 0, PFN_UP(size), &map);
 	if (unlikely(ret != 0)) {
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
index fcb87d83760ef..75cf9e76df2ed 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c
@@ -604,15 +604,14 @@ int vmw_bo_create_and_populate(struct vmw_private *dev_priv,
 		.busy_domain = domain,
 		.bo_type = ttm_bo_type_kernel,
 		.size = bo_size,
-		.pin = true
+		.pin = true,
+		.keep_resv = true,
 	};
 
 	ret = vmw_bo_create(dev_priv, &bo_params, &vbo);
 	if (unlikely(ret != 0))
 		return ret;
 
-	ret = ttm_bo_reserve(&vbo->tbo, false, true, NULL);
-	BUG_ON(ret != 0);
 	ret = vmw_ttm_populate(vbo->tbo.bdev, vbo->tbo.ttm, &ctx);
 	if (likely(ret == 0)) {
 		struct vmw_ttm_tt *vmw_tt =
-- 
2.39.5



