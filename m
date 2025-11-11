Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724E72701D1;
	Tue, 11 Nov 2025 01:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823364; cv=none; b=msIwKiCuXaQLKx7SPIkwdMv1Gu1pQewb6E9NIkdKCi831IrnA3a31nWOTF68JUM8BOyzGotCygdZItztaMXQERW4nbsFOoQfBhdZ5VaeCgNJL2hFLYnsY+w8+ruODgDNsDIsGI2sUs4pFcLVFHEWgeVK3jraiGZVmjEUtR0udc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823364; c=relaxed/simple;
	bh=JcvVAHFfnpb2IlJc7jBjSyh7wuMWBEtG2ujTrBcSe2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7fDwJF2zkvCTotn3CsTzgGxRyQXppdYrNVRiwSFoHSzHCGnBwBWnTaH25j+ybIkh2Q8MUe1//HWoHLN30PzRLar1ZFV7mrkArvsfQIduoG+KndZ/WM0bkzVwyh5uYkkYONf44JV97e87JRSADJQgHQPQnYErZb7nJk8mR1HzTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXnURVWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXnURVWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FF2C19421;
	Tue, 11 Nov 2025 01:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823364;
	bh=JcvVAHFfnpb2IlJc7jBjSyh7wuMWBEtG2ujTrBcSe2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXnURVWiRbgNQh2HpeyvKgVElmV7lsAIqAIywg7/85U8Bo66+IrQ0Jrmuu7GmwZX9
	 I/fZ3VWblKKDjqa4JxRouh9FuT+c0/IxyWtKfyDoPDzNrNzpB943SEJmak6F7zQTM6
	 BH+tEBaR12RH0dM7CJ/6ZRxOrkTgundo/Oi7bbms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiang Liu <gerry@linux.alibaba.com>,
	Meng Li <li.meng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 248/849] drm/amd/amdgpu: Release xcp drm memory after unplug
Date: Tue, 11 Nov 2025 09:36:58 +0900
Message-ID: <20251111004542.428545210@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Meng Li <li.meng@amd.com>

[ Upstream commit e6c2b0f23221ed43c4cc6f636e9ab7862954d562 ]

Add a new API amdgpu_xcp_drm_dev_free().
After unplug xcp device, need to release xcp drm memory etc.

Co-developed-by: Jiang Liu <gerry@linux.alibaba.com>
Signed-off-by: Jiang Liu <gerry@linux.alibaba.com>
Signed-off-by: Meng Li <li.meng@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c     |  1 +
 drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c | 56 +++++++++++++++++----
 drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.h |  1 +
 3 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
index c417f86892207..699acc1b46b59 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
@@ -406,6 +406,7 @@ void amdgpu_xcp_dev_unplug(struct amdgpu_device *adev)
 		p_ddev->primary->dev = adev->xcp_mgr->xcp[i].pdev;
 		p_ddev->driver =  adev->xcp_mgr->xcp[i].driver;
 		p_ddev->vma_offset_manager = adev->xcp_mgr->xcp[i].vma_offset_manager;
+		amdgpu_xcp_drm_dev_free(p_ddev);
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c b/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c
index 8bc36f04b1b71..44009aa8216ed 100644
--- a/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c
+++ b/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.c
@@ -46,18 +46,29 @@ static const struct drm_driver amdgpu_xcp_driver = {
 
 static int8_t pdev_num;
 static struct xcp_device *xcp_dev[MAX_XCP_PLATFORM_DEVICE];
+static DEFINE_MUTEX(xcp_mutex);
 
 int amdgpu_xcp_drm_dev_alloc(struct drm_device **ddev)
 {
 	struct platform_device *pdev;
 	struct xcp_device *pxcp_dev;
 	char dev_name[20];
-	int ret;
+	int ret, i;
+
+	guard(mutex)(&xcp_mutex);
 
 	if (pdev_num >= MAX_XCP_PLATFORM_DEVICE)
 		return -ENODEV;
 
-	snprintf(dev_name, sizeof(dev_name), "amdgpu_xcp_%d", pdev_num);
+	for (i = 0; i < MAX_XCP_PLATFORM_DEVICE; i++) {
+		if (!xcp_dev[i])
+			break;
+	}
+
+	if (i >= MAX_XCP_PLATFORM_DEVICE)
+		return -ENODEV;
+
+	snprintf(dev_name, sizeof(dev_name), "amdgpu_xcp_%d", i);
 	pdev = platform_device_register_simple(dev_name, -1, NULL, 0);
 	if (IS_ERR(pdev))
 		return PTR_ERR(pdev);
@@ -73,8 +84,8 @@ int amdgpu_xcp_drm_dev_alloc(struct drm_device **ddev)
 		goto out_devres;
 	}
 
-	xcp_dev[pdev_num] = pxcp_dev;
-	xcp_dev[pdev_num]->pdev = pdev;
+	xcp_dev[i] = pxcp_dev;
+	xcp_dev[i]->pdev = pdev;
 	*ddev = &pxcp_dev->drm;
 	pdev_num++;
 
@@ -89,16 +100,43 @@ int amdgpu_xcp_drm_dev_alloc(struct drm_device **ddev)
 }
 EXPORT_SYMBOL(amdgpu_xcp_drm_dev_alloc);
 
-void amdgpu_xcp_drv_release(void)
+static void free_xcp_dev(int8_t index)
 {
-	for (--pdev_num; pdev_num >= 0; --pdev_num) {
-		struct platform_device *pdev = xcp_dev[pdev_num]->pdev;
+	if ((index < MAX_XCP_PLATFORM_DEVICE) && (xcp_dev[index])) {
+		struct platform_device *pdev = xcp_dev[index]->pdev;
 
 		devres_release_group(&pdev->dev, NULL);
 		platform_device_unregister(pdev);
-		xcp_dev[pdev_num] = NULL;
+
+		xcp_dev[index] = NULL;
+		pdev_num--;
+	}
+}
+
+void amdgpu_xcp_drm_dev_free(struct drm_device *ddev)
+{
+	int8_t i;
+
+	guard(mutex)(&xcp_mutex);
+
+	for (i = 0; i < MAX_XCP_PLATFORM_DEVICE; i++) {
+		if ((xcp_dev[i]) && (&xcp_dev[i]->drm == ddev)) {
+			free_xcp_dev(i);
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL(amdgpu_xcp_drm_dev_free);
+
+void amdgpu_xcp_drv_release(void)
+{
+	int8_t i;
+
+	guard(mutex)(&xcp_mutex);
+
+	for (i = 0; pdev_num && i < MAX_XCP_PLATFORM_DEVICE; i++) {
+		free_xcp_dev(i);
 	}
-	pdev_num = 0;
 }
 EXPORT_SYMBOL(amdgpu_xcp_drv_release);
 
diff --git a/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.h b/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.h
index c1c4b679bf95c..580a1602c8e36 100644
--- a/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.h
+++ b/drivers/gpu/drm/amd/amdxcp/amdgpu_xcp_drv.h
@@ -25,5 +25,6 @@
 #define _AMDGPU_XCP_DRV_H_
 
 int amdgpu_xcp_drm_dev_alloc(struct drm_device **ddev);
+void amdgpu_xcp_drm_dev_free(struct drm_device *ddev);
 void amdgpu_xcp_drv_release(void);
 #endif /* _AMDGPU_XCP_DRV_H_ */
-- 
2.51.0



