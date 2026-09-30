Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F015335BA;
	Wed, 30 Sep 2026 17:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790387; cv=none; b=GUVbCqs5/6PiKWWDcX5Az+n9w6X+tQp9D8sfBK4Dp2HYEqISfVABO/iXgF8YWeR1DbQy466RP0CAa+9nBHQPdby2O3VjLHu8FArOSJc185DNzB3T4hYR9yPr7y3kTckF8/SkZI0RZr79fh0e4gH4+pzrUT/7JqS6JFnirsLfZDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790387; c=relaxed/simple;
	bh=xiQ2xUxivnXrdcGhEcwHvxfhBnxrsQGfb64cUznNLJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKfmPNcsotBj+X7nBi1Ig1gnrMceh06/T2R9iOrVIjLQlNvL0KVyZUdVBwRHlvR7ojCXcyc1uDZkBNKrGXhqTPj0MUQKIYbPDAMy51N/90/jNvo47DkAvTDHPfRLdWdGDQ1Y6rdyNs652RwdC2hZsIFKe0To/rWHpZ5h+6/ZzAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJ2MIKcK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJ2MIKcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69851F0089A;
	Wed, 30 Sep 2026 17:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790386;
	bh=iFvXaTyDV1vDoX74OZ9ZmoedR9wX1kegvSaZQLqv1Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJ2MIKcKn/tVpWeAwFCU/BCDk+A94EettG446Q34hR+hY8ojs+vSZyRGQraE8bbB7
	 NXSKWw55VYUmkbdJnui9YDOjypQlIplurq0W9jFB1G9vzxkKcRYN/hMXmYbulvVnFt
	 EkAjHSEjEDfgweJMwViHt9gqU/T/J6RuAU5XYVUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengjun Yao <Chengjun.Yao@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 810/877] drm/amdgpu: fix rmmio iounmap skipped on device removal
Date: Wed, 30 Sep 2026 17:28:41 +0200
Message-ID: <20260930152432.197872636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengjun Yao <Chengjun.Yao@amd.com>

[ Upstream commit 5155002b03b24ba3ef91c5c313b8cf0171b24904 ]

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
[ removed `int idx;` entirely because the isolation cleanup loop requiring `i` is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4776,7 +4776,6 @@ void amdgpu_device_fini_hw(struct amdgpu
 
 void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 {
-	int idx;
 	bool px;
 
 	amdgpu_device_ip_fini(adev);
@@ -4814,11 +4813,9 @@ void amdgpu_device_fini_sw(struct amdgpu
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


