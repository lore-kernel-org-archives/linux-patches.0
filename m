Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D386147A0DD;
	Wed, 30 Sep 2026 16:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786080; cv=none; b=PAhfTtaT1BV+C5V8RvBKbfixt6cKxzxnfZqU3Aq3FweDHyyQTYxdNJJZHOkLjYbcM+pEoev5O5h4HrTsO2+IKX+26pnP9rN3hp3AWvtDp0/oBD2fdeF1GkCl0sm3rWConvpWgxhHeHKufToS4sRZYe8ruLmK5NrZsHI6NRQAEyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786080; c=relaxed/simple;
	bh=btrorHGuQAA2QG2td8mMXnlKANoBy40XrwBuQrnu3z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leUG1tdXkwmIv4J+y7znj5LEti4lq5Z4cGKb93OR9tEc1PQEjrVytSc0wnK+xyQ6WfXIwSeYiPSLgdihMLKzyTB0IJyTCiUkeJcNIFP8Z2Nq6+wg0pZ1HWwPzP2Y3VwAHfKEOxoutFTepfDLmdtF6I2RRhx7nKCNvXxuO+a1izI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoVTdXWL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoVTdXWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5681F000FF;
	Wed, 30 Sep 2026 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786078;
	bh=/rEtf2kL7kyCMMLrSUO+psgWc+A7hTUPXMIH/KMyRJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hoVTdXWLWNSlL4t9cEdsBPZqMBrXo9l+EQ/TnAtcaqNI+lvKtPwpoqUptqloGvkUf
	 Uu9Ukkc2OM5GtixW47rMeNOKnXEIbL8+MNuMg+wSwW75Oi6FBdHxq/x8R0BaekWZP/
	 kd+1CskZxsaftEGEnd+fK4TxZ+jzzAR+MTnQiKvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Tayar <ttayar@habana.ai>,
	Oded Gabbay <ogabbay@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 690/982] accel/habanalabs: postpone mem_mgr IDR destruction to hpriv_release()
Date: Wed, 30 Sep 2026 17:23:46 +0200
Message-ID: <20260930152431.582378679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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

[ Backport to 6.1.y: this tree keeps Habanalabs under drivers/misc
  rather than drivers/accel; the source change is otherwise unchanged. ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/device.c         |  9 +++++++++
 drivers/misc/habanalabs/common/habanalabs.h     |  1 +
 drivers/misc/habanalabs/common/habanalabs_drv.c |  1 +
 drivers/misc/habanalabs/common/memory_mgr.c     | 13 ++++++++++++-
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index 9ee1b6abd8a05..60a9fc65845bf 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -375,6 +375,9 @@ static void hpriv_release(struct kref *ref)
 	mutex_destroy(&hpriv->ctx_lock);
 	mutex_destroy(&hpriv->restore_phase_mutex);
 
+	/* There should be no memory buffers at this point and handles IDR can be destroyed */
+	hl_mem_mgr_idr_destroy(&hpriv->mem_mgr);
+
 	if ((!hdev->pldm) && (hdev->pdev) &&
 			(!hdev->asic_funcs->is_device_idle(hdev,
 				idle_mask,
@@ -464,6 +467,10 @@ static int hl_device_release(struct inode *inode, struct file *filp)
 	hl_release_pending_user_interrupts(hpriv->hdev);
 
 	hl_ctx_mgr_fini(hdev, &hpriv->ctx_mgr);
+
+	/* Memory buffers might be still in use at this point and thus the handles IDR destruction
+	 * is postponed to hpriv_release().
+	 */
 	hl_mem_mgr_fini(&hpriv->mem_mgr);
 
 	hdev->compute_ctx_in_release = 1;
@@ -808,6 +815,7 @@ static int device_early_init(struct hl_device *hdev)
 
 free_cb_mgr:
 	hl_mem_mgr_fini(&hdev->kernel_mem_mgr);
+	hl_mem_mgr_idr_destroy(&hdev->kernel_mem_mgr);
 free_chip_info:
 	kfree(hdev->hl_chip_info);
 free_pf_wq:
@@ -851,6 +859,7 @@ static void device_early_fini(struct hl_device *hdev)
 	mutex_destroy(&hdev->clk_throttling.lock);
 
 	hl_mem_mgr_fini(&hdev->kernel_mem_mgr);
+	hl_mem_mgr_idr_destroy(&hdev->kernel_mem_mgr);
 
 	kfree(hdev->hl_chip_info);
 
diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/habanalabs/common/habanalabs.h
index 257b94cec6248..e6eabcdda1c5c 100644
--- a/drivers/misc/habanalabs/common/habanalabs.h
+++ b/drivers/misc/habanalabs/common/habanalabs.h
@@ -3789,6 +3789,7 @@ const char *hl_sync_engine_to_string(enum hl_sync_engine_type engine_type);
 
 void hl_mem_mgr_init(struct device *dev, struct hl_mem_mgr *mmg);
 void hl_mem_mgr_fini(struct hl_mem_mgr *mmg);
+void hl_mem_mgr_idr_destroy(struct hl_mem_mgr *mmg);
 int hl_mem_mgr_mmap(struct hl_mem_mgr *mmg, struct vm_area_struct *vma,
 		    void *args);
 struct hl_mmap_mem_buf *hl_mmap_mem_buf_get(struct hl_mem_mgr *mmg,
diff --git a/drivers/misc/habanalabs/common/habanalabs_drv.c b/drivers/misc/habanalabs/common/habanalabs_drv.c
index ae3cab3f4aa55..3d4eaa7327e31 100644
--- a/drivers/misc/habanalabs/common/habanalabs_drv.c
+++ b/drivers/misc/habanalabs/common/habanalabs_drv.c
@@ -222,6 +222,7 @@ int hl_device_open(struct inode *inode, struct file *filp)
 out_err:
 	mutex_unlock(&hdev->fpriv_list_lock);
 	hl_mem_mgr_fini(&hpriv->mem_mgr);
+	hl_mem_mgr_idr_destroy(&hpriv->mem_mgr);
 	hl_ctx_mgr_fini(hpriv->hdev, &hpriv->ctx_mgr);
 	filp->private_data = NULL;
 	mutex_destroy(&hpriv->ctx_lock);
diff --git a/drivers/misc/habanalabs/common/memory_mgr.c b/drivers/misc/habanalabs/common/memory_mgr.c
index 1936d653699ed..93a2b9faf419f 100644
--- a/drivers/misc/habanalabs/common/memory_mgr.c
+++ b/drivers/misc/habanalabs/common/memory_mgr.c
@@ -342,8 +342,19 @@ void hl_mem_mgr_fini(struct hl_mem_mgr *mmg)
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
2.53.0



