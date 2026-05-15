Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B962949E0;
	Fri, 15 May 2026 16:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862741; cv=none; b=lcQNwEe2jf3UA0YeFH9cfWXlND+LScz07A4zdSKf+y1rnyGpkVRRGbSLSqQ+uJGJRi59YYES0NzJgoEXX2MiXnqWda/CBVlW6EOXfBg/vBcf6SkUOhnMeG4uuoBFMDWZ4nJBaC9pr+SUCAS9FxyotkoiWlDBkN3Uq5xoJGMWQss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862741; c=relaxed/simple;
	bh=VNubr+fRAB1Syn/V0cxhBlwMClNUWK7zCUOkFCGRR4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEm8yNavauvBq4lERTO/KAXsOExhE8oaRosykcFOFk9Yu3wh4zj8Bh3LjrTkhxuG/hya6RdewYkSI1D1Z2ghI3tOKMCYQDw7u3st6Qj13mLL+pU4BSbUDSkxoan4wRs/A3zQGC+vH4rml039EmkoqL6HPO4o4DNPcIV+LiqDC6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGmgNicN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGmgNicN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA61C2BCB0;
	Fri, 15 May 2026 16:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862741;
	bh=VNubr+fRAB1Syn/V0cxhBlwMClNUWK7zCUOkFCGRR4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGmgNicNDIA5qIsLmNblQdi7UiQZAqQm//P6ktaiFWe0Lk4Ek2yaUKf/jQfqYcCWI
	 iKlBtBMT+hXTBkxzNelVXpn/OIJambhgX4X3efexMCJPEwWFfkuo/96PYDOU7X2SSp
	 5ItZX+O2gSCBjUQvfWj9IX5U61WkWqROMbMka5qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Philip Yang <philip.yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 164/201] drm/amdkfd: Make all TLB-flushes heavy-weight
Date: Fri, 15 May 2026 17:49:42 +0200
Message-ID: <20260515154702.127482650@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Kuehling <felix.kuehling@amd.com>

commit 9b4e3495d1bd2469bf94b74930c153c2d534ddb7 upstream.

With only one sequence number we cannot track the need for legacy vs
heavy-weight flushes reliably. Always use heavy-weight.

Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Philip Yang <philip.yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c1a3ff1d327820cd9a52bc1056b98681fc088949)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c              |    4 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |    6 +++---
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h                 |    6 +++---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c                  |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1360,7 +1360,7 @@ static int kfd_ioctl_map_memory_to_gpu(s
 		peer_pdd = kfd_process_device_data_by_id(p, devices_arr[i]);
 		if (WARN_ON_ONCE(!peer_pdd))
 			continue;
-		kfd_flush_tlb(peer_pdd, TLB_FLUSH_LEGACY);
+		kfd_flush_tlb(peer_pdd);
 	}
 	kfree(devices_arr);
 
@@ -1455,7 +1455,7 @@ static int kfd_ioctl_unmap_memory_from_g
 		if (WARN_ON_ONCE(!peer_pdd))
 			continue;
 		if (flush_tlb)
-			kfd_flush_tlb(peer_pdd, TLB_FLUSH_HEAVYWEIGHT);
+			kfd_flush_tlb(peer_pdd);
 
 		/* Remove dma mapping after tlb flush to avoid IO_PAGE_FAULT */
 		err = amdgpu_amdkfd_gpuvm_dmaunmap_mem(mem, peer_pdd->drm_priv);
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -572,7 +572,7 @@ static int allocate_vmid(struct device_q
 			qpd->vmid,
 			qpd->page_table_base);
 	/* invalidate the VM context after pasid and vmid mapping is set up */
-	kfd_flush_tlb(qpd_to_pdd(qpd), TLB_FLUSH_LEGACY);
+	kfd_flush_tlb(qpd_to_pdd(qpd));
 
 	if (dqm->dev->kfd2kgd->set_scratch_backing_va)
 		dqm->dev->kfd2kgd->set_scratch_backing_va(dqm->dev->adev,
@@ -610,7 +610,7 @@ static void deallocate_vmid(struct devic
 		if (flush_texture_cache_nocpsch(q->device, qpd))
 			dev_err(dev, "Failed to flush TC\n");
 
-	kfd_flush_tlb(qpd_to_pdd(qpd), TLB_FLUSH_LEGACY);
+	kfd_flush_tlb(qpd_to_pdd(qpd));
 
 	/* Release the vmid mapping */
 	set_pasid_vmid_mapping(dqm, 0, qpd->vmid);
@@ -1284,7 +1284,7 @@ static int restore_process_queues_nocpsc
 				dqm->dev->adev,
 				qpd->vmid,
 				qpd->page_table_base);
-		kfd_flush_tlb(pdd, TLB_FLUSH_LEGACY);
+		kfd_flush_tlb(pdd);
 	}
 
 	/* Take a safe reference to the mm_struct, which may otherwise
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -1554,13 +1554,13 @@ void kfd_signal_reset_event(struct kfd_n
 void kfd_signal_poison_consumed_event(struct kfd_node *dev, u32 pasid);
 void kfd_signal_process_terminate_event(struct kfd_process *p);
 
-static inline void kfd_flush_tlb(struct kfd_process_device *pdd,
-				 enum TLB_FLUSH_TYPE type)
+static inline void kfd_flush_tlb(struct kfd_process_device *pdd)
 {
 	struct amdgpu_device *adev = pdd->dev->adev;
 	struct amdgpu_vm *vm = drm_priv_to_vm(pdd->drm_priv);
 
-	amdgpu_vm_flush_compute_tlb(adev, vm, type, pdd->dev->xcc_mask);
+	amdgpu_vm_flush_compute_tlb(adev, vm, TLB_FLUSH_HEAVYWEIGHT,
+				    pdd->dev->xcc_mask);
 }
 
 static inline bool kfd_flush_tlb_after_unmap(struct kfd_dev *dev)
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1415,7 +1415,7 @@ svm_range_unmap_from_gpus(struct svm_ran
 			if (r)
 				break;
 		}
-		kfd_flush_tlb(pdd, TLB_FLUSH_HEAVYWEIGHT);
+		kfd_flush_tlb(pdd);
 	}
 
 	return r;
@@ -1557,7 +1557,7 @@ svm_range_map_to_gpus(struct svm_range *
 			}
 		}
 
-		kfd_flush_tlb(pdd, TLB_FLUSH_LEGACY);
+		kfd_flush_tlb(pdd);
 	}
 
 	return r;


