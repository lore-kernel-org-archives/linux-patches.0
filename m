Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDA33A1E81;
	Tue, 13 Oct 2026 12:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893661; cv=none; b=nm3Dc3bg7l6Gd2swOnyl5ncyD/W+Uk7G7eAeANWAL0WF2RbtddFBmdxHkyK3/2YddRZuWoeVSrTbqUBMr6DaPaQfnL0fVS9jtvgbDNfmz6WyLv4MDVJ5PxSTpvWDMRM1rbJafFYPjFsHnZ6Ksf7gVLwjDscsZSVQ/KL6Xgk6zjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893661; c=relaxed/simple;
	bh=KrvbGl7d7ONXZMtMro9uSy1q1koc/XAKyijxke+idBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMsxEMWl5Qfd4k/9mKvAMteUIXc46+L6oQYLgFUscHu/zJdyibIEwx7A8ipuByLDsMMqpXjUVAe4rAThpX1zdGJI13R/rr1O/52A3K9MmGe3hNw0FW7BruOB9IJEt9DI+iZc5V1QHEpB6sGvC53U+/Lv6X6luzdeMS824uFx/A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jb1UTfne; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jb1UTfne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6DB1F000FF;
	Tue, 13 Oct 2026 12:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893660;
	bh=+LTouxthD5NB8WtV3zbBceFaNEhb6P5wqjZA7r2cRoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jb1UTfnexadSOWEp5QzfyOuR1kjFBhETf+nxSRSZjHWOBQmzgh0tdFlH4O+mbscMl
	 pr51gL/tklSVx4Jgd8MQZ+3REDMSTVGjP/8Z1Am4PB4z00Rn9b98aNALOQIhx0w6kU
	 rRzDEIebz0Gr9I6F5RyuZks280+ulsQ6vZQQcVD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 256/621] drm/amdgpu: Fix kernel panic during driver load failure
Date: Tue, 13 Oct 2026 13:34:11 +0200
Message-ID: <20261013112926.936794849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5358ee33914e8..433381f806b2b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -3473,10 +3473,19 @@ static int gfx_v12_0_cp_resume(struct amdgpu_device *adev)
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



