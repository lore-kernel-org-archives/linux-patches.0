Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462D918E35C;
	Tue, 10 Sep 2024 09:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961485; cv=none; b=oC2k6MdIaxGAXxBFdCX0IDwg2nRmvfwBFW8gEm5ponKNMvr/ZiIt36QJiEVSaGdTynCzmpb5Iyns1sC5bJIfhkGlM5/XXAhnLkNWbrogmQeles7e9Ww0J46LOArDiz8mwwfPrOFUOLBqMpwFrOGox0nuXXE3G4HABWzCmzRiks8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961485; c=relaxed/simple;
	bh=MzkvgYxjgNAO8paRWpan+tgxk7xRblcEA3+e67mWiyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=svwV/VVrtL8ObJI1g554WGSaoYzX9I3kaj5+MzSkjBhql7QgfaCcsY2EA4GSTVGw60vQB+Foge8Jd43is2tE39ffYD4QcpiwiH9lkLj2gvm0o3u7aSDnM7LV4QhASjdy6qXTIEyz/4NQJNZ4OxRsBnzEs257dpiUHJpYtvSo5DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NC8xYFqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NC8xYFqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AC0C4CEC3;
	Tue, 10 Sep 2024 09:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961484;
	bh=MzkvgYxjgNAO8paRWpan+tgxk7xRblcEA3+e67mWiyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NC8xYFqIgSkAe8ItR7q/nTAXQuYiIFMQ95Dvx3bvLBDHVlVHu4ilGJPDk8dWP20Af
	 4i0CvypsgKXJsUd2fzrBNb040yXdyXS2O9iUkRnKWLpVjV2SId3xFSRDpgEMT6kKh9
	 KUhm7hMeOCEiHr94J0cz6Urbxjqh9FV2c5ec07G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 6.10 086/375] drm/panthor: flush FW AS caches in slow reset path
Date: Tue, 10 Sep 2024 11:28:03 +0200
Message-ID: <20240910092625.121622222@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

commit 7de295d1a1a1b84e57b348e8bfd0fab5aab3ce69 upstream.

In the off-chance that waiting for the firmware to signal its booted status
timed out in the fast reset path, one must flush the cache lines for the
entire FW VM address space before reloading the regions, otherwise stale
values eventually lead to a scheduler job timeout.

Fixes: 647810ec2476 ("drm/panthor: Add the MMU/VM logical block")
Cc: stable@vger.kernel.org
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240902130237.3440720-1-adrian.larumbe@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c  |  8 +++++++-
 drivers/gpu/drm/panthor/panthor_mmu.c | 21 ++++++++++++++++++---
 drivers/gpu/drm/panthor/panthor_mmu.h |  1 +
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_fw.c b/drivers/gpu/drm/panthor/panthor_fw.c
index 857f3f11258a..ef232c0c2049 100644
--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -1089,6 +1089,12 @@ int panthor_fw_post_reset(struct panthor_device *ptdev)
 		panthor_fw_stop(ptdev);
 		ptdev->fw->fast_reset = false;
 		drm_err(&ptdev->base, "FW fast reset failed, trying a slow reset");
+
+		ret = panthor_vm_flush_all(ptdev->fw->vm);
+		if (ret) {
+			drm_err(&ptdev->base, "FW slow reset failed (couldn't flush FW's AS l2cache)");
+			return ret;
+		}
 	}
 
 	/* Reload all sections, including RO ones. We're not supposed
@@ -1099,7 +1105,7 @@ int panthor_fw_post_reset(struct panthor_device *ptdev)
 
 	ret = panthor_fw_start(ptdev);
 	if (ret) {
-		drm_err(&ptdev->base, "FW slow reset failed");
+		drm_err(&ptdev->base, "FW slow reset failed (couldn't start the FW )");
 		return ret;
 	}
 
diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index fa0a002b1016..cc6e13a97783 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -576,6 +576,12 @@ static int mmu_hw_do_operation_locked(struct panthor_device *ptdev, int as_nr,
 	if (as_nr < 0)
 		return 0;
 
+	/*
+	 * If the AS number is greater than zero, then we can be sure
+	 * the device is up and running, so we don't need to explicitly
+	 * power it up
+	 */
+
 	if (op != AS_COMMAND_UNLOCK)
 		lock_region(ptdev, as_nr, iova, size);
 
@@ -874,14 +880,23 @@ static int panthor_vm_flush_range(struct panthor_vm *vm, u64 iova, u64 size)
 	if (!drm_dev_enter(&ptdev->base, &cookie))
 		return 0;
 
-	/* Flush the PTs only if we're already awake */
-	if (pm_runtime_active(ptdev->base.dev))
-		ret = mmu_hw_do_operation(vm, iova, size, AS_COMMAND_FLUSH_PT);
+	ret = mmu_hw_do_operation(vm, iova, size, AS_COMMAND_FLUSH_PT);
 
 	drm_dev_exit(cookie);
 	return ret;
 }
 
+/**
+ * panthor_vm_flush_all() - Flush L2 caches for the entirety of a VM's AS
+ * @vm: VM whose cache to flush
+ *
+ * Return: 0 on success, a negative error code if flush failed.
+ */
+int panthor_vm_flush_all(struct panthor_vm *vm)
+{
+	return panthor_vm_flush_range(vm, vm->base.mm_start, vm->base.mm_range);
+}
+
 static int panthor_vm_unmap_pages(struct panthor_vm *vm, u64 iova, u64 size)
 {
 	struct panthor_device *ptdev = vm->ptdev;
diff --git a/drivers/gpu/drm/panthor/panthor_mmu.h b/drivers/gpu/drm/panthor/panthor_mmu.h
index f3c1ed19f973..6788771071e3 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.h
+++ b/drivers/gpu/drm/panthor/panthor_mmu.h
@@ -31,6 +31,7 @@ panthor_vm_get_bo_for_va(struct panthor_vm *vm, u64 va, u64 *bo_offset);
 int panthor_vm_active(struct panthor_vm *vm);
 void panthor_vm_idle(struct panthor_vm *vm);
 int panthor_vm_as(struct panthor_vm *vm);
+int panthor_vm_flush_all(struct panthor_vm *vm);
 
 struct panthor_heap_pool *
 panthor_vm_get_heap_pool(struct panthor_vm *vm, bool create);
-- 
2.46.0



