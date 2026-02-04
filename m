Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B224541B34E;
	Wed,  4 Feb 2026 15:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218801; cv=none; b=HMDQ720xIEUThYDOAAu8gfFbcC730UlIP7ehNnx07HM2V54+PckMnIcGGjBDjLwQnXN4iUQvHLXlYHRXW+3mnTMy5E4/HOlYWx+XFUefmGtX4nSiyKOBmTRNR+A2AWDUeK03O9ikUlFONl6/yu6YX1Ztm3InQTeJhR1KdD6nifY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218801; c=relaxed/simple;
	bh=kSKJiO9svrg/HDpYMg5XNtQvCyV0Ld2qH6ShONhGK1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zr4WNTKIXnEKFavGjqFcYvMZ8stZvSdh7MQLcu2taCcSTC+zpOqE4WjdFRhKjGYR8r41gQ5HQyIvOMagqhNHnodUYcVhRA6AQD8pasxndo0kdw5Bh3PLr16P7eyfEcG1e+TTaeunqRCdd3w/VJwJfkltZPdJ7plWbegp7w2OPo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SaBPR1NF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaBPR1NF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A71BC4CEF7;
	Wed,  4 Feb 2026 15:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218801;
	bh=kSKJiO9svrg/HDpYMg5XNtQvCyV0Ld2qH6ShONhGK1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaBPR1NFkEnHN5hOZ4GC1c7OApBkK04WxYSIgN8JaoDUsDJqJj8LcJVt26rgxqtaW
	 CFn41RtQY7t+C8WBKAjNexzR7v3/wTuBGsmHIZcjQApP6pGDnwhWEUXckFYUco3+dA
	 GmJatZonNoYfoY3AIq5BW81PSvQXJG8XcFI/9x3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 66/87] drm/amdgpu: Fix cond_exec handling in amdgpu_ib_schedule()
Date: Wed,  4 Feb 2026 15:41:04 +0100
Message-ID: <20260204143849.293416525@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b1defcdc4457649db236415ee618a7151e28788c upstream.

The EXEC_COUNT field must be > 0.  In the gfx shadow
handling we always emit a cond_exec packet after the gfx_shadow
packet, but the EXEC_COUNT never gets patched.  This leads
to a hang when we try and reset queues on gfx11 APUs.

Fixes: c68cbbfd54c6 ("drm/amdgpu: cleanup conditional execution")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4789
Reviewed-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ba205ac3d6e83f56c4f824f23f1b4522cb844ff3)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -223,7 +223,7 @@ int amdgpu_ib_schedule(struct amdgpu_rin
 
 	amdgpu_ring_ib_begin(ring);
 
-	if (ring->funcs->emit_gfx_shadow)
+	if (ring->funcs->emit_gfx_shadow && adev->gfx.cp_gfx_shadow)
 		amdgpu_ring_emit_gfx_shadow(ring, shadow_va, csa_va, gds_va,
 					    init_shadow, vmid);
 
@@ -279,7 +279,8 @@ int amdgpu_ib_schedule(struct amdgpu_rin
 				       fence_flags | AMDGPU_FENCE_FLAG_64BIT);
 	}
 
-	if (ring->funcs->emit_gfx_shadow && ring->funcs->init_cond_exec) {
+	if (ring->funcs->emit_gfx_shadow && ring->funcs->init_cond_exec &&
+	    adev->gfx.cp_gfx_shadow) {
 		amdgpu_ring_emit_gfx_shadow(ring, 0, 0, 0, false, 0);
 		amdgpu_ring_init_cond_exec(ring, ring->cond_exe_gpu_addr);
 	}


