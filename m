Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02451EC018;
	Wed, 19 Feb 2025 08:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953985; cv=none; b=RHoVfLsu/IBmbCi8xfX8IbTslqYq0vqfh4bXI9e+UDMklke0FQUnAvdk37Pz7tgN6oy9mXbaR+LqX8Bb3m+5TgSjKrau7GHQipHAwspqFIzydAxW3IHs1dV8/Wf4RnYBGbew83KUXoxoiAJA9ssCrIA8+mYuEDshRwLsI0AzEE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953985; c=relaxed/simple;
	bh=dpJ6RTCBOuERrQsXCqeB/sZdw70vw8klK8dUaT+OxPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr2XZ0Y/v0br9+cR2xkwR2QYOFj+ryjRZSW3Gi6CbJ+b1bgJPsXay/XluYNzalAGAFV+tm2y4DZdyWTQXLaIQcRdIXXqZvNAwzfUxam8GBxqWJO3SHVhtzZPcuCluVFnmjJFjiTGzkB966A0vRQtbpCW/B/DCVre1YRzdoIdbIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXvKaj5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXvKaj5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C629C4CEEB;
	Wed, 19 Feb 2025 08:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953985;
	bh=dpJ6RTCBOuERrQsXCqeB/sZdw70vw8klK8dUaT+OxPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXvKaj5l8k9d4obrQRYeFq4y5OHLhwHoc1i9UwZFX2c3AjsFpGkE0Es2Z8DtemWsq
	 qDz9uWmeOVWodYzaVXQ6Ey17oMH3cs6twZeVHU3441goKxZldzJUT8dDVBKesB47xW
	 3Uv3MkzId/MjnXP6ZCSMV7JyUhnqdFLNxjQIDjRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jiang Liu <gerry@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 059/274] drm/amdgpu: bail out when failed to load fw in psp_init_cap_microcode()
Date: Wed, 19 Feb 2025 09:25:13 +0100
Message-ID: <20250219082611.937181725@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <gerry@linux.alibaba.com>

[ Upstream commit a0a455b4bc7483ad60e8b8a50330c1e05bb7bfcf ]

In function psp_init_cap_microcode(), it should bail out when failed to
load firmware, otherwise it may cause invalid memory access.

Fixes: 07dbfc6b102e ("drm/amd: Use `amdgpu_ucode_*` helpers for PSP")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Jiang Liu <gerry@linux.alibaba.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 448f9e742983f..75c0f64602ed9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -3790,9 +3790,10 @@ int psp_init_cap_microcode(struct psp_context *psp, const char *chip_name)
 		if (err == -ENODEV) {
 			dev_warn(adev->dev, "cap microcode does not exist, skip\n");
 			err = 0;
-			goto out;
+		} else {
+			dev_err(adev->dev, "fail to initialize cap microcode\n");
 		}
-		dev_err(adev->dev, "fail to initialize cap microcode\n");
+		goto out;
 	}
 
 	info = &adev->firmware.ucode[AMDGPU_UCODE_ID_CAP];
-- 
2.39.5



