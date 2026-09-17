Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A70A3DA7FF;
	Thu, 17 Sep 2026 17:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667463; cv=none; b=BC/bjLcfgEpt4CgQNn/mp3Wlbmvs2sC4XBGgoUAo/6AGkrCgvm4yqlYcePteeogHZODJ9e7DxznZ5782AhaSdxOG/MRTib78tWYk21AhMLrXFS3BeSTXM+BmRQAmKUcxy3HPgI0Ev7wRiw/piHiR1wprwdFXGrTB3L69zSFtjMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667463; c=relaxed/simple;
	bh=wQOd0kJGN4M80Y1DQM8BktAm2JDRxZQrgykHGMgBHbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOeVlDYZ5aOcC5AJkKwlY+MBoX97bJZpH8mWXLQ35++W/DfDod3kcnQqfZaFudR4cvhTVwjuD63VfD26qsUY5DaW3ROHAAnYW4a/B3HhJKh7DhUNPhkAucurNwxz+J7epMPSN+j7Y5ZQfaRQyAfstbmbUpiLIHlJ32CQBsGxFJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7jmuEWl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7jmuEWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652C51F000FF;
	Thu, 17 Sep 2026 17:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667461;
	bh=c1c56CqLAom/DfUnzzOGEQYSbBr9XNV1niIElsXfwgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x7jmuEWlTwLHQTOA4QUS8b3sSROYw4NIVPg3BTeVbdmuNvIgM4DJ+7coaM3oMHnak
	 AB1v9b0Ma+0u1nyvQ4lpN8KBC6xMea7MUk5Vsz+sqWWu0M1JhXeFHvhQyaTwe1z3au
	 FYH515Mh9Att+AoDItzO4GRmsKqToriuiZRzzrJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brajesh Gupta <brajesh.gupta@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0102/1102] drm/imagination: Populate FW common context ID before passing to the FW
Date: Thu, 17 Sep 2026 16:00:45 +0100
Message-ID: <20260917151542.059565406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e330adba75f1c..af4c93660a40b 100644
--- a/drivers/gpu/drm/imagination/pvr_context.c
+++ b/drivers/gpu/drm/imagination/pvr_context.c
@@ -332,10 +332,14 @@ int pvr_context_create(struct pvr_file *pvr_file, struct drm_pvr_ioctl_create_co
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
@@ -343,23 +347,12 @@ int pvr_context_create(struct pvr_file *pvr_file, struct drm_pvr_ioctl_create_co
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
@@ -372,6 +365,15 @@ int pvr_context_create(struct pvr_file *pvr_file, struct drm_pvr_ioctl_create_co
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



