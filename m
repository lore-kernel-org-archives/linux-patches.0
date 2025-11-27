Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C70D3346BA;
	Thu, 27 Nov 2025 15:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255667; cv=none; b=ujh2Q/RHHpn8oeNZ9Mb05Uydy5YVQTYJR3ZVz9SHE/DcRqO1sNQ6/uRbAVJYDS0oKx6GBRugyEEqmqv4xn1j3lg5lLN+cIas3gQo1RIltYrGKZta9Rc95QHuIXvS5QWhNRE6bz3/yrWNTdbQwDY0ZydjzZhw/b+k1J4IhiNHbio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255667; c=relaxed/simple;
	bh=O9oW7CgrZCsalvh2pf0aC15sO7a/DLOQ9WsJyn74aek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0M4DGte0qZSE5aE2DPxciQA/2jMeZ+AM3ufmjstV96trlaorVP+ink5xOgQvRPycXQrcNU7VMdnA36u8flg04AAsSKMJFXrVqjmwg490uR+2jLYnWvKT0VkycyDMjdOtkDOtVY9e68qEdttlkiwmt6pVbURxcV1Q1Hk0KWkHsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WW3YNAca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WW3YNAca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561B1C4CEF8;
	Thu, 27 Nov 2025 15:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255664;
	bh=O9oW7CgrZCsalvh2pf0aC15sO7a/DLOQ9WsJyn74aek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WW3YNAcay9k83s/qdr4DhiQY1jNNG7qpjJ7oVO9nUPc/yThyeA8QtycQZSov+ydzL
	 xPP+DZtQu+/SBJuJrdQuldun7fxE7EzzjfkU05yUh4I5ur7p9XIuclzMCaRHlLh7fl
	 WQbSvX6xg5sTWokBWVAd9lIusoqUjNejTdpi7zXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zha <Yifan.Zha@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 072/175] drm/amdgpu: Skip emit de meta data on gfx11 with rs64 enabled
Date: Thu, 27 Nov 2025 15:45:25 +0100
Message-ID: <20251127144045.595939717@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

From: Yifan Zha <Yifan.Zha@amd.com>

commit 80d8a9ad1587b64c545d515ab6cb7ecb9908e1b3 upstream.

[Why]
Accoreding to CP updated to RS64 on gfx11,
WRITE_DATA with PREEMPTION_META_MEMORY(dst_sel=8) is illegal for CP FW.
That packet is used for MCBP on F32 based system.
So it would lead to incorrect GRBM write and FW is not handling that
extra case correctly.

[How]
With gfx11 rs64 enabled, skip emit de meta data.

Signed-off-by: Yifan Zha <Yifan.Zha@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8366cd442d226463e673bed5d199df916f4ecbcf)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -5874,9 +5874,9 @@ static void gfx_v11_0_ring_emit_ib_gfx(s
 		if (flags & AMDGPU_IB_PREEMPTED)
 			control |= INDIRECT_BUFFER_PRE_RESUME(1);
 
-		if (vmid)
+		if (vmid && !ring->adev->gfx.rs64_enable)
 			gfx_v11_0_ring_emit_de_meta(ring,
-				    (!amdgpu_sriov_vf(ring->adev) && flags & AMDGPU_IB_PREEMPTED) ? true : false);
+				!amdgpu_sriov_vf(ring->adev) && (flags & AMDGPU_IB_PREEMPTED));
 	}
 
 	amdgpu_ring_write(ring, header);


