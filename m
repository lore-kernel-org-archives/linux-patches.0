Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0098F3A16AC;
	Tue, 16 Jun 2026 16:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626268; cv=none; b=qYyuAE9hb+O4yHNi/2ltkNWBPmbs3rQOtBMZUaxDxbtRfp6TDyW/PanCnIT+G+rG+j2J+PXMa85dI/HoPOoJYW2vgS2o6jBrV3TNNBJMVTlrsAESgJpp/44tuXFHjOLt70gTQtT2Dtg+5NwbHJiy4pCgg7T4+atlTaHRG9ywB3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626268; c=relaxed/simple;
	bh=C22Y7fnf+qKdD+Gtn9kPMRIoZID0wzl8OHdaguU6Y8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dw3vFjKG0sh0iGJ2hSor0UujcnRysYvujMWDcnoULiDs0kqhKjbCdRKm7v0kGIZ+Ih96zWIYocZ5wh63B6s0CwykKobshUobm9yaRJS+3/2hP61lC0q4EFE/ObS9qzHC07KkULz9RiUv4ry/FlWbjcR+xB+TgfxASJjyARqeYtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szNoy8j6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szNoy8j6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00AB1F000E9;
	Tue, 16 Jun 2026 16:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626267;
	bh=Gj1wRwhGyVh0EEC1bPE5yI39ovCfA7xpAFtWqwf0Yw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=szNoy8j6xkcazgAulchOwt4MgKWFxmLS5lg7HoILWrWYqmFTJO7kFnATwPQv6ePvm
	 XXGSlrgGANMq5Pu/roqBjfmR0D8f5fz72HtWktvtNY1Z5jO+z3pk09TwPrGIXJp2Qf
	 ajJKvguMPm4azlmNR8C+uO95B/N6qySktvcrJQBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priya Hosur <Priya.Hosur@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 296/325] drm/amd/pm: smu_v14_0_0: use SoftMin for gfxclk in set_soft_freq_limited_range
Date: Tue, 16 Jun 2026 20:31:32 +0530
Message-ID: <20260616145113.609624533@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priya Hosur <Priya.Hosur@amd.com>

commit 03b70e0d8aa26bab89a0f1394c1c80a871925e42 upstream.

In smu_v14_0_0_set_soft_freq_limited_range(), the gfxclk floor is
programmed via SetHardMinGfxClk together with SetSoftMaxGfxClk. Under
power_dpm_force_performance_level=high this pins HardMin to peak gfxclk.

In PMFW arbitration HardMin has higher priority than SoftMax, so the
firmware thermal/PPT throttler cannot clamp gfxclk via SoftMax once
HardMin is set to peak. Replace SetHardMinGfxClk with SetSoftMinGfxclk
so the driver still requests peak performance but the firmware
throttler retains the ability to clamp gfxclk under thermal/PPT
pressure. SoftMax handling is unchanged and no other clock domains
are affected.

Signed-off-by: Priya Hosur <Priya.Hosur@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3ea273267fd29cbf6d83ee72329f59eb5042605b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c
@@ -1221,7 +1221,8 @@ static int smu_v14_0_0_set_soft_freq_lim
 	switch (clk_type) {
 	case SMU_GFXCLK:
 	case SMU_SCLK:
-		msg_set_min = SMU_MSG_SetHardMinGfxClk;
+		/* SoftMin lets PMFW throttle gfxclk; HardMin would override SoftMax. */
+		msg_set_min = SMU_MSG_SetSoftMinGfxclk;
 		msg_set_max = SMU_MSG_SetSoftMaxGfxClk;
 		break;
 	case SMU_FCLK:


