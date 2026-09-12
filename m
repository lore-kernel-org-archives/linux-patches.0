Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9DE30DEA3;
	Sat, 12 Sep 2026 14:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222662; cv=none; b=ufOAoQbOzWBpTZDwXRHQ1c9XYr3UJiPNRj7q+ZdGrm/zKP2Pwh0hw1h/2jBcfOaVWuaVMfOoRKR7cnGWuzU7Y2NOJ7zSc1Y1OSjM5hlzmLCHZ6+PPC29/+/XvwM5wGq+pKNlcppCglHlhCfY/KalakuPRerpZvbfwGsim2ZOizA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222662; c=relaxed/simple;
	bh=D++rdzalS49fJOq4mcqRVNdLmJ8Q+HoN1atp/wYUJoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePKImSREonyuJdH15MiN6mGA2sLN+hFRRQLYOO7tsI7AnBHen6ToiE1eblS+KsgQ5Rn7YNDst/700Cz23VigP1KAzZwBqigGshD+q3/1tjjc9GSIoMBeDT2w1xI3A8gR/mNcwhOW2J72uLqihm/RGb/eDYpULddPiTwH7uB4JMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPnsPQoK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPnsPQoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F8A1F000FF;
	Sat, 12 Sep 2026 14:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222657;
	bh=pgjlFKxpNxUYfRhglcN6jw8y6Sja1et/7rw2NA4HCrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPnsPQoKu7h7B1hDSpk4k6IdQbJUQNQjWsw3WqW8MgJgmxHqIrFlcJ884Md2Tf4lW
	 namLaXvzI7RN86eTAf1w2Nt0+J1XtqXYgyM0wlMPQr0uxBYhIMQlxbept1UPzVtaj8
	 uBLkCCdoELGW2q0BwwrMFP6MCpAKDroB6cjePCbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Qiang Yu <yuq825@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0588/1424] drm/lima: call drm_mm_init() with a valid allocation range
Date: Sat, 12 Sep 2026 08:50:20 +0200
Message-ID: <20260912065620.459698806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 02cef0cea6572..3843797d376b3 100644
--- a/drivers/gpu/drm/lima/lima_device.c
+++ b/drivers/gpu/drm/lima/lima_device.c
@@ -368,12 +368,6 @@ int lima_device_init(struct lima_device *ldev)
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
@@ -387,6 +381,12 @@ int lima_device_init(struct lima_device *ldev)
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



