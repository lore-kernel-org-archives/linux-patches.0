Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D69F2773DA;
	Tue, 21 Oct 2025 20:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077444; cv=none; b=rW0Smal9rsml7Cl0BGr/OnTu62rd7Dn4vJFVyeuZFSb58OI1EG1yCihjUrG+mso1coNbn9LniGUSwlVdJC3TOJK/ORfriESzW7eOU3ihXzZdzMdbRmbTS2wAs7Qk2oBFcIixFgWWppWSeL0lfR8dmCu1i5TBd81O9GxSxJnJBZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077444; c=relaxed/simple;
	bh=gBJAtxFCWgp7vHDvi74Z+ObU/69P5WWBK0cZ9WHo19k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfeLGh7zjMCkWqri/MDgvsZibOS6KcIGyE+gVhUFeWvXftCL+JkST57UhU5Aweey+ZMSt8eh1YdomK3eTFlzyTwxHfUQWqtE0mxt2L1f1N0OlJ9+clqqaObEmsjA8gFvY7LKHGmF5gwfILNKv0jvP2P3DzaNM3yXhfXK0HrJ/Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyR6lVzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyR6lVzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A62C4CEF7;
	Tue, 21 Oct 2025 20:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077443;
	bh=gBJAtxFCWgp7vHDvi74Z+ObU/69P5WWBK0cZ9WHo19k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyR6lVzwyOx93255PunF5/Yb5R2W2cyZaJmZ4Ml/qQVm6BngV6bFGRAfJwjCmgl/D
	 huKc95mgxwWpFanS346ZJruSoic4yE8JBaHCkKrzfIjyiezwxkc3nsoQyo+Bm8VQZN
	 gLRdQSLtu4fOwzYdzl6A/YNhAulC5lkurrRDpnrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom St Denis <tom.stdenis@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 107/159] drm/amdgpu: fix handling of harvesting for ip_discovery firmware
Date: Tue, 21 Oct 2025 21:51:24 +0200
Message-ID: <20251021195045.747556740@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 357d90be2c7aaa526a840cddffd2b8d676fe75a6 ]

Chips which use the IP discovery firmware loaded by the driver
reported incorrect harvesting information in the ip discovery
table in sysfs because the driver only uses the ip discovery
firmware for populating sysfs and not for direct parsing for the
driver itself as such, the fields that are used to print the
harvesting info in sysfs report incorrect data for some IPs.  Populate
the relevant fields for this case as well.

Fixes: 514678da56da ("drm/amdgpu/discovery: fix fw based ip discovery")
Acked-by: Tom St Denis <tom.stdenis@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index 38c4ebc063db2..e814da2b14225 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1033,7 +1033,9 @@ static uint8_t amdgpu_discovery_get_harvest_info(struct amdgpu_device *adev,
 	/* Until a uniform way is figured, get mask based on hwid */
 	switch (hw_id) {
 	case VCN_HWID:
-		harvest = ((1 << inst) & adev->vcn.inst_mask) == 0;
+		/* VCN vs UVD+VCE */
+		if (!amdgpu_ip_version(adev, VCE_HWIP, 0))
+			harvest = ((1 << inst) & adev->vcn.inst_mask) == 0;
 		break;
 	case DMU_HWID:
 		if (adev->harvest_ip_mask & AMD_HARVEST_IP_DMU_MASK)
@@ -2562,7 +2564,9 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 		amdgpu_discovery_init(adev);
 		vega10_reg_base_init(adev);
 		adev->sdma.num_instances = 2;
+		adev->sdma.sdma_mask = 3;
 		adev->gmc.num_umc = 4;
+		adev->gfx.xcc_mask = 1;
 		adev->ip_versions[MMHUB_HWIP][0] = IP_VERSION(9, 0, 0);
 		adev->ip_versions[ATHUB_HWIP][0] = IP_VERSION(9, 0, 0);
 		adev->ip_versions[OSSSYS_HWIP][0] = IP_VERSION(4, 0, 0);
@@ -2589,7 +2593,9 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 		amdgpu_discovery_init(adev);
 		vega10_reg_base_init(adev);
 		adev->sdma.num_instances = 2;
+		adev->sdma.sdma_mask = 3;
 		adev->gmc.num_umc = 4;
+		adev->gfx.xcc_mask = 1;
 		adev->ip_versions[MMHUB_HWIP][0] = IP_VERSION(9, 3, 0);
 		adev->ip_versions[ATHUB_HWIP][0] = IP_VERSION(9, 3, 0);
 		adev->ip_versions[OSSSYS_HWIP][0] = IP_VERSION(4, 0, 1);
@@ -2616,8 +2622,10 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 		amdgpu_discovery_init(adev);
 		vega10_reg_base_init(adev);
 		adev->sdma.num_instances = 1;
+		adev->sdma.sdma_mask = 1;
 		adev->vcn.num_vcn_inst = 1;
 		adev->gmc.num_umc = 2;
+		adev->gfx.xcc_mask = 1;
 		if (adev->apu_flags & AMD_APU_IS_RAVEN2) {
 			adev->ip_versions[MMHUB_HWIP][0] = IP_VERSION(9, 2, 0);
 			adev->ip_versions[ATHUB_HWIP][0] = IP_VERSION(9, 2, 0);
@@ -2662,7 +2670,9 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 		amdgpu_discovery_init(adev);
 		vega20_reg_base_init(adev);
 		adev->sdma.num_instances = 2;
+		adev->sdma.sdma_mask = 3;
 		adev->gmc.num_umc = 8;
+		adev->gfx.xcc_mask = 1;
 		adev->ip_versions[MMHUB_HWIP][0] = IP_VERSION(9, 4, 0);
 		adev->ip_versions[ATHUB_HWIP][0] = IP_VERSION(9, 4, 0);
 		adev->ip_versions[OSSSYS_HWIP][0] = IP_VERSION(4, 2, 0);
@@ -2690,8 +2700,10 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 		amdgpu_discovery_init(adev);
 		arct_reg_base_init(adev);
 		adev->sdma.num_instances = 8;
+		adev->sdma.sdma_mask = 0xff;
 		adev->vcn.num_vcn_inst = 2;
 		adev->gmc.num_umc = 8;
+		adev->gfx.xcc_mask = 1;
 		adev->ip_versions[MMHUB_HWIP][0] = IP_VERSION(9, 4, 1);
 		adev->ip_versions[ATHUB_HWIP][0] = IP_VERSION(9, 4, 1);
 		adev->ip_versions[OSSSYS_HWIP][0] = IP_VERSION(4, 2, 1);
@@ -2723,8 +2735,10 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 		amdgpu_discovery_init(adev);
 		aldebaran_reg_base_init(adev);
 		adev->sdma.num_instances = 5;
+		adev->sdma.sdma_mask = 0x1f;
 		adev->vcn.num_vcn_inst = 2;
 		adev->gmc.num_umc = 4;
+		adev->gfx.xcc_mask = 1;
 		adev->ip_versions[MMHUB_HWIP][0] = IP_VERSION(9, 4, 2);
 		adev->ip_versions[ATHUB_HWIP][0] = IP_VERSION(9, 4, 2);
 		adev->ip_versions[OSSSYS_HWIP][0] = IP_VERSION(4, 4, 0);
@@ -2759,6 +2773,8 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 		} else {
 			cyan_skillfish_reg_base_init(adev);
 			adev->sdma.num_instances = 2;
+			adev->sdma.sdma_mask = 3;
+			adev->gfx.xcc_mask = 1;
 			adev->ip_versions[MMHUB_HWIP][0] = IP_VERSION(2, 0, 3);
 			adev->ip_versions[ATHUB_HWIP][0] = IP_VERSION(2, 0, 3);
 			adev->ip_versions[OSSSYS_HWIP][0] = IP_VERSION(5, 0, 1);
-- 
2.51.0



