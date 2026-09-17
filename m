Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8674DEC0F;
	Thu, 17 Sep 2026 16:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661295; cv=none; b=bFpulrkmChdyyddU3jQttIVLMhHKjhZwgIYPmDvmbzq7ClJD04hZP1NLRTo+rlwRH/7avT/5rPkyxgt/ZCdVjZyn6aBKk+u5qavDJUK4333khTrMu6/5OOv4jNcrh3WdHurlG9CTqUnIQVK0CapO1vrw2oF9qqZAp5IDeB6lL1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661295; c=relaxed/simple;
	bh=dcW/KTYaPpPMNwlQltfBp36WwS/QsLp5r81WDe36O5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bq6AD80/LSbBnU3joUdA47P9RRyrwFgHN/aZj66e8jS1fy3R/Q3XNvxdtpQ/+RAd5osp2tY8x+AczTaOmjSVSdGSGYdX2ht4MYbZhuhWwLfbUBR4EDJ3+jQMR+kb9/h9ulAVlX3gvQiqZnGj8CJkVQ691QVN5o0A18o2OWaElPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzJpXilk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzJpXilk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CDA1F000FF;
	Thu, 17 Sep 2026 16:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661294;
	bh=SwYrzcQGz6dSjbGE2OxY/YTjirQuh42pHED75NfkFKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzJpXilkaE5sUIFJ9GzF5UQte/KIt309nFpeopR6AQj2HJ/gy9c75UUupBzmR0Z+e
	 qt659w6TxBBldnuyMKqPb+7M+3zBJ4II1bSY6sx7ND70rxwK89zIbAAIg+nBIljmnE
	 ljcQAtGzEmt2s5GVakhTBgnXCtSuxZgyrFdfWS5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brajesh Gupta <brajesh.gupta@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0147/1250] drm/imagination: Populate FW common context ID before passing to the FW
Date: Thu, 17 Sep 2026 15:59:02 +0100
Message-ID: <20260917151556.046243671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brajesh Gupta <brajesh.gupta@imgtec.com>

[ Upstream commit de1e8a590f4ed48b6b7902fc3aafc878262f8278 ]

Initialise the context ID for the FW common context correctly by moving
the context allocation earlier.

Signed-off-by: Brajesh Gupta <brajesh.gupta@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patch.msgid.link/20260519-b4-context_reset-v2-1-931018a7131d@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_context.c | 30 ++++++++++++-----------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/imagination/pvr_context.c b/drivers/gpu/drm/imagination/pvr_context.c
index d9066a4fefcf3..5befaed562ac6 100644
--- a/drivers/gpu/drm/imagination/pvr_context.c
+++ b/drivers/gpu/drm/imagination/pvr_context.c
@@ -320,10 +320,14 @@ int pvr_context_create(struct pvr_file *pvr_file, struct drm_pvr_ioctl_create_co
 		goto err_put_vm;
 	}
 
-	err = pvr_context_create_queues(ctx, args, ctx->data);
+	err = xa_alloc(&pvr_dev->ctx_ids, &ctx->ctx_id, ctx, xa_limit_32b, GFP_KERNEL);
 	if (err)
 		goto err_free_ctx_data;
 
+	err = pvr_context_create_queues(ctx, args, ctx->data);
+	if (err)
+		goto err_free_ctx_id;
+
 	err = init_fw_objs(ctx, args, ctx->data);
 	if (err)
 		goto err_destroy_queues;
@@ -331,23 +335,12 @@ int pvr_context_create(struct pvr_file *pvr_file, struct drm_pvr_ioctl_create_co
 	err = pvr_fw_object_create(pvr_dev, ctx_size, PVR_BO_FW_FLAGS_DEVICE_UNCACHED,
 				   ctx_fw_data_init, ctx, &ctx->fw_obj);
 	if (err)
-		goto err_free_ctx_data;
+		goto err_destroy_queues;
 
-	err = xa_alloc(&pvr_dev->ctx_ids, &ctx->ctx_id, ctx, xa_limit_32b, GFP_KERNEL);
+	err = xa_alloc(&pvr_file->ctx_handles, &args->handle, ctx, xa_limit_32b, GFP_KERNEL);
 	if (err)
 		goto err_destroy_fw_obj;
 
-	err = xa_alloc(&pvr_file->ctx_handles, &args->handle, ctx, xa_limit_32b, GFP_KERNEL);
-	if (err) {
-		/*
-		 * It's possible that another thread could have taken a reference on the context at
-		 * this point as it is in the ctx_ids xarray. Therefore instead of directly
-		 * destroying the context, drop a reference instead.
-		 */
-		pvr_context_put(ctx);
-		return err;
-	}
-
 	spin_lock(&pvr_dev->ctx_list_lock);
 	list_add_tail(&ctx->file_link, &pvr_file->contexts);
 	spin_unlock(&pvr_dev->ctx_list_lock);
@@ -360,6 +353,15 @@ int pvr_context_create(struct pvr_file *pvr_file, struct drm_pvr_ioctl_create_co
 err_destroy_queues:
 	pvr_context_destroy_queues(ctx, true);
 
+err_free_ctx_id:
+	/*
+	 * Ctx_id is not exposed to userspace and not visible yet within
+	 * the kernel/FW, plus a matching context handle (exposed to userspace)
+	 * hasn't been allocated yet, so it is safe to remove ctx_id
+	 * from the ctx_ids xarray.
+	 */
+	xa_erase(&pvr_dev->ctx_ids, ctx->ctx_id);
+
 err_free_ctx_data:
 	kfree(ctx->data);
 
-- 
2.53.0



