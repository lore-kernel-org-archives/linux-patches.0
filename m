Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B587436828A;
	Mon,  9 Feb 2026 14:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648014; cv=none; b=R3tfsVSKGmVmyIPpiJwnl2hTLDpAL5HjvVf1MVTn2CdPAGgUasw6hCxUyRhjYuQkHwzqlYCkLIGor843UkhFVmPcsK5EHRE2Znlcjbfc/sFIUF2wlULYsxA30vywBsFttUSaA8JdevpmKQbsVu2nTR42kqyQSzVL9kau2mWJheY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648014; c=relaxed/simple;
	bh=t+9v2Tz9f3NZi05N0MWlUVzXiF9shXAzdrzIv0yFNz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQG4w9Z7jnovAdk50NYKdjiJ2vMh8ioZmArzn3vIt2Yabx4i6z8Y1A/X3BdSrGaMFt1Yg3ktMonSoMGSp0M7yiJn3sMb9apTXCf8bh55Lk3bpyZJ3p+UxgleGxJjC6RJPs/bBprOWb50V4lseDp7tfJ+UJxsFQ2qWQKaV2vtlP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hm/ufwLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hm/ufwLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2972EC116C6;
	Mon,  9 Feb 2026 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648014;
	bh=t+9v2Tz9f3NZi05N0MWlUVzXiF9shXAzdrzIv0yFNz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hm/ufwLSIzv4qt7s84yXAuLnBSeY+GqVQ1vPB7i808NllevD7n/EiHUkQLZoMb07H
	 YHntQ3WsCTQajXe4sTYI39ARP1wBhJYWEi6A89/EC4NvwfBAxZSuWcEVoXbe67Tdhr
	 QUTILHO0TNJkaVnGd+XmdpAE5ZPGJ18QpK5PJj/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/113] drm/amd/display: fix wrong color value mapping on MCM shaper LUT
Date: Mon,  9 Feb 2026 15:24:03 +0100
Message-ID: <20260209142313.559012092@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit 8f959d37c1f2efec6dac55915ee82302e98101fb ]

Some shimmer/colorful points appears when using the steamOS color
pipeline for HDR on gaming with DCN32. These points look like black
values being wrongly mapped to red/blue/green values. It was caused
because the number of hw points in regular LUTs and in a shaper LUT was
treated as the same.

DCN3+ regular LUTs have 257 bases and implicit deltas (i.e. HW
calculates them), but shaper LUT is a special case: it has 256 bases and
256 deltas, as in DCN1-2 regular LUTs, and outputs 14-bit values.

Fix that by setting by decreasing in 1 the number of HW points computed
in the LUT segmentation so that shaper LUT (i.e. fixpoint == true) keeps
the same DCN10 CM logic and regular LUTs go with `hw_points + 1`.

CC: Krunoslav Kovac <Krunoslav.Kovac@amd.com>
Fixes: 4d5fd3d08ea9 ("drm/amd/display: PQ tail accuracy")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5006505b19a2119e71c008044d59f6d753c858b9)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
index f31f0e3abfc0f..f299d9455f510 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c
@@ -168,6 +168,11 @@ bool cm3_helper_translate_curve_to_hw_format(
 			hw_points += (1 << seg_distr[k]);
 	}
 
+	// DCN3+ have 257 pts in lieu of no separate slope registers
+	// Prior HW had 256 base+slope pairs
+	// Shaper LUT (i.e. fixpoint == true) is still 256 bases and 256 deltas
+	hw_points = fixpoint ? (hw_points - 1) : hw_points;
+
 	j = 0;
 	for (k = 0; k < (region_end - region_start); k++) {
 		increment = NUMBER_SW_SEGMENTS / (1 << seg_distr[k]);
@@ -228,8 +233,6 @@ bool cm3_helper_translate_curve_to_hw_format(
 	corner_points[1].green.slope = dc_fixpt_zero;
 	corner_points[1].blue.slope = dc_fixpt_zero;
 
-	// DCN3+ have 257 pts in lieu of no separate slope registers
-	// Prior HW had 256 base+slope pairs
 	lut_params->hw_points_num = hw_points + 1;
 
 	k = 0;
-- 
2.51.0



