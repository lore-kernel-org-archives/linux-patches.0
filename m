Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC201F1313;
	Mon, 13 Oct 2025 15:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369365; cv=none; b=tTjVftf/9OCa2QN8IUBMc7QGLQf+uxzE+dX3fqQyr7Htijv5ZN66BfzaafNgYr0VmBVwXQpTJRalyISw8LHT4FbmqJNTZz/JoFRaRfxjRBjbXvAD+7NeDqW8uPsaimU+6nR9hHIXKVZeynNDhlhthR3eC1XnYFdGLI7XeHwlJ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369365; c=relaxed/simple;
	bh=Wg2k9n5PK4OsCEeLGUMy8a9blhUx7n5sdWZ1G1PboNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0nvO/3liEc1qW6SrjQYvSc5wvO2V7KhHi6dSUMoPQOYS5XFCaUKHNIuKw2hufXaygqgBrQEkk2+06MNcZQ4ftknzMhXkPF560yMZcLHIgZHTepUA5aD0jZAfHGITTa8mGs7tBnOUV0+4BHdJA1TnE+LbPpqrbh7j72WRd1JWwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjSlCS8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjSlCS8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59DBC4CEE7;
	Mon, 13 Oct 2025 15:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369365;
	bh=Wg2k9n5PK4OsCEeLGUMy8a9blhUx7n5sdWZ1G1PboNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjSlCS8kU0cylmI1bb+1IUWMpMp159lAiqkUlPu2G49MDGWjrFmxVTd5V3azqCtiE
	 cDV8Scv9KvxnrlIw4wtOrhawqGO1SlYruhRTkHUJ69LyTzRT5EL+lSiMoqCpuKMY81
	 /IFStGhNhy5DVpYNW95f/BhYBADwqSDvJnXWYKfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 220/563] drm/amdgpu: Fix vcn v4.0.3 poison irq call trace on sriov guest
Date: Mon, 13 Oct 2025 16:41:21 +0200
Message-ID: <20251013144419.252736086@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit 58364f01db4a155356f92cce1474761d7a0eda3d ]

Sriov guest side doesn't init ras feature hence the poison irq shouldn't
be put during hw fini.

[25209.468816] Call Trace:
[25209.468817]  <TASK>
[25209.468818]  ? srso_alias_return_thunk+0x5/0x7f
[25209.468820]  ? show_trace_log_lvl+0x28e/0x2ea
[25209.468822]  ? show_trace_log_lvl+0x28e/0x2ea
[25209.468825]  ? vcn_v4_0_3_hw_fini+0xaf/0xe0 [amdgpu]
[25209.468936]  ? show_regs.part.0+0x23/0x29
[25209.468939]  ? show_regs.cold+0x8/0xd
[25209.468940]  ? amdgpu_irq_put+0x9e/0xc0 [amdgpu]
[25209.469038]  ? __warn+0x8c/0x100
[25209.469040]  ? amdgpu_irq_put+0x9e/0xc0 [amdgpu]
[25209.469135]  ? report_bug+0xa4/0xd0
[25209.469138]  ? handle_bug+0x39/0x90
[25209.469140]  ? exc_invalid_op+0x19/0x70
[25209.469142]  ? asm_exc_invalid_op+0x1b/0x20
[25209.469146]  ? amdgpu_irq_put+0x9e/0xc0 [amdgpu]
[25209.469241]  vcn_v4_0_3_hw_fini+0xaf/0xe0 [amdgpu]
[25209.469343]  amdgpu_ip_block_hw_fini+0x34/0x61 [amdgpu]
[25209.469511]  amdgpu_device_fini_hw+0x3b3/0x467 [amdgpu]

Fixes: 4c4a89149608 ("drm/amdgpu: Register aqua vanjaram vcn poison irq")
Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Stanley.Yang <Stanley.Yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
index 2a3663b551af9..52613205669e1 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -391,7 +391,7 @@ static int vcn_v4_0_3_hw_fini(struct amdgpu_ip_block *ip_block)
 			vinst->set_pg_state(vinst, AMD_PG_STATE_GATE);
 	}
 
-	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__VCN))
+	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__VCN) && !amdgpu_sriov_vf(adev))
 		amdgpu_irq_put(adev, &adev->vcn.inst->ras_poison_irq, 0);
 
 	return 0;
-- 
2.51.0



