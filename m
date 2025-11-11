Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A10C263F52;
	Tue, 11 Nov 2025 01:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824132; cv=none; b=rfxvz70NyV97KobqDi6nF5MxeMy7mpd6GzSw3NFmTj2L61D0wHoLig1TcwP4YCw+e/BvVFpyb/+jZQP2/yiA6r0D4mRwAxkkg9outSTSBwpqN9xK2oiQKuh5ahlyYE4L6QP5COtkRdq2FV9hjGirEN3pRY7t9hMH9AMtrv10iPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824132; c=relaxed/simple;
	bh=TMKE7IlWqyYzI+qRZlQT+i/u4A1oDEI0GPv+iF4EG0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edHEnIy0VOqlps+uNZyz3KE1vf/9pYa2ikuxlxOen6mgtb877x9goPBq/RzKTtMymLMS02IIKNhiujIkUmcp22PhC1rMakgtb6wTrv9IPIp/JtyRs2K4dCU4HHp+pd7kNJeJjP52K6SBCC++v0xRnC3AXsnaBUTOkl2U7BKb/7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAlEkQZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAlEkQZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF93C116D0;
	Tue, 11 Nov 2025 01:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824132;
	bh=TMKE7IlWqyYzI+qRZlQT+i/u4A1oDEI0GPv+iF4EG0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAlEkQZD95xaPj81WJo13LEmKLvBL7KFt+CwCGWZ0raOF7GfUQfoOuDwZ/Vxnm05/
	 i2BA2JSf/ZNiHG7ZxDIJB2FwGyEN+Yka5hSuUCTKeLPcGtGjvF7l9dKHetyfsbAtuf
	 3cI+vw7s+P8RlEqes7Ci6jMx0jAqaAtBWqACPPD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Chen <leo.chen@amd.com>,
	Ausef Yousof <Ausef.Yousof@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 362/565] drm/amd/display: fix dml ms order of operations
Date: Tue, 11 Nov 2025 09:43:38 +0900
Message-ID: <20251111004535.010145146@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Ausef Yousof <Ausef.Yousof@amd.com>

[ Upstream commit 02a6c2e4b28ff31f7a904c196a99fb2efe81e2cf ]

[why&how]
small error in order of operations in immediateflipbytes
calculation on dml ms side that can result in dml ms
and mp mismatch immediateflip support for a given pipe
and thus an invalid hw state, correct the order to align
with mp.

Reviewed-by: Leo Chen <leo.chen@amd.com>
Signed-off-by: Ausef Yousof <Ausef.Yousof@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
index 6822b07951204..d0b7fae7d73c8 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
@@ -6527,7 +6527,7 @@ static void dml_prefetch_check(struct display_mode_lib_st *mode_lib)
 				mode_lib->ms.TotImmediateFlipBytes = 0;
 				for (k = 0; k <= mode_lib->ms.num_active_planes - 1; k++) {
 					if (!(mode_lib->ms.policy.ImmediateFlipRequirement[k] == dml_immediate_flip_not_required)) {
-						mode_lib->ms.TotImmediateFlipBytes = mode_lib->ms.TotImmediateFlipBytes + mode_lib->ms.NoOfDPP[j][k] * mode_lib->ms.PDEAndMetaPTEBytesPerFrame[j][k] + mode_lib->ms.MetaRowBytes[j][k];
+						mode_lib->ms.TotImmediateFlipBytes = mode_lib->ms.TotImmediateFlipBytes + mode_lib->ms.NoOfDPP[j][k] * (mode_lib->ms.PDEAndMetaPTEBytesPerFrame[j][k] + mode_lib->ms.MetaRowBytes[j][k]);
 						if (mode_lib->ms.use_one_row_for_frame_flip[j][k]) {
 							mode_lib->ms.TotImmediateFlipBytes = mode_lib->ms.TotImmediateFlipBytes + mode_lib->ms.NoOfDPP[j][k] * (2 * mode_lib->ms.DPTEBytesPerRow[j][k]);
 						} else {
-- 
2.51.0



