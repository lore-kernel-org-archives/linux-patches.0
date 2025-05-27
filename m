Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FD927FD43;
	Tue, 27 May 2025 17:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367785; cv=none; b=jE9e8gfJFVWTuISGy79OC4+jGEu0EjFLppWxAguGbDyx3zvWL5TsnZ3kwSY7cQqYG4KbEGgcJGSsZpOelMtKMrXgR2OvodQhLpUBBxXKr/Vk6notDicubtoZDNOLzBCgvQ42HpUmzc4qf4I5vumvoC3rFImWIM+0DCIuJHHE7bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367785; c=relaxed/simple;
	bh=65Temymziy10mCYIZkl2C7r7WcJdurOPATluHZotTn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCpvlOgTxRDki3fBWirjjNkQQib3hynJg+utAafLBCsufQfSGFX7a9aeHJCLJLKK3MzB3EOdFJKhbx98WiD8ZIwFtwdFdLzMlEuvtnjCuJrO3jF1tM14g9HBflFjhYpGCSUd26EQqmVlDeXRfdN2sxNgbL9lnQw28vrIexsVcz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgAozbFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgAozbFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A87C4CEE9;
	Tue, 27 May 2025 17:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367785;
	bh=65Temymziy10mCYIZkl2C7r7WcJdurOPATluHZotTn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgAozbFgdsUmOd79ll4gXPixFGGkzF2KdKUQ8AaOBuVxdP861cVpl0scRabJshvhM
	 x0hpF5nL0Fw3TuxRacd31celaPZn9QIjTkdefDiL8X8KkO7MVTO9f7T3GkxwtIywEP
	 Slpr1ePJbVJNL3WGlogas3wbSxV2A/ZHMIn9/1kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Austin Zheng <Austin.Zheng@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 498/783] drm/amd/display: Use Nominal vBlank If Provided Instead Of Capping It
Date: Tue, 27 May 2025 18:24:55 +0200
Message-ID: <20250527162533.423816763@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Austin Zheng <Austin.Zheng@amd.com>

[ Upstream commit 41df56b1fc24cc36fffb10e437385b3a49fbb5e2 ]

[Why/How]
vBlank used to determine the max vStartup is based on the smallest between
the vblank provided by the timing and vblank in ip_caps.
Extra vblank time is not considered if the vblank provided by the timing ends
up being higher than what's defined by the ip_caps

Use 1 less than the vblank size in case the timing is interlaced
so vstartup will always be less than vblank_nom.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Austin Zheng <Austin.Zheng@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c       | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
index 913f33c31cf38..a72b4c05e1fbf 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -3713,13 +3713,12 @@ static unsigned int CalculateMaxVStartup(
 	double line_time_us = (double)timing->h_total / ((double)timing->pixel_clock_khz / 1000);
 	unsigned int vblank_actual = timing->v_total - timing->v_active;
 	unsigned int vblank_nom_default_in_line = (unsigned int)math_floor2((double)vblank_nom_default_us / line_time_us, 1.0);
-	unsigned int vblank_nom_input = (unsigned int)math_min2(timing->vblank_nom, vblank_nom_default_in_line);
-	unsigned int vblank_avail = (vblank_nom_input == 0) ? vblank_nom_default_in_line : vblank_nom_input;
+	unsigned int vblank_avail = (timing->vblank_nom == 0) ? vblank_nom_default_in_line : (unsigned int)timing->vblank_nom;
 
 	vblank_size = (unsigned int)math_min2(vblank_actual, vblank_avail);
 
 	if (timing->interlaced && !ptoi_supported)
-		max_vstartup_lines = (unsigned int)(math_floor2(vblank_size / 2.0, 1.0));
+		max_vstartup_lines = (unsigned int)(math_floor2((vblank_size - 1) / 2.0, 1.0));
 	else
 		max_vstartup_lines = vblank_size - (unsigned int)math_max2(1.0, math_ceil2(write_back_delay_us / line_time_us, 1.0));
 #ifdef __DML_VBA_DEBUG__
-- 
2.39.5



