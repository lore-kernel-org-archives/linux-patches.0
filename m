Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBB6344044;
	Sat, 28 Feb 2026 17:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301557; cv=none; b=Df496F0aK+I3dRs61BwH7q08iy4hNl1ebWCUTOuaq3/2uJGpUwnWZWLX1gElPcjTMHtDcwFw8DPqZz0c5qfxmhnq8pWuviK0T5YYh2qT3UDagVBc4yCEsmGR27FtnIngx33JTJf5ozNAocnZzkYnhMQNVbs1txAClf46bVeT1wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301557; c=relaxed/simple;
	bh=RoatinsszV997m9+MV8CsOROBPrtaPYyDnvljB0ZmME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OERTW7ktguuHXOX/K8ghLT7jRgVT0i0049NrfOCzrYKDL3yuhaRKnFG6ulWez46AOmKCQEBDwvmXIOMcW0P180b0qAxhk7YUI6/MVsU0yGa1vEA38y9GZJK+LQWXFetzeygJrsUnHUZkugG9UN0vehGJhfJpgEe1Iu3P9/1czuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eRDKRyUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRDKRyUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D22C116D0;
	Sat, 28 Feb 2026 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301557;
	bh=RoatinsszV997m9+MV8CsOROBPrtaPYyDnvljB0ZmME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRDKRyUryTIei+Z8+Rudp/mTfgeM4i3o5KC7ErRcw8Hga4Iu03jMwo0TOy6pwSrlu
	 dydd5hjOJ8r6WnhLsKhwj72zdHUS7ZujGNOIggCIEP+Hef/GFblf2O/blHmOihw4BL
	 JGBw3AP68MEcDBA+EXAKG+RVQLXY6ZTeeuNlTuPSwYTi55eqkj6XRaxFS3zEq65nIR
	 onDkFS5Mi88pYtngkIy+/ajYJ1+y0eXRzlcTDVJHn6ppkPQ7ZGCzQxONdJRjRPYCKp
	 DzHNgl3KiHVrHEm3OKay20eNpRrVampXFYEO4NmhspWspvfSIb37yuLhbDNyUTzIal
	 SMJFNKF6EyqzA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alex Deucher <alexander.deucher@amd.com>,
	Mario Kleiner <mario.kleiner.de@gmail.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 741/752] drm/amdgpu: keep vga memory on MacBooks with switchable graphics
Date: Sat, 28 Feb 2026 12:47:32 -0500
Message-ID: <20260228174750.1542406-741-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 01ad5cc008a96..1e3b8a506d1b9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -1013,6 +1013,16 @@ void amdgpu_gmc_get_vbios_allocations(struct amdgpu_device *adev)
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

