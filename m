Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1DF23C4F2;
	Tue, 11 Nov 2025 01:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823890; cv=none; b=KKUr9MbSbqAQjEHnXDae8TnGvVeeauQ7eDJoZp86RN2/S9/qwM2cyxEmzHObImw9g+Dhrv49TAn0dGC+SFnv3iv6VBmAvDBDMvolILMBjviM/ucJfauceEtQ9X685wN47tvoLPvC9AKYRNG8ZZfSLm4Lmvf+BlnmmDpW6CoicBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823890; c=relaxed/simple;
	bh=ZXO5aHmXoKoirKr1X9c4HlE8BLw0UCCJyRv3AknyRqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E15nz22Y/7+JNdAdoVR7TSuE8rYoWXg1nPgDMyHNLtQtBPuuhXKDR/QxW4QICXLKJDOulD6BlUAqc4OSpJc6hzluIo5iWfa4hXO0rg8Of5GF7Qw1PEyHil4ybRShXy4Gulmuj6ZMDilwlNz459skrosRzITJLXVqBHG/DxM1KYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mU1j5kO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mU1j5kO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9331AC116B1;
	Tue, 11 Nov 2025 01:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823887;
	bh=ZXO5aHmXoKoirKr1X9c4HlE8BLw0UCCJyRv3AknyRqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mU1j5kO1QAVviGqjGsiN2V6IP1O/lSyLkJ69jEsteQTO9zODe7Br9IIJDmEctsktV
	 nMacD6i3CjZODcNz583aD3+cZi7rqy7zPQf7KuYwDqI+cb/LEeF1GI6JgSHX7VPEEx
	 ccbvOUkMWuHxQb7AaLbyRqcGAsy2bIez0tbdcCWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Park <chris.park@amd.com>,
	Relja Vojvodic <rvojvodi@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 391/849] drm/amd/display: Increase minimum clock for TMDS 420 with pipe splitting
Date: Tue, 11 Nov 2025 09:39:21 +0900
Message-ID: <20251111004545.886344043@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Relja Vojvodic <rvojvodi@amd.com>

[ Upstream commit 002a612023c8b105bd3829d81862dee04368d6de ]

[Why]
-Pipe splitting allows for clocks to be reduced, but when using TMDS 420,
reduced clocks lead to missed clocks cycles on clock resyncing

[How]
-Impose a minimum clock when using TMDS 420

Reviewed-by: Chris Park <chris.park@amd.com>
Signed-off-by: Relja Vojvodic <rvojvodi@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../src/dml2_core/dml2_core_dcn4_calcs.c      | 28 +++++++++++++------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
index b9cff21985110..bf62d42b3f78b 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -1238,18 +1238,27 @@ static void CalculateDETBufferSize(
 
 static double CalculateRequiredDispclk(
 	enum dml2_odm_mode ODMMode,
-	double PixelClock)
+	double PixelClock,
+	bool isTMDS420)
 {
+	double DispClk;
 
 	if (ODMMode == dml2_odm_mode_combine_4to1) {
-		return PixelClock / 4.0;
+		DispClk = PixelClock / 4.0;
 	} else if (ODMMode == dml2_odm_mode_combine_3to1) {
-		return PixelClock / 3.0;
+		DispClk = PixelClock / 3.0;
 	} else if (ODMMode == dml2_odm_mode_combine_2to1) {
-		return PixelClock / 2.0;
+		DispClk = PixelClock / 2.0;
 	} else {
-		return PixelClock;
+		DispClk = PixelClock;
+	}
+
+	if (isTMDS420) {
+		double TMDS420MinPixClock = PixelClock / 2.0;
+		DispClk = math_max2(DispClk, TMDS420MinPixClock);
 	}
+
+	return DispClk;
 }
 
 static double TruncToValidBPP(
@@ -4122,11 +4131,12 @@ static noinline_for_stack void CalculateODMMode(
 	bool success;
 	bool UseDSC = DSCEnable && (NumberOfDSCSlices > 0);
 	enum dml2_odm_mode DecidedODMMode;
+	bool isTMDS420 = (OutFormat == dml2_420 && Output == dml2_hdmi);
 
-	SurfaceRequiredDISPCLKWithoutODMCombine = CalculateRequiredDispclk(dml2_odm_mode_bypass, PixelClock);
-	SurfaceRequiredDISPCLKWithODMCombineTwoToOne = CalculateRequiredDispclk(dml2_odm_mode_combine_2to1, PixelClock);
-	SurfaceRequiredDISPCLKWithODMCombineThreeToOne = CalculateRequiredDispclk(dml2_odm_mode_combine_3to1, PixelClock);
-	SurfaceRequiredDISPCLKWithODMCombineFourToOne = CalculateRequiredDispclk(dml2_odm_mode_combine_4to1, PixelClock);
+	SurfaceRequiredDISPCLKWithoutODMCombine = CalculateRequiredDispclk(dml2_odm_mode_bypass, PixelClock, isTMDS420);
+	SurfaceRequiredDISPCLKWithODMCombineTwoToOne = CalculateRequiredDispclk(dml2_odm_mode_combine_2to1, PixelClock, isTMDS420);
+	SurfaceRequiredDISPCLKWithODMCombineThreeToOne = CalculateRequiredDispclk(dml2_odm_mode_combine_3to1, PixelClock, isTMDS420);
+	SurfaceRequiredDISPCLKWithODMCombineFourToOne = CalculateRequiredDispclk(dml2_odm_mode_combine_4to1, PixelClock, isTMDS420);
 #ifdef __DML_VBA_DEBUG__
 	DML_LOG_VERBOSE("DML::%s: ODMUse = %d\n", __func__, ODMUse);
 	DML_LOG_VERBOSE("DML::%s: Output = %d\n", __func__, Output);
-- 
2.51.0



