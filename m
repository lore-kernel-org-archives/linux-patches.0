Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B339F302779;
	Wed, 28 Jan 2026 15:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615851; cv=none; b=fiMw5ov0m4HSwDZWyunyyR+YH6j6ziBKw7Wc4G4Ot9j3yc9f7xIZffx9qyi6ge+eYblIplDRmyiD/p17mxTb/9cZ4EmKcvJut4nUTowDRxqWETyofX8dr+riuEqVcx3ocgB05SUWR7AYeU8zUEhx4LZi7eGXg+JUTp1ztTEWNSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615851; c=relaxed/simple;
	bh=uslLRsxhBpHs8Z0mXsZiAGABmX6kcDn/VLv11ST2Bfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B1VZ3Wx8KRKNyYz6CKeV99Cz9uwhLV73UamM9jxsYYA6Njd2QHBZYFj2MDqHIxXJ3VIfsEvXFtMbJjlgCUo8/uUUixdq8HK44IKnh4EJ0mzUYO6M7w1cfAKwI90lSvgOQWq0XNYxg+jzw9pWSCSMkAWmpCRJAveBKYDOfCYP5C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKa7Ex/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKa7Ex/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4087C4CEF1;
	Wed, 28 Jan 2026 15:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615851;
	bh=uslLRsxhBpHs8Z0mXsZiAGABmX6kcDn/VLv11ST2Bfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKa7Ex/yL6eT84FCHEMAnW+uEiUsBPQ4IMSQLxPLlBL1HYmAoWQByupQYO7B7yTVM
	 cBey33s1aXJMyDh8PJPfFfvgxJjSXXtCy82L+sbya2cOiCgz5VjKI5fCPbIU5mPTTl
	 XJmvAK3DJ69JbQq8Gb/E1D+znOGAeZJmfrMj25y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 131/227] drm/amd/pm: Workaround SI powertune issue on Radeon 430 (v2)
Date: Wed, 28 Jan 2026 16:22:56 +0100
Message-ID: <20260128145349.174903574@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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
index 08ffa79154111..a1da3e5812ce3 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -2281,6 +2281,12 @@ static int si_populate_smc_tdp_limits(struct amdgpu_device *adev,
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
@@ -3468,10 +3474,15 @@ static void si_apply_state_adjust_rules(struct amdgpu_device *adev,
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



