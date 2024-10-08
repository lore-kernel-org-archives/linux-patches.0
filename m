Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862AD1CCB32;
	Tue,  8 Oct 2024 12:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392037; cv=none; b=e8QtopFt3Sq5AnMoxqYhuKiKZ7GfC0i8HO2JLcnzo78VOaylAF4GXfsOLKPFzTs/teTyVGZwzxrM8duRVBbkI+rHfE77GBgh5J6t2R9YjxDk/YnTxz5/pPYvyu0ct7xndmOKqNJwbwO0aD1TMFwcTSf+HwvPpMkenwH5gyRKe54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392037; c=relaxed/simple;
	bh=L+sldHu0w1X6PkZQfpnN0+J65ZpwdvMMl0IdZ5Uz1/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwPVGVOlc1HlbGtKB0P6ndCm3NXG7dclnRjYWviMAiNPrUzNA3ckL3J/gMz/zd6UYY/fekVjjhZzyjo9JNrMMQ2VyQmLfLsYAkuZjUH/I1cAgxSQT56z1RtE4Qc7p1ki8QxMun9CrD09NNEehsBgIS1ykm6q/YQbqJa3DnuHf1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDON8WYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDON8WYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4E8C4CEC7;
	Tue,  8 Oct 2024 12:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392037;
	bh=L+sldHu0w1X6PkZQfpnN0+J65ZpwdvMMl0IdZ5Uz1/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDON8WYriWrWGHy9wTXlJ9yQRCyNO3pZLD1CMtfWL2bSHWSLo/hOFnJoJjBPjO3Zf
	 pKdIzpdmYmEJqO+NEm9v4JSpeyWWwGHk43SxqYazXhJDR1+9GevGbNppuP2QLG4bSU
	 uDGwgGZpkrfa4VIctFMBLKqx/mkTlYgVGUtTbSQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 297/558] drm/amdgpu/gfx10: use rlc safe mode for soft recovery
Date: Tue,  8 Oct 2024 14:05:27 +0200
Message-ID: <20241008115714.008633477@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 5b41c6a44068c..1bb602c4f9b3f 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -8889,7 +8889,9 @@ static void gfx_v10_0_ring_soft_recovery(struct amdgpu_ring *ring,
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



