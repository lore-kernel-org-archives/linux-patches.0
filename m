Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9073F612D7;
	Tue, 20 Feb 2024 21:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463837; cv=none; b=CbS03dvUGogjzC5Gn/2uKdw43EDnTZTVryvWfkAO+ynZPF4sSCerJeFT8+gWr6iajAGZ5N+tr9Gjet7i261fgw/++aSe9H2X/+Qry5flkk++4yj8nE2Hs7aW9P7LxFyOtV5Tjh1o7w8vsJOpTdxIWKNRels9xgUnQL30prfFSCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463837; c=relaxed/simple;
	bh=Ec5EhI7oJC1nTHnscBGlXdJT+dumccuIhUAzy05nuno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEAMRy8Q9GRJ9doHWJDTi7GLBbugkfizMAE8/O3rwaacfQOY5MtT3O9XLr7w7sU4XSXazhRdA51bKuhTKIIq7mCgdJdV0GVe3B7If04V3TgYqP6Ldmm9+/CsnRaIOIejqO+ZO3PnrRfzAn9fGWxfH/YaWcK46Ka3YaFM0AQmCrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F03ZD1Gk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F03ZD1Gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40E6C433C7;
	Tue, 20 Feb 2024 21:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463837;
	bh=Ec5EhI7oJC1nTHnscBGlXdJT+dumccuIhUAzy05nuno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F03ZD1GkzaWjRnPMeKJmVmtWNkzjMBERJ+cGMyJENxpF0y+e6qITbMMUDC3jVYim3
	 Ja+tmdTLUWtj8S1R+wjo/nKtFo3ocJEKoThFgcsJWZ2ztZv7IAonJiudo9HeSSAhT3
	 cPeQM+tnBvwy5nWd57nlAKWKZVV7+EK79J0IYpc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Zhikai Zhai <zhikai.zhai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.6 168/331] drm/amd/display: Add align done check
Date: Tue, 20 Feb 2024 21:54:44 +0100
Message-ID: <20240220205642.800966255@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhikai Zhai <zhikai.zhai@amd.com>

commit 94b38b895dec8c0ef093140a141e191b60ff614c upstream.

[WHY]
We Double-check link status if training successful,
but miss the lane align status.

[HOW]
Add the lane align status check

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Zhikai Zhai <zhikai.zhai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
@@ -517,6 +517,7 @@ enum link_training_result dp_check_link_
 {
 	enum link_training_result status = LINK_TRAINING_SUCCESS;
 	union lane_status lane_status;
+	union lane_align_status_updated dpcd_lane_status_updated;
 	uint8_t dpcd_buf[6] = {0};
 	uint32_t lane;
 
@@ -532,10 +533,12 @@ enum link_training_result dp_check_link_
 		 * check lanes status
 		 */
 		lane_status.raw = dp_get_nibble_at_index(&dpcd_buf[2], lane);
+		dpcd_lane_status_updated.raw = dpcd_buf[4];
 
 		if (!lane_status.bits.CHANNEL_EQ_DONE_0 ||
 			!lane_status.bits.CR_DONE_0 ||
-			!lane_status.bits.SYMBOL_LOCKED_0) {
+			!lane_status.bits.SYMBOL_LOCKED_0 ||
+			!dp_is_interlane_aligned(dpcd_lane_status_updated)) {
 			/* if one of the channel equalization, clock
 			 * recovery or symbol lock is dropped
 			 * consider it as (link has been


