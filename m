Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8358C3537DF;
	Fri, 24 Apr 2026 13:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038099; cv=none; b=SdWuzjRQ/oIQiOue0NhV9PksBi76fQSxXFWbH3wLQFDt9bj28VYDRfd7pIKJn7WOX8ut2kSxnX5zHxGqACc8zM51NBQJZt2sCrHkZFKeqQ3Ury7yBd6uIs/LdjYI2O6iCtcz9XAdRudl33faMwocnWv/PSp0qJc6XN4zMFJAzcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038099; c=relaxed/simple;
	bh=5tI1I6KH4peweSGSBdvL+dRfiuDuei3tGtjik4HFSu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Or9/gNqtYYwRAZS1pbpnhDLr8/guSbrfjYC7kF+MhsHN7xXiWYBf9tQSqqF9SamqisQa/wAeV77U8UsvQWqaKXmjZX0+kkf1bU0lHSrrq2kdlKeQyy2lpwAjXDkNeohHcLc47/sLfZdlzXZS8EKjP+5J2U/otDT/Ghrre28knyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmi2wnya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmi2wnya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AB4C19425;
	Fri, 24 Apr 2026 13:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038099;
	bh=5tI1I6KH4peweSGSBdvL+dRfiuDuei3tGtjik4HFSu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmi2wnyatYxa/rURbFa/OfMujTqdn9IcrHvF2gw+PKvFLpwZ2MS7nP1GZjbeLkhiY
	 xgsvuA/4AIGay9W1U8+2GP5dNtEtof2CsxeqTj7yKgp2hviKvJ43CVM6S2NOZXQxS9
	 Q+c2cmXUa2syfXyDKq2vAeFqjqyjBEd0DUm1gARQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Thomas Sowell <tom@ldtlb.com>
Subject: [PATCH 6.18 04/55] drm/amdgpu: replace PASID IDR with XArray
Date: Fri, 24 Apr 2026 15:30:43 +0200
Message-ID: <20260424132430.919486258@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

commit 3c863ff920b45fa7a9b7d4cb932f466488a87a58 upstream.

Replace the PASID IDR + spinlock with XArray as noted in the TODO
left by commit ea56aa262570 ("drm/amdgpu: fix the idr allocation
flags").

The IDR conversion still has an IRQ safety issue:
amdgpu_pasid_free() can be called from hardirq context via the fence
signal path, but amdgpu_pasid_idr_lock is taken with plain spin_lock()
in process context, creating a potential deadlock:

     CPU0
     ----
     spin_lock(&amdgpu_pasid_idr_lock)   // process context, IRQs on
     <Interrupt>
       spin_lock(&amdgpu_pasid_idr_lock) // deadlock

   The hardirq call chain is:

     sdma_v6_0_process_trap_irq
      -> amdgpu_fence_process
       -> dma_fence_signal
        -> drm_sched_job_done
         -> dma_fence_signal
          -> amdgpu_pasid_free_cb
           -> amdgpu_pasid_free

Use XArray with XA_FLAGS_LOCK_IRQ (all xa operations use IRQ-safe
locking internally) and XA_FLAGS_ALLOC1 (zero is not a valid PASID).
Both xa_alloc_cyclic() and xa_erase() then handle locking
consistently, fixing the IRQ safety issue and removing the need for
an explicit spinlock.

v8: squash in irq safe fix

Reviewed-by: Christian König <christian.koenig@amd.com>
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Fixes: ea56aa262570 ("drm/amdgpu: fix the idr allocation flags")
Fixes: 8f1de51f49be ("drm/amdgpu: prevent immediate PASID reuse case")
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Thomas Sowell <tom@ldtlb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c |   39 +++++++++++++++-----------------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
@@ -22,7 +22,7 @@
  */
 #include "amdgpu_ids.h"
 
-#include <linux/idr.h>
+#include <linux/xarray.h>
 #include <linux/dma-fence-array.h>
 
 
@@ -40,8 +40,8 @@
  * VMs are looked up from the PASID per amdgpu_device.
  */
 
-static DEFINE_IDR(amdgpu_pasid_idr);
-static DEFINE_SPINLOCK(amdgpu_pasid_idr_lock);
+static DEFINE_XARRAY_FLAGS(amdgpu_pasid_xa, XA_FLAGS_LOCK_IRQ | XA_FLAGS_ALLOC1);
+static u32 amdgpu_pasid_xa_next;
 
 /* Helper to free pasid from a fence callback */
 struct amdgpu_pasid_cb {
@@ -62,36 +62,37 @@ struct amdgpu_pasid_cb {
  */
 int amdgpu_pasid_alloc(unsigned int bits)
 {
-	int pasid;
+	u32 pasid;
+	int r;
 
 	if (bits == 0)
 		return -EINVAL;
 
-	spin_lock(&amdgpu_pasid_idr_lock);
-	/* TODO: Need to replace the idr with an xarry, and then
-	 * handle the internal locking with ATOMIC safe paths.
-	 */
-	pasid = idr_alloc_cyclic(&amdgpu_pasid_idr, NULL, 1,
-				 1U << bits, GFP_ATOMIC);
-	spin_unlock(&amdgpu_pasid_idr_lock);
-
-	if (pasid >= 0)
-		trace_amdgpu_pasid_allocated(pasid);
+	r = xa_alloc_cyclic_irq(&amdgpu_pasid_xa, &pasid, xa_mk_value(0),
+			    XA_LIMIT(1, (1U << bits) - 1),
+			    &amdgpu_pasid_xa_next, GFP_KERNEL);
+	if (r < 0)
+		return r;
 
+	trace_amdgpu_pasid_allocated(pasid);
 	return pasid;
 }
 
 /**
  * amdgpu_pasid_free - Free a PASID
  * @pasid: PASID to free
+ *
+ * Called in IRQ context.
  */
 void amdgpu_pasid_free(u32 pasid)
 {
+	unsigned long flags;
+
 	trace_amdgpu_pasid_freed(pasid);
 
-	spin_lock(&amdgpu_pasid_idr_lock);
-	idr_remove(&amdgpu_pasid_idr, pasid);
-	spin_unlock(&amdgpu_pasid_idr_lock);
+	xa_lock_irqsave(&amdgpu_pasid_xa, flags);
+	__xa_erase(&amdgpu_pasid_xa, pasid);
+	xa_unlock_irqrestore(&amdgpu_pasid_xa, flags);
 }
 
 static void amdgpu_pasid_free_cb(struct dma_fence *fence,
@@ -658,7 +659,5 @@ void amdgpu_vmid_mgr_fini(struct amdgpu_
  */
 void amdgpu_pasid_mgr_cleanup(void)
 {
-	spin_lock(&amdgpu_pasid_idr_lock);
-	idr_destroy(&amdgpu_pasid_idr);
-	spin_unlock(&amdgpu_pasid_idr_lock);
+	xa_destroy(&amdgpu_pasid_xa);
 }


