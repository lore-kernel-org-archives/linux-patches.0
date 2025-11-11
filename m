Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D994C97;
	Tue, 11 Nov 2025 00:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822463; cv=none; b=YiBZ2vWTFTFlb9UdQbGZV3tvO0P+GHigXSn8UCOcgB6jTG2SdFeTwobcpiJT5RiYlHy9zKDCRBeXTfGdj8GVIoBEXarHrVj6lcPMGDCZrZVBu7h+fN8eXLqW/j+0Ti6CKEXjwDTdTAsoUTqbt0lCKUmWBOEh27xl2SoESJWr3t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822463; c=relaxed/simple;
	bh=pxlR6xHy7+ovjhYlEw6rS+kODZ8mf6BULDYWbucUDmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T39FueJcZOxtLMuM8FEst1bPpFs2NBDyxtbVb+FdDczeEZKWKL6xowJRD7Jejr8Wq5KMossLXuLH2bnK9P1yFn9TI7SbYY5COE/+sJTih0uNcljNW55T9I3I+GNnI0cDoxPqdSfoR0HKMeOCsWivIT21SwHwp//MAP+NRvCS+eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAAD3zuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAAD3zuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C9BC4CEF5;
	Tue, 11 Nov 2025 00:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822463;
	bh=pxlR6xHy7+ovjhYlEw6rS+kODZ8mf6BULDYWbucUDmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAAD3zuf6Y6yeYpPktXl1ngqyMEkTl7EmJ6BvLBGHYMlClu0qjQLuLtqV0zu9wzO6
	 Oa7UIV2MIsDL46UCLAzGSdXcP6T+cYeUZG6G7k7+/66ZngA3IU0jIuHeqeFglGGEhm
	 vm3bIZtDqcJiqJ5Dqgr0tNxCemfbumOcFUWmIeWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/565] drm/radeon: Remove calls to drm_put_dev()
Date: Tue, 11 Nov 2025 09:38:31 +0900
Message-ID: <20251111004528.154551244@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Daniel Palmer <daniel@0x0f.com>

[ Upstream commit 745bae76acdd71709773c129a69deca01036250b ]

Since the allocation of the drivers main structure was changed to
devm_drm_dev_alloc() drm_put_dev()'ing to trigger it to be free'd
should be done by devres.

However, drm_put_dev() is still in the probe error and device remove
paths. When the driver fails to probe warnings like the following are
shown because devres is trying to drm_put_dev() after the driver
already did it.

[    5.642230] radeon 0000:01:05.0: probe with driver radeon failed with error -22
[    5.649605] ------------[ cut here ]------------
[    5.649607] refcount_t: underflow; use-after-free.
[    5.649620] WARNING: CPU: 0 PID: 357 at lib/refcount.c:28 refcount_warn_saturate+0xbe/0x110

Fixes: a9ed2f052c5c ("drm/radeon: change drm_dev_alloc to devm_drm_dev_alloc")
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3eb8c0b4c091da0a623ade0d3ee7aa4a93df1ea4)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_drv.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index e5a6f3e7c75b6..31fac034a17e6 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -312,46 +312,30 @@ static int radeon_pci_probe(struct pci_dev *pdev,
 
 	ret = pci_enable_device(pdev);
 	if (ret)
-		goto err_free;
+		return ret;
 
 	pci_set_drvdata(pdev, ddev);
 
 	ret = radeon_driver_load_kms(ddev, flags);
 	if (ret)
-		goto err_agp;
+		goto err;
 
 	ret = drm_dev_register(ddev, flags);
 	if (ret)
-		goto err_agp;
+		goto err;
 
 	radeon_fbdev_setup(ddev->dev_private);
 
 	return 0;
 
-err_agp:
+err:
 	pci_disable_device(pdev);
-err_free:
-	drm_dev_put(ddev);
 	return ret;
 }
 
-static void
-radeon_pci_remove(struct pci_dev *pdev)
-{
-	struct drm_device *dev = pci_get_drvdata(pdev);
-
-	drm_put_dev(dev);
-}
-
 static void
 radeon_pci_shutdown(struct pci_dev *pdev)
 {
-	/* if we are running in a VM, make sure the device
-	 * torn down properly on reboot/shutdown
-	 */
-	if (radeon_device_is_virtual())
-		radeon_pci_remove(pdev);
-
 #if defined(CONFIG_PPC64) || defined(CONFIG_MACH_LOONGSON64)
 	/*
 	 * Some adapters need to be suspended before a
@@ -603,7 +587,6 @@ static struct pci_driver radeon_kms_pci_driver = {
 	.name = DRIVER_NAME,
 	.id_table = pciidlist,
 	.probe = radeon_pci_probe,
-	.remove = radeon_pci_remove,
 	.shutdown = radeon_pci_shutdown,
 	.driver.pm = &radeon_pm_ops,
 };
-- 
2.51.0



