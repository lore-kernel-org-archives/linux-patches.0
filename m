Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D954446F4;
	Thu, 30 Jul 2026 15:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424336; cv=none; b=fKefNDNQ0E6A+qM0bJ/+TLDodHhQJpmpksw4uq3tLu9WbLUhfbqw1OIzohMXeQ0GzFI8Qu7uB2d0M+fJMqODeXco/vmeUWhn2/4Hzu81rrfNbh3AHgm2qYTvMp49fjo+0x6kokCYN/yKhka1fDc7wTetKeT2mKF0e/fhu871YY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424336; c=relaxed/simple;
	bh=fqPiyYumyHqYRKwdgqS0YIyaEpbV9RUqARtNcfnEDDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUz7NiZxYfoO/6a/bZBpGU0/9jxovc+ZNVGblG4OSNAQcD+0RroOsuMhsj+A9WwV3uFTShtJsa+lVcLIUpE3+MnGnwPVKl2sbC345YEKwjE4WJ07qV5U2q0GCdaP2Ag6L6LeLahoMsr6FKHSDuV/yk2UOnzlDYBFYhwu/NisG04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5Zy0oqn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5Zy0oqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EB31F00A3E;
	Thu, 30 Jul 2026 15:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424333;
	bh=0bDF2e2cdqwm/+K59JZxF4AcOaqbmwRWoax+PpFTTLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5Zy0oqnQZXxFXR0r/EahyPemBQrpewbmeNwJfAg9E4fRmOmtxygYE3rqOTYyE7Yz
	 vu8tBQBqiNFH5O4rl7P/voOnzrRRB+vT26z7DhJgDh5NP2FqCcmwYacP3AZXj5oA0r
	 4npnSP/Vz6zAN457uQzB4mwOOwdksrjqOOFZXHv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Philip Yang <philip.yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 355/675] drm/amdkfd: fix 32-bit overflow in CWSR total size calculation
Date: Thu, 30 Jul 2026 16:11:25 +0200
Message-ID: <20260730141452.678808797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Yongqiang Sun <Yongqiang.Sun@amd.com>

commit 2b0386d4293920e690c0e017708f999b93cc729b upstream.

total_cwsr_size was computed in 32-bit before being used as a BO/SVM
allocation size.
With large ctx_save_restore_area_size and debug_memory_size
multiplied by the XCC count, the product can wrap,
yielding an undersized CWSR save area that firmware later overruns.

Promote total_cwsr_size to u64 and use check_add_overflow()/
check_mul_overflow() in both kfd_queue_acquire_buffers() and
kfd_queue_release_buffers().

Signed-off-by: Yongqiang Sun <Yongqiang.Sun@amd.com>
Reviewed-by: Philip Yang <philip.yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 319f7e13423ae3f486b9aea82f9ad2d6af0ee608)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/overflow.h>
 #include "kfd_priv.h"
 #include "kfd_topology.h"
 #include "kfd_svm.h"
@@ -235,7 +236,7 @@ int kfd_queue_acquire_buffers(struct kfd
 	struct kfd_topology_device *topo_dev;
 	u64 expected_queue_size;
 	struct amdgpu_vm *vm;
-	u32 total_cwsr_size;
+	u64 total_cwsr_size;
 	int err;
 
 	topo_dev = kfd_topology_device_by_id(pdd->dev->id);
@@ -305,8 +306,14 @@ int kfd_queue_acquire_buffers(struct kfd
 		goto out_err_unreserve;
 	}
 
-	total_cwsr_size = (properties->ctx_save_restore_area_size +
-			   topo_dev->node_props.debug_memory_size) * NUM_XCC(pdd->dev->xcc_mask);
+	total_cwsr_size = (u64)properties->ctx_save_restore_area_size +
+			  topo_dev->node_props.debug_memory_size;
+	if (check_mul_overflow(total_cwsr_size,
+			       NUM_XCC(pdd->dev->xcc_mask),
+			       &total_cwsr_size)) {
+		err = -EINVAL;
+		goto out_err_unreserve;
+	}
 	total_cwsr_size = ALIGN(total_cwsr_size, PAGE_SIZE);
 
 	err = kfd_queue_buffer_get(vm, (void *)properties->ctx_save_restore_area_address,
@@ -341,7 +348,7 @@ out_err_release:
 int kfd_queue_release_buffers(struct kfd_process_device *pdd, struct queue_properties *properties)
 {
 	struct kfd_topology_device *topo_dev;
-	u32 total_cwsr_size;
+	u64 total_cwsr_size;
 
 	kfd_queue_buffer_put(&properties->wptr_bo);
 	kfd_queue_buffer_put(&properties->rptr_bo);
@@ -352,8 +359,12 @@ int kfd_queue_release_buffers(struct kfd
 	topo_dev = kfd_topology_device_by_id(pdd->dev->id);
 	if (!topo_dev)
 		return -EINVAL;
-	total_cwsr_size = (properties->ctx_save_restore_area_size +
-			   topo_dev->node_props.debug_memory_size) * NUM_XCC(pdd->dev->xcc_mask);
+	total_cwsr_size = (u64)properties->ctx_save_restore_area_size +
+			  topo_dev->node_props.debug_memory_size;
+	if (check_mul_overflow(total_cwsr_size,
+			       NUM_XCC(pdd->dev->xcc_mask),
+			       &total_cwsr_size))
+		return -EINVAL;
 	total_cwsr_size = ALIGN(total_cwsr_size, PAGE_SIZE);
 
 	kfd_queue_buffer_svm_put(pdd, properties->ctx_save_restore_area_address, total_cwsr_size);


