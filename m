Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1042E62CD;
	Thu,  3 Jul 2025 14:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554648; cv=none; b=NjOhrIhO7aaQT5r20KyHndULVEwMRFGXF8w8pXWnMMtNci0W+DMoKpwIuXsfIByoUq78gQukf3O19POzRNoVEk4ht00lIFtJnnSd/ZVjQqYiXUKI60ctVdzg5EkaYzLjBPFHrT6NPFK7JdHePb+RNweEMkEzTZSrJfDJuIpCIJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554648; c=relaxed/simple;
	bh=H7ZfXeNBWtvIv7hkh9MF5OG+I4JT5GtFnJctlIrS9cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8Ow8mQqN/i7MFPxnCJw12JpCR6sQsaXCC5ln8Cyf3JUtzW5t56G/18fs1ofu6AqAKBjtgINT0zSaOoFX2pgtbf+G56p+fjZgmognsio8qTYIdlZa0f2rf09F4ai+XL5B0orHIK9EtO3e8ztlPWC8kQIFzYm8hUIYgg9t3qrKRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKCEajnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKCEajnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCFEC4CEE3;
	Thu,  3 Jul 2025 14:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554648;
	bh=H7ZfXeNBWtvIv7hkh9MF5OG+I4JT5GtFnJctlIrS9cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKCEajnYl2MSiljgJ+KSztde+KLBy1FagpykG01cC2ZX9A7HY7XDYMqDHcIeRqInr
	 /h5pmirHPHlAQcoqh4NFQCRFqVj26KjQsGorjzyx36GEndnUI++DmDr2xbRF2hNjl6
	 Gb++p4NftszdoUR8Xz33V5qje1mME4UzFAXe0i5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruijing Dong <ruijing.dong@amd.com>,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 037/263] drm/amdgpu/vcn5.0.1: read back register after written
Date: Thu,  3 Jul 2025 16:39:17 +0200
Message-ID: <20250703144005.784797663@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

[ Upstream commit bf394d28548c3c0a01e113fdef20ddb6cd2df106 ]

The addition of register read-back in VCN v5.0.1 is intended to prevent
potential race conditions.

Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
index e0e84ef7f5686..9a142a21aaea8 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
@@ -809,6 +809,11 @@ static int vcn_v5_0_1_start(struct amdgpu_vcn_inst *vinst)
 	WREG32_SOC15(VCN, vcn_inst, regVCN_RB_ENABLE, tmp);
 	fw_shared->sq.queue_mode &= ~(FW_QUEUE_RING_RESET | FW_QUEUE_DPG_HOLD_OFF);
 
+	/* Keeping one read-back to ensure all register writes are done,
+	 * otherwise it may introduce race conditions.
+	 */
+	RREG32_SOC15(VCN, vcn_inst, regUVD_STATUS);
+
 	return 0;
 }
 
@@ -843,6 +848,11 @@ static void vcn_v5_0_1_stop_dpg_mode(struct amdgpu_vcn_inst *vinst)
 	/* disable dynamic power gating mode */
 	WREG32_P(SOC15_REG_OFFSET(VCN, vcn_inst, regUVD_POWER_STATUS), 0,
 		~UVD_POWER_STATUS__UVD_PG_MODE_MASK);
+
+	/* Keeping one read-back to ensure all register writes are done,
+	 * otherwise it may introduce race conditions.
+	 */
+	RREG32_SOC15(VCN, vcn_inst, regUVD_STATUS);
 }
 
 /**
@@ -918,6 +928,11 @@ static int vcn_v5_0_1_stop(struct amdgpu_vcn_inst *vinst)
 	/* clear status */
 	WREG32_SOC15(VCN, vcn_inst, regUVD_STATUS, 0);
 
+	/* Keeping one read-back to ensure all register writes are done,
+	 * otherwise it may introduce race conditions.
+	 */
+	RREG32_SOC15(VCN, vcn_inst, regUVD_STATUS);
+
 	return 0;
 }
 
-- 
2.39.5



