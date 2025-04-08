Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE92A264614;
	Tue,  8 Apr 2025 11:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110988; cv=none; b=Faq/qYep21LP43lIf9gS0Q/nZ+98VTXEM1ipYPAs2r63goa4kzVoesO3HDkCmwmVGlVCj7axpJw0PeDgC2vncpKPfnLd9LVSxUUfyHWJeBiuHZctHDZpMITuC6cNIcAYr2f+ij4LJ9djtJpIyTfNOSYxbaf3ugwlGa4b/yaJHFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110988; c=relaxed/simple;
	bh=vEGeZJg/zYTvhAIKcH6ckyGhGcLGtESitKgfrUuYAdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfyEKayhW5v8c1hDlL8DNM043K5UnucBaR66OvKuKEe/Y3ASRL/UlFhdK9IaCZ2kaUNdZAOVWWvN59aWEucHNEYODfLkazT1jwpJWm8jhj4UxZTCjNQVJVvNoskCq53M6tkoUh1Eq+Pzbl2ZBmDrc7nMiShvv+Jed27uW9XlrTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KO+wGd78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KO+wGd78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB00C4CEE5;
	Tue,  8 Apr 2025 11:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110988;
	bh=vEGeZJg/zYTvhAIKcH6ckyGhGcLGtESitKgfrUuYAdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KO+wGd78JU3F5QBm/INIU0J6ndpj1ZNWsQrLNZ9IZLI80ZSzc4D4vjVoWVtVFdvgU
	 MIngsJcsxHRnvHvb7YjkdJuSJN02HlgubdZvjdA1fc2xk2P9y8zG90jHtUD2SeLZs0
	 JYGoLodopbUJpSCk6xXN6aXU5etHgC8+5qLCR6xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 269/731] drm/panthor: Fix a race between the reset and suspend path
Date: Tue,  8 Apr 2025 12:42:46 +0200
Message-ID: <20250408104920.536345967@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 57e233c3bd63f32d2c7e937db2e16b98f723ce2f ]

If a reset is scheduled when the suspend happens, we drop the
reset-pending info on the floor assuming the resume will fix things,
but the resume logic might try a fast reset. If we're lucky, the
fast reset fails and we fallback to a slow reset, but if the FW was
corrupted in a way that makes it partially functional (it boots but
doesn't quite do what it's expected to do), we won't notice immediately
that things are not working correctly, leading to a new reset further
down the road.

Fixes: 5fe909cae118 ("drm/panthor: Add the device logical block")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241217092457.1582053-1-boris.brezillon@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_device.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/panthor/panthor_device.c
index 0a37cfeeb181c..a9da1d1eeb707 100644
--- a/drivers/gpu/drm/panthor/panthor_device.c
+++ b/drivers/gpu/drm/panthor/panthor_device.c
@@ -128,14 +128,11 @@ static void panthor_device_reset_work(struct work_struct *work)
 	struct panthor_device *ptdev = container_of(work, struct panthor_device, reset.work);
 	int ret = 0, cookie;
 
-	if (atomic_read(&ptdev->pm.state) != PANTHOR_DEVICE_PM_STATE_ACTIVE) {
-		/*
-		 * No need for a reset as the device has been (or will be)
-		 * powered down
-		 */
-		atomic_set(&ptdev->reset.pending, 0);
+	/* If the device is entering suspend, we don't reset. A slow reset will
+	 * be forced at resume time instead.
+	 */
+	if (atomic_read(&ptdev->pm.state) != PANTHOR_DEVICE_PM_STATE_ACTIVE)
 		return;
-	}
 
 	if (!drm_dev_enter(&ptdev->base, &cookie))
 		return;
@@ -477,6 +474,14 @@ int panthor_device_resume(struct device *dev)
 
 	if (panthor_device_is_initialized(ptdev) &&
 	    drm_dev_enter(&ptdev->base, &cookie)) {
+		/* If there was a reset pending at the time we suspended the
+		 * device, we force a slow reset.
+		 */
+		if (atomic_read(&ptdev->reset.pending)) {
+			ptdev->reset.fast = false;
+			atomic_set(&ptdev->reset.pending, 0);
+		}
+
 		ret = panthor_device_resume_hw_components(ptdev);
 		if (ret && ptdev->reset.fast) {
 			drm_err(&ptdev->base, "Fast reset failed, trying a slow reset");
@@ -493,9 +498,6 @@ int panthor_device_resume(struct device *dev)
 			goto err_suspend_devfreq;
 	}
 
-	if (atomic_read(&ptdev->reset.pending))
-		queue_work(ptdev->reset.wq, &ptdev->reset.work);
-
 	/* Clear all IOMEM mappings pointing to this device after we've
 	 * resumed. This way the fake mappings pointing to the dummy pages
 	 * are removed and the real iomem mapping will be restored on next
-- 
2.39.5



