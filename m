Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493BD53B332;
	Wed, 23 Sep 2026 14:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175175; cv=none; b=cnbZSbWVt2L4t10HHbpMXkHac+iFLoaTZJZ9bLHAjmUsXN0iF7zGVkOKZ/ExeXIgsZLDV0sQtFARkD1yqcV0OUUZNCULDwJ7qj8/WY6A74ZlYWJzzyluoAt29PPyrB2cEbHY8Vz3gPnm5p5u3HKGwsGn3jWiZFmVYWrHIt/M8iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175175; c=relaxed/simple;
	bh=xil9GfY0wQGpe++ofXNSpWt+ECYM6eW4+gHpQ6xOU7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGBDpOL2HSJkzs71fwRYWxj/YxZ1U12jQab0ldZ9/8vAs4s+2H5xbEn6Vz7kw8NQTntwBPehBnbuS44a5drlRizOIzXOv7LHQn9/IWmI8t1bxZTcqsqbr4if0MLt/B2/iWh7uxMHJA5hMPDEQo37qR1lT7ERdVzyVFzk9Qveu44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhOwWxve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhOwWxve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EA41F00893;
	Wed, 23 Sep 2026 14:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175172;
	bh=bKAiN7oyfzlI46DvbgNkqyhRw9Z79mXO3N97ohmQKq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhOwWxves6xQaycMmaSEc8jswE7pJL4jCMZWA84NjkbvACfDybnv3vTuoC/fLCtsY
	 yxFJH25gRTGc/jjs7tpA7/dzKXXxnjl6Bv7VKSUANXJVq2TR17vixiOhnN31qhDxQA
	 VPCeFSMTuXYPca97ac5dzTcSpqEcn6o8aUlUf5s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jonghyuk Kim(MalHyuk)" <malhyuk97@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 6.18 343/398] drm/msm: RCU-free the scheduler-containing ring and VM objects
Date: Wed, 23 Sep 2026 16:06:57 +0200
Message-ID: <20260923140652.320954680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Jonghyuk Kim(MalHyuk) <malhyuk97@gmail.com>

commit 01c8d1f385f788f1bbbbb7687c4386d614281218 upstream.

Both struct msm_ringbuffer and struct msm_gem_vm embed a struct
drm_gpu_scheduler.  msm_ringbuffer_destroy() and the VM free callback
msm_gem_vm_free() call drm_sched_fini() on the embedded scheduler and then
free the containing object with plain kfree().

drm_sched_fence_get_timeline_name() returns fence->sched->name, and the
scheduler fence keeps a .release callback so it is not ops-detached on
signalling.  A finished fence exported to userspace (the submit out-fence, or
a VM_BIND fence, via sync_file / drm_syncobj) keeps pointing at the embedded
scheduler after the ring/VM is freed, so a later get_timeline_name() --
reachable unprivileged through SYNC_IOC_FILE_INFO -- dereferences freed slab
memory (KASAN slab-use-after-free read).

Per the dma-fence lifetime contract the exporter must keep the data backing a
signalled fence alive for an RCU grace period.  Free the scheduler-containing
objects with kfree_rcu() instead of kfree().

Fixes: 1d8a5ca436ee ("drm/msm: Conversion to drm scheduler")
Fixes: 92395af63a99 ("drm/msm: Add VM_BIND submitqueue")
Cc: stable@vger.kernel.org
Signed-off-by: Jonghyuk Kim(MalHyuk) <malhyuk97@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/750234/
Message-ID: <20260902012720.880783-1-malhyuk97@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_gem.h        |    3 +++
 drivers/gpu/drm/msm/msm_gem_vma.c    |    2 +-
 drivers/gpu/drm/msm/msm_ringbuffer.c |    2 +-
 drivers/gpu/drm/msm/msm_ringbuffer.h |    1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/msm/msm_gem.h
+++ b/drivers/gpu/drm/msm/msm_gem.h
@@ -68,6 +68,9 @@ struct msm_gem_vm {
 	/** @base: Inherit from drm_gpuvm. */
 	struct drm_gpuvm base;
 
+	/** @rcu: RCU-delayed free so an exported sched fence->sched stays valid. */
+	struct rcu_head rcu;
+
 	/**
 	 * @sched: Scheduler used for asynchronous VM_BIND request.
 	 *
--- a/drivers/gpu/drm/msm/msm_gem_vma.c
+++ b/drivers/gpu/drm/msm/msm_gem_vma.c
@@ -166,7 +166,7 @@ msm_gem_vm_free(struct drm_gpuvm *gpuvm)
 	dma_fence_put(vm->last_fence);
 	put_pid(vm->pid);
 	kfree(vm->log);
-	kfree(vm);
+	kfree_rcu(vm, rcu);
 }
 
 /**
--- a/drivers/gpu/drm/msm/msm_ringbuffer.c
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.c
@@ -140,5 +140,5 @@ void msm_ringbuffer_destroy(struct msm_r
 
 	msm_gem_kernel_put(ring->bo, ring->gpu->vm);
 
-	kfree(ring);
+	kfree_rcu(ring, rcu);
 }
--- a/drivers/gpu/drm/msm/msm_ringbuffer.h
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.h
@@ -53,6 +53,7 @@ struct msm_ringbuffer {
 	/*
 	 * The job scheduler for this ring.
 	 */
+	struct rcu_head rcu;
 	struct drm_gpu_scheduler sched;
 	bool sched_initialized;
 


