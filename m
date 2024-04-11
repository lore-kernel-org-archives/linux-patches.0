Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBFF1DDE9;
	Thu, 11 Apr 2024 10:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830395; cv=none; b=Xd1EjSreNgf74+/ZjEvAdbpiLX5nVPqoW3RKNLOOwvV8kL/d0RogG4d/sAN1YtRIpXgID1U9+voJCc8l51mkbJbxxBgRp0ev5NvY5Pju+yjHR+ZQH1d9C4o08CQWwoLHpcw+7P4TTOnYEBFQl3KSsE9lFIc9iC1UbX9UVMT+Wsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830395; c=relaxed/simple;
	bh=B1JE5kJwCrY5SNG2lIls2CfTl0VzYuUsAxFDCqe05j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z41RFGM2MwqBjt2dIs9LV6EToI51jZsvNf397fgivIpWffIeAielxPk2cT6avDNWbwXpALu++cHlIPAfLxcwkZE/vlKmxo5LiqCg2AcKXPkKaiIH7j9ITcoYfX8U9wVSzVjtOnUY5HNO+9Pae9faoIVi0jL82uQY4Wob3PSItZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Qngdjr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Qngdjr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB071C433F1;
	Thu, 11 Apr 2024 10:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830395;
	bh=B1JE5kJwCrY5SNG2lIls2CfTl0VzYuUsAxFDCqe05j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Qngdjr+veMbrl4f4H/Vg+d93ICr34mZzqYE9d12Yg46pI9sY7W6dWF6iq/iXe0vB
	 rMUWGkAxiIDR1V11jm1uhYeOb92j1qVQ7PbwNPMCTqoANkK5tAfGT9hB35sZ5lFNg0
	 +JRi4oBG0xH8cR2LHGA4N88RzsGsmqR7XWDVpONM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Rehman <Ahmad.Rehman@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 130/143] drm/amdgpu: Init zone device and drm client after mode-1 reset on reload
Date: Thu, 11 Apr 2024 11:56:38 +0200
Message-ID: <20240411095424.816968150@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Rehman <Ahmad.Rehman@amd.com>

[ Upstream commit f679fd6057fbf5ab34aaee28d58b7f81af0cbf48 ]

In passthrough environment, when amdgpu is reloaded after unload, mode-1
is triggered after initializing the necessary IPs, That init does not
include KFD, and KFD init waits until the reset is completed. KFD init
is called in the reset handler, but in this case, the zone device and
drm client is not initialized, causing app to create kernel panic.

v2: Removing the init KFD condition from amdgpu_amdkfd_drm_client_create.
As the previous version has the potential of creating DRM client twice.

v3: v2 patch results in SDMA engine hung as DRM open causes VM clear to SDMA
before SDMA init. Adding the condition to in drm client creation, on top of v1,
to guard against drm client creation call multiple times.

Signed-off-by: Ahmad Rehman <Ahmad.Rehman@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c    | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index 41db030ddc4ee..131983ed43465 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -146,7 +146,7 @@ int amdgpu_amdkfd_drm_client_create(struct amdgpu_device *adev)
 {
 	int ret;
 
-	if (!adev->kfd.init_complete)
+	if (!adev->kfd.init_complete || adev->kfd.client.dev)
 		return 0;
 
 	ret = drm_client_init(&adev->ddev, &adev->kfd.client, "kfd",
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 586f4d03039df..64b1bb2404242 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2451,8 +2451,11 @@ static void amdgpu_drv_delayed_reset_work_handler(struct work_struct *work)
 	}
 	for (i = 0; i < mgpu_info.num_dgpu; i++) {
 		adev = mgpu_info.gpu_ins[i].adev;
-		if (!adev->kfd.init_complete)
+		if (!adev->kfd.init_complete) {
+			kgd2kfd_init_zone_device(adev);
 			amdgpu_amdkfd_device_init(adev);
+			amdgpu_amdkfd_drm_client_create(adev);
+		}
 		amdgpu_ttm_set_buffer_funcs_status(adev, true);
 	}
 }
-- 
2.43.0



