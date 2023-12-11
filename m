Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F515101A;
	Mon, 11 Dec 2023 18:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ukn3VEy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBADC433C7;
	Mon, 11 Dec 2023 18:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319268;
	bh=ikW3O9JzaViDpUJ3IGvWKwrS8H/ZzAjMqevw4fydA4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ukn3VEy27I4YinniE5fQ6gi7Sw6S9NWBu+QqXpTx/2j2V2hRA4BJZlv4UZdtaWgfP
	 B3bMwICZkDSp4l4XBxYp5wLinNcEH3qCwxCihlgFTYIsBnOgLUayZNH3o3EHP1A0gn
	 VRsBLZ8k70ZgWa0hFEUcTu1VTZV9LEa6HxASgr8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Lu <victorchengchi.lu@amd.com>,
	Samir Dhume <samir.dhume@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/244] drm/amdgpu: Do not program VF copy regs in mmhub v1.8 under SRIOV (v2)
Date: Mon, 11 Dec 2023 19:18:26 +0100
Message-ID: <20231211182046.367434616@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Lu <victorchengchi.lu@amd.com>

[ Upstream commit 0288603040c38ccfeb5342f34a52673366d90038 ]

MC_VM_AGP_* registers should not be programmed by guest driver.

v2: move early return outside of loop

Signed-off-by: Victor Lu <victorchengchi.lu@amd.com>
Reviewed-by: Samir Dhume <samir.dhume@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c
index 784c4e0774707..3d8e579d5c4e8 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c
@@ -130,6 +130,9 @@ static void mmhub_v1_8_init_system_aperture_regs(struct amdgpu_device *adev)
 	uint64_t value;
 	int i;
 
+	if (amdgpu_sriov_vf(adev))
+		return;
+
 	inst_mask = adev->aid_mask;
 	for_each_inst(i, inst_mask) {
 		/* Program the AGP BAR */
@@ -139,9 +142,6 @@ static void mmhub_v1_8_init_system_aperture_regs(struct amdgpu_device *adev)
 		WREG32_SOC15(MMHUB, i, regMC_VM_AGP_TOP,
 			     adev->gmc.agp_end >> 24);
 
-		if (amdgpu_sriov_vf(adev))
-			return;
-
 		/* Program the system aperture low logical page number. */
 		WREG32_SOC15(MMHUB, i, regMC_VM_SYSTEM_APERTURE_LOW_ADDR,
 			min(adev->gmc.fb_start, adev->gmc.agp_start) >> 18);
-- 
2.42.0



