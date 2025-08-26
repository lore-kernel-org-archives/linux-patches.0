Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5794D319858;
	Tue, 26 Aug 2025 11:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208171; cv=none; b=nZ9VChVmE7yvp9eB9KXeDTzmWVddYrOJAfQNLJr9EXHyVcckvf1PB6hwvd1VDrMvpePYKhU/ZYBRNUZS3qdnur+0LaxXfmxBQFZqFtwIqJEWndNgo7ZFY9ZbHBxsSs3K59VGZ3SiVbdESbOUZ9ipf1OZ1srgs5NExcFSUae4PjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208171; c=relaxed/simple;
	bh=f17BPTL3u/zuW9pO3EU0cWGpb67SRntIuAHbaOGjzMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IhWllpORBfSoJq2621M77vhRnIUFNalFlwFcjt69B0AF9v4UMqqdYEn8dwmCDYlvkrWiScYjPqs2776xuY8mFw5e0uTQdPkEZlZD8b/ecnoBP7Au6Y8VyiQsHyNCxAdfdORSpnU5DwNNbtFFRNxZPhTnroK8PREXZjp75eiOeC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHNhuTVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHNhuTVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90724C4CEF1;
	Tue, 26 Aug 2025 11:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208170;
	bh=f17BPTL3u/zuW9pO3EU0cWGpb67SRntIuAHbaOGjzMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHNhuTVuQ3ETb922qrNDC2sBjO9r5e01VNMAQ1qZJpj5VoSqD/5+B36QRPi/yKcPa
	 32l3a8qDJ9KCZgcvG+wt/PatRafTBxMgSUBDoE43H4arDwMUKGAQjClhgKm9wMli9o
	 7miuxtyyNVnaj5+rlD/BkiwPJ1PeRTmgRjeweY1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 456/457] drm/xe: Move ASID allocation and user PT BO tracking into xe_vm_create
Date: Tue, 26 Aug 2025 13:12:20 +0200
Message-ID: <20250826110948.554716426@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Piórkowski <piotr.piorkowski@intel.com>

[ Upstream commit 8a30114073639fd97f2c7390abbc34fb8711327a ]

Currently, ASID assignment for user VMs and page-table BO accounting for
client memory tracking are performed in xe_vm_create_ioctl.
To consolidate VM object initialization, move this logic to
xe_vm_create.

v2:
 - removed unnecessary duplicate BO tracking code
 - using the local variable xef to verify whether the VM is being created
   by userspace

Fixes: 658a1c8e0a66 ("drm/xe: Assign ioctl xe file handler to vm in xe_vm_create")
Suggested-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/20250811104358.2064150-3-piotr.piorkowski@intel.com
Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
(cherry picked from commit 30e0c3f43a414616e0b6ca76cf7f7b2cd387e1d4)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Rodrigo: Added fixes tag]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vm.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 7251f23b919c..3135de124c18 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1767,6 +1767,20 @@ struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags, struct xe_file *xef)
 	if (number_tiles > 1)
 		vm->composite_fence_ctx = dma_fence_context_alloc(1);
 
+	if (xef && xe->info.has_asid) {
+		u32 asid;
+
+		down_write(&xe->usm.lock);
+		err = xa_alloc_cyclic(&xe->usm.asid_to_vm, &asid, vm,
+				      XA_LIMIT(1, XE_MAX_ASID - 1),
+				      &xe->usm.next_asid, GFP_KERNEL);
+		up_write(&xe->usm.lock);
+		if (err < 0)
+			goto err_unlock_close;
+
+		vm->usm.asid = asid;
+	}
+
 	trace_xe_vm_create(vm);
 
 	return vm;
@@ -2034,9 +2048,8 @@ int xe_vm_create_ioctl(struct drm_device *dev, void *data,
 	struct xe_device *xe = to_xe_device(dev);
 	struct xe_file *xef = to_xe_file(file);
 	struct drm_xe_vm_create *args = data;
-	struct xe_tile *tile;
 	struct xe_vm *vm;
-	u32 id, asid;
+	u32 id;
 	int err;
 	u32 flags = 0;
 
@@ -2076,23 +2089,6 @@ int xe_vm_create_ioctl(struct drm_device *dev, void *data,
 	if (IS_ERR(vm))
 		return PTR_ERR(vm);
 
-	if (xe->info.has_asid) {
-		down_write(&xe->usm.lock);
-		err = xa_alloc_cyclic(&xe->usm.asid_to_vm, &asid, vm,
-				      XA_LIMIT(1, XE_MAX_ASID - 1),
-				      &xe->usm.next_asid, GFP_KERNEL);
-		up_write(&xe->usm.lock);
-		if (err < 0)
-			goto err_close_and_put;
-
-		vm->usm.asid = asid;
-	}
-
-	/* Record BO memory for VM pagetable created against client */
-	for_each_tile(tile, xe, id)
-		if (vm->pt_root[id])
-			xe_drm_client_add_bo(vm->xef->client, vm->pt_root[id]->bo);
-
 #if IS_ENABLED(CONFIG_DRM_XE_DEBUG_MEM)
 	/* Warning: Security issue - never enable by default */
 	args->reserved[0] = xe_bo_main_addr(vm->pt_root[0]->bo, XE_PAGE_SIZE);
-- 
2.50.1



