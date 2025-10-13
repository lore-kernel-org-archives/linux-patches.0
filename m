Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E9A2566;
	Mon, 13 Oct 2025 15:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369362; cv=none; b=Pd3pWSZe3MtEQtbLKw+rOl8JQ4qZhM9azz2efzlhrYcMLALKEUcKlaxQEU5xGXw4329r8/R2NpvS9E56xz//BQxR84A+x5RIgT8qjNnPiboIDeLnXe2bMfWKZxZe6R431NLMAK3ylETesT3W954s5dDJRyCpbg1Td1/6Dd6AB1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369362; c=relaxed/simple;
	bh=CgsdYLg+PG22/uUyoMNz0O/yuoxc9kpKkUGoO0AVeSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiGOfck1VX/66e0mDTrwsaQW4p0vbuD/Yu5qXWH3TiC7ievxEetjR0hJvkmxg2xqRH7QNCjn4ug4kQpnguvavXSshH8D7GqO+Ok3GW1ur/GYARzXqJr3CXnLbJgfXv20S756pK4f1iIoKgQuQZUxgCYn0qKjdzY9M2dFx05/wqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+6lJbjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+6lJbjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152DAC4CEE7;
	Mon, 13 Oct 2025 15:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369362;
	bh=CgsdYLg+PG22/uUyoMNz0O/yuoxc9kpKkUGoO0AVeSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+6lJbjlQ1u53CxqNG+Po1JJB7FUR6EtBPh7xuWVOH3xgjioBzjEcFn/R52qbXtF5
	 vQz9l8uGJwkTTPnz7nJy3H1aerKvpi3UgTxujX6Mi2x+vR+goMmOxSe85PMrb1VSDA
	 YGoXWvNKx/xU4L7Bn7N+NoY9OiR4uG4O/pprJt24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 219/563] drm/amdgpu: Fix jpeg v4.0.3 poison irq call trace on sriov guest
Date: Mon, 13 Oct 2025 16:41:20 +0200
Message-ID: <20251013144419.216501087@linuxfoundation.org>
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

[ Upstream commit d3d73bdb02e8cc4a1b2b721a42908504cd18ebf9 ]

Sriov guest side doesn't init ras feature hence the poison irq shouldn't
be put during hw fini.

[25209.467154] Call Trace:
[25209.467156]  <TASK>
[25209.467158]  ? srso_alias_return_thunk+0x5/0x7f
[25209.467162]  ? show_trace_log_lvl+0x28e/0x2ea
[25209.467166]  ? show_trace_log_lvl+0x28e/0x2ea
[25209.467171]  ? jpeg_v4_0_3_hw_fini+0x6f/0x90 [amdgpu]
[25209.467300]  ? show_regs.part.0+0x23/0x29
[25209.467303]  ? show_regs.cold+0x8/0xd
[25209.467304]  ? amdgpu_irq_put+0x9e/0xc0 [amdgpu]
[25209.467403]  ? __warn+0x8c/0x100
[25209.467407]  ? amdgpu_irq_put+0x9e/0xc0 [amdgpu]
[25209.467503]  ? report_bug+0xa4/0xd0
[25209.467508]  ? handle_bug+0x39/0x90
[25209.467511]  ? exc_invalid_op+0x19/0x70
[25209.467513]  ? asm_exc_invalid_op+0x1b/0x20
[25209.467518]  ? amdgpu_irq_put+0x9e/0xc0 [amdgpu]
[25209.467613]  ? amdgpu_irq_put+0x5f/0xc0 [amdgpu]
[25209.467709]  jpeg_v4_0_3_hw_fini+0x6f/0x90 [amdgpu]
[25209.467805]  amdgpu_ip_block_hw_fini+0x34/0x61 [amdgpu]
[25209.467971]  amdgpu_device_fini_hw+0x3b3/0x467 [amdgpu]

Fixes: 1b2231de4163 ("drm/amdgpu: Register aqua vanjaram jpeg poison irq")
Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Stanley.Yang <Stanley.Yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
index b86288a69e7b7..a78144773fabb 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -444,7 +444,7 @@ static int jpeg_v4_0_3_hw_fini(struct amdgpu_ip_block *ip_block)
 			ret = jpeg_v4_0_3_set_powergating_state(ip_block, AMD_PG_STATE_GATE);
 	}
 
-	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__JPEG))
+	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__JPEG) && !amdgpu_sriov_vf(adev))
 		amdgpu_irq_put(adev, &adev->jpeg.inst->ras_poison_irq, 0);
 
 	return ret;
-- 
2.51.0



