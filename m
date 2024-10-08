Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152801DE886;
	Tue,  8 Oct 2024 12:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391994; cv=none; b=IIIrzhPMUvD4NCARDHFvQ5fFALHRVI+T29j7V+AglbvgCfX/P0lSWYr9pGWbFAJGpLMwedKyT2RFtuiIPA3pSQopDg9HedD4cwDKsJXqJpo2r8kxFuYnGzJnEF7o099ckg1r7AFsdbdLPSGFvm0ZaE95yWTWEfWOV4Gi1EyJMjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391994; c=relaxed/simple;
	bh=jU8tw2lZOfCcOAv107k6aaK7HIdat/i6PP8W9+DPciM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLU4QfEfvFOqgfnrAn+DLqaHLVYV/Q/eIuB+PRY76Z2FmqNfOvTrLVqXZRkzobRoNfRDf3RyazzWOxuZnxkF5fhSnP+dtkg1LxKaAP50btPca+teibXVC1oqnQrdg/nfw95deLoTOBtxNIK/fmP5AosaS0xNpm9BqJVxNnj3YYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEfh+eDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEfh+eDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880C0C4CEC7;
	Tue,  8 Oct 2024 12:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391993;
	bh=jU8tw2lZOfCcOAv107k6aaK7HIdat/i6PP8W9+DPciM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEfh+eDOjKdqtw/4zFacxeGqrDGF3x81R2kFywyZ43MqJ9dRYo15uG3yjlzBZdFpL
	 NaOnYoM8+95GfU0Z4ub4+lJUiU/SlpKGQY02mUzbE3vixWpEvP0IvDzulkiZaDngSf
	 lW1p7I/GAqgv24rQTMYQq0fmZHm925C8J41jk+Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 285/558] drm/amdgpu/gfx9: use rlc safe mode for soft recovery
Date: Tue,  8 Oct 2024 14:05:15 +0200
Message-ID: <20241008115713.542173704@linuxfoundation.org>
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

[ Upstream commit 3ec2ad7c34c412bd9264cd1ff235d0812be90e82 ]

Protect the MMIO access with safe mode.

Acked-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 6f178bfb8f104..02eb5bd9d7d82 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -5862,7 +5862,9 @@ static void gfx_v9_0_ring_soft_recovery(struct amdgpu_ring *ring, unsigned vmid)
 	value = REG_SET_FIELD(value, SQ_CMD, MODE, 0x01);
 	value = REG_SET_FIELD(value, SQ_CMD, CHECK_VMID, 1);
 	value = REG_SET_FIELD(value, SQ_CMD, VM_ID, vmid);
+	amdgpu_gfx_rlc_enter_safe_mode(adev, 0);
 	WREG32_SOC15(GC, 0, mmSQ_CMD, value);
+	amdgpu_gfx_rlc_exit_safe_mode(adev, 0);
 }
 
 static void gfx_v9_0_set_gfx_eop_interrupt_state(struct amdgpu_device *adev,
-- 
2.43.0



