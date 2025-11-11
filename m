Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D3226ED5E;
	Tue, 11 Nov 2025 01:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823313; cv=none; b=Box1zY1CAAFB8URddiSnZ4JH1XPBF6gO8xaiLfuSwoxX2xEghk24MnJEDz04BegrHz6sVNlV7NS1vYuMhss6kZRwb8w9arR7HorLSuWe08Dj1d7f0zGKOqrDgJZsH4dGbAXDJBSZW4nk8ZbsW3+KIqNzI1Z1u7DJ9pLF/I9DV50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823313; c=relaxed/simple;
	bh=P9pnHyEDNpAHWJ63PfhV0ah4+Hpvy9qFAODYxJwkDYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIUcdZBxipIxOQEvsPFX+CKuIMNlH25ujriUo1egDwQiiLahg/HmQljBrZkECNjyosooDLxFDd4zlgm7gl4Qd9hBGQ/d1B3o5D1lKINcUWlPujp4wbPltUq8zF+aqqmPP1RfM013tMUZks0IoC4KQor7MiKBIPDiJc2xppvZWO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWuQgjob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWuQgjob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5359EC19422;
	Tue, 11 Nov 2025 01:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823313;
	bh=P9pnHyEDNpAHWJ63PfhV0ah4+Hpvy9qFAODYxJwkDYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWuQgjobDmfcro5jS1uIzrds7A4SjA3kC90PAzXIpbmT/Ke8x5CFx3cmJSuuM3QP0
	 kmFGGwgRDLQjv5vl98ETdL7JnhQBkBBve/JFqfo4HMzNb4Vw9yTgqp1e4XQ8PkDrwq
	 qKMoUCQKLpaIyhTVxyaaPmO1wb3Ken7qY8IdcJ6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ce Sun <cesun102@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 247/849] drm/amdgpu: Effective health check before reset
Date: Tue, 11 Nov 2025 09:36:57 +0900
Message-ID: <20251111004542.403821518@linuxfoundation.org>
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

From: Ce Sun <cesun102@amd.com>

[ Upstream commit da467352296f8e50c7ab7057ead44a1df1c81496 ]

Move amdgpu_device_health_check into amdgpu_device_gpu_recover to
ensure that if the device is present can be checked before reset

The reason is:
1.During the dpc event, the device where the dpc event occurs is not
present on the bus
2.When both dpc event and ATHUB event occur simultaneously,the dpc thread
holds the reset domain lock when detecting error,and the gpu recover thread
acquires the hive lock.The device is simultaneously in the states of
amdgpu_ras_in_recovery and occurs_dpc,so gpu recover thread will not go to
amdgpu_device_health_check.It waits for the reset domain lock held by the
dpc thread, but dpc thread has not released the reset domain lock.In the dpc
callback slot_reset,to obtain the hive lock, the hive lock is held by the
gpu recover thread at this time.So a deadlock occurred

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 26 +++++++---------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index c8459337fcb89..dfa68cb411966 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6132,12 +6132,11 @@ static int amdgpu_device_health_check(struct list_head *device_list_handle)
 	return ret;
 }
 
-static int amdgpu_device_recovery_prepare(struct amdgpu_device *adev,
+static void amdgpu_device_recovery_prepare(struct amdgpu_device *adev,
 					  struct list_head *device_list,
 					  struct amdgpu_hive_info *hive)
 {
 	struct amdgpu_device *tmp_adev = NULL;
-	int r;
 
 	/*
 	 * Build list of devices to reset.
@@ -6157,14 +6156,6 @@ static int amdgpu_device_recovery_prepare(struct amdgpu_device *adev,
 	} else {
 		list_add_tail(&adev->reset_list, device_list);
 	}
-
-	if (!amdgpu_sriov_vf(adev) && (!adev->pcie_reset_ctx.occurs_dpc)) {
-		r = amdgpu_device_health_check(device_list);
-		if (r)
-			return r;
-	}
-
-	return 0;
 }
 
 static void amdgpu_device_recovery_get_reset_lock(struct amdgpu_device *adev,
@@ -6457,8 +6448,13 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	reset_context->hive = hive;
 	INIT_LIST_HEAD(&device_list);
 
-	if (amdgpu_device_recovery_prepare(adev, &device_list, hive))
-		goto end_reset;
+	amdgpu_device_recovery_prepare(adev, &device_list, hive);
+
+	if (!amdgpu_sriov_vf(adev)) {
+		r = amdgpu_device_health_check(&device_list);
+		if (r)
+			goto end_reset;
+	}
 
 	/* We need to lock reset domain only once both for XGMI and single device */
 	amdgpu_device_recovery_get_reset_lock(adev, &device_list);
@@ -6965,12 +6961,6 @@ pci_ers_result_t amdgpu_pci_slot_reset(struct pci_dev *pdev)
 	int r = 0, i;
 	u32 memsize;
 
-	/* PCI error slot reset should be skipped During RAS recovery */
-	if ((amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 4, 3) ||
-	    amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 4, 4)) &&
-	    amdgpu_ras_in_recovery(adev))
-		return PCI_ERS_RESULT_RECOVERED;
-
 	dev_info(adev->dev, "PCI error: slot reset callback!!\n");
 
 	memset(&reset_context, 0, sizeof(reset_context));
-- 
2.51.0



