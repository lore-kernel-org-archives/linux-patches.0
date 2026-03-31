Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C052E1C7C;
	Tue, 31 Mar 2026 17:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976805; cv=none; b=gkv0CsiW4ZaonU/aVam+wEpFOscFfKj6ShRYid/SnYHa0nA5BEWDAG1t+8JzVPKStdjIPc8q5iZKM/nsNaMUX3R2FNxWNRU6DkRESdmmamRG4h6R1jajYq4Leb0RFGw/JJzKd0ez5VYl1ov3G455YiFZJqx2DMHW+w3sGIH7S60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976805; c=relaxed/simple;
	bh=31XaKez47BQuFzFHSqJYnA9EzkD2TlPHJL2HvGBJ1UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QhtM3cXHJQ4moLS3ZYYhLE2KyW6jdIL4++Rxgh1idpNwStBAjiR/Ps6HB1nR3v7tHxqoHiTX7qFPlUnwvD2ay/Gw1FBlqGPaX51JwgeJpChQm33eWh3r2dfjcIoCLPQ2kF0EveSRAmNGcKuAz7R7L1vTEKtJUcsLDUTLarhBIWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SoElibnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SoElibnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F3FC19423;
	Tue, 31 Mar 2026 17:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976804;
	bh=31XaKez47BQuFzFHSqJYnA9EzkD2TlPHJL2HvGBJ1UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SoElibnQWA1Vp7iOzN59tsUqt02yhfqNbra6b/xc/Xx9PSffNWtycxC5+eWSGHnrN
	 5uauEh1VnEAAJVf7xapZkbOhC+eRl5CnU8OgnluhCJ55sAKg105ZRvZ1LtYX/rhfjy
	 zCew3OVhaHUvearbKC9YDRMPN8jnheVloEfjFhwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 233/309] drm/amdgpu: prevent immediate PASID reuse case
Date: Tue, 31 Mar 2026 18:22:16 +0200
Message-ID: <20260331161802.155707744@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Huang <jinhuieric.huang@amd.com>

commit 14b81abe7bdc25f8097906fc2f91276ffedb2d26 upstream.

PASID resue could cause interrupt issue when process
immediately runs into hw state left by previous
process exited with the same PASID, it's possible that
page faults are still pending in the IH ring buffer when
the process exits and frees up its PASID. To prevent the
case, it uses idr cyclic allocator same as kernel pid's.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8f1de51f49be692de137c8525106e0fce2d1912d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c |   45 ++++++++++++++++++++++----------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c  |    1 
 3 files changed, 34 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
@@ -35,10 +35,13 @@
  * PASIDs are global address space identifiers that can be shared
  * between the GPU, an IOMMU and the driver. VMs on different devices
  * may use the same PASID if they share the same address
- * space. Therefore PASIDs are allocated using a global IDA. VMs are
- * looked up from the PASID per amdgpu_device.
+ * space. Therefore PASIDs are allocated using IDR cyclic allocator
+ * (similar to kernel PID allocation) which naturally delays reuse.
+ * VMs are looked up from the PASID per amdgpu_device.
  */
-static DEFINE_IDA(amdgpu_pasid_ida);
+
+static DEFINE_IDR(amdgpu_pasid_idr);
+static DEFINE_SPINLOCK(amdgpu_pasid_idr_lock);
 
 /* Helper to free pasid from a fence callback */
 struct amdgpu_pasid_cb {
@@ -50,8 +53,8 @@ struct amdgpu_pasid_cb {
  * amdgpu_pasid_alloc - Allocate a PASID
  * @bits: Maximum width of the PASID in bits, must be at least 1
  *
- * Allocates a PASID of the given width while keeping smaller PASIDs
- * available if possible.
+ * Uses kernel's IDR cyclic allocator (same as PID allocation).
+ * Allocates sequentially with automatic wrap-around.
  *
  * Returns a positive integer on success. Returns %-EINVAL if bits==0.
  * Returns %-ENOSPC if no PASID was available. Returns %-ENOMEM on
@@ -59,14 +62,15 @@ struct amdgpu_pasid_cb {
  */
 int amdgpu_pasid_alloc(unsigned int bits)
 {
-	int pasid = -EINVAL;
+	int pasid;
 
-	for (bits = min(bits, 31U); bits > 0; bits--) {
-		pasid = ida_alloc_range(&amdgpu_pasid_ida, 1U << (bits - 1),
-					(1U << bits) - 1, GFP_KERNEL);
-		if (pasid != -ENOSPC)
-			break;
-	}
+	if (bits == 0)
+		return -EINVAL;
+
+	spin_lock(&amdgpu_pasid_idr_lock);
+	pasid = idr_alloc_cyclic(&amdgpu_pasid_idr, NULL, 1,
+				 1U << bits, GFP_KERNEL);
+	spin_unlock(&amdgpu_pasid_idr_lock);
 
 	if (pasid >= 0)
 		trace_amdgpu_pasid_allocated(pasid);
@@ -81,7 +85,10 @@ int amdgpu_pasid_alloc(unsigned int bits
 void amdgpu_pasid_free(u32 pasid)
 {
 	trace_amdgpu_pasid_freed(pasid);
-	ida_free(&amdgpu_pasid_ida, pasid);
+
+	spin_lock(&amdgpu_pasid_idr_lock);
+	idr_remove(&amdgpu_pasid_idr, pasid);
+	spin_unlock(&amdgpu_pasid_idr_lock);
 }
 
 static void amdgpu_pasid_free_cb(struct dma_fence *fence,
@@ -640,3 +647,15 @@ void amdgpu_vmid_mgr_fini(struct amdgpu_
 		}
 	}
 }
+
+/**
+ * amdgpu_pasid_mgr_cleanup - cleanup PASID manager
+ *
+ * Cleanup the IDR allocator.
+ */
+void amdgpu_pasid_mgr_cleanup(void)
+{
+	spin_lock(&amdgpu_pasid_idr_lock);
+	idr_destroy(&amdgpu_pasid_idr);
+	spin_unlock(&amdgpu_pasid_idr_lock);
+}
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h
@@ -74,6 +74,7 @@ int amdgpu_pasid_alloc(unsigned int bits
 void amdgpu_pasid_free(u32 pasid);
 void amdgpu_pasid_free_delayed(struct dma_resv *resv,
 			       u32 pasid);
+void amdgpu_pasid_mgr_cleanup(void);
 
 bool amdgpu_vmid_had_gpu_reset(struct amdgpu_device *adev,
 			       struct amdgpu_vmid *id);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2884,6 +2884,7 @@ void amdgpu_vm_manager_fini(struct amdgp
 	xa_destroy(&adev->vm_manager.pasids);
 
 	amdgpu_vmid_mgr_fini(adev);
+	amdgpu_pasid_mgr_cleanup();
 }
 
 /**


