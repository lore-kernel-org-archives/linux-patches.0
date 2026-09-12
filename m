Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB7A3AAF53;
	Sat, 12 Sep 2026 18:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238184; cv=none; b=EgqyfjYs16vIO7UA2Vpg96Q0Cfs7g4osxDzniKpsLXLX2H/ygn2Spck2dAh6H2540C3CCkL1IvT8RrBF8LMKhKcGBnyjphik7GaG/BcIg+3ffzfRn+AJ62kBd1Y+O0pmSYOYTuY8iYNnfcVrK5RYPI4rC8Zc5LMP4JQlW/1XG1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238184; c=relaxed/simple;
	bh=YNnaYV72Rjf3zMO0MxhoIXxuAjcLr14qC8Lt3lV5tIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3uyseytKBSIT39z1bdaTxD+njj/NVWtR+vroLYR5LmUcMJZ1ONaljHSIKvYlKpbLgYShMsIVaDTF5pnSfSR2lMV/0q4x5U3/+id2ery1511aya6X8hO+0zpmH6xoYQjlRU+cGBinHUxtJOTUO8EPQF2OmJyTOJ1BSM98szmEfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltElzQvr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltElzQvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92751F000FF;
	Sat, 12 Sep 2026 18:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238178;
	bh=fI+dPtepbT1GzFcg/gwVivXJPyROF/fR8qSl901aIIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltElzQvr1Cs8GwKsbkWkO62vdg8c+h/zg3ioKMTFV3Bu20WpUmht4zLIht9AjbIic
	 4mL1KQbf+MRhhcRtbTwtUJ0Eeg5ORnmLE5rtSUOEi0FvCVNrRYQuB4OY0kuMXIg/Kh
	 DARHUADjMKtF/T7wJxTx0kWb4zHaO+irYsn7lzFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Qiang Yu <yuq825@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 410/935] drm/lima: call drm_mm_init() with a valid allocation range
Date: Sat, 12 Sep 2026 08:57:20 +0200
Message-ID: <20260912065536.227674795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Grimler <henrik.grimler@axis.com>

[ Upstream commit 3b3bce4a692ac60d9f4a341e6b597dd1fd0a28f9 ]

lima_vm_create() is currently run before va_start and va_end are set up,
meaning they are both 0. lima_vm_create() runs drm_mm_init() with them
as arguments for the allocator, and if DRM_DEBUG_MM is enabled the
DRM_MM_BUG_ON check in drm_mm_init then fires, as seen here on
exynos4412-odroid-u2:

[    1.736297] ------------[ cut here ]------------
[    1.740370] kernel BUG at drivers/gpu/drm/drm_mm.c:931!
[    1.745574] Internal error: Oops - BUG: 0 [#1] SMP ARM
[    1.750697] Modules linked in:
[    1.753734] CPU: 0 UID: 0 PID: 41 Comm: kworker/u16:1 Not tainted 7.0.10-postmarketos-exynos4 #11 PREEMPT
[    1.763372] Hardware name: Samsung Exynos (Flattened Device Tree)
[    1.769446] Workqueue: events_unbound deferred_probe_work_func
[    1.775261] PC is at drm_mm_init+0x9c/0xa4
[    1.779339] LR is at lima_vm_create+0x144/0x17c
[ ... ]

Fix the issue by moving the lima_vm_create() call after va_start and
va_end are set up.

Fixes: a1d2a6339961 ("drm/lima: driver for ARM Mali4xx GPUs")
Signed-off-by: Henrik Grimler <henrik.grimler@axis.com>
Signed-off-by: Qiang Yu <yuq825@gmail.com>
Link: https://patch.msgid.link/20260601-lima-alloc-fix-v1-1-16d3f3b7b780@axis.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/lima/lima_device.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/lima/lima_device.c b/drivers/gpu/drm/lima/lima_device.c
index 36c9905894278..234789c00d964 100644
--- a/drivers/gpu/drm/lima/lima_device.c
+++ b/drivers/gpu/drm/lima/lima_device.c
@@ -367,12 +367,6 @@ int lima_device_init(struct lima_device *ldev)
 	if (err)
 		goto err_out0;
 
-	ldev->empty_vm = lima_vm_create(ldev);
-	if (!ldev->empty_vm) {
-		err = -ENOMEM;
-		goto err_out1;
-	}
-
 	ldev->va_start = 0;
 	if (ldev->id == lima_gpu_mali450) {
 		ldev->va_end = LIMA_VA_RESERVE_START;
@@ -386,6 +380,12 @@ int lima_device_init(struct lima_device *ldev)
 	} else
 		ldev->va_end = LIMA_VA_RESERVE_END;
 
+	ldev->empty_vm = lima_vm_create(ldev);
+	if (!ldev->empty_vm) {
+		err = -ENOMEM;
+		goto err_out1;
+	}
+
 	ldev->iomem = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(ldev->iomem)) {
 		dev_err(ldev->dev, "fail to ioremap iomem\n");
-- 
2.53.0



