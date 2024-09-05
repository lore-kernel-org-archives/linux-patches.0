Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534AA1494DB;
	Thu,  5 Sep 2024 10:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530513; cv=none; b=aEsgWeWKZIjBSGf3ABTrCcTfoiJqxyYCy8EYqHJ8kUwys2bV1mLhJYINC/6O5PB/kCLFx9yvZocarCUWJgjFvsipPU8bmw1/NL78MJPteUWxZe4oeloDk4ycpBB0ndAgnR8pZxURdHxASkmFCLy/gsyipD0wimmatjMeFvjBlSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530513; c=relaxed/simple;
	bh=xPBotwMgeHZqvUgP1RdKIrFLEbpO5oeiIiP/CUtin54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=th6tmzED9D5JPA0crtYWbYlRg/OxyXaQ/ET2++ciCAEWeKcbUtSqg9Ad0G+TRckiPosr30wq/87R8Vlu9Yj56Ti1zDWQmrpMCDgUhV0yHKzgoLigzYHC+0J0jNwafrkMiaERIid4yN6J9iXkK0WOkUefLseSLfHmU2bCXWWaXHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZ+Hc0dR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZ+Hc0dR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D30C4CEC3;
	Thu,  5 Sep 2024 10:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530513;
	bh=xPBotwMgeHZqvUgP1RdKIrFLEbpO5oeiIiP/CUtin54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZ+Hc0dRCfv1A9ukAsh6fLWNBwLBbHTHaIsSaPZIiYbLYWxJ42N3Svhg9mqSRtVAj
	 A464afSXa88KUW7qBlDPEO9dihrxcG5tgFpIAbF5I6a7wgYDjgjjf+qYMVBM1E0Dk+
	 AVzFStEr+7ljxAId+FBA9oLjFOWaccRzRYm0Ke+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/101] drm/amd/display: Ensure index calculation will not overflow
Date: Thu,  5 Sep 2024 11:41:19 +0200
Message-ID: <20240905093717.979143404@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 8e2734bf444767fed787305ccdcb36a2be5301a2 ]

[WHY & HOW]
Make sure vmid0p72_idx, vnom0p8_idx and vmax0p9_idx calculation will
never overflow and exceess array size.

This fixes 3 OVERRUN and 1 INTEGER_OVERFLOW issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/calcs/dcn_calcs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/calcs/dcn_calcs.c b/drivers/gpu/drm/amd/display/dc/dml/calcs/dcn_calcs.c
index e73f089c84bb..ebd7ed1b9a3c 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/calcs/dcn_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/calcs/dcn_calcs.c
@@ -1453,10 +1453,9 @@ void dcn_bw_update_from_pplib_fclks(
 	ASSERT(fclks->num_levels);
 
 	vmin0p65_idx = 0;
-	vmid0p72_idx = fclks->num_levels -
-		(fclks->num_levels > 2 ? 3 : (fclks->num_levels > 1 ? 2 : 1));
-	vnom0p8_idx = fclks->num_levels - (fclks->num_levels > 1 ? 2 : 1);
-	vmax0p9_idx = fclks->num_levels - 1;
+	vmid0p72_idx = fclks->num_levels > 2 ? fclks->num_levels - 3 : 0;
+	vnom0p8_idx = fclks->num_levels > 1 ? fclks->num_levels - 2 : 0;
+	vmax0p9_idx = fclks->num_levels > 0 ? fclks->num_levels - 1 : 0;
 
 	dc->dcn_soc->fabric_and_dram_bandwidth_vmin0p65 =
 		32 * (fclks->data[vmin0p65_idx].clocks_in_khz / 1000.0) / 1000.0;
-- 
2.43.0



