Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8530F497B76;
	Wed, 23 Sep 2026 14:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174113; cv=none; b=Poe4obAPE5pDaMmBfx1RP7wjjvFVfIhYHZ3Ikc2kPSIGUuOCsAY8hAywS7XvXoLLhnWupeFyEqf99+ZgsXq2fcxgDPp6UIfT8x8SMCI6cWGtHBX9zD2LJiK9QeO8bNO6/4g5UFWbJCYh4Xzbidzrtiw88YM28yVBXtxiJqYbWlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174113; c=relaxed/simple;
	bh=gcyDB2NPnsygy4qBj5yGMBlIwwNoyFbPxyVtgBkXy38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0nOqjZUPDA0SGgRZGMvdje5DJiqUFLts8B0VKBz+j531PW1zYGVigCPa1AtyAM6zCkkV57K13iakwlMGzifbaPyWYmOPv2jD4miHZ0BlyVqDilYlqd34mgcb5vet9wkMOFNFK3PiCmTiqi1EVi36LY+9cyZ0QkSdaCwDArBBxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXQyACLB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXQyACLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D731F1F00893;
	Wed, 23 Sep 2026 14:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174112;
	bh=xalm2IPBBA2YR/g/Pp/P6QEz+nmZ/6dT0gYKW5PPckE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXQyACLBEgNSaYF1Jbui+GbpHZB4q1uFt6Fgg3u4IBnfsSa2yvUE+kTKmzS2iCga+
	 ioAweJIJ1j3m/J93nook1+oX+nQgiik7XkXzCAwRdf/W+tpRF+t0w1KLXFrJ0crOTA
	 ISyoYDrOBUQv0+o82pEKSHxp3ANbF8PZKZxXXqPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengjun Yao <Chengjun.Yao@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 407/438] drm/amdgpu: fix rmmio iounmap skipped on device removal
Date: Wed, 23 Sep 2026 16:07:08 +0200
Message-ID: <20260923140655.450976761@linuxfoundation.org>
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
@@ -4344,7 +4344,7 @@ void amdgpu_device_fini_hw(struct amdgpu
 
 void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 {
-	int i, idx;
+	int i;
 	bool px;
 
 	amdgpu_device_ip_fini(adev);
@@ -4386,11 +4386,9 @@ void amdgpu_device_fini_sw(struct amdgpu
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


