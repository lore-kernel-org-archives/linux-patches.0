Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A1F1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEF0C433C8;
	Mon, 21 Aug 2023 20:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648035;
	bh=0iHeBoxJF9I7wo2RyntRNXCFBuWwNcAKAv2oBA0EBgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ak1xnbXATDOv6JfArGBpqnCroCZUIpRg+aO2GYsVJ4S1lcNE4fpWKNKLJ7p3RZzJ6
	 KWzuy+jwWdb/pRMN6r1TQSlEs27ERgcflocX7r/2Fw5dFWL+Pm2AQUyobx0JDYX85h
	 d/SpGaXqQDfRdJT6B6ExVy6f7vb9gWlqyC4hu9mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guchun Chen <guchun.chen@amd.com>,
	Feifei Xu <Feifei.Xu@amd.com>,
	Longlong Yao <Longlong.Yao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 006/234] drm/amdgpu: fix calltrace warning in amddrm_buddy_fini
Date: Mon, 21 Aug 2023 21:39:29 +0200
Message-ID: <20230821194129.026032926@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Longlong Yao <Longlong.Yao@amd.com>

[ Upstream commit 01382501509871d0799bab6bd412c228486af5bf ]

The following call trace is observed when removing the amdgpu driver, which
is caused by that BOs allocated for psp are not freed until removing.

[61811.450562] RIP: 0010:amddrm_buddy_fini.cold+0x29/0x47 [amddrm_buddy]
[61811.450577] Call Trace:
[61811.450577]  <TASK>
[61811.450579]  amdgpu_vram_mgr_fini+0x135/0x1c0 [amdgpu]
[61811.450728]  amdgpu_ttm_fini+0x207/0x290 [amdgpu]
[61811.450870]  amdgpu_bo_fini+0x27/0xa0 [amdgpu]
[61811.451012]  gmc_v9_0_sw_fini+0x4a/0x60 [amdgpu]
[61811.451166]  amdgpu_device_fini_sw+0x117/0x520 [amdgpu]
[61811.451306]  amdgpu_driver_release_kms+0x16/0x30 [amdgpu]
[61811.451447]  devm_drm_dev_init_release+0x4d/0x80 [drm]
[61811.451466]  devm_action_release+0x15/0x20
[61811.451469]  release_nodes+0x40/0xb0
[61811.451471]  devres_release_all+0x9b/0xd0
[61811.451473]  __device_release_driver+0x1bb/0x2a0
[61811.451476]  driver_detach+0xf3/0x140
[61811.451479]  bus_remove_driver+0x6c/0xf0
[61811.451481]  driver_unregister+0x31/0x60
[61811.451483]  pci_unregister_driver+0x40/0x90
[61811.451486]  amdgpu_exit+0x15/0x447 [amdgpu]

For smu v13_0_2, if the GPU supports xgmi, refer to

commit f5c7e7797060 ("drm/amdgpu: Adjust removal control flow for smu v13_0_2"),

it will run gpu recover in AMDGPU_RESET_FOR_DEVICE_REMOVE mode when removing,
which makes all devices in hive list have hw reset but no resume except the
basic ip blocks, then other ip blocks will not call .hw_fini according to
ip_block.status.hw.

Since psp_free_shared_bufs just includes some software operations, so move
it to psp_sw_fini.

Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Longlong Yao <Longlong.Yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index db820331f2c61..39e54685653cc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -520,6 +520,8 @@ static int psp_sw_fini(void *handle)
 	kfree(cmd);
 	cmd = NULL;
 
+	psp_free_shared_bufs(psp);
+
 	if (psp->km_ring.ring_mem)
 		amdgpu_bo_free_kernel(&adev->firmware.rbuf,
 				      &psp->km_ring.ring_mem_mc_addr,
@@ -2657,8 +2659,6 @@ static int psp_hw_fini(void *handle)
 
 	psp_ring_destroy(psp, PSP_RING_TYPE__KM);
 
-	psp_free_shared_bufs(psp);
-
 	return 0;
 }
 
-- 
2.40.1



