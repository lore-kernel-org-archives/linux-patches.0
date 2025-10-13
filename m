Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D67F21E0AD;
	Mon, 13 Oct 2025 15:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369359; cv=none; b=DUFifWa28FrlJMniryZZZv1W/CWi9gXK/+zmTFWiUpXknNPOFmL9Fr8t3BgsPWEumXqKVPfExsiKTG5p00b9fLk+erBiUsiZw6GiCxXv9IcK+u+ajp4ZLBm2OBx11etJHLLO5yETEuBU03UUMAx8TQZQPQg8F8NgzMktm+RDcxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369359; c=relaxed/simple;
	bh=ZcqYtLUmYVA5dRgxbyCg2txqtUzeJwcKgMkllfUVmsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9SN/0ybk9sAFscQWqu8I1XI2VsxMWj1+INi6PikobvLZmaQRsF0h6YWeR8cKLLOfCuPHThksFyYXKvP92pgcsrLDOprU1BHyK2orjKEsHotuLdJ1UgnSG69eoBtuPge9HDBVHQ9YZ9IW5OKxYde7wxeBu2e2NNErXrCEzMX5J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUWdomWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUWdomWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40AFC4CEE7;
	Mon, 13 Oct 2025 15:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369359;
	bh=ZcqYtLUmYVA5dRgxbyCg2txqtUzeJwcKgMkllfUVmsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUWdomWIvWd/xeS3JEMIkp2+9ErP2vAwN8MMDgtvgwG8f6ks+Sg3QQJeQVvNt0xmZ
	 GLp0DI4uETXT8rJ69VZ+zZKOa35rjUclpwcRjSKhivVGwP/oSkMxN6WJhikRGR6V0s
	 Y+lhOGCNlLF8/HBxQaPBR2MXVVatEYpIyMFGza8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 218/563] drm/amdgpu: fix link error for !PM_SLEEP
Date: Mon, 13 Oct 2025 16:41:19 +0200
Message-ID: <20251013144419.180855194@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 4d22db6d070ed3934f02ed15391283f6feb258ad ]

When power management is not enabled in the kernel build, the newly
added hibernation changes cause a link failure:

arm-linux-gnueabi-ld: drivers/gpu/drm/amd/amdgpu/amdgpu_drv.o: in function `amdgpu_pmops_thaw':
amdgpu_drv.c:(.text+0x1514): undefined reference to `pm_hibernate_is_recovering'

Make the power management code in this driver conditional on
CONFIG_PM and CONFIG_PM_SLEEP

Fixes: 530694f54dd5 ("drm/amdgpu: do not resume device in thaw for normal hibernation")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250714081635.4071570-1-arnd@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 395c6be901ce7..dbbb3407fa13b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2964,15 +2964,15 @@ long amdgpu_drm_ioctl(struct file *filp,
 }
 
 static const struct dev_pm_ops amdgpu_pm_ops = {
-	.prepare = amdgpu_pmops_prepare,
-	.complete = amdgpu_pmops_complete,
-	.suspend = amdgpu_pmops_suspend,
-	.suspend_noirq = amdgpu_pmops_suspend_noirq,
-	.resume = amdgpu_pmops_resume,
-	.freeze = amdgpu_pmops_freeze,
-	.thaw = amdgpu_pmops_thaw,
-	.poweroff = amdgpu_pmops_poweroff,
-	.restore = amdgpu_pmops_restore,
+	.prepare = pm_sleep_ptr(amdgpu_pmops_prepare),
+	.complete = pm_sleep_ptr(amdgpu_pmops_complete),
+	.suspend = pm_sleep_ptr(amdgpu_pmops_suspend),
+	.suspend_noirq = pm_sleep_ptr(amdgpu_pmops_suspend_noirq),
+	.resume = pm_sleep_ptr(amdgpu_pmops_resume),
+	.freeze = pm_sleep_ptr(amdgpu_pmops_freeze),
+	.thaw = pm_sleep_ptr(amdgpu_pmops_thaw),
+	.poweroff = pm_sleep_ptr(amdgpu_pmops_poweroff),
+	.restore = pm_sleep_ptr(amdgpu_pmops_restore),
 	.runtime_suspend = amdgpu_pmops_runtime_suspend,
 	.runtime_resume = amdgpu_pmops_runtime_resume,
 	.runtime_idle = amdgpu_pmops_runtime_idle,
@@ -3117,7 +3117,7 @@ static struct pci_driver amdgpu_kms_pci_driver = {
 	.probe = amdgpu_pci_probe,
 	.remove = amdgpu_pci_remove,
 	.shutdown = amdgpu_pci_shutdown,
-	.driver.pm = &amdgpu_pm_ops,
+	.driver.pm = pm_ptr(&amdgpu_pm_ops),
 	.err_handler = &amdgpu_pci_err_handler,
 	.dev_groups = amdgpu_sysfs_groups,
 };
-- 
2.51.0



