Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AE528D8D0;
	Wed,  4 Feb 2026 15:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217879; cv=none; b=jQAIird+CADw80O1Q2Q9evJnDW6HgX/+AwcpD4RbDjh/IP8sxPMHQ9suhOhJxnG8royUrTyKYGYo/4UTHRQGkw+WvDMYy4dJxKfuilD//JXkJKvqJW31iP0ULdQblpYzu6i87UiHFuTnok6OSbkLK2deBS40S/3/XFu+VF0RacM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217879; c=relaxed/simple;
	bh=1zzNIXVGasxxtuA0XRCaDveXtkmGjx3Nvr7g8RwD+7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KhzAhlrBNP5h+0G8U/d/mdSgqNBAMJ/59gmp4oKvj/a0QjxRahIrWlrQMUqt1ae4oaiVlgNT5uS+rETq+bCBXtUQteQEu5Q1nO01mC/EmxLFJQAx3XPna22lg6r+RXVSPJ3BokYeWFp798knb58lX7Y+L5Xp3l3XbxsR5DuWvUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkLfPoc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkLfPoc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7348DC4CEF7;
	Wed,  4 Feb 2026 15:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217878;
	bh=1zzNIXVGasxxtuA0XRCaDveXtkmGjx3Nvr7g8RwD+7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkLfPoc1+Pbos4gpSM4D5hii1uKGMFmTv3A22ZH8nHN6q825kEezw+KGWy6SJYrPA
	 HnZ6weSfgDKQIbaiqc+JEqle/iGHCKc3u/ndIpZDBHV/VN00e8w6LyPETd99GhzkGH
	 xAAEYSq9xowwHcO4yLfVs7dZYAayaJgNP5QhxX2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/280] drm/amd/pm: Workaround SI powertune issue on Radeon 430 (v2)
Date: Wed,  4 Feb 2026 15:38:40 +0100
Message-ID: <20260204143914.887916284@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index a8278fa75ff9a..bcc4d9fa5b0d2 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -2265,6 +2265,12 @@ static int si_populate_smc_tdp_limits(struct amdgpu_device *adev,
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
@@ -3448,10 +3454,15 @@ static void si_apply_state_adjust_rules(struct amdgpu_device *adev,
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



