Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B231DDA36;
	Tue,  8 Oct 2024 13:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393517; cv=none; b=fPzTskIrCB5wadCK84f9WBmH5zRrSjeYjOne7XMOhdOSL7HpXh/za2wVqZA041KqPrQg5XahCwG3vPDMB+8vo6Ultxj2xpmr7zm933C5+OiMbGsEGDXQnbZWnkqYgqF8qrTsnVCL7QHO6x9AnGPlErc4Ro8OO96+E98Q4PJiHEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393517; c=relaxed/simple;
	bh=wD9TO7jQIysvVE2mTBlWAlZMcJySc+VBd/Ti4ls4m04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7qCF6tik4R0RTkdYdG7JE2l8jGbbfeocBHAayf997bLnxs3BQFPEaalKfSi+H+DjX1ltBqnoygX9fCE0ljiBp0O/HPWX90OLMDCmDOWQrQf4qv8+nV0aWWRI+QIrLk+80qPPyrepB+4/jpV8AORfbxH19Ks9Ept108dxuzLWPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsRAFyt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsRAFyt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A07C4CECC;
	Tue,  8 Oct 2024 13:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393517;
	bh=wD9TO7jQIysvVE2mTBlWAlZMcJySc+VBd/Ti4ls4m04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsRAFyt0mWWR1iXkdBNnsCRzv487wq0+bDSX3IRgrbXQjAEXKhgbYIbxCJnLVDW34
	 YNIljdrs5qOR0vDyxGZ5BZtLdLhKpBJ7QzDrlvtPxhx1TuDiIbpKHJQp/ALMlvtfPI
	 ebdduAIcz1exYiSAW7Kyt2UeP8GiiwzRecox1wPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/386] drm/amdgpu/gfx10: use rlc safe mode for soft recovery
Date: Tue,  8 Oct 2024 14:07:00 +0200
Message-ID: <20241008115636.305896668@linuxfoundation.org>
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

[ Upstream commit ead60e9c4e29c8574cae1be4fe3af1d9a978fb0f ]

Protect the MMIO access with safe mode.

Acked-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index cd594b92c6129..53c99bc6abb33 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -8748,7 +8748,9 @@ static void gfx_v10_0_ring_soft_recovery(struct amdgpu_ring *ring,
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



