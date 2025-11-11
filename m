Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E703446DE;
	Tue, 11 Nov 2025 01:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823196; cv=none; b=nA0sLnudxXrmcRI3zgVhwvvfua+lRWTCJhx8LH+PZTDPe7GRV4KXbdJEEfM6IxNwfYMERdAB4YzTNRUOCqAPbQorj+z/SIZNhefolnsHIpvLP+a2jnrB3UkltV8pSGIk97tzq88KyitbEYX15yAja4JrIliSm6LxCyJfyrTVPVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823196; c=relaxed/simple;
	bh=3jtstzl4YuJRD9LC0JrCZRnDV3nvOZIrcmZShURMhow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAN1lL2BHBauFtyU/BI6lCiVxJJZxLcLZwFbsvWft/GxcmwD6L7erS1+aOe1dHow9GpedG6NV2dqEADnFfaHezOKhxvh2AwRkfPKMryn02QI/MohKrGwLuypkep8BlajbVaIFahXXcEWeYfhya51TQIwMFngISTUoH4DW89akss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7DIowpI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7DIowpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D03C4CEF5;
	Tue, 11 Nov 2025 01:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823196;
	bh=3jtstzl4YuJRD9LC0JrCZRnDV3nvOZIrcmZShURMhow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7DIowpIFKdC9TF4+ERKg8dj/oT8Ub7Va5QbjP+tMkcNeG9sXMDjHtI+KdLVtVfUz
	 kHckM+K/+Y6S2AcsuJSYOJ6UbH46BmpkkYa0BonDZQsW+2snHcsTMsXOCs92vKOZ3a
	 hXfZuTkhVqXq9QRyuBjp2B50gmCcGDC7JcWXONqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 251/849] drm/amdgpu: Skip poison aca bank from UE channel
Date: Tue, 11 Nov 2025 09:37:01 +0900
Message-ID: <20251111004542.499560891@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit 8e8e08c831f088ed581444c58a635c49ea1222ab ]

Avoid GFX poison consumption errors logged when fatal error occurs.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c | 51 +++++++++++++++----------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
index cbc40cad581b4..d1e431818212d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
@@ -130,6 +130,27 @@ static void aca_smu_bank_dump(struct amdgpu_device *adev, int idx, int total, st
 		RAS_EVENT_LOG(adev, event_id, HW_ERR "hardware error logged by the scrubber\n");
 }
 
+static bool aca_bank_hwip_is_matched(struct aca_bank *bank, enum aca_hwip_type type)
+{
+
+	struct aca_hwip *hwip;
+	int hwid, mcatype;
+	u64 ipid;
+
+	if (!bank || type == ACA_HWIP_TYPE_UNKNOW)
+		return false;
+
+	hwip = &aca_hwid_mcatypes[type];
+	if (!hwip->hwid)
+		return false;
+
+	ipid = bank->regs[ACA_REG_IDX_IPID];
+	hwid = ACA_REG__IPID__HARDWAREID(ipid);
+	mcatype = ACA_REG__IPID__MCATYPE(ipid);
+
+	return hwip->hwid == hwid && hwip->mcatype == mcatype;
+}
+
 static int aca_smu_get_valid_aca_banks(struct amdgpu_device *adev, enum aca_smu_type type,
 				       int start, int count,
 				       struct aca_banks *banks, struct ras_query_context *qctx)
@@ -168,6 +189,15 @@ static int aca_smu_get_valid_aca_banks(struct amdgpu_device *adev, enum aca_smu_
 
 		bank.smu_err_type = type;
 
+		/*
+		 * Poison being consumed when injecting a UE while running background workloads,
+		 * which are unexpected.
+		 */
+		if (type == ACA_SMU_TYPE_UE &&
+		    ACA_REG__STATUS__POISON(bank.regs[ACA_REG_IDX_STATUS]) &&
+		    !aca_bank_hwip_is_matched(&bank, ACA_HWIP_TYPE_UMC))
+			continue;
+
 		aca_smu_bank_dump(adev, i, count, &bank, qctx);
 
 		ret = aca_banks_add_bank(banks, &bank);
@@ -178,27 +208,6 @@ static int aca_smu_get_valid_aca_banks(struct amdgpu_device *adev, enum aca_smu_
 	return 0;
 }
 
-static bool aca_bank_hwip_is_matched(struct aca_bank *bank, enum aca_hwip_type type)
-{
-
-	struct aca_hwip *hwip;
-	int hwid, mcatype;
-	u64 ipid;
-
-	if (!bank || type == ACA_HWIP_TYPE_UNKNOW)
-		return false;
-
-	hwip = &aca_hwid_mcatypes[type];
-	if (!hwip->hwid)
-		return false;
-
-	ipid = bank->regs[ACA_REG_IDX_IPID];
-	hwid = ACA_REG__IPID__HARDWAREID(ipid);
-	mcatype = ACA_REG__IPID__MCATYPE(ipid);
-
-	return hwip->hwid == hwid && hwip->mcatype == mcatype;
-}
-
 static bool aca_bank_is_valid(struct aca_handle *handle, struct aca_bank *bank, enum aca_smu_type type)
 {
 	const struct aca_bank_ops *bank_ops = handle->bank_ops;
-- 
2.51.0



