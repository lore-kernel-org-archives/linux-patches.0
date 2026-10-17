Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F43F3A0E8B;
	Sat, 17 Oct 2026 16:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254233; cv=none; b=AO4EV7AeKUp+AbRGJBRfOBvuFLHFAiDz9TZZtdTab6M56vvZkrDKIqAwQoYyG5Z4zx6l9Qr+Ct76BYchQrhW4zYzcSt5Cm3eTpIsx8w0euX4bjgXvXJlXQOllNn0XIziFvDWivro7qH3mQKG5P3YEP9OG1Y0EUY9xC0jjayD41A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254233; c=relaxed/simple;
	bh=mOsivJd1Il/nLaOgFdbGzAUK7KixOQHRjqoNPtSZzX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoWhdocWZwBLql1VnYCJeMSCGd3skeeTpmOKwfzesUiMtTWi8jZc5nGsm2JYpC4SZfooB3D9ZQzctoZKib6Uikc41wpn33gvCqThhxxTw/XaGdmc1kF9VF4OEtWLx/QLoXr3pNusOsQgpPLkywjWBC7uD6rUd81exSY+MfzYBnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+HdI/th; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+HdI/th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EDC1F000C4;
	Sat, 17 Oct 2026 16:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254231;
	bh=sDfC/h0qfdaACgOeEE9ZD9AXLy1kRx+9NjtTNpHtb+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+HdI/th+lurJo9HJa+2yP2PZ0C4eFOHI2uLQunBPW3LpP6W19iNLIXBSjxg1sVK2
	 7lwzmZ5iQIIHOJyEj5oLG+nDTQX3cCfg2FjDYgEPiH9fxKM29lIIR+fWB/4YYlLvHV
	 z8tu4NNvfIRIXViJTfc8re1kG+G6GyJk/MpPERdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 377/869] drm/amdgpu: Fix kernel panic during driver load failure
Date: Sat, 17 Oct 2026 17:53:38 +0200
Message-ID: <20261017160046.783085941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

[ Upstream commit a279bd143b3c184358b658e43a057e31ee8c4de5 ]

Avoid kernel panic if MES init fails during driver load. The KIQ ring is
falsely marked as ready as ASICs that use MES, KIQ is owned by MES.

BUG: kernel NULL pointer dereference, address: 0000000000000000
RIP: 0010:gfx_v12_1_wait_reg_mem+0x5a/0x1f0 [amdgpu]
Call Trace:
 gfx_v12_1_ring_emit_reg_write_reg_wait+0x1f/0x30 [amdgpu]
 amdgpu_gmc_fw_reg_write_reg_wait+0xb2/0x190 [amdgpu]
 amdgpu_gmc_flush_gpu_tlb+0x1cc/0x230 [amdgpu]
 amdgpu_gart_invalidate_tlb+0x81/0xa0 [amdgpu]
 amdgpu_gart_unbind+0x72/0x90 [amdgpu]
 amdgpu_ttm_backend_unbind+0xa4/0xb0 [amdgpu]
 amdgpu_ttm_tt_unpopulate+0x13/0xd0 [amdgpu]
 amdttm_tt_unpopulate+0x29/0x70 [amdttm]
 ttm_bo_put+0x1eb/0x360 [amdttm]
 amdgpu_bo_free_kernel+0xf9/0x1f0 [amdgpu]
 amdgpu_ih_ring_fini+0x5a/0x90 [amdgpu]
 amdgpu_irq_fini_hw+0x58/0x80 [amdgpu]
 amdgpu_device_fini_hw+0x4e0/0x5b0 [amdgpu]
 amdgpu_driver_load_kms+0x60/0xa0 [amdgpu]
 amdgpu_pci_probe+0x28e/0x6d0 [amdgpu]
 pci_device_probe+0x19f/0x220
 really_probe+0x1ed/0x340
 driver_probe_device+0x1e/0x80
 __driver_attach+0xd3/0x1a0
 bus_for_each_dev+0x68/0xa0
 bus_add_driver+0x19f/0x270
 driver_register+0x5d/0xf0
 do_one_initcall+0xac/0x200
 do_init_module+0x1ec/0x280
 __se_sys_finit_module+0x2de/0x310
 do_syscall_64+0x6a/0x250
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4623b958dd6da0f4c3026afdf330626a09ecb0f0)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index 4d115538a9563..a076a314dc677 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -3398,10 +3398,19 @@ static int gfx_v12_0_cp_resume(struct amdgpu_device *adev)
 		gfx_v12_0_cp_gfx_enable(adev, true);
 	}
 
-	if (adev->enable_mes_kiq && adev->mes.kiq_hw_init)
+	if (adev->enable_mes_kiq && adev->mes.kiq_hw_init) {
 		r = amdgpu_mes_kiq_hw_init(adev);
-	else
+		/*
+		 * With MES, GFX KIQ ring is owned by the MES and is never
+		 * initialized/used directly by the driver, so it must
+		 * not be left flagged as ready. mes_v12_0_hw_init() clears
+		 * but clear here if MES init fails
+		*/
+		if (r)
+			adev->gfx.kiq[0].ring.sched.ready = false;
+	} else {
 		r = gfx_v12_0_kiq_resume(adev);
+	}
 	if (r)
 		return r;
 
-- 
2.53.0



