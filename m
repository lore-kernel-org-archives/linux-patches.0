Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37251DEFF6;
	Tue,  8 Oct 2024 13:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393496; cv=none; b=TQ+W7MX3IDIqLxXMCW0jOrHLuvUEfkrfhR50/khruUI/YYAUvsRqr3drnSu+BKkbAW0YVPoQF1XozFKPfA7NrAq2VVUUb9kGwzvXsg3nVo1Z0P7JVa0Oqlzv81BYqbdDxdFXI5MY5ubDMPlxlzXXQha6Hm/CnZwu3IKMgkDOf9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393496; c=relaxed/simple;
	bh=DnzhjDEeo7QJZZ7eXc5jw4H9gTLCA8olWFEWhaxGVws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FI1qjW1WbPnMD4krdVokA09gk76O1R/85yN4aRddOqvWkXEY2duuLU9ge+gNrNrkwcp/eqPFzqGuwl1AIhiGicRdF2phbzEO2DVm4DawYStFIH1cajXgrHB2LppNIwCI1au6f4Wd06bVgeLmSQ7wSMcKyuniVMB/TDdG8M4BOrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbXIL10f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbXIL10f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11EDC4CEC7;
	Tue,  8 Oct 2024 13:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393496;
	bh=DnzhjDEeo7QJZZ7eXc5jw4H9gTLCA8olWFEWhaxGVws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VbXIL10fBqfbcdgZABfmZEI0AMkVrMFCxmfzkxBtyHLGk0Q0onTAxupmy3dBzchhV
	 PB65Z55riiz3/Tk0jq5JIT8NzD/58qnZ611jIHE8DxCkKNOxMxHpzmQdkzorE731pF
	 4FYit+xBKV5QwAo29z/nBo0+YdYDXdl68ivNsmrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/386] drm/amdgpu/gfx9: use rlc safe mode for soft recovery
Date: Tue,  8 Oct 2024 14:06:55 +0200
Message-ID: <20241008115636.112781065@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 00e693c47f3cc..895060f6948f3 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -5709,7 +5709,9 @@ static void gfx_v9_0_ring_soft_recovery(struct amdgpu_ring *ring, unsigned vmid)
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



