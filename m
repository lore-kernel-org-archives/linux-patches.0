Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB7A143C6E;
	Tue, 27 Feb 2024 13:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041912; cv=none; b=tiHoR2lwWokwcpw4YXovl9WAvL+QPxgbSyBftyYiVpRz4HKBXzQo0ySoOkdkmb4QAiXunXEX5GCaL22XJg2Lcjfgusqove1LkMplNLpHBFXopig1t29koQTf0WloVCS7XQ8dv4Np4Qndmx5Jsw5AZjU/aW2jpqeUl5ez+wd0I5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041912; c=relaxed/simple;
	bh=Dq8zOdJC9uAzVJlJ8O0rLNnMjMk9EGYmGNzzZwu4PC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwkUiLrFgoecsF3lh7Rzq9NnkLJepTnCBHKFvojlOHGmGb6EMQ8yRfr1mcfurxXBlHH4cxRgba9HuqyyWG2hUVkxg0QwFuVy941hdRQq8fDaS5o60NP4fuYpn3Ip+m/DXsaxO6HCAJXdSofc+6+oHX8L34wRcMjcmoMhem1knPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYRo7kKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYRo7kKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C836C433C7;
	Tue, 27 Feb 2024 13:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041912;
	bh=Dq8zOdJC9uAzVJlJ8O0rLNnMjMk9EGYmGNzzZwu4PC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYRo7kKkBRh1MMAQiraZcKGGJhBTP6A4SHNK9rqbhJLy8+GtTlWI+12pT5Sx5GN3J
	 ZL0VOcIL4F1WhflX6MSjKqUY7QKF84W1E19OVvgAtkARbJJIypc/WfsmQshgfuqIdm
	 9KzKZ7DxhRyehFVT4JqOJqlPtjUHt77on2C+DSaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/299] drm/amdgpu: reset gpu for s3 suspend abort case
Date: Tue, 27 Feb 2024 14:23:43 +0100
Message-ID: <20240227131629.477686993@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 6ef82ac664bb9568ca3956e0d9c9c478e25077ff ]

In the s3 suspend abort case some type of gfx9 power
rail not turn off from FCH side and this will put the
GPU in an unknown power status, so let's reset the gpu
to a known good power state before reinitialize gpu
device.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 3667f9a548414..2a7c606d1d191 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1296,10 +1296,32 @@ static int soc15_common_suspend(void *handle)
 	return soc15_common_hw_fini(adev);
 }
 
+static bool soc15_need_reset_on_resume(struct amdgpu_device *adev)
+{
+	u32 sol_reg;
+
+	sol_reg = RREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_81);
+
+	/* Will reset for the following suspend abort cases.
+	 * 1) Only reset limit on APU side, dGPU hasn't checked yet.
+	 * 2) S3 suspend abort and TOS already launched.
+	 */
+	if (adev->flags & AMD_IS_APU && adev->in_s3 &&
+			!adev->suspend_complete &&
+			sol_reg)
+		return true;
+
+	return false;
+}
+
 static int soc15_common_resume(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	if (soc15_need_reset_on_resume(adev)) {
+		dev_info(adev->dev, "S3 suspend abort case, let's reset ASIC.\n");
+		soc15_asic_reset(adev);
+	}
 	return soc15_common_hw_init(adev);
 }
 
-- 
2.43.0



