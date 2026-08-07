Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E328373BE6;
	Fri,  7 Aug 2026 15:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115806; cv=none; b=Hb3Ff71jqi1OefNVkQ3RyNZJBazpjrj6bmouGF/MfShBTygEHSLXkyc0xJvFdSSpW18rj2finfdw36dcKJ7V+BRedKOT0VojdZ0jkadODlXfO3uoAwfOzoSb1SRgKuj8pBL627P3C3Cd6Zf4Mm19SHDdcns6zEKug0qh2gpVgm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115806; c=relaxed/simple;
	bh=nuAqMHH6upGGnsQfUXY8D+JWUyh9gGRSZr/wgSVnYO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c2TJjDbWo+j1gtbbsCU+RXLahrnQn+W4+TPz4BvztNKsXLv8DDWBxCbqLSNAKM1ySVeLOyzcR/jPWPNxRCgHtgdtdkqnI6CnGvHHJ01fWQEE8GnEcNnqLRDEW0dRK+S4fdsI79uE5kgiC0EPmWSB0+EQ2O01wGFE6g0MvAe0Mp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHXh4Nuu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHXh4Nuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E911F00A3A;
	Fri,  7 Aug 2026 15:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115801;
	bh=2IkziQMRTJYWh9MlJbt71t7ZIk3DjLWz8VVhifCxJ7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LHXh4Nuuh7zQMVRDQxAEzDSwgoFu1roNFm5TnWRDJxpFUCvpQqPa3tHhG4QvUvt3x
	 LQuYeo6c3ky4NtctVr9snea8XXRMo6/vci/t37R2AKooclEl10QwmU18kRyMGgJA8V
	 ApLUW+VFJhTd7VktJLe5yQ/w1WjU4zgaxv/aTKyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.18 385/396] drm/xe: Wait on external BO kernel fences in exec IOCTL
Date: Fri,  7 Aug 2026 16:39:05 +0200
Message-ID: <20260807143432.582048959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit af80e2bfde9312c76b60cf9274248dce0410b30d ]

Before arming a user job, xe_exec_ioctl() only added the VM's
dma-resv KERNEL slot as a dependency. That slot covers rebinds and
the kernel operations of the VM's private BOs, but not external BOs
(bo->vm == NULL), which carry their kernel operations (evictions,
moves, ...) in their own dma-resv KERNEL slot.

The DMA_RESV_USAGE_KERNEL slot is the cross-driver contract for
memory management operations that must complete before the BO or its
backing store may be used: any accessor is required to wait on the
KERNEL fences before touching the resv. By skipping the external BOs'
KERNEL slots, the exec path violated that contract and could schedule
a user job while a kernel operation on an external BO mapped by the VM
was still in flight, racing against it and potentially reading or
writing memory that was being moved.

Replace the VM-only dependency with an iteration over every object
locked by the exec, adding each object's KERNEL slot as a job
dependency. This covers the VM resv (rebinds and private BOs) as well
as every external BO, mirroring the drm_gpuvm_resv_add_fence() call
that later publishes the job fence to the same set of objects.
Long-running mode continues to skip this, as before.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org
Assisted-by: GitHub_Copilot:claude-opus-4.8
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20260702215805.4011228-1-matthew.brost@intel.com
(cherry picked from commit a6b842acf3ddd1efc53a56de9260cfa718fb35e7)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Review <review@local>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_exec.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/xe/xe_exec.c
+++ b/drivers/gpu/drm/xe/xe_exec.c
@@ -286,13 +286,23 @@ retry:
 		goto err_exec;
 	}
 
-	/* Wait behind rebinds */
+	/*
+	 * Wait behind rebinds and any kernel operations (evictions, defrag
+	 * moves, ...) on the VM and all external BOs. The VM's private BOs
+	 * carry their kernel ops in the VM dma-resv KERNEL slot, while each
+	 * external BO carries them in its own dma-resv KERNEL slot; both are
+	 * covered by iterating every object locked by the exec, mirroring the
+	 * drm_gpuvm_resv_add_fence() below.
+	 */
 	if (!xe_vm_in_lr_mode(vm)) {
-		err = xe_sched_job_add_deps(job,
-					    xe_vm_resv(vm),
-					    DMA_RESV_USAGE_KERNEL);
-		if (err)
-			goto err_put_job;
+		struct drm_gem_object *obj;
+
+		drm_exec_for_each_locked_object(exec, obj) {
+			err = xe_sched_job_add_deps(job, obj->resv,
+						    DMA_RESV_USAGE_KERNEL);
+			if (err)
+				goto err_put_job;
+		}
 	}
 
 	for (i = 0; i < num_syncs && !err; i++)


