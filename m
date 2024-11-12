Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC37121314E;
	Tue, 12 Nov 2024 10:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408340; cv=none; b=asViGjthLFVv7dNNTzgzGSeMne7jQeITjj1CZpyISPvg9a8uTv66p/kSqOO4Uv5NAjvKfWSF9YN3rqWOjj9oFSyiUjrrLtvryeSgcfI/abuPiBBNm1NFs8llrDBy7lBg4XtcGLLPi4qFLJymEhFy2NHI3+rGVZv6Szv/8aGLCpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408340; c=relaxed/simple;
	bh=ctWrCEEE67s6q2Kuh7FFoz7VKpz51p3ilpb+0TPVCUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1fkUHISejz71zvRs/bs8EGorlZdlu6V8UDHVXHStu1qPFDVt4+cVjEIEzAH2ggXoAexcKwLM/pO8QKYnBYGED3CL4Ztg/9NFaTV4hEcdbZB6r8mswxfD0U743lDF+1L8ZnjIPjgrgE7MS2u54h5HSOP16/LGvKxLesW3r9ECQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDlm3oYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDlm3oYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF1AC4CECD;
	Tue, 12 Nov 2024 10:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408340;
	bh=ctWrCEEE67s6q2Kuh7FFoz7VKpz51p3ilpb+0TPVCUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDlm3oYq32ZovMY3mYbX3+t/aS8eXi03g49WdBeM7I46s0J+jB4+BtXcT82LoU6kk
	 BPa+se82oFVMgEKm78JKP3VNS3JSyXLdhdFWXqHD+HRgV3PvaPIT8Nwznex54QZztj
	 ClpOkEmAymeV3omMwYA4Qw9hwbiNB1FCPQO9wIdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan King <brendan.king@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Frank Binns <frank.binns@imgtec.com>
Subject: [PATCH 6.11 101/184] drm/imagination: Add a per-file PVR context list
Date: Tue, 12 Nov 2024 11:20:59 +0100
Message-ID: <20241112101904.739148160@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brendan King <brendan.king@imgtec.com>

commit b0ef514bc6bbdeb8cc7492c0f473e14cb06b14d4 upstream.

This adds a linked list of VM contexts which is needed for the next patch
to be able to correctly track VM contexts for destruction on file close.

It is only safe for VM contexts to be removed from the list and destroyed
when not in interrupt context.

Signed-off-by: Brendan King <brendan.king@imgtec.com>
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Reviewed-by: Frank Binns <frank.binns@imgtec.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/e57128ea-f0ce-4e93-a9d4-3f033a8b06fa@imgtec.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_context.c |   14 ++++++++++++++
 drivers/gpu/drm/imagination/pvr_context.h |    3 +++
 drivers/gpu/drm/imagination/pvr_device.h  |   10 ++++++++++
 drivers/gpu/drm/imagination/pvr_drv.c     |    3 +++
 4 files changed, 30 insertions(+)

--- a/drivers/gpu/drm/imagination/pvr_context.c
+++ b/drivers/gpu/drm/imagination/pvr_context.c
@@ -17,10 +17,14 @@
 
 #include <drm/drm_auth.h>
 #include <drm/drm_managed.h>
+
+#include <linux/bug.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/xarray.h>
@@ -354,6 +358,10 @@ int pvr_context_create(struct pvr_file *
 		return err;
 	}
 
+	spin_lock(&pvr_dev->ctx_list_lock);
+	list_add_tail(&ctx->file_link, &pvr_file->contexts);
+	spin_unlock(&pvr_dev->ctx_list_lock);
+
 	return 0;
 
 err_destroy_fw_obj:
@@ -380,6 +388,11 @@ pvr_context_release(struct kref *ref_cou
 		container_of(ref_count, struct pvr_context, ref_count);
 	struct pvr_device *pvr_dev = ctx->pvr_dev;
 
+	WARN_ON(in_interrupt());
+	spin_lock(&pvr_dev->ctx_list_lock);
+	list_del(&ctx->file_link);
+	spin_unlock(&pvr_dev->ctx_list_lock);
+
 	xa_erase(&pvr_dev->ctx_ids, ctx->ctx_id);
 	pvr_context_destroy_queues(ctx);
 	pvr_fw_object_destroy(ctx->fw_obj);
@@ -451,6 +464,7 @@ void pvr_destroy_contexts_for_file(struc
 void pvr_context_device_init(struct pvr_device *pvr_dev)
 {
 	xa_init_flags(&pvr_dev->ctx_ids, XA_FLAGS_ALLOC1);
+	spin_lock_init(&pvr_dev->ctx_list_lock);
 }
 
 /**
--- a/drivers/gpu/drm/imagination/pvr_context.h
+++ b/drivers/gpu/drm/imagination/pvr_context.h
@@ -85,6 +85,9 @@ struct pvr_context {
 		/** @compute: Transfer queue. */
 		struct pvr_queue *transfer;
 	} queues;
+
+	/** @file_link: pvr_file PVR context list link. */
+	struct list_head file_link;
 };
 
 static __always_inline struct pvr_queue *
--- a/drivers/gpu/drm/imagination/pvr_device.h
+++ b/drivers/gpu/drm/imagination/pvr_device.h
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/math.h>
 #include <linux/mutex.h>
+#include <linux/spinlock_types.h>
 #include <linux/timer.h>
 #include <linux/types.h>
 #include <linux/wait.h>
@@ -293,6 +294,12 @@ struct pvr_device {
 
 	/** @sched_wq: Workqueue for schedulers. */
 	struct workqueue_struct *sched_wq;
+
+	/**
+	 * @ctx_list_lock: Lock to be held when accessing the context list in
+	 *  struct pvr_file.
+	 */
+	spinlock_t ctx_list_lock;
 };
 
 /**
@@ -344,6 +351,9 @@ struct pvr_file {
 	 * This array is used to allocate handles returned to userspace.
 	 */
 	struct xarray vm_ctx_handles;
+
+	/** @contexts: PVR context list. */
+	struct list_head contexts;
 };
 
 /**
--- a/drivers/gpu/drm/imagination/pvr_drv.c
+++ b/drivers/gpu/drm/imagination/pvr_drv.c
@@ -28,6 +28,7 @@
 #include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -1326,6 +1327,8 @@ pvr_drm_driver_open(struct drm_device *d
 	 */
 	pvr_file->pvr_dev = pvr_dev;
 
+	INIT_LIST_HEAD(&pvr_file->contexts);
+
 	xa_init_flags(&pvr_file->ctx_handles, XA_FLAGS_ALLOC1);
 	xa_init_flags(&pvr_file->free_list_handles, XA_FLAGS_ALLOC1);
 	xa_init_flags(&pvr_file->hwrt_handles, XA_FLAGS_ALLOC1);


