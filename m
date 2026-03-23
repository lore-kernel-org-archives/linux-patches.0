Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DC73AC0D3;
	Mon, 23 Mar 2026 16:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282199; cv=none; b=drrcd5wDwK7OzofHY16yPboM0sd5xeTG7Pls40q+sY/Vo18XHzZaMkeTKbnUa8pJ8thJZ1EIj6bi8Gfcj333cv4V5aaILmjvVhHlk/yTQe0nqOq3BNu+PXrA3doo8hPLRJAkqmL/IDZEc5dJ6pZR2+CIkLnYyGGcObbAjTifK0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282199; c=relaxed/simple;
	bh=/UeWjjoZSQ0W9mzdRix6CgfyyaleJU06pK9FAOW9nq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+PFAsHfFu1Q5vVBWSQ+71YNt0Qd2CbfB+jXjwNA/FNTwZM+2SojGALPm3rXFBTnCnPWM2Ilin0OQoOMOmVhQgHJxdor3gnfDLwgE3vrSL04QL9To6PnReZSjUbf5CCGXoGKkxvApLVITl5ppP07fuZvz0r9HPXLTIQ4mh14oHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSjzBrDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSjzBrDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E4CC4CEF7;
	Mon, 23 Mar 2026 16:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282199;
	bh=/UeWjjoZSQ0W9mzdRix6CgfyyaleJU06pK9FAOW9nq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSjzBrDhpbOWFUcgr7WsrrOY5mLbZvk5nA0kgEIAjz5EndTQoM0ys+keExuBUqpZx
	 KSgWkD2XlWwjPqG9EKxM6lNhPGxgKuv1AiCe5dhfOh+fdQ8BIYHnD8jsx1tXhUbJwb
	 SfOUJ4r0S6P1raq4UFlezre1Yh7+thOluYFjQhdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Kleiner <mario.kleiner.de@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/481] drm/amdgpu: keep vga memory on MacBooks with switchable graphics
Date: Mon, 23 Mar 2026 14:40:50 +0100
Message-ID: <20260323134526.888122081@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 096bb75e13cc508d3915b7604e356bcb12b17766 ]

On Intel MacBookPros with switchable graphics, when the iGPU
is enabled, the address of VRAM gets put at 0 in the dGPU's
virtual address space.  This is non-standard and seems to cause
issues with the cursor if it ends up at 0.  We have the framework
to reserve memory at 0 in the address space, so enable it here if
the vram start address is 0.

Reviewed-and-tested-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4302
Cc: stable@vger.kernel.org
Cc: Mario Kleiner <mario.kleiner.de@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index 4bc05178504dc..3a1576e2f8e3b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -652,6 +652,16 @@ void amdgpu_gmc_get_vbios_allocations(struct amdgpu_device *adev)
 	case CHIP_RENOIR:
 		adev->mman.keep_stolen_vga_memory = true;
 		break;
+	case CHIP_POLARIS10:
+	case CHIP_POLARIS11:
+	case CHIP_POLARIS12:
+		/* MacBookPros with switchable graphics put VRAM at 0 when
+		 * the iGPU is enabled which results in cursor issues if
+		 * the cursor ends up at 0.  Reserve vram at 0 in that case.
+		 */
+		if (adev->gmc.vram_start == 0)
+			adev->mman.keep_stolen_vga_memory = true;
+		break;
 	default:
 		adev->mman.keep_stolen_vga_memory = false;
 		break;
-- 
2.51.0



