Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21E6350A3C;
	Tue, 21 Oct 2025 20:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076920; cv=none; b=qSjulXGfi3c2xqH9gEPhLcIRLGg6rEQZytKkvxMH1gmfdlIAvhUItlGXtwx9PPJ+Og0mcmDnrDXcxAj7kap6bQfePdwKnnI9xKCBcMh75811YJx3P25DqIvw5jT4H9YmNIXo34Xc+jNhxEb/am6Q/YhJKR4n0Qsrk4n9w45PjcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076920; c=relaxed/simple;
	bh=FjFLsKkhP2wAhoHklfvP3H64HzbTjSdlP7viFnNrYjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acqV6bCey3wVXt0jpacAfrs5G6DCpM++GCpCdjIOBxoeGQcXFzcrC7S95PR1rdogORa4Mk8g4BBeDSAS8zObzVlS1T+HT3bar+87XWuqhhhLE1MrTgXz39pSK/BoXDFT43aX+aGnxlF0t5uESf6hiH7i5AH2bFmO45ElT40hv0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lr25CCs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lr25CCs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A43C4CEF1;
	Tue, 21 Oct 2025 20:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076919;
	bh=FjFLsKkhP2wAhoHklfvP3H64HzbTjSdlP7viFnNrYjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lr25CCs5SxIMAGx9u4qMfFqAqoXutgefB0Du8SVvn4b3OSup10npmSAgBKUWxykqi
	 cA8S9T8diKplPC1I4XPFiFSN8g64PYU/V8Iqio6jMWmpFwQquJN0/OnK5ryX36fUo1
	 kD9+lUra4fQwnta3JbwpyfR4fhSDUSe+/c34+se4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom St Denis <tom.stdenis@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/136] drm/amdgpu: fix handling of harvesting for ip_discovery firmware
Date: Tue, 21 Oct 2025 21:51:06 +0200
Message-ID: <20251021195037.845392386@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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
index 0f427314b2b48..e00b5e4542347 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1016,7 +1016,9 @@ static uint8_t amdgpu_discovery_get_harvest_info(struct amdgpu_device *adev,
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
@@ -2462,7 +2464,9 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 		amdgpu_discovery_init(adev);
 		vega10_reg_base_init(adev);
 		adev->sdma.num_instances = 2;
+		adev->sdma.sdma_mask = 3;
 		adev->gmc.num_umc = 4;
+		adev->gfx.xcc_mask = 1;
 		adev->ip_versions[MMHUB_HWIP][0] = IP_VERSION(9, 0, 0);
 		adev->ip_versions[ATHUB_HWIP][0] = IP_VERSION(9, 0, 0);
 		adev->ip_versions[OSSSYS_HWIP][0] = IP_VERSION(4, 0, 0);
@@ -2489,7 +2493,9 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 		amdgpu_discovery_init(adev);
 		vega10_reg_base_init(adev);
 		adev->sdma.num_instances = 2;
+		adev->sdma.sdma_mask = 3;
 		adev->gmc.num_umc = 4;
+		adev->gfx.xcc_mask = 1;
 		adev->ip_versions[MMHUB_HWIP][0] = IP_VERSION(9, 3, 0);
 		adev->ip_versions[ATHUB_HWIP][0] = IP_VERSION(9, 3, 0);
 		adev->ip_versions[OSSSYS_HWIP][0] = IP_VERSION(4, 0, 1);
@@ -2516,8 +2522,10 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
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
@@ -2560,7 +2568,9 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 		amdgpu_discovery_init(adev);
 		vega20_reg_base_init(adev);
 		adev->sdma.num_instances = 2;
+		adev->sdma.sdma_mask = 3;
 		adev->gmc.num_umc = 8;
+		adev->gfx.xcc_mask = 1;
 		adev->ip_versions[MMHUB_HWIP][0] = IP_VERSION(9, 4, 0);
 		adev->ip_versions[ATHUB_HWIP][0] = IP_VERSION(9, 4, 0);
 		adev->ip_versions[OSSSYS_HWIP][0] = IP_VERSION(4, 2, 0);
@@ -2588,8 +2598,10 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
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
@@ -2621,8 +2633,10 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
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
@@ -2657,6 +2671,8 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
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



