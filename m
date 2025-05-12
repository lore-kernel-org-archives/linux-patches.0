Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE561C173C;
	Mon, 12 May 2025 17:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072082; cv=none; b=RDtMH+As/GJoJlOc8PnziNTxNpiTqQ03vJkDXvHFeEVd3ncoOb6np7ujLWWiivA0oNbyKsmSzTcfrUjHX0h+uCLYb8zUeJUoglPX2NjHyX9jQ/BfdDhOKC2OKyVb63wZnoq1VLxdRYK8Hx7Yx6j+NVJmDo/NhAlyRhkWP5tpEzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072082; c=relaxed/simple;
	bh=M+1CCiOJI1UqsrHaA2X1ufg5ZL3AoHouVy9wUHe5DUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLnliVVwjtViORaMEF/pi95cAXT+SgBt99TDlYtfg/SKvjDlAiFTcETCTqSh8sLBapk+ogZE5HfEmuQFG2URyWmgyMyQVmlNrs0BUmIeE5mMKAd9KuNt4b8l4AvLNLeLno6QCjPgyS4QdTOPYPnQBxPvO8/UmgLs+4M7PP9zeTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYJ3Ueai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYJ3Ueai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E113C4CEE7;
	Mon, 12 May 2025 17:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072082;
	bh=M+1CCiOJI1UqsrHaA2X1ufg5ZL3AoHouVy9wUHe5DUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYJ3UeaiacZ4LBNdiDDWclFE8SOgmJ08kk2UmSVX/vmn3Bn2j1hDR0Szu9yoZpUlE
	 LxCQlrJpDXR4z7n99kbksNxTF7XI+haKmimOAUE1DeAtn2kAU5LIWrUFquNe/uzf2B
	 cyntu7Py610b6Ua1w39X+AlUpqfFWvW0DT2nUFZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 104/197] drm/amdgpu: fix pm notifier handling
Date: Mon, 12 May 2025 19:39:14 +0200
Message-ID: <20250512172048.618165191@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4819,28 +4819,20 @@ static int amdgpu_device_evict_resources
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
@@ -2582,13 +2582,8 @@ static int amdgpu_pmops_freeze(struct de
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
@@ -2601,9 +2596,6 @@ static int amdgpu_pmops_poweroff(struct
 static int amdgpu_pmops_restore(struct device *dev)
 {
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
-	struct amdgpu_device *adev = drm_to_adev(drm_dev);
-
-	adev->in_s4 = false;
 
 	return amdgpu_device_resume(drm_dev, true);
 }


