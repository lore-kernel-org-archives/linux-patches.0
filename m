Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52885338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301740; cv=none; b=n62KG3S+jn757XX0tzKTPi6jZ++Ym/Qh8gfsRkiFNIBJZd+kkOkzJOH1faAkDc1VVnDHQOPBEEVpTs9FA22RT4k2PqimV4P2to9Pe5vOC30GTdkM8c9FeN4agvfvI/iTgn4QQSHznmEsUhmQLZp5wZultGBAiOvZblOsKJifkxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301740; c=relaxed/simple;
	bh=XbVGjK1Ds62Za61jnyxfXONGWRlbeafv93qP/SvVe+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHVlbDv751+00qYfcw+sdhfAF2tKkJrogEjGeBMMU3AEeCDrURsojE3IZtrXpn39c6dLrtcDU/bOHC7h25ue9ZeWQ/6Yc/Lr74DDp20j0qctZ5dROZD4Jc817ilSddZut82ggmnOz/z/CxPVwHkqKNoIwxbhlqU0rYA+IxvO43Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q/HCSwao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q/HCSwao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA1CC19424;
	Sat, 28 Feb 2026 18:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301740;
	bh=XbVGjK1Ds62Za61jnyxfXONGWRlbeafv93qP/SvVe+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/HCSwaoq+CVE4GTxgwFROZy9Nr4uFP3FtweI9XtwY2UPfSqpf7Pvv3nywmTyameq
	 diSuB0a+jiGbPBMsXsCn9vn6XMEnIpFmaHQGUaAujdRYovc64tvGR1haHp8iOZW+P2
	 a11ijJSl4bYQzByOuRbYrzMFjKyw6Y9IZhovSH0sN/M1c8FJ9FgxMX74ujB+5e9FMV
	 xC5QJ1GySmSi6Vww+4O2WgApTkbcVzFG3DnuRRQrURqlSrPkjYQYGCx9vpXtUpYsEg
	 3lf5Hl3VkV3vKJZWE4myQZ5aJA9DZK2DHnpelkQx4pUqFY2TZodd3y9BjJGqMxD2PC
	 Z8XhzUVGNQ3gQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ketil Johnsen <ketil.johnsen@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/385] drm/panthor: Evict groups before VM termination
Date: Sat, 28 Feb 2026 12:56:03 -0500
Message-ID: <20260228180011.1568201-141-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index ed769749ec354..e221708cf1aa3 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1554,6 +1554,10 @@ static void panthor_vm_destroy(struct panthor_vm *vm)
 
 	vm->destroyed = true;
 
+	/* Tell scheduler to stop all GPU work related to this VM */
+	if (refcount_read(&vm->as.active_cnt) > 0)
+		panthor_sched_prepare_for_vm_destruction(vm->ptdev);
+
 	mutex_lock(&vm->heaps.lock);
 	panthor_heap_pool_destroy(vm->heaps.pool);
 	vm->heaps.pool = NULL;
diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 9124df017a1a4..2d4dacece655f 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2658,6 +2658,20 @@ void panthor_sched_report_mmu_fault(struct panthor_device *ptdev)
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
index 3a30d2328b308..666d1655ee18e 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.h
+++ b/drivers/gpu/drm/panthor/panthor_sched.h
@@ -45,6 +45,7 @@ void panthor_sched_suspend(struct panthor_device *ptdev);
 void panthor_sched_resume(struct panthor_device *ptdev);
 
 void panthor_sched_report_mmu_fault(struct panthor_device *ptdev);
+void panthor_sched_prepare_for_vm_destruction(struct panthor_device *ptdev);
 void panthor_sched_report_fw_events(struct panthor_device *ptdev, u32 events);
 
 #endif
-- 
2.51.0

