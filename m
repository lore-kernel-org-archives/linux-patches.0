Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005F82E7F0B;
	Thu,  3 Jul 2025 14:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554655; cv=none; b=Zp3U6elKZZ8gDMCDgZ3P/y6/g3OZphz5sdjFzN+sAq4Eh9eYOj3jO96D09HTD0cPWwdtCm4bfmlwpfeTz3Cwi9hP4ZBEcONztuMjihAYucLnG+mGwZw0LmDUnuiHgS8wZw8o39VRgUDxpFuhbC6/CXaHjRUTS5MJwTWPde4BXvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554655; c=relaxed/simple;
	bh=H593oyvfuEXl0/C8l9kj7FXbM11iuqwUh93yrWL5LGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUx9MlD1Oi/dnZkoXvgt1DxVanDhIpG5LP/kb9qp0uL+axKWq9i14M/G1U+acL6YRKcERGntsHwVR8Ja/KJ0CMnOlQPEiL46lXzH+BWnHf/PtG9L9JuqdVN/2TZ4z7DIKneZpMmXhoTnQlFRG062jj9HPcdVQ+NO+OwgwAqZROw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGVnH96z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGVnH96z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63637C4CEE3;
	Thu,  3 Jul 2025 14:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554654;
	bh=H593oyvfuEXl0/C8l9kj7FXbM11iuqwUh93yrWL5LGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGVnH96zmkaxT+IXrOaPn3ysZNFgfHABZ2DcjvxL3LVe2JfYQ1Pa8i2qdiyWuMS3c
	 gnNge0DnW+hKTCqoeHEpQ3hgR9MUgecwtm9+/+WNYW86K6zInRRoFZdliZ8zz1HV0P
	 KDhwZ0PH5G8t3p7EW/SkxnK/9UsUKv4yU51m5iBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruijing Dong <ruijing.dong@amd.com>,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 039/263] drm/amdgpu/vcn3: read back register after written
Date: Thu,  3 Jul 2025 16:39:19 +0200
Message-ID: <20250703144005.872748051@linuxfoundation.org>
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

[ Upstream commit b7a4842a917e3a251b5a6aa1a21a5daf6d396ef3 ]

The addition of register read-back in VCN v3.0 is intended to prevent
potential race conditions.

Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index 0b19f0ab4480d..9fb0d53805892 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1173,6 +1173,11 @@ static int vcn_v3_0_start_dpg_mode(struct amdgpu_vcn_inst *vinst, bool indirect)
 	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, mmUVD_POWER_STATUS),
 		0, ~UVD_POWER_STATUS__STALL_DPG_POWER_UP_MASK);
 
+	/* Keeping one read-back to ensure all register writes are done,
+	 * otherwise it may introduce race conditions.
+	 */
+	RREG32_SOC15(VCN, inst_idx, mmUVD_STATUS);
+
 	return 0;
 }
 
@@ -1360,6 +1365,11 @@ static int vcn_v3_0_start(struct amdgpu_vcn_inst *vinst)
 		fw_shared->multi_queue.encode_lowlatency_queue_mode &= cpu_to_le32(~FW_QUEUE_RING_RESET);
 	}
 
+	/* Keeping one read-back to ensure all register writes are done,
+	 * otherwise it may introduce race conditions.
+	 */
+	RREG32_SOC15(VCN, i, mmUVD_STATUS);
+
 	return 0;
 }
 
@@ -1602,6 +1612,11 @@ static int vcn_v3_0_stop_dpg_mode(struct amdgpu_vcn_inst *vinst)
 	WREG32_P(SOC15_REG_OFFSET(VCN, inst_idx, mmUVD_POWER_STATUS), 0,
 		~UVD_POWER_STATUS__UVD_PG_MODE_MASK);
 
+	/* Keeping one read-back to ensure all register writes are done,
+	 * otherwise it may introduce race conditions.
+	 */
+	RREG32_SOC15(VCN, inst_idx, mmUVD_STATUS);
+
 	return 0;
 }
 
@@ -1674,6 +1689,11 @@ static int vcn_v3_0_stop(struct amdgpu_vcn_inst *vinst)
 	/* enable VCN power gating */
 	vcn_v3_0_enable_static_power_gating(vinst);
 
+	/* Keeping one read-back to ensure all register writes are done,
+	 * otherwise it may introduce race conditions.
+	 */
+	RREG32_SOC15(VCN, i, mmUVD_STATUS);
+
 done:
 	if (adev->pm.dpm_enabled)
 		amdgpu_dpm_enable_vcn(adev, false, i);
-- 
2.39.5



