Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591212;
	b=JxZnVbgzw+pK27hhHnLAHCIGUIDWk+8czOmH0bOxSHKOK+GhLJEWaBdh/3PtyvAiQfD2
	 5GXptKTUYyn9LyAGSkB2HibYzkGiDGZ2V0AezzJaUZ2upre7A0eXk6/5dMrNDvukMHlob
	 p8gV+VoTzojHioOLKWTMtBBB+1mE3R/zoRLbHojc9S2tax1Ztcv1OQX0e4bt53eeQvgy3
	 TEsyB7Dzxhr9nNi/TGnMzKMer7oo/HmJLx5B5W3Zvp07K/1VaAHpzr5ordXbqeHaHfWyn
	 GysZqbSdqC9DQM90T5gS5t/omUKv5TRqRtYnVHWuKhi0hsNSOLnaiQcbTVl52Z+erPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fgs8zvqAOe1RAopnhqrjSYS4Vff5HevabR+KhK9stXM=;
	b=3dha0rlpd3v7hPkiBVlAAQ3X1CaVhSBAF9MFaRHyQ3hVFm9jCaa9z1gZBfWcyolx8Zzz
	 ZUxd0wxZiDOUf8sw5iCv8Eyfz/y2KLn399oSVDzzpD26URfvkaD7qSNXr0eQQHt5Sohu2
	 kxUPfNBmdhX/SJngjGCA7H7yPP5vUl93plfSINcTNZoxoH/gqd1nTJQcu2zhNMx+JmJPJ
	 z3ORCOEzuSWD8vfH7H3CZ9LOylVMqQUUBwyUmngML/EJVnuOav8LB0dGSVMSsfDDZdrSn
	 OK1DZ0xcB0yFxaI4Rxo8KzVrnfrN07/gMk9Jt5265rDBlsIDlohqqF4lFBEYI6T1fig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QrJED7HL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B8D6075854;
	Fri, 13 Nov 2026 17:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QrJED7HL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FF51F000C4;
	Fri, 13 Nov 2026 17:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591212;
	bh=fgs8zvqAOe1RAopnhqrjSYS4Vff5HevabR+KhK9stXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QrJED7HLMWQ3fFzyJVGVYnYK8FShqW/8LwQRifVil1AK0QSQGei1OEvtPgbcdsM9+
	 MPUtw3hpAu6OYt3gt+iqfgIizJEC0SwoZjDOHXlfDLhIEqawgwm0Q2zCxQhmPnXwH+
	 CVQs6wf+GYNLqS3YoG+k87wErqhQDs54NhmSVUVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 346/670] drm/amdgpu/gfx12: disallow GFXOFF while updating the SPM VMID
Date: Fri, 13 Nov 2026 10:48:30 -0500
Message-ID: <20261113153823.560636773@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a076a314dc677..5282c2de1ec83 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -3828,6 +3828,7 @@ static void gfx_v12_0_update_spm_vmid(struct amdgpu_device *adev,
 {
 	u32 reg, data;
 
+	amdgpu_gfx_off_ctrl(adev, false);
 	reg = SOC15_REG_OFFSET(GC, 0, regRLC_SPM_MC_CNTL);
 	if (amdgpu_sriov_is_pp_one_vf(adev))
 		data = RREG32_NO_KIQ(reg);
@@ -3841,6 +3842,7 @@ static void gfx_v12_0_update_spm_vmid(struct amdgpu_device *adev,
 		WREG32_SOC15_NO_KIQ(GC, 0, regRLC_SPM_MC_CNTL, data);
 	else
 		WREG32_SOC15(GC, 0, regRLC_SPM_MC_CNTL, data);
+	amdgpu_gfx_off_ctrl(adev, true);
 
 	if (ring
 	    && amdgpu_sriov_is_pp_one_vf(adev)
-- 
2.53.0



