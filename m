Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794EF384223;
	Thu, 30 Jul 2026 15:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426033; cv=none; b=L5YZjQsi/qqPRpGJX7JkLCSHKcaZByEZ29DphorPRP/UUjv5x87AsqB2kPf2kOQhsl0eJBLCD0mdpVeuQsi/Doek2cRad1b+i6mM8e36EICC/DoEZnJsGqr4CCjLUK85dYi6tsR9byi79Gtw2kauQRLlL0Vx4oP23khFKH05Eoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426033; c=relaxed/simple;
	bh=IkMWfjMsaXOVIbPGzD7heiFfFfOpAAUTCfOrnvEvriQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgBkE3AHSe9Bdc/l6oKIrevt8RRjsW1dLOlKPdZSU4nSWQRooimcHO99oHfmegmrHkU7b/T0JOkXbvT8rtLfZ+iikaNnly6IZl0gApZl8DQrKS/ZXGvKot/oikotfJtnkWsvIZgSbBz3hBSynm4JQtkcBRIojUsEfN/HR6pNrN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3xWJinu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3xWJinu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49431F000E9;
	Thu, 30 Jul 2026 15:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426032;
	bh=DCWHZ7KrRh3t8wYwJYubFh/1r6AxDFzwZ4/w0jJbRSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3xWJinuWIRzukkMXUbv6a5piyM1M8XxcpFSLbMbFhNEBf7s0ggTmEHzruJ5Aa+32
	 U76vaT2E4LFCwWfA/IQN4A8ZkPCeVy0shFWGIKPSo5GLxIDHVVNqEBgLoSt0lZzlLM
	 k9VhpNV6v9k9AWcI2WwKaH2bkbgjULYKD2MtKLbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Philip Yang <philip.yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 275/602] drm/amdkfd: fix 32-bit overflow in CWSR total size calculation
Date: Thu, 30 Jul 2026 16:11:07 +0200
Message-ID: <20260730141441.749759332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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


