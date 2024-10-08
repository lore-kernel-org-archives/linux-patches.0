Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6351DE4CC;
	Tue,  8 Oct 2024 13:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393510; cv=none; b=GlI/FefsyDGxk4VGNzY7KwrKFbQA86g6Zd+bSmrSzqXDm97B0q3evQt0bU8R5K08Ek6sgOjwU8qkxszo1U2clbRoWDzYryKf1+hywz1qGDl34BbxJ/t1f6VO2eNhh7646B2vvqGwSZSfE0jewkLewdzdcncOxjYFR09WHh2UcLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393510; c=relaxed/simple;
	bh=wBXBKUNyccLju50gagsWv+mKClgiqtv+G3QfWf4eEfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGR2apeHaAINtB4fm0EuA2zAwAS2V/qVC4DvRahoC3SHovMxRRDRftiserLLcZER2PF59KQejy/NO59D044HLKlHewqKAhc8u/sxDSzU6DijhD9MeVjcHknM4u+5EObhCt9UFRAyvN7PPleJH+Y5opT/4bUm4XROUqv8spzNNKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2Qgl2cQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2Qgl2cQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1E5C4CEC7;
	Tue,  8 Oct 2024 13:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393510;
	bh=wBXBKUNyccLju50gagsWv+mKClgiqtv+G3QfWf4eEfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2Qgl2cQOFjKcl7HfoPjVMFndDrqo3OOh8KVQ/DvZ8jNsuZBg+sAGvr+8u3CO3AuE
	 OmFBGPe+fIEG0HUifvs/odCM8SthOsEJvA0eAdphDLsWpDnAtSxpt3Z3fooWy61Jt0
	 59GG5rNmFYEm4jC8oIb8seMGoz3qOY/HvD/ij8Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/386] drm/amdgpu/gfx11: use rlc safe mode for soft recovery
Date: Tue,  8 Oct 2024 14:06:59 +0200
Message-ID: <20241008115636.267769703@linuxfoundation.org>
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

[ Upstream commit 3f2d35c325534c1b7ac5072173f0dc7ca969dec2 ]

Protect the MMIO access with safe mode.

Acked-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index c813cd7b015e1..54ec9b32562c2 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -5701,7 +5701,9 @@ static void gfx_v11_0_ring_soft_recovery(struct amdgpu_ring *ring,
 	value = REG_SET_FIELD(value, SQ_CMD, MODE, 0x01);
 	value = REG_SET_FIELD(value, SQ_CMD, CHECK_VMID, 1);
 	value = REG_SET_FIELD(value, SQ_CMD, VM_ID, vmid);
+	amdgpu_gfx_rlc_enter_safe_mode(adev, 0);
 	WREG32_SOC15(GC, 0, regSQ_CMD, value);
+	amdgpu_gfx_rlc_exit_safe_mode(adev, 0);
 }
 
 static void
-- 
2.43.0



