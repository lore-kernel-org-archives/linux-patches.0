Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3375A2BAF7;
	Wed, 25 Feb 2026 01:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983064; cv=none; b=pfw/yO9c1Vn3j8BeGM8M5EcPBdBRnXUP56mE0JmeimABUiFNGtjFITvwWxCcwMQ7ewSTXM2vFhf7CaHsLrXT2pB+TUJoeMTlPUvyTGO1KnKh2wUD0XnhY2P/qNLQpacC8dbTnSX+xcfL/43iaF/F7W7T0PJiv3fu+91pWCSmB4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983064; c=relaxed/simple;
	bh=9JahBHeCu6z8Qo3gpxjPsIN1537gxO+mKnDHWgELtew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dj32zfoESxn0/eDPiW1yWLglhPxyCShwjKwlB7dkIlVzXn4mbfu0P9dMGAgSbm7j51AU5trS6JUwtLcXNu+pjQy6kOU+Rgmi0OMi48ZN8OKyxiKDrEECE8Fkx9LykA5Gvzjd7+ATKcuX1zURUyggfxqDvWUe9yXqMOx3qxGVggk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJr5i5jn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJr5i5jn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDEAC116D0;
	Wed, 25 Feb 2026 01:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983064;
	bh=9JahBHeCu6z8Qo3gpxjPsIN1537gxO+mKnDHWgELtew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJr5i5jnr7smhTEBXgEHDWXHSRPwxwH9vzfSfz1mrTsQ25jgyxpJIJHBtt9aTE00z
	 xvw1JrZDTTcpNR+v7n/XnG3bqab/SBBWZJNB9YG7tb1NIL5LDA7zCNMQ0m2JuKbGfB
	 0HtQIeg0wePFSkGGyTYOzuIW/+BJuSG/H+koWcx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Ketil Johnsen <ketil.johnsen@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 227/781] drm/panthor: Evict groups before VM termination
Date: Tue, 24 Feb 2026 17:15:36 -0800
Message-ID: <20260225012405.279281781@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ketil Johnsen <ketil.johnsen@arm.com>

[ Upstream commit 565ed40b5fc1242f7538a016fce5a85f802d4fb5 ]

Ensure all related groups are evicted and suspended before VM
destruction takes place.

This fixes an issue where panthor_vm_destroy() destroys and unmaps the
heap context while there are still on slot groups using this.
The FW will do a write out to the heap context when a CSG (group) is
suspended, so a premature unmap of the heap context will cause a
GPU page fault.
This page fault is quite harmless, and do not affect the continued
operation of the GPU.

Fixes: 647810ec2476 ("drm/panthor: Add the MMU/VM logical block")
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Ketil Johnsen <ketil.johnsen@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20251219093546.1227697-1-ketil.johnsen@arm.com
Co-developed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_mmu.c   |  4 ++++
 drivers/gpu/drm/panthor/panthor_sched.c | 14 ++++++++++++++
 drivers/gpu/drm/panthor/panthor_sched.h |  1 +
 3 files changed, 19 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index f6339963e4960..9194bad4b6196 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1503,6 +1503,10 @@ static void panthor_vm_destroy(struct panthor_vm *vm)
 
 	vm->destroyed = true;
 
+	/* Tell scheduler to stop all GPU work related to this VM */
+	if (refcount_read(&vm->as.active_cnt) > 0)
+		panthor_sched_prepare_for_vm_destruction(vm->ptdev);
+
 	mutex_lock(&vm->heaps.lock);
 	panthor_heap_pool_destroy(vm->heaps.pool);
 	vm->heaps.pool = NULL;
diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 6ac4cec52f9e4..bd397d773d72b 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2805,6 +2805,20 @@ void panthor_sched_report_mmu_fault(struct panthor_device *ptdev)
 		panthor_sched_immediate_tick(ptdev);
 }
 
+void panthor_sched_prepare_for_vm_destruction(struct panthor_device *ptdev)
+{
+	/* FW can write out internal state, like the heap context, during CSG
+	 * suspend. It is therefore important that the scheduler has fully
+	 * evicted any pending and related groups before VM destruction can
+	 * safely continue. Failure to do so can lead to GPU page faults.
+	 * A controlled termination of a Panthor instance involves destroying
+	 * the group(s) before the VM. This means any relevant group eviction
+	 * has already been initiated by this point, and we just need to
+	 * ensure that any pending tick_work() has been completed.
+	 */
+	flush_work(&ptdev->scheduler->tick_work.work);
+}
+
 void panthor_sched_resume(struct panthor_device *ptdev)
 {
 	/* Force a tick to re-evaluate after a resume. */
diff --git a/drivers/gpu/drm/panthor/panthor_sched.h b/drivers/gpu/drm/panthor/panthor_sched.h
index f4a475aa34c0a..9a8692de8aded 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.h
+++ b/drivers/gpu/drm/panthor/panthor_sched.h
@@ -50,6 +50,7 @@ void panthor_sched_suspend(struct panthor_device *ptdev);
 void panthor_sched_resume(struct panthor_device *ptdev);
 
 void panthor_sched_report_mmu_fault(struct panthor_device *ptdev);
+void panthor_sched_prepare_for_vm_destruction(struct panthor_device *ptdev);
 void panthor_sched_report_fw_events(struct panthor_device *ptdev, u32 events);
 
 void panthor_fdinfo_gather_group_samples(struct panthor_file *pfile);
-- 
2.51.0



