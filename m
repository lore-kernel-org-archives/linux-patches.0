Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585775;
	b=EfLFhEfiMnCbpFNkeTeoizCbC66NVdAMH1eIRsSshLSbLQXUbuB55mg9Ig2ECX6Awb8n
	 NIfZDlrD5y2RwuT8UTBObmKFrIpCkhH8cWG5i93W3nQlnn9C1oXu2G9HQnQ3kreqXeaZj
	 4gUXi0RIFSuHnSjc40nutmaWTkdExXo/zY3EUhKu5AjaZXt76Qzxm3uM9ct9SzwaV2ONM
	 lrIkArw3WdxT/T6mOUvwolTT/gly4m+Bxq2wVRH/VOoZxObqYQeHF9eet2CXZfoGn0uIR
	 OoIM1TPU9ouGsdJyiOPhKKJfbCpuvg2sne00WNrLw5ZSI/DYJ1s7yI3RGQrz+ZahSDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lxGn9W8+iv4iICWInkpfzLwnbaHnia3P6IWORHDdajg=;
	b=eHAKHMLjMS7HhgCh4c4qca1VA6e7bFhdZusXRsbJt13v7wRrCnEHRBstF21I+LqwBYla
	 FJLT5Nx+UkFlsDSkSYCAmFvJmRosUUO2CyfIlXG9b3TFeOOgMBK0LqtkxmftQsuRl/Rv8
	 PkGve9LEX1/yjkVi7szqjgMbjQpNQ0XC7JVAlQzz25zIxw7hDVuOGUltYVG9jqNDt+RZz
	 yVztxTqisDJBbUF7rJ2YS+Iq2IlKpihUCzsX7gxKf85sMF4KVQ4bATOv3g9owCHmYIrIO
	 6dQBh4FWViPWx4SNEAT3FOZTUhyc+HP1NSI3kAhuhgDq39vdz+S06J1USFtcX/7efjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qi/VTcgV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7055E606D45A;
	Fri, 13 Nov 2026 16:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qi/VTcgV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD8C1F000C4;
	Fri, 13 Nov 2026 16:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585775;
	bh=lxGn9W8+iv4iICWInkpfzLwnbaHnia3P6IWORHDdajg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qi/VTcgV5vvYF88+7ljmo8R/xwe4sjHxM0cCgdMgp/FJ6Uqjxbv9ZbmL1eZyHhyXI
	 9PJhyT7Jjes9DxxHdgxSc2sU0Dxjc78xJJDL/C8g26JBdwQJr60h8yhrIfJxr4q6kO
	 56dbKCZeqnKUSKXSIkwxtjWDfn/wUpLiMFjkpjhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 364/507] drm/amdgpu/gfx12: disallow GFXOFF while updating the SPM VMID
Date: Fri, 13 Nov 2026 10:51:08 -0500
Message-ID: <20261113153808.313799274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit d1551515a3258b43cba60bd7f45bbdd1f4e9e60a ]

gfx_v12_0_update_spm_vmid() does a read-modify-write of RLC_SPM_MC_CNTL
over MMIO without keeping GFX powered, unlike gfx11. When GFX is in
GFXOFF at that point the update doesn't stick, and with the SPM VMID
programmed on submission again, the job of a process with a reserved
VMID can still run with the SPM writing through VMID 0.

On navi48, after a few other submissions and a VM fault on the same VM,
a COPY_DATA of RLC_SPM_MC_CNTL from such a job reads 0 although the
update was called for it:

  $ amd_uapi_regression --run-subtest cs-secure-ib-compute,gem-mapping-info-high-va,gpuvm-fault-high-va,reserved-vmid-spm-vmid
  amdgpu 0000:03:00.0: [gfxhub] page fault (src_id:0 ring:40 vmid:7 pasid:185)
  amdgpu 0000:03:00.0: 	 Faulty UTCL2 client ID: SDMA1 (0xe)
  RLC_SPM_MC_CNTL in the job: 0x00000000

With GFXOFF disallowed around the update it reads the reserved VMID 15.

Fixes: 52cb80c12e8a ("drm/amdgpu: Add gfx v12_0 ip block support (v6)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 907aebc5578ae09fa5c0e2f0784201295837e60b)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index d69c43f1e194c..60debaa23762d 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -4080,6 +4080,7 @@ static void gfx_v12_0_update_spm_vmid(struct amdgpu_device *adev,
 {
 	u32 reg, data;
 
+	amdgpu_gfx_off_ctrl(adev, false);
 	reg = SOC15_REG_OFFSET(GC, 0, regRLC_SPM_MC_CNTL);
 	if (amdgpu_sriov_is_pp_one_vf(adev))
 		data = RREG32_NO_KIQ(reg);
@@ -4093,6 +4094,7 @@ static void gfx_v12_0_update_spm_vmid(struct amdgpu_device *adev,
 		WREG32_SOC15_NO_KIQ(GC, 0, regRLC_SPM_MC_CNTL, data);
 	else
 		WREG32_SOC15(GC, 0, regRLC_SPM_MC_CNTL, data);
+	amdgpu_gfx_off_ctrl(adev, true);
 
 	if (ring
 	    && amdgpu_sriov_is_pp_one_vf(adev)
-- 
2.53.0



