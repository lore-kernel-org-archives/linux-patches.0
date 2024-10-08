Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D7E1DE2CF;
	Tue,  8 Oct 2024 12:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392034; cv=none; b=F0MRt/fkvHFUmp0gWBjbF+ds4cg2iA5ftL+ZAL7acE+J4jf++d5d/A8GQ+XEajXtC8LOGoo6Omx/CXIPmiMaBUePnPgaU46fFeZhqG47tJF1pV/Vcw6lhixd+fkVc7+1+AxirGAsScdC8y+thCEt0IpTKrW22LBhUZoKsKuHeUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392034; c=relaxed/simple;
	bh=He2yA67+LiQyTNfPSPvuBpZYtN3wyq+s3qChVi3zmfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFClsvq6eOisyR3c1FOkIzPaksVhXnmwjQ2s2208gNZUyDqEbgpNdLD4FFCp+31srqnUN3hGX/TDJ9Qd39wfgr7075xW5wW3c3t3d5C2JgouGia+NnaCB5909hZ1H0tXZNXRTF3zwLTSv10TIwUgMWKJMAOJrubSuCZgUeAlI34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZFPSb+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZFPSb+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29309C4CECD;
	Tue,  8 Oct 2024 12:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392034;
	bh=He2yA67+LiQyTNfPSPvuBpZYtN3wyq+s3qChVi3zmfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZFPSb+ZOljKHlla+KOt4//T3pKIy+g+51vE1oNu6xS3fwAyL00frTWFLLbsp/lix
	 X4WDNsJtG+AR7zXwjERbtLITGCia4w+75cl75/TN9j+6Uoa53KNRtN6ut76naSoVJC
	 3Dqyo29gG0zRGsKwDc6somlDnpOPTPAAPA6FBCf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 296/558] drm/amdgpu/gfx11: use rlc safe mode for soft recovery
Date: Tue,  8 Oct 2024 14:05:26 +0200
Message-ID: <20241008115713.970411933@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 3f2d35c325534c1b7ac5072173f0dc7ca969dec2 ]

Protect the MMIO access with safe mode.

Acked-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 228124b389541..b80b1b6f2eea7 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -6008,7 +6008,9 @@ static void gfx_v11_0_ring_soft_recovery(struct amdgpu_ring *ring,
 	value = REG_SET_FIELD(value, SQ_CMD, MODE, 0x01);
 	value = REG_SET_FIELD(value, SQ_CMD, CHECK_VMID, 1);
 	value = REG_SET_FIELD(value, SQ_CMD, VM_ID, vmid);
+	amdgpu_gfx_rlc_enter_safe_mode(adev, 0);
 	WREG32_SOC15(GC, 0, regSQ_CMD, value);
+	amdgpu_gfx_rlc_exit_safe_mode(adev, 0);
 }
 
 static void
-- 
2.43.0



