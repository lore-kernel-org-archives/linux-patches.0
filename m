Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9822878F4A;
	Fri, 24 Apr 2026 13:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037564; cv=none; b=bTL2ZXHrUIY+bZOxXVMT5l6G104+I8BK3BhqRQyx7c4cwDvnblZlmBD5gy920p5LqHbjbkrUT4P85mVevfhDiPEabtc9yLl+R3LYQ972LVxvl8XHV3p5lRLVgMGSlOR/I4Lecg8bgZOqK/8t3oA5afkikdl+RhKXxzQn9yXQEZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037564; c=relaxed/simple;
	bh=5kROmjtvG63ZUZUmudIJfHRpcTb2hX4LSQ0tfRCTxN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e6LsrNqezM1Az08j1WJDbSR1AiuOOfGCHhCElZxi+VMFYScEWszCmRk96k+bgBFPRnyeNEG1hgKEuW+eT3OVvZXGdCPneV3baV5cpqwu8dgrgxjneHd1/isvnAghax3pbCWvAiDbA2Oa3wbIatJvqx8uGlg9N3xGy+eLVSC+ESM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xs/isXkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xs/isXkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25491C2BCB2;
	Fri, 24 Apr 2026 13:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037564;
	bh=5kROmjtvG63ZUZUmudIJfHRpcTb2hX4LSQ0tfRCTxN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xs/isXklLWRd6x+4ZuW96Mco5WFSp3WPrgup6s/0pUwG1V5VYfgvpT51Wact+rCYz
	 X9H0L0xbFxVrSTDkpS0XvOpcruRjqRgOuhV4JZPpiVC7pIBcuNvZxmjqMZ9cDc/ecP
	 6j0C7mdKP6oVSqPYkAFPiw7FVkOAhkdK6NL3MQnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Thomas Sowell <tom@ldtlb.com>
Subject: [PATCH 7.0 03/42] drm/amdgpu: replace PASID IDR with XArray
Date: Fri, 24 Apr 2026 15:30:28 +0200
Message-ID: <20260424132421.100913011@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -634,7 +635,5 @@ void amdgpu_vmid_mgr_fini(struct amdgpu_
  */
 void amdgpu_pasid_mgr_cleanup(void)
 {
-	spin_lock(&amdgpu_pasid_idr_lock);
-	idr_destroy(&amdgpu_pasid_idr);
-	spin_unlock(&amdgpu_pasid_idr_lock);
+	xa_destroy(&amdgpu_pasid_xa);
 }


