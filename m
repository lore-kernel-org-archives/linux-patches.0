Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFC413AD3F;
	Thu,  5 Sep 2024 09:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529568; cv=none; b=IDQPSg9NxibxAIX5EEVo7VuLpm6nTeLt81DBxuQQUotFLdUsibVknZdBd4MRW0abTvrp4or/Fd0XCR0DdSv6R4d0+YAhXktkrpBkCWpFKcjQVl5npd1P/qK7FPox+L1ZB3It1g4hhz+sakue2uejktnO4WubggJvScfyIW11z0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529568; c=relaxed/simple;
	bh=78x1iNJjzA4TUIQFjEOHBWPmQ/VQGl/iYdUf8D+WIBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSut/zcizOHp6YhDjLRCpyZnXmyKd45ubODYYWOSayrQllwJxr20dvGfRkbLW9b0Nyasd9oW+K7Xh9+2zcUwagEjvzbF58baAZkRFt4KNCMwxLD725ICaPIUJd4DcC2oA9RwvwqtskyKrzHIxUt8MfnabYdCrYWEj5GKZ+umtXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXfeLxHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXfeLxHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936BCC4CEC3;
	Thu,  5 Sep 2024 09:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529568;
	bh=78x1iNJjzA4TUIQFjEOHBWPmQ/VQGl/iYdUf8D+WIBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXfeLxHq1YV1+HYKoCQ8pU3RvxH3qUajlLlaCO4Tya8Q5m1LgJ6UJ2hkSR2TUlWK5
	 f21HxDJWaw1Iidtu07BgS8LVMpwm/QSbaWVRIJxJAd0zO98yTEfzeSUtHAqh0PBtYy
	 2YibKd6KIgT2zGvqjI5s61HKLjB8VMUToXgFnghM=
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
Subject: [PATCH 6.10 075/184] drm/amd/display: Ensure index calculation will not overflow
Date: Thu,  5 Sep 2024 11:39:48 +0200
Message-ID: <20240905093735.170081639@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0c4a8fe8e5ca..f1cde1e4265f 100644
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



