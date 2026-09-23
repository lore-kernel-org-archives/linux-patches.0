Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24EE52189B;
	Wed, 23 Sep 2026 14:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175179; cv=none; b=HTD7vxlx/ENJCtzLUVJgyZIfLI6/cOJ/rtorOtAZeFe4UxlMD3NGa6uXBFb8fKmA0zAho3hhjVjn42vr6o6zNEcbYa9UeIKHAoTsYbLUdZPDNXq81nLB9WflP2WzHvR1BO2GYiFU8kOTeJff/tDMdsU9jA7iYURnr0ezd8WvD0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175179; c=relaxed/simple;
	bh=9K94R0avNJRy9KCBFnfJl+jntWcnjKX7FUwlnpXxXjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqO5wuUSsKI0BOvU30pgTACyrTzZa3O06J9de6c+pnrBxzhKVm2Z75bYMKuCMYg+w08gQcxQ3e+jsn6b/9XDB7SCRmGNXxs7ImHoKZ57nd2ZnKUdwbEMe8LmKMQyFMNz5Xs8Jb6aQf428r4AhbvGwxaQkLPQ7Tq8aD1XX6ufNvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XdlfzurF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XdlfzurF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003E31F000FF;
	Wed, 23 Sep 2026 14:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175176;
	bh=eneISOZ6+67wUfnIKXXTGExplMHJiutPbxNBUIxI1MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XdlfzurFnA65yaeDyZL6DT8cMHb+vf7KzD4YfWsBGUC2owpe9WPx2UeqzwcoZ4PMo
	 YBMl/1Sv7z6K/mKslSVsNg+ctz65m0gQ56rdt5JY+ZVaWqvuTxOE1LEpKINASE4mVM
	 SQovdZo2lAstaV3ckNMbmaz3sX6/ifp4V2lDmiAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengjun Yao <Chengjun.Yao@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 344/398] drm/amdgpu: fix rmmio iounmap skipped on device removal
Date: Wed, 23 Sep 2026 16:06:58 +0200
Message-ID: <20260923140652.345453990@linuxfoundation.org>
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

From: Chengjun Yao <Chengjun.Yao@amd.com>

commit 5155002b03b24ba3ef91c5c313b8cf0171b24904 upstream.

amdgpu_pci_remove() calls drm_dev_unplug() before fini_sw(), so
drm_dev_enter() is already false there and the iounmap() guarded by it
is skipped. This .remove path runs on both hot-unplug and plain rmmod,
so the register BAR ioremap mapping leaks one instance per unload.

Unmap rmmio unconditionally (guard only on non-NULL) and drop the now
unused idx.

Fixes: 62d5f9f7110a ("drm/amdgpu: Unmap MMIO mappings when device is not unplugged")
Signed-off-by: Chengjun Yao <Chengjun.Yao@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dd6f86a97260e5207d3329ad03aa89fdad61b1e6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5098,7 +5098,7 @@ void amdgpu_device_fini_hw(struct amdgpu
 
 void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 {
-	int i, idx;
+	int i;
 	bool px;
 
 	amdgpu_device_ip_fini(adev);
@@ -5140,11 +5140,9 @@ void amdgpu_device_fini_sw(struct amdgpu
 	if ((adev->pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
 		vga_client_unregister(adev->pdev);
 
-	if (drm_dev_enter(adev_to_drm(adev), &idx)) {
-
+	if (adev->rmmio) {
 		iounmap(adev->rmmio);
 		adev->rmmio = NULL;
-		drm_dev_exit(idx);
 	}
 
 	if (IS_ENABLED(CONFIG_PERF_EVENTS))


