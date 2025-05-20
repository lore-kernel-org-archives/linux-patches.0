Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666702512FC;
	Tue, 20 May 2025 14:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750433; cv=none; b=NXFa3XaL6qADOUNRO6YH9aHYEmE0YwZmg58b7nXSUbVn7YQWnsEsuG+bR8gQOHgcpgcjDvVZgZmkRTxU2G7sYQoBWE+/+FRdp8YpAJkkEt5reQtsr82DYKeZ8uok6j91AKb0JFhB1BH1oM/iHwy8MByE7om4B+aHtBM6pF2NUxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750433; c=relaxed/simple;
	bh=M7UQWvkQYTwMSMDIEP808gFuKISnM5ztMglLVvZZY1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPMcOQ3rcpeE+3QqKKpriJBr4hn5wQztdZktg3S5blmmslpcBAs4Km0Ua98cl5l6eK+VZV2figyrik3iW/J415Bs67IgiCIKqXrXMw3blAulvVPh1Lbpo4bE5PpZc8Ycad0HASc3PNIbyKxoEy3xUwVyA12hm8jufYwa9qck9Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/J87h94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/J87h94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0293C4CEEB;
	Tue, 20 May 2025 14:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750433;
	bh=M7UQWvkQYTwMSMDIEP808gFuKISnM5ztMglLVvZZY1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/J87h94a5H2e7BsMIBKZvktJiCMfbQsrOKAAKnbKCNVY/NtzWwT4N9z8laHJB54c
	 OSrRMpU38LsaCtfpmeZuQBKqs/XkcMr4/3NEOOKXlzRJLgv0euVbjC1M9mNkOCewXz
	 VSZA9WFnGyQ2bnhflsKPi5DepuJdouc0jHgr70yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 143/143] drm/amdgpu: fix pm notifier handling
Date: Tue, 20 May 2025 15:51:38 +0200
Message-ID: <20250520125815.632496384@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 4aaffc85751da5722e858e4333e8cf0aa4b6c78f upstream.

Set the s3/s0ix and s4 flags in the pm notifier so that we can skip
the resource evictions properly in pm prepare based on whether
we are suspending or hibernating.  Drop the eviction as processes
are not frozen at this time, we we can end up getting stuck trying
to evict VRAM while applications continue to submit work which
causes the buffers to get pulled back into VRAM.

v2: Move suspend flags out of pm notifier (Mario)

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4178
Fixes: 2965e6355dcd ("drm/amd: Add Suspend/Hibernate notification callback support")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 06f2dcc241e7e5c681f81fbc46cacdf4bfd7d6d7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   18 +++++-------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c    |   10 +---------
 2 files changed, 6 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4728,28 +4728,20 @@ static int amdgpu_device_evict_resources
  * @data: data
  *
  * This function is called when the system is about to suspend or hibernate.
- * It is used to evict resources from the device before the system goes to
- * sleep while there is still access to swap.
+ * It is used to set the appropriate flags so that eviction can be optimized
+ * in the pm prepare callback.
  */
 static int amdgpu_device_pm_notifier(struct notifier_block *nb, unsigned long mode,
 				     void *data)
 {
 	struct amdgpu_device *adev = container_of(nb, struct amdgpu_device, pm_nb);
-	int r;
 
 	switch (mode) {
 	case PM_HIBERNATION_PREPARE:
 		adev->in_s4 = true;
-		fallthrough;
-	case PM_SUSPEND_PREPARE:
-		r = amdgpu_device_evict_resources(adev);
-		/*
-		 * This is considered non-fatal at this time because
-		 * amdgpu_device_prepare() will also fatally evict resources.
-		 * See https://gitlab.freedesktop.org/drm/amd/-/issues/3781
-		 */
-		if (r)
-			drm_warn(adev_to_drm(adev), "Failed to evict resources, freeze active processes if problems occur: %d\n", r);
+		break;
+	case PM_POST_HIBERNATION:
+		adev->in_s4 = false;
 		break;
 	}
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2647,13 +2647,8 @@ static int amdgpu_pmops_freeze(struct de
 static int amdgpu_pmops_thaw(struct device *dev)
 {
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
-	struct amdgpu_device *adev = drm_to_adev(drm_dev);
-	int r;
 
-	r = amdgpu_device_resume(drm_dev, true);
-	adev->in_s4 = false;
-
-	return r;
+	return amdgpu_device_resume(drm_dev, true);
 }
 
 static int amdgpu_pmops_poweroff(struct device *dev)
@@ -2666,9 +2661,6 @@ static int amdgpu_pmops_poweroff(struct
 static int amdgpu_pmops_restore(struct device *dev)
 {
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
-	struct amdgpu_device *adev = drm_to_adev(drm_dev);
-
-	adev->in_s4 = false;
 
 	return amdgpu_device_resume(drm_dev, true);
 }


