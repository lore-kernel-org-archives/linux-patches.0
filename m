Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94437533582;
	Wed, 23 Sep 2026 14:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174106; cv=none; b=nScnSeRPpQqZYgGEvAAOfRcU27ZOPVhOmBFNIO3brTodMzhWpmPF2B87cAahczuxoARsLAuD6P9v2IbqpgRIaNzsJ9kveVQ1mp1EORfB9dI6L5tjpWgLs3nd7DUuDLX5i5MTYc/QHSm8DAY9smCWqkJ0EbEhRyWGl24VXlMGyZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174106; c=relaxed/simple;
	bh=cAqIXGLTV4vvqxF/b11IqKufL37XgPgma1dGmCuLx44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HotO/LGaLZ5ASFhLC+OMbFNdFVEs9mfVjmE6ZYa2beZ46lh+XkkhAjkOnQpo7PhLdPJL9E0ZCORpEaHrO5ja4U0YF5DN/M1FMoXMx7aoC4o3Z5ouuylTuo1ougoL7D218OBgX/blBAGW9y9uafoIR5J4BYlVZuN6iItKSSK5Wn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WU1i6FyY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WU1i6FyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E671D1F000FF;
	Wed, 23 Sep 2026 14:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174105;
	bh=QAJtweps7lV+Vs1hSBrHyptGAjdv8VkpgoNZgI3bf9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WU1i6FyYobJDcDUjyAKjjmRSNQcGctBwMI0BL8XQkD1DIOeQOXVg7WiVAXy766dQH
	 Jd4IRQJeQyPHeL1M0kcqVOiPkVRufsBn5uFB+68utuR7QLOD7ouBjOb31+wGYopN+A
	 H+y+vp4i3n6+yeoRd5cApkkxJpuwdXwOgozTc/SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jonghyuk Kim(MalHyuk)" <malhyuk97@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 7.2 405/438] drm/msm: RCU-free the scheduler-containing ring and VM objects
Date: Wed, 23 Sep 2026 16:07:06 +0200
Message-ID: <20260923140655.392480255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -55,6 +55,7 @@ struct msm_ringbuffer {
 	/*
 	 * The job scheduler for this ring.
 	 */
+	struct rcu_head rcu;
 	struct drm_gpu_scheduler sched;
 	bool sched_initialized;
 


