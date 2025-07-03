Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D372EAD1B;
	Thu,  3 Jul 2025 14:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554651; cv=none; b=Ed5DJda89ffFfsNYVOTop5N+9GLK+LcDF8YIH0ev8XYyQdWe4GMEd1cOXaKGcUC14+CYdANbmTMbMYVMKHiDF+CH3TeL15K0E5fsx+IisyZ4MEATY7i1lQ9zo/brnohTKMPEANQwmp1UvE7zhqQQohhmu9o5V1HXtrIMgXlWRhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554651; c=relaxed/simple;
	bh=ANuY7rM2Lj6txqy9ZgokSKZ/+51nuxmLhAREGAlqeWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odqypsYLMpVulQ0AzNC/NnnxHbLAwXlv92krLCJh6XCssi2FRMHRn8U/HY/Lpd5Znq1OP32VZJhfJgLNfBob4wYalkWuIHTjVwORmy2YXvBAWe9hz+9tHx8+03lu1b2uEa0CJWiFu78NIaYMdW62uTPoCtCjBxYVQLYCDDl4q2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pDssVaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pDssVaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D390C4CEE3;
	Thu,  3 Jul 2025 14:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554651;
	bh=ANuY7rM2Lj6txqy9ZgokSKZ/+51nuxmLhAREGAlqeWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pDssVaERuxw3UKAf6LC7dzgrX19ezC23NCibwq3yFtP0Z9yqh7VkIC3C3tcoviRd
	 CV8N41IcKy8eCY0WIPi0HAYKvbvsulSmLtuLtDaM6zD1R9AYaQGJ+UxfeArSPpAqB5
	 pKL5bRkCETqh/hJZCIxQjoLf6FT827kCacUNduLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruijing Dong <ruijing.dong@amd.com>,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 038/263] drm/amdgpu/vcn4: read back register after written
Date: Thu,  3 Jul 2025 16:39:18 +0200
Message-ID: <20250703144005.834115133@linuxfoundation.org>
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

[ Upstream commit a3810a5e37c58329aa2c7992f3172a423f4ae194 ]

The addition of register read-back in VCN v4.0.0 is intended to prevent
potential race conditions.

Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
index 1f777c125b00d..4a88a4d37aeeb 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1122,6 +1122,11 @@ static int vcn_v4_0_start_dpg_mode(struct amdgpu_vcn_inst *vinst, bool indirect)
 			ring->doorbell_index << VCN_RB1_DB_CTRL__OFFSET__SHIFT |
 			VCN_RB1_DB_CTRL__EN_MASK);
 
+	/* Keeping one read-back to ensure all register writes are done,
+	 * otherwise it may introduce race conditions.
+	 */
+	RREG32_SOC15(VCN, inst_idx, regUVD_STATUS);
+
 	return 0;
 }
 
@@ -1303,6 +1308,11 @@ static int vcn_v4_0_start(struct amdgpu_vcn_inst *vinst)
 	WREG32_SOC15(VCN, i, regVCN_RB_ENABLE, tmp);
 	fw_shared->sq.queue_mode &= ~(FW_QUEUE_RING_RESET | FW_QUEUE_DPG_HOLD_OFF);
 
+	/* Keeping one read-back to ensure all register writes are done,
+	 * otherwise it may introduce race conditions.
+	 */
+	RREG32_SOC15(VCN, i, regUVD_STATUS);
+
 	return 0;
 }
 
@@ -1583,6 +1593,11 @@ static void vcn_v4_0_stop_dpg_mode(struct amdgpu_vcn_inst *vinst)
 	/* disable dynamic power gating mode */
 	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, regUVD_POWER_STATUS), 0,
 		~UVD_POWER_STATUS__UVD_PG_MODE_MASK);
+
+	/* Keeping one read-back to ensure all register writes are done,
+	 * otherwise it may introduce race conditions.
+	 */
+	RREG32_SOC15(VCN, inst_idx, regUVD_STATUS);
 }
 
 /**
@@ -1666,6 +1681,11 @@ static int vcn_v4_0_stop(struct amdgpu_vcn_inst *vinst)
 	/* enable VCN power gating */
 	vcn_v4_0_enable_static_power_gating(vinst);
 
+	/* Keeping one read-back to ensure all register writes are done,
+	 * otherwise it may introduce race conditions.
+	 */
+	RREG32_SOC15(VCN, i, regUVD_STATUS);
+
 done:
 	if (adev->pm.dpm_enabled)
 		amdgpu_dpm_enable_vcn(adev, false, i);
-- 
2.39.5



