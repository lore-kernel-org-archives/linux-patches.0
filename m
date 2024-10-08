Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49D31DE2CF;
	Tue,  8 Oct 2024 12:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392031; cv=none; b=Enuyu45RxEHcZAt04dOAzJ/zDh4aYEPWx43Y0TOg76vszrp9u6DnkjZYn8NNtOfy60GE6S7M/ZV5IEoN5Ql08csapsM4YxH99dy6Kjh+rvFf1Whck/vWfCMhGFLgCAvarVo6vaIcgJBr2Nhnk6XvRGacN7DG0LGWlvE6xKxf3k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392031; c=relaxed/simple;
	bh=kK6YZPXm4QUlB3hk3hwDPvrHcsEghBXhrEBrw2/fIEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9hLN98caNxIRAAY2cHhWDpPrEJfWLkhn7qXYWD5TSaKj6RtW+dv1dTV8tSYzKmlN5pX+5nVuHm53bK/10GCgiOJREhs/20k54PYH8JJKdplh43c+j/NUVNgaFIx689u4qYrwi+9gdkANZ0KQ9TiGo2slWAUjFg61ytACLcBS7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgcIljIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgcIljIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49749C4CEC7;
	Tue,  8 Oct 2024 12:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392031;
	bh=kK6YZPXm4QUlB3hk3hwDPvrHcsEghBXhrEBrw2/fIEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NgcIljILhUYIpfFQXRYuIMVfp/IMAskMbNxIgKcRA+6EeXu80cZPeTcvlQVpgcrUJ
	 IrlF/fLe7LXp394Kjtcz4aKxD7GtRGWPPJ2O6Uvb14+5poAkjOELsT10WZWksQstaK
	 yhhFjMK2W4Zxwljzmt7vK/OkVsQkt+vqB1zimb5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 295/558] drm/amdgpu/gfx12: use rlc safe mode for soft recovery
Date: Tue,  8 Oct 2024 14:05:25 +0200
Message-ID: <20241008115713.931327596@linuxfoundation.org>
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

[ Upstream commit 21818f39beda2e843199e5d8d9e3f9e43c8080a3 ]

Protect the MMIO access with safe mode.

Acked-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index ac671656069a3..515fc7d6f8389 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -4613,7 +4613,9 @@ static void gfx_v12_0_ring_soft_recovery(struct amdgpu_ring *ring,
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



