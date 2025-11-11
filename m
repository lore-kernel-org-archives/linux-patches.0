Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EA43016FC;
	Tue, 11 Nov 2025 01:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823158; cv=none; b=BSL4HzZzjELBTIzVmkNWkGHwXmYX+ttjElDj+KuSLk4KDDX15SbTD6RuSoye9782XMlqpB3VT5xJy7Kbaf3SFZG5ls/q7EXpiRukXWxFKSCjq/FkyY7Fvf7SVPys1Tv3DYD+nGUruslcLzniJ4KnZZEWY1CPG90O8hUZkf7pqaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823158; c=relaxed/simple;
	bh=tvJgv4ca2t3/L2uXZn+6hm73bnY9RsRpwXYUxqb0sh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lblqhhNfZ8fHZyLkH4iBwvgKQeY63ylLsCK22UtBMl09dnmpDa+XohZ9OAeidmFRpOjaoQzcrmZdVU2tBg9+8iz6OzSpLRN6kbgDk4zIzBhg180EUgkDP4Btx6+JwNyOhXxJ+BXh0uibte46mSyvKKGpX2+3VU9q3NCgBKargJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLsy48De; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLsy48De"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07482C116B1;
	Tue, 11 Nov 2025 01:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823158;
	bh=tvJgv4ca2t3/L2uXZn+6hm73bnY9RsRpwXYUxqb0sh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLsy48DegfxaRUOSvmbUqhaJ2HTfYT9fxvH3BYOxsq/sz6sJigvUpKgbHu0zB2TBc
	 B2lfHs7xuj5uZJc+CZneLFdKdXUs0rO+Ocue9EVJ+Rlb6xACvVFdKG/G8Mq4dmoKK8
	 titCJ2beau30Ue0Jx43a2lRB8LwXKtj2kzUBXZXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/565] drm/amdgpu: Skip poison aca bank from UE channel
Date: Tue, 11 Nov 2025 09:40:38 +0900
Message-ID: <20251111004531.029540160@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9d6345146495f..a95f45d063144 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
@@ -132,6 +132,27 @@ static void aca_smu_bank_dump(struct amdgpu_device *adev, int idx, int total, st
 			      idx + 1, total, aca_regs[i].name, bank->regs[aca_regs[i].reg_idx]);
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
@@ -170,6 +191,15 @@ static int aca_smu_get_valid_aca_banks(struct amdgpu_device *adev, enum aca_smu_
 
 		bank.type = type;
 
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
@@ -180,27 +210,6 @@ static int aca_smu_get_valid_aca_banks(struct amdgpu_device *adev, enum aca_smu_
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



