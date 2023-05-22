Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC6C171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA3EC433EF;
	Mon, 22 May 2023 19:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784358;
	bh=CG6iidfJYvBtjEQvRVQLTsIrpzO11PNYCTvVzvScUro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+2NYzZ/7D2pEc4NY3GQdiCWV3wOzbLaZdV22TAVFletH9Fh275DSpj9sFGYZqwFC
	 JDZkx5kUAPYfmyn8HKngW+7RTvHMw3lxusLu9xOHIWkiVfD63DInY87xhR5xtQrmF3
	 Yrwx/JcdBFAf8NMqlUXE0kor0iKV5sfRslRd36fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Tayar <ttayar@habana.ai>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 055/364] accel/habanalabs: postpone mem_mgr IDR destruction to hpriv_release()
Date: Mon, 22 May 2023 20:06:00 +0100
Message-Id: <20230522190414.178037186@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomer Tayar <ttayar@habana.ai>

[ Upstream commit 2e8e9a895c4589f124a37fc84d123b5114406e94 ]

The memory manager IDR is currently destroyed when user releases the
file descriptor.
However, at this point the user context might be still held, and memory
buffers might be still in use.
Later on, calls to release those buffers will fail due to not finding
their handles in the IDR, leading to a memory leak.
To avoid this leak, split the IDR destruction from the memory manager
fini, and postpone it to hpriv_release() when there is no user context
and no buffers are used.

Signed-off-by: Tomer Tayar <ttayar@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/common/device.c         |  9 +++++++++
 drivers/accel/habanalabs/common/habanalabs.h     |  1 +
 drivers/accel/habanalabs/common/habanalabs_drv.c |  1 +
 drivers/accel/habanalabs/common/memory_mgr.c     | 13 ++++++++++++-
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/habanalabs/common/device.c b/drivers/accel/habanalabs/common/device.c
index 9933e5858a363..c91436609f080 100644
--- a/drivers/accel/habanalabs/common/device.c
+++ b/drivers/accel/habanalabs/common/device.c
@@ -423,6 +423,9 @@ static void hpriv_release(struct kref *ref)
 	mutex_destroy(&hpriv->ctx_lock);
 	mutex_destroy(&hpriv->restore_phase_mutex);
 
+	/* There should be no memory buffers at this point and handles IDR can be destroyed */
+	hl_mem_mgr_idr_destroy(&hpriv->mem_mgr);
+
 	/* Device should be reset if reset-upon-device-release is enabled, or if there is a pending
 	 * reset that waits for device release.
 	 */
@@ -514,6 +517,10 @@ static int hl_device_release(struct inode *inode, struct file *filp)
 	}
 
 	hl_ctx_mgr_fini(hdev, &hpriv->ctx_mgr);
+
+	/* Memory buffers might be still in use at this point and thus the handles IDR destruction
+	 * is postponed to hpriv_release().
+	 */
 	hl_mem_mgr_fini(&hpriv->mem_mgr);
 
 	hdev->compute_ctx_in_release = 1;
@@ -887,6 +894,7 @@ static int device_early_init(struct hl_device *hdev)
 
 free_cb_mgr:
 	hl_mem_mgr_fini(&hdev->kernel_mem_mgr);
+	hl_mem_mgr_idr_destroy(&hdev->kernel_mem_mgr);
 free_chip_info:
 	kfree(hdev->hl_chip_info);
 free_prefetch_wq:
@@ -930,6 +938,7 @@ static void device_early_fini(struct hl_device *hdev)
 	mutex_destroy(&hdev->clk_throttling.lock);
 
 	hl_mem_mgr_fini(&hdev->kernel_mem_mgr);
+	hl_mem_mgr_idr_destroy(&hdev->kernel_mem_mgr);
 
 	kfree(hdev->hl_chip_info);
 
diff --git a/drivers/accel/habanalabs/common/habanalabs.h b/drivers/accel/habanalabs/common/habanalabs.h
index fa05e76d3d21a..829b30ab1961a 100644
--- a/drivers/accel/habanalabs/common/habanalabs.h
+++ b/drivers/accel/habanalabs/common/habanalabs.h
@@ -3861,6 +3861,7 @@ const char *hl_sync_engine_to_string(enum hl_sync_engine_type engine_type);
 
 void hl_mem_mgr_init(struct device *dev, struct hl_mem_mgr *mmg);
 void hl_mem_mgr_fini(struct hl_mem_mgr *mmg);
+void hl_mem_mgr_idr_destroy(struct hl_mem_mgr *mmg);
 int hl_mem_mgr_mmap(struct hl_mem_mgr *mmg, struct vm_area_struct *vma,
 		    void *args);
 struct hl_mmap_mem_buf *hl_mmap_mem_buf_get(struct hl_mem_mgr *mmg,
diff --git a/drivers/accel/habanalabs/common/habanalabs_drv.c b/drivers/accel/habanalabs/common/habanalabs_drv.c
index 03dae57dc8386..e3781cfe8a7fe 100644
--- a/drivers/accel/habanalabs/common/habanalabs_drv.c
+++ b/drivers/accel/habanalabs/common/habanalabs_drv.c
@@ -237,6 +237,7 @@ int hl_device_open(struct inode *inode, struct file *filp)
 out_err:
 	mutex_unlock(&hdev->fpriv_list_lock);
 	hl_mem_mgr_fini(&hpriv->mem_mgr);
+	hl_mem_mgr_idr_destroy(&hpriv->mem_mgr);
 	hl_ctx_mgr_fini(hpriv->hdev, &hpriv->ctx_mgr);
 	filp->private_data = NULL;
 	mutex_destroy(&hpriv->ctx_lock);
diff --git a/drivers/accel/habanalabs/common/memory_mgr.c b/drivers/accel/habanalabs/common/memory_mgr.c
index 0f2759e265477..f8e8261cc83d8 100644
--- a/drivers/accel/habanalabs/common/memory_mgr.c
+++ b/drivers/accel/habanalabs/common/memory_mgr.c
@@ -341,8 +341,19 @@ void hl_mem_mgr_fini(struct hl_mem_mgr *mmg)
 				"%s: Buff handle %u for CTX is still alive\n",
 				topic, id);
 	}
+}
 
-	/* TODO: can it happen that some buffer is still in use at this point? */
+/**
+ * hl_mem_mgr_idr_destroy() - destroy memory manager IDR.
+ * @mmg: parent unified memory manager
+ *
+ * Destroy the memory manager IDR.
+ * Shall be called when IDR is empty and no memory buffers are in use.
+ */
+void hl_mem_mgr_idr_destroy(struct hl_mem_mgr *mmg)
+{
+	if (!idr_is_empty(&mmg->handles))
+		dev_crit(mmg->dev, "memory manager IDR is destroyed while it is not empty!\n");
 
 	idr_destroy(&mmg->handles);
 }
-- 
2.39.2



