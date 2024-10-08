Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2811D27B3;
	Tue,  8 Oct 2024 12:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390239; cv=none; b=iz0LmUGnL8L7GGr9h1T0mhHjvryk+esoOcklBmmAUaZj8DaYEMqQT3GKErPyvStacxKiGOyRZ22PLafoiukFhz2QM62Ws0nIOaksCjZQnr6qQEUdYbobL0Qs0eplEt7pJCzfEl7JRculgBZmENQtUON2cBDZxV6GHk8N8UHcZMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390239; c=relaxed/simple;
	bh=lU0vmN1yUuplXu4/fS8WLPq/fLuDnAL1gE8jCC3j0YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3tqIYKHHIcsHHSFWT0gHM541ojl3t1TmHVIcWJ2GvyGd0zwvbXI019hX1N9CBSnkB3Lz3QpawJ31/OZcMR9N3HJqh21m7jW25CJRyCHkp0hkDDgNgcI8KQNEpRQIiQKXDAaLGB8zZ64S95VzlLJEAMayy/tawKopEZUgQvwF8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYKlsiIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYKlsiIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23EFC4CEC7;
	Tue,  8 Oct 2024 12:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390239;
	bh=lU0vmN1yUuplXu4/fS8WLPq/fLuDnAL1gE8jCC3j0YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYKlsiIuErCwgHRA9ILXMmZkq9+EWimNsj4AJPLTYPWRvQZ0fTUlMae1Yt0jcKlaF
	 tmBnvLHAIIq6muSvifD4nw7YjSOWtftDvZYMNus/rRSgZ/Rx605yAqQgKuzxthR0Ft
	 bUOS55G/oigwTMYDbagensRfjgamtRmBU8ZyJ4RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 232/482] drm/amdgpu/gfx9: use rlc safe mode for soft recovery
Date: Tue,  8 Oct 2024 14:04:55 +0200
Message-ID: <20241008115657.431146143@linuxfoundation.org>
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

[ Upstream commit 3ec2ad7c34c412bd9264cd1ff235d0812be90e82 ]

Protect the MMIO access with safe mode.

Acked-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index b278453cad6d4..d8d3d2c93d8ee 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -5701,7 +5701,9 @@ static void gfx_v9_0_ring_soft_recovery(struct amdgpu_ring *ring, unsigned vmid)
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



