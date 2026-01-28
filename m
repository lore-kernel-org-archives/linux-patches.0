Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE3A2DEA6B;
	Wed, 28 Jan 2026 15:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614700; cv=none; b=TYdkeZei0eOVbgkPT/xLu1mBiOZYsWv98Nwfl/NuS/onC03sUCAAB8bxG28ECZOcxfGJ6q7RzafLl3fwRoa82jCZaqIUyi/SgQRgK4fC5vBYvn7RPazA4QVxcRpisFJWyVVxtJrPX1rCkW4FNgrWd/Yv6dDk555gvwxysMa74h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614700; c=relaxed/simple;
	bh=gXAs7AB66Gq8S+cndFWLGlC8A99ghCMChqieRLLtCic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hTKilnNSbDYhfw2Yad1cagnwUdODiZOLUjrKnTCC3m0hmb/KOgzzoWloiPkIMtMyo4Tco/ukFh+K77C8XS640n3o7b/OwJHC9l17HvZJDPz4YzmFTsdveLdLdEXRDqKRfhaCzI1LUGv6ZiwBp5aG/tcfPW8ADmguMDfrnjxtt6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBRsY2pY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBRsY2pY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC477C4CEF1;
	Wed, 28 Jan 2026 15:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614700;
	bh=gXAs7AB66Gq8S+cndFWLGlC8A99ghCMChqieRLLtCic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBRsY2pYVXaWD77shlnTZl1fO53sJ7dQlovOnDJSeQNMRfFOUJWwE6yihZVDQVgyU
	 OXDr+arfGNftwC2Xq7EYNG8qbjD6A3nI+SS/jc5xZMAyjAJoJpyQpbuqo4MWgrYMuJ
	 PRy4k8pIr2vcSUezEB3Y8V+vPee37zXIq9/frHvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/254] drm/amd/pm: Workaround SI powertune issue on Radeon 430 (v2)
Date: Wed, 28 Jan 2026 16:22:28 +0100
Message-ID: <20260128145350.995337318@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e8ca74fc089b7..caf590caaf2c7 100644
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



