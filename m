Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FD11DEFC5;
	Tue,  8 Oct 2024 12:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390276; cv=none; b=Ow4eZJ+CUg4dsNw3awnTl/5rJQGlsC3+z14+twymPWvonMuxY+OezpCxwLUkoxWcUIJNfcBmndCGiwaclIiZrRqxxPJSiENlWFYRqyV3xdnynD/3ZAmofoG1od6y6ZBg1WtMH6CohhkJWq7L6L3PZjL0IHUJlBad8nTaarkTgvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390276; c=relaxed/simple;
	bh=oNJ6stC/TYH34evsR7qcXX3mD/xitTbjDJN5Fk5UdZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUBMzLd1FFD1n5jfBJnefBwIqoMwuJLeLBJyCz7/JZTduvNHFoFgaIyyo16fwEhxSnIsemyWPuSjUBQk/zi9GZosyYQjlkudRHCmjvC6zN/Ga53HUOR1tJ+xMG30QuuqZRPrEnFp9/YCKjPHl8i3O0W3zrg6sm0ziSVXvY5wqBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGuLw6aO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGuLw6aO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92ACBC4CEC7;
	Tue,  8 Oct 2024 12:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390276;
	bh=oNJ6stC/TYH34evsR7qcXX3mD/xitTbjDJN5Fk5UdZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGuLw6aOF0xEuCLw3nO+sbjVWdEgWTzoVJmAqWr9OjEHRBM6TBVeRiW2WNdUH+d+9
	 j3AQvPTLsZzUcOlvK/4aURbn78l2siFNBhE/L4px1Mht16l1ctV2qh1r7eKEzV6z+P
	 4PT90MN8/AhzVTbwfjXnLkEZRm7xLophDMG4DJi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 242/482] drm/amdgpu/gfx10: use rlc safe mode for soft recovery
Date: Tue,  8 Oct 2024 14:05:05 +0200
Message-ID: <20241008115657.819464073@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit ead60e9c4e29c8574cae1be4fe3af1d9a978fb0f ]

Protect the MMIO access with safe mode.

Acked-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 536287ddd2ec1..6204336750c6a 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -8897,7 +8897,9 @@ static void gfx_v10_0_ring_soft_recovery(struct amdgpu_ring *ring,
 	value = REG_SET_FIELD(value, SQ_CMD, MODE, 0x01);
 	value = REG_SET_FIELD(value, SQ_CMD, CHECK_VMID, 1);
 	value = REG_SET_FIELD(value, SQ_CMD, VM_ID, vmid);
+	amdgpu_gfx_rlc_enter_safe_mode(adev, 0);
 	WREG32_SOC15(GC, 0, mmSQ_CMD, value);
+	amdgpu_gfx_rlc_exit_safe_mode(adev, 0);
 }
 
 static void
-- 
2.43.0



