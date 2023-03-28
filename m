Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1F68BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB64C433D2;
	Tue, 28 Mar 2023 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015819;
	bh=f9FdH9zwOoW1vm4Ust8+KYJDSMeinCSbsWbTMuDnivI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtdkqQlwlMLmRp7FxVLHafAzwA5Z0biAf262vlEOh8CfB7+ITIkhlQFObE4ncXjQU
	 9FrbsFU2Y3RKJAKSGKeKbHj2Lecv4Ww4klqk7b9NQQRFQwdFWspMFY+/cWabrxpKT/
	 87WKezx55x/CpcZ2w0xbZIuEKq4GxsriZbKoI5lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lyndonli <Lyndon.Li@amd.com>,
	Guchun Chen <guchun.chen@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/224] drm/amdgpu: Fix call trace warning and hang when removing amdgpu device
Date: Tue, 28 Mar 2023 16:42:22 +0200
Message-Id: <20230328142623.453599655@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: lyndonli <Lyndon.Li@amd.com>

[ Upstream commit 93bb18d2a873d2fa9625c8ea927723660a868b95 ]

On GPUs with RAS enabled, below call trace and hang are observed when
shutting down device.

v2: use DRM device unplugged flag instead of shutdown flag as the check to
prevent memory wipe in shutdown stage.

[ +0.000000] RIP: 0010:amdgpu_vram_mgr_fini+0x18d/0x1c0 [amdgpu]
[ +0.000001] PKRU: 55555554
[ +0.000001] Call Trace:
[ +0.000001] <TASK>
[ +0.000002] amdgpu_ttm_fini+0x140/0x1c0 [amdgpu]
[ +0.000183] amdgpu_bo_fini+0x27/0xa0 [amdgpu]
[ +0.000184] gmc_v11_0_sw_fini+0x2b/0x40 [amdgpu]
[ +0.000163] amdgpu_device_fini_sw+0xb6/0x510 [amdgpu]
[ +0.000152] amdgpu_driver_release_kms+0x16/0x30 [amdgpu]
[ +0.000090] drm_dev_release+0x28/0x50 [drm]
[ +0.000016] devm_drm_dev_init_release+0x38/0x60 [drm]
[ +0.000011] devm_action_release+0x15/0x20
[ +0.000003] release_nodes+0x40/0xc0
[ +0.000001] devres_release_all+0x9e/0xe0
[ +0.000001] device_unbind_cleanup+0x12/0x80
[ +0.000003] device_release_driver_internal+0xff/0x160
[ +0.000001] driver_detach+0x4a/0x90
[ +0.000001] bus_remove_driver+0x6c/0xf0
[ +0.000001] driver_unregister+0x31/0x50
[ +0.000001] pci_unregister_driver+0x40/0x90
[ +0.000003] amdgpu_exit+0x15/0x120 [amdgpu]

Signed-off-by: lyndonli <Lyndon.Li@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index cfd78c4a45baa..4feedf518a191 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1312,7 +1312,7 @@ void amdgpu_bo_release_notify(struct ttm_buffer_object *bo)
 
 	if (!bo->resource || bo->resource->mem_type != TTM_PL_VRAM ||
 	    !(abo->flags & AMDGPU_GEM_CREATE_VRAM_WIPE_ON_RELEASE) ||
-	    adev->in_suspend || adev->shutdown)
+	    adev->in_suspend || drm_dev_is_unplugged(adev_to_drm(adev)))
 		return;
 
 	if (WARN_ON_ONCE(!dma_resv_trylock(bo->base.resv)))
-- 
2.39.2



