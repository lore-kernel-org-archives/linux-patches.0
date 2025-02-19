Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C1C1C3BF1;
	Wed, 19 Feb 2025 08:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955483; cv=none; b=TH2DPW5t0EycnhWnNG8RCgMUHydJSIPBQBhV3SsLR68kYffgs0bQKjOIFu8awXxZx/Rab6GPgmnW3/JvdP0ovcRro/DxiCveHTnWqWVgUpcMs7J1Gxz1my/K7+Ze4e44BIFUkLcjbcUyapQ623iOfneKwPWpl2ydR/l79a5YSEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955483; c=relaxed/simple;
	bh=6H2frLbdbUXfCcFVqL/CreUrf52AS4mqdXAVfmdk/yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+HcoU6w/qvZ2b6F7uGztroTrbpLYiUzqEld+ZJNPAMhjH8KIS82E+Air98UsiOQiZNBMEiErpTcPGVESmkUA0Yz2CjJaz+Ftygx6Lg6HASvMyUAKWyjJq7VqTnZV0S58V8hUMI58nsNOTymxNekdd5nwW3u1Fu+qojH16Do/mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grgU8Uhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grgU8Uhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F16C4CED1;
	Wed, 19 Feb 2025 08:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955483;
	bh=6H2frLbdbUXfCcFVqL/CreUrf52AS4mqdXAVfmdk/yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grgU8Uhs/ACK1INSDt6syqx0H2aNPrrjQqen66J3gqPkCUrWdx2wu3qepK8Pc0jrw
	 kkrJG7IdP5WoqvULI+ufJ4QfzukLK9gjFV0XXleqiPS2/k5tkCF7kmldaFkw55m5d1
	 vLOGknsQDmNkRLCZzUclRJzwpBvkHdfDg5mFkwSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jiang Liu <gerry@linux.alibaba.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/152] drm/amdgpu: bail out when failed to load fw in psp_init_cap_microcode()
Date: Wed, 19 Feb 2025 09:27:13 +0100
Message-ID: <20250219082550.831768574@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a4f9015345ccb..6a24e8ceb9449 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -3450,9 +3450,10 @@ int psp_init_cap_microcode(struct psp_context *psp, const char *chip_name)
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



