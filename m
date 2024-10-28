Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C543F8837;
	Mon, 28 Oct 2024 06:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098139; cv=none; b=geQPY1vVx90bPWyVhqSajPoklnvNNscd2YHxNKcxH2LblmOLdOYSQICLmwkU25oDncUwdL9Q1o3DO+Toh+/2x9z+oZaRTofb5MH5KYB3ECzJNvMkJbeHajipA/nZv1GbMnwDJoY7JuZJEjUBfpIQhxxt4LyjbNPufrPBWUdcDGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098139; c=relaxed/simple;
	bh=rJXkFqbKgN+G4kAUlfya621K0S6YXVJ9P8ljt0s1+xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rUBwNNmCrvWkuLDkWxoIPkHvrbE2NGQj7AjF4XG6DdjYLAy2JbVnGOe5CcUdQ86aeLi+AZSYi2743O2kWgS8ff8FyWauuE/8ZGdr3EqberBFpVzSYllWRYyre6H0uo3sf6+2JMHaYex+U2q+3xAHU86SFjwrMUB37j2FZ/ZJCrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CzYb+oAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CzYb+oAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6398AC4CEC3;
	Mon, 28 Oct 2024 06:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098139;
	bh=rJXkFqbKgN+G4kAUlfya621K0S6YXVJ9P8ljt0s1+xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CzYb+oAcQxAaqwOvHAut5Pr3R1hfmrOFyWYv1jY7Jy2CXvZB8mI5oCPfToLT3Rr7F
	 Cr0p91XLo/m83cUl/TScun3oyEwK+qtBB7IyTh/+9IwjG0rxRMExRHDo3zYmcn2THe
	 T38c4D8Pd8lnkWdQJxJ1wUEZQHpuadhK1PMPFARs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Kenneth Graunke <kenneth.w.graunke@intel.com>,
	Paulo Zanoni <paulo.r.zanoni@intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Matthew Brost <matthew.brost@intel.com>,
	Kenneth Graunke <kenneth@whitecape.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 093/261] drm/xe: Use bookkeep slots for external BOs in exec IOCTL
Date: Mon, 28 Oct 2024 07:23:55 +0100
Message-ID: <20241028062314.360805564@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit e7518276e9388d36f103e8c1c7e99898a30d11f5 ]

Fix external BO's dma-resv usage in exec IOCTL using bookkeep slots
rather than write slots. This leaves syncing to user space rather than
the KMD blindly enforcing write semantics on every external BO.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Kenneth Graunke <kenneth.w.graunke@intel.com>
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>
Reported-by: Simona Vetter <simona.vetter@ffwll.ch>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2673
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Kenneth Graunke <kenneth@whitecape.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240911152622.903058-1-matthew.brost@intel.com
(cherry picked from commit b8b1163248759ba18509f7443a2d19b15b4c1df8)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_exec.c b/drivers/gpu/drm/xe/xe_exec.c
index f36980aa26e69..6e5ba381eaded 100644
--- a/drivers/gpu/drm/xe/xe_exec.c
+++ b/drivers/gpu/drm/xe/xe_exec.c
@@ -40,11 +40,6 @@
  * user knows an exec writes to a BO and reads from the BO in the next exec, it
  * is the user's responsibility to pass in / out fence between the two execs).
  *
- * Implicit dependencies for external BOs are handled by using the dma-buf
- * implicit dependency uAPI (TODO: add link). To make this works each exec must
- * install the job's fence into the DMA_RESV_USAGE_WRITE slot of every external
- * BO mapped in the VM.
- *
  * We do not allow a user to trigger a bind at exec time rather we have a VM
  * bind IOCTL which uses the same in / out fence interface as exec. In that
  * sense, a VM bind is basically the same operation as an exec from the user
@@ -58,8 +53,8 @@
  * behind any pending kernel operations on any external BOs in VM or any BOs
  * private to the VM. This is accomplished by the rebinds waiting on BOs
  * DMA_RESV_USAGE_KERNEL slot (kernel ops) and kernel ops waiting on all BOs
- * slots (inflight execs are in the DMA_RESV_USAGE_BOOKING for private BOs and
- * in DMA_RESV_USAGE_WRITE for external BOs).
+ * slots (inflight execs are in the DMA_RESV_USAGE_BOOKKEEP for private BOs and
+ * for external BOs).
  *
  * Rebinds / dma-resv usage applies to non-compute mode VMs only as for compute
  * mode VMs we use preempt fences and a rebind worker (TODO: add link).
@@ -292,7 +287,8 @@ int xe_exec_ioctl(struct drm_device *dev, void *data, struct drm_file *file)
 	xe_sched_job_arm(job);
 	if (!xe_vm_in_lr_mode(vm))
 		drm_gpuvm_resv_add_fence(&vm->gpuvm, exec, &job->drm.s_fence->finished,
-					 DMA_RESV_USAGE_BOOKKEEP, DMA_RESV_USAGE_WRITE);
+					 DMA_RESV_USAGE_BOOKKEEP,
+					 DMA_RESV_USAGE_BOOKKEEP);
 
 	for (i = 0; i < num_syncs; i++) {
 		xe_sync_entry_signal(&syncs[i], &job->drm.s_fence->finished);
-- 
2.43.0



