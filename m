Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B59362157;
	Sat, 30 May 2026 18:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164615; cv=none; b=RMHeOmtKa9FWwdqePwWzx4tAd6VrrcZ0JD/zOEQZrbfaXyhz6dPJHAYYmnvjEW1sK0mmXyh8YEYAuf/VCnvxf86VpnXyn84fvfFdhtXnHsdkm4YGUYTMwjwnyrtJmwNnx8IOGAD6WmNKMd2++fPfkbHKKx7UQ/XZrLRw74MSzRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164615; c=relaxed/simple;
	bh=QVQLBJG4Pd24WwQd6Ud75o7ppa4TkQhJexkec/zL2nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p0dr6WRa2C6x7LlV2ceL/HYgvf8fnOjwZuEskGJxtC/h+8r8DViARA+KpX1Upl6Vd+C464+6qROuD85J07Fbk+uHsuemE7eaN5i2cAzhCRrGrBObUyzovkbSTsoHEg/aT+RTrNo2A9NfPozx8EVcgw3/D/SxPMh+Jw85hMyRrac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUwoyj+V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUwoyj+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA52B1F00893;
	Sat, 30 May 2026 18:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164614;
	bh=wfkJZE7ExU5tVJSDyyxPYj3gmjYrFN3BOIY4YSnaD3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUwoyj+V1KC1hIjq+yOQdCeYkhf4O1KOWpNVYXKk8qbyaq7crPcDB7AAYBF5eJCpf
	 +wblp8E36CG45k6q8ofHCijX+64e51PNILnr7d1Q6aLLMmKCk4uoAVmqpZDZe4MuPc
	 RE/I22T+IojnevfRFAZ61cu7AwJWYyHfIvaLZO9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 607/776] drm/amdgpu/uvd3.1: Dont validate the firmware when already validated
Date: Sat, 30 May 2026 18:05:21 +0200
Message-ID: <20260530160255.703477379@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 13e4cf116dbf7a1fb8123a59bea2c098f30d3736 ]

UVD 3.1 firmware validation seems to always fail after
attempting it when it had already been validated.
(This works similarly with the VCE 1.0 as well.)

Don't attempt repeating the validation when it's already done.

This caused issues in situations when the system isn't able
to suspend the GPU properly and so the GPU isn't actually
powered down. Then amdgpu would fail when calling the IP
block resume function.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/2887
Fixes: bb7978111dd3 ("drm/amdgpu: fix SI UVD firmware validate resume fail")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 889a2cfd889c4a4dd9d0c89ce9a8e60b78be71dd)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
index fbfed90503868..3a27bed57b4ff 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
@@ -242,6 +242,10 @@ static void uvd_v3_1_mc_resume(struct amdgpu_device *adev)
 	uint64_t addr;
 	uint32_t size;
 
+	/* When the keyselect is already set, don't perturb it. */
+	if (RREG32(mmUVD_FW_START))
+		return;
+
 	/* program the VCPU memory controller bits 0-27 */
 	addr = (adev->uvd.inst->gpu_addr + AMDGPU_UVD_FIRMWARE_OFFSET) >> 3;
 	size = AMDGPU_UVD_FIRMWARE_SIZE(adev) >> 3;
@@ -284,6 +288,12 @@ static int uvd_v3_1_fw_validate(struct amdgpu_device *adev)
 	int i;
 	uint32_t keysel = adev->uvd.keyselect;
 
+	if (RREG32(mmUVD_FW_START) & UVD_FW_STATUS__PASS_MASK) {
+		dev_dbg(adev->dev, "UVD keyselect already set: 0x%x (on CPU: 0x%x)\n",
+			RREG32(mmUVD_FW_START), adev->uvd.keyselect);
+		return 0;
+	}
+
 	WREG32(mmUVD_FW_START, keysel);
 
 	for (i = 0; i < 10; ++i) {
-- 
2.53.0



