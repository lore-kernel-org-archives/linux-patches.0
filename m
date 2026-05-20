Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2FE3F1AD9;
	Wed, 20 May 2026 17:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299517; cv=none; b=T1CmR8G4wd4JSpFvO+pOkym44SQ/fWqNMt55sQnCpHWiMW5it192IVXePhQFfAH1a/EBRwo9rXf7YGuOTgolyxN2m52md3euB0dFXnyGOfGVq1hCaaa39OmC5HXBZ77Ehps6ZKFkjk6kzHbI1Fu8RV8xpnw6cifDkMkHLUbhKJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299517; c=relaxed/simple;
	bh=GQX61aJOol9L0BtSHLeLxKAg0Qk6bCCXUr7NehcaBCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e100YZHisCcQQR6hJqsClQ2OkQ6GlakQLqDwUcIc8xL69GF/vEXu4lJHeqklTRM9iIj7lGM8LaxWqM/MBPULijzP/tXLY6dTQMFI8DiprGpykM0JmnsATdZ154UItHTBXeXrx+pR7vD5Edj9UMCqgP1ewXStPdtbqM9W7XPg5EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q636/qDT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q636/qDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C043F1F000E9;
	Wed, 20 May 2026 17:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299516;
	bh=sLfi/wxuzAHTGHRQqAeA4iadAFqBVlffesXpLaqiu8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q636/qDTmj5haxQfNkMfbat/+GwJX78YeGkY0ASU52Kd4huocFDXwGDjfmF7POMt9
	 wRvb/6eGU/jvnunoBbWz0ItDXD1Vv8HLfcBWJKtsWmzCih/D4gdsyY+8Z45jTjMAy9
	 zvMkH7OyEC+i1fTm0+fEIZpLKeut9kptkFTCwU2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 750/957] drm/amdgpu/uvd3.1: Dont validate the firmware when already validated
Date: Wed, 20 May 2026 18:20:33 +0200
Message-ID: <20260520162150.827846532@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2e79a3afc7748..1df45633e8120 100644
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



