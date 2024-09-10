Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338A418E75B;
	Tue, 10 Sep 2024 09:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961594; cv=none; b=W42e46bPRRYfEGlsVDx/1XzTQRyF/fYL5xNLr+7X4HKqaenCMbhgoNpadDPvigUhsE+t2Sn2ZZIhGUPPd+oLExxvZysxCzAA8RTN1sOtbobndQYfzdNNUbcIdSfWOpO1zSlkamuB+rP9wlpRl+R3hEyw0c0m6g6d7BbD7lwRQsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961594; c=relaxed/simple;
	bh=MrFdSjJHDH62+z5anZ5Lhq6RG1MKozIWF4ywp5nnreE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsC7NkEagzVVM3GnWrPAw59fr/ertk/e6gG2bztrPlD+Ygm2ANd4mZMND8cwfIoS61wcpfRdgjyHKlL7pAbDJeGTjAMEWu7RdsFBypqKn7hhuFwPBQtR8wJPwMsExz2h1Yp5a04JpSoeNrv/GYofFcKx6NnMxg+vq5Zlup9+xHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCH3IVbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCH3IVbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFFDC4CEC3;
	Tue, 10 Sep 2024 09:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961593;
	bh=MrFdSjJHDH62+z5anZ5Lhq6RG1MKozIWF4ywp5nnreE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCH3IVbbWKKjkSJkxDPzTESkexHOoFwZqLUEC2vWNcgJo6qUOWsaeu4w5ydnd9XDz
	 ZBAxdn7FScrU4jUL7a3fiUgAjK+EEnQ8rNYsEN4RuQuI9liZGDUi7o2Y+JCWN6EmyP
	 YuXES/rffQrKd0z3Z3Be8VYKDmdAl9EfMUpnGMjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 122/375] drm/amdgpu: Fix register access violation
Date: Tue, 10 Sep 2024 11:28:39 +0200
Message-ID: <20240910092626.535472801@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit 9da0f7736763aa0fbf63bb15060c6827135f3f67 ]

fault_status is read only register. fault_cntl
is not accessible from guest environment.

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfxhub_v1_2.c | 8 +++++---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c    | 3 ++-
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c  | 8 +++++---
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfxhub_v1_2.c b/drivers/gpu/drm/amd/amdgpu/gfxhub_v1_2.c
index 77df8c9cbad2..9e10e552952e 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfxhub_v1_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfxhub_v1_2.c
@@ -627,9 +627,11 @@ static bool gfxhub_v1_2_query_utcl2_poison_status(struct amdgpu_device *adev,
 
 	status = RREG32_SOC15(GC, GET_INST(GC, xcc_id), regVM_L2_PROTECTION_FAULT_STATUS);
 	fed = REG_GET_FIELD(status, VM_L2_PROTECTION_FAULT_STATUS, FED);
-	/* reset page fault status */
-	WREG32_P(SOC15_REG_OFFSET(GC, GET_INST(GC, xcc_id),
-			regVM_L2_PROTECTION_FAULT_STATUS), 1, ~1);
+	if (!amdgpu_sriov_vf(adev)) {
+		/* clear page fault status and address */
+		WREG32_P(SOC15_REG_OFFSET(GC, GET_INST(GC, xcc_id),
+			 regVM_L2_PROTECTION_FAULT_CNTL), 1, ~1);
+	}
 
 	return fed;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index f7f492475102..bd55a7e43f07 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -671,7 +671,8 @@ static int gmc_v9_0_process_interrupt(struct amdgpu_device *adev,
 	    (amdgpu_ip_version(adev, GC_HWIP, 0) >= IP_VERSION(9, 4, 2)))
 		return 0;
 
-	WREG32_P(hub->vm_l2_pro_fault_cntl, 1, ~1);
+	if (!amdgpu_sriov_vf(adev))
+		WREG32_P(hub->vm_l2_pro_fault_cntl, 1, ~1);
 
 	amdgpu_vm_update_fault_cache(adev, entry->pasid, addr, status, vmhub);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c
index 7a1ff298417a..8d7267a013d2 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c
@@ -566,9 +566,11 @@ static bool mmhub_v1_8_query_utcl2_poison_status(struct amdgpu_device *adev,
 
 	status = RREG32_SOC15(MMHUB, hub_inst, regVM_L2_PROTECTION_FAULT_STATUS);
 	fed = REG_GET_FIELD(status, VM_L2_PROTECTION_FAULT_STATUS, FED);
-	/* reset page fault status */
-	WREG32_P(SOC15_REG_OFFSET(MMHUB, hub_inst,
-			regVM_L2_PROTECTION_FAULT_STATUS), 1, ~1);
+	if (!amdgpu_sriov_vf(adev)) {
+		/* clear page fault status and address */
+		WREG32_P(SOC15_REG_OFFSET(MMHUB, hub_inst,
+			 regVM_L2_PROTECTION_FAULT_STATUS), 1, ~1);
+	}
 
 	return fed;
 }
-- 
2.43.0



