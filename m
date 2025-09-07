Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A6E1A9FAA;
	Sun,  7 Sep 2025 20:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276385; cv=none; b=PAOMuVm9MGOE/CMem1vZlNKKcwL21X2K0zWDtl3+gujwz9NsY1cPoSh+T1Rp7Zf4jkYKzBuJfU4UOy+f63wbaWc+mwCGdYuC395wRkjRXkmXrjeN/YhjsyjfGGPsbjCVMsapgCug/HKHDxmZavrbSDKYaak0NSBmwcJ/v19OquE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276385; c=relaxed/simple;
	bh=cunvF/uwGZsRfoBEPN/+x2Qj/G5A4LDPY2w9ZB590Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ainyeYg4zWFnxZdNAVjUsdNdsW/skzRXEH7B7NRxYTrO8lreax3958+cG0Eq1MCz00U+dSTr2YsyDUahJ+XdEvrBHdjjHXv0KsH74bFYgNnWnPFQwjWADuIgbl8FENOhF+wWVuuesriuzYodz3mUgIbBD002kjA5sSI4CMCDrUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjsMp6Wk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjsMp6Wk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3302DC4CEF0;
	Sun,  7 Sep 2025 20:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276384;
	bh=cunvF/uwGZsRfoBEPN/+x2Qj/G5A4LDPY2w9ZB590Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjsMp6WkpOfp1Pnec5sc+Csh6cxzMan19CDZ2aR7I3SCJvZ67FyjHjacM17fT4LdG
	 9tgD6ljLIchLA+R1fYzIoUKW7sOCJYzf/YjVsKTD5LRDz4yTum8XlNvGVddAYQEuhM
	 gDvP0QcyeuFFHtmn9cdjaG2w+Kqe0NYIINq2iCbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Candice Li <candice.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/104] drm/amdgpu: Optimize RAS TA initialization and TA unload funcs
Date: Sun,  7 Sep 2025 21:58:45 +0200
Message-ID: <20250907195609.953620312@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Candice Li <candice.li@amd.com>

[ Upstream commit bf7d777289d106963fd2080d298e6b88b7263b66 ]

1. Save TA unload psp response status
2. Add RAS TA loading status check for initializaiton
3. Drop RAS context teardown to allow RAS TA to be reloaded

Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Candice Li <candice.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 467e00b30dfe ("drm/amd/amdgpu: Fix missing error return on kzalloc failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index ae6643c8ade6c..d101333fe3a57 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -994,6 +994,8 @@ int psp_ta_unload(struct psp_context *psp, struct ta_context *context)
 
 	ret = psp_cmd_submit_buf(psp, NULL, cmd, psp->fence_buf_mc_addr);
 
+	context->resp_status = cmd->resp.status;
+
 	release_psp_cmd_buf(psp);
 
 	return ret;
@@ -1569,6 +1571,11 @@ static int psp_ras_initialize(struct psp_context *psp)
 	if (amdgpu_sriov_vf(adev))
 		return 0;
 
+	if (psp->ras_context.context.initialized) {
+		dev_warn(adev->dev, "RAS WARN: TA has already been loaded\n");
+		return 0;
+	}
+
 	if (!adev->psp.ras_context.context.bin_desc.size_bytes ||
 	    !adev->psp.ras_context.context.bin_desc.start_addr) {
 		dev_info(adev->dev, "RAS: optional ras ta ucode is not available\n");
@@ -1619,7 +1626,7 @@ static int psp_ras_initialize(struct psp_context *psp)
 	psp->ras_context.context.mem_context.shared_mem_size = PSP_RAS_SHARED_MEM_SIZE;
 	psp->ras_context.context.ta_load_type = GFX_CMD_ID_LOAD_TA;
 
-	if (!psp->ras_context.context.initialized) {
+	if (!psp->ras_context.context.mem_context.shared_buf) {
 		ret = psp_ta_init_shared_buf(psp, &psp->ras_context.context.mem_context);
 		if (ret)
 			return ret;
@@ -1640,7 +1647,6 @@ static int psp_ras_initialize(struct psp_context *psp)
 	else {
 		if (ras_cmd->ras_status)
 			dev_warn(psp->adev->dev, "RAS Init Status: 0x%X\n", ras_cmd->ras_status);
-		amdgpu_ras_fini(psp->adev);
 	}
 
 	return ret;
-- 
2.51.0



