Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE9141B377;
	Wed,  4 Feb 2026 14:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217133; cv=none; b=Q7yFKQHvTimOS/59RC8cOPYy2RkLESeMY3wEmrtXubx3R4PgM47Rsj+2z8gimGkFrRCpAc3GB05hr2aGlnkpiDc94I4z2nKLUru3pNUuGDLG6//E5BXodsKNDq1Uyc4eNgxsqXnG1Lq0V7rXKb8D0PQ4XM1LFrX5o/aTmSwUvR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217133; c=relaxed/simple;
	bh=me/5yslbOXai7gsjAMeNmNVi5EbhtT2eyfwBm0JUIDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S2b2z0z/b0RQCcwpUAOzRzPX8sT2q7xifoxcA/j874VbqvzZ0iG3828BKM+2PGZ9ptvyKuHeoVu6ivbLiymG2a9O3L0RV5gu5KN7Kb4eKJBEBgnQcXynp5Z/TxG4QWc61wHCsZeJAZTW7ikMCY59/zF62Nju7bM7Iy+6MZmEDvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJut7oDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJut7oDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752ABC4CEF7;
	Wed,  4 Feb 2026 14:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217132;
	bh=me/5yslbOXai7gsjAMeNmNVi5EbhtT2eyfwBm0JUIDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJut7oDCh7UIdTAnMffAEaSadrPqrCESHISMDRUgjD3GOJ5g7p12zNelEnwYts6uC
	 BZxvj9d6lgfYDcYUncJEVwjm5EdWI2w4NIUXChIXsqE7fKAEbWQOui6WScmbFioc0m
	 3xIpuFyed3lFPEW1yEydZLbZfvJGu0wm6Zy3d/DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/206] drm/amd/pm: Workaround SI powertune issue on Radeon 430 (v2)
Date: Wed,  4 Feb 2026 15:38:51 +0100
Message-ID: <20260204143901.813183274@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

[ Upstream commit 764a90eb02268a23b1bb98be5f4a13671346804a ]

Radeon 430 and 520 are OEM GPUs from 2016~2017
They have the same device id: 0x6611 and revision: 0x87

On the Radeon 430, powertune is buggy and throttles the GPU,
never allowing it to reach its maximum SCLK. Work around this
bug by raising the TDP limits we program to the SMC from
24W (specified by the VBIOS on Radeon 430) to 32W.

Disabling powertune entirely is	not a viable workaround,
because	it causes the Radeon 520 to heat up above 100 C,
which I prefer to avoid.

Additionally, revise the maximum SCLK limit. Considering the
above issue, these GPUs never reached a high SCLK on Linux,
and the workarounds were added before the GPUs were released,
so the workaround likely didn't target these specifically.
Use 780 MHz (the maximum SCLK according to the VBIOS on the
Radeon 430). Note that the Radeon 520 VBIOS has a higher
maximum SCLK: 905 MHz, but in practice it doesn't seem to
perform better with the higher clock, only heats up more.

v2:
Move the workaround to si_populate_smc_tdp_limits.

Fixes: 841686df9f7d ("drm/amdgpu: add SI DPM support (v4)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 966d70f1e160bdfdecaf7ff2b3f22ad088516e9f)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
index 0bc785f09ee1d..a6ed28ab07083 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
@@ -2250,6 +2250,12 @@ static int si_populate_smc_tdp_limits(struct amdgpu_device *adev,
 		if (ret)
 			return ret;
 
+		if (adev->pdev->device == 0x6611 && adev->pdev->revision == 0x87) {
+			/* Workaround buggy powertune on Radeon 430 and 520. */
+			tdp_limit = 32;
+			near_tdp_limit = 28;
+		}
+
 		smc_table->dpm2Params.TDPLimit =
 			cpu_to_be32(si_scale_power_for_smc(tdp_limit, scaling_factor) * 1000);
 		smc_table->dpm2Params.NearTDPLimit =
@@ -3425,10 +3431,15 @@ static void si_apply_state_adjust_rules(struct amdgpu_device *adev,
 		    (adev->pdev->revision == 0x80) ||
 		    (adev->pdev->revision == 0x81) ||
 		    (adev->pdev->revision == 0x83) ||
-		    (adev->pdev->revision == 0x87) ||
+		    (adev->pdev->revision == 0x87 &&
+				adev->pdev->device != 0x6611) ||
 		    (adev->pdev->device == 0x6604) ||
 		    (adev->pdev->device == 0x6605)) {
 			max_sclk = 75000;
+		} else if (adev->pdev->revision == 0x87 &&
+				adev->pdev->device == 0x6611) {
+			/* Radeon 430 and 520 */
+			max_sclk = 78000;
 		}
 	}
 
-- 
2.51.0



