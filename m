Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AAD3B0AE5;
	Mon, 23 Mar 2026 14:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277738; cv=none; b=e+A+xOWSYa87r5KyWyHytPZDUcU9vcFHbkoPApUx/ubvRfUQARHEM9zjAeexYu797T6kpBO9bO+s0LRYLx5yEpzFa5N5LLwCqnQzXVvL+ZBXVGmXlbXhafxtRwGEuid7QErEqHH7fDyBHU1Mbt8vpB0n+qELCjiVwmahF+f0Luo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277738; c=relaxed/simple;
	bh=w1xXU4xAt9YTwbawzppVzsyN3pnETr8l/dzvd7ZXeUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqOq40AkCaiRcl97yX0ltNOFei/L0U3gKwFBO3Plqwehnk+4RvUiN/gi42JB2tkk5p9rThz86wAMLZCCFW/fGg9msnMMbtSkBVSFPQMikNr5usbnCKYqVyaKkJ9QBBjpSlxNWN64lio2VwxM0uZ6iKn0Cgc4t9YZX4hs+88x1dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Bg/HmXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Bg/HmXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2605C2BCB1;
	Mon, 23 Mar 2026 14:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277738;
	bh=w1xXU4xAt9YTwbawzppVzsyN3pnETr8l/dzvd7ZXeUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Bg/HmXq8g3Bn21tHrhygWjsC5/pHhWIoitT6l49pFs1SosTIpVNkq6o5lRrZ1cUi
	 dv/fwfvWupQQPVgmaJd3l3xvyim1CiM9s8PqaT2dKoQZzaIhIQnVuxxfLnQ7scHK90
	 VhLvzzV9Qhubn2p87u01hJ5CzgXpvHG5GAqf5X08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Kleiner <mario.kleiner.de@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/567] drm/amdgpu: keep vga memory on MacBooks with switchable graphics
Date: Mon, 23 Mar 2026 14:40:06 +0100
Message-ID: <20260323134535.956155446@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7d120d4175499..8cb192636368f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -728,6 +728,16 @@ void amdgpu_gmc_get_vbios_allocations(struct amdgpu_device *adev)
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



