Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10EE2DA768;
	Tue, 11 Nov 2025 01:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823132; cv=none; b=d9nkHDPrnrNHT6cVv7cnMVQVMLhECPJtwL8e3Cc5Lo03AsfPVakFrD4nphAkcFKLK51wi0AzuQuldMVm25noQR7od4kdFf8NyL+eLf0jqonl2Sf1+mmlqONnIu36abkx6nQVJ8tU0B3ztgrdqs4pNs4bfg/I5uDfmcvnbzASNI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823132; c=relaxed/simple;
	bh=AMwDVL1tejcgZVnvaPA5I/JAQxGevlcUZgZzS4v5UXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvLyhpXaSpRj5F6vLEBEjwdmRpO3MOa/yaam1LDgdW+b403QuouRTgxWwieY5e1ukd+WkP/LIUb6hnJdInpKN81joNFVJWPpE0SE8KI7r6vlwBvOj7kUO3wQSWRPASq6s9AoLV44asaKLO4Z+k4g7eExbUAKqgXQYKgTTQ48Crs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jha4smoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jha4smoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2EFC4CEF5;
	Tue, 11 Nov 2025 01:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823132;
	bh=AMwDVL1tejcgZVnvaPA5I/JAQxGevlcUZgZzS4v5UXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jha4smoHxC+zIYQ24c5fqwGyMbDo/Btwb4W8N4YzG64hX+AMsoIak/DYKJbxIKg3B
	 HOJuifL7TxihK7GFm/xqxcfuR4XHHCZQvAs6N3BLAeZmlvfccEkN5jbYi017Sz37aR
	 pHpnJMcncrn1ckZOuOyTfluza4q5vF+z7o75axU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Michael Strauss <michael.strauss@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/565] drm/amd/display: Increase AUX Intra-Hop Done Max Wait Duration
Date: Tue, 11 Nov 2025 09:40:33 +0900
Message-ID: <20251111004530.915687661@linuxfoundation.org>
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

From: Michael Strauss <michael.strauss@amd.com>

[ Upstream commit e3419e1e44b87d4176fb98679a77301b1ca40f63 ]

[WHY]
In the worst case, AUX intra-hop done can take hundreds of milliseconds as
each retimer in a link might have to wait a full AUX_RD_INTERVAL to send
LT abort downstream.

[HOW]
Wait 300ms for each retimer in a link to allow time to propagate a LT abort
without infinitely waiting on intra-hop done.
For no-retimer case, keep the max duration at 10ms.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/link/protocols/link_dp_training.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
index 9385a32a471b8..16b5e6b64162a 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
@@ -1012,7 +1012,12 @@ static enum link_training_result dpcd_exit_training_mode(struct dc_link *link, e
 {
 	enum dc_status status;
 	uint8_t sink_status = 0;
-	uint8_t i;
+	uint32_t i;
+	uint8_t lttpr_count = dp_parse_lttpr_repeater_count(link->dpcd_caps.lttpr_caps.phy_repeater_cnt);
+	uint32_t intra_hop_disable_time_ms = (lttpr_count > 0 ? lttpr_count * 300 : 10);
+
+	// Each hop could theoretically take over 256ms (max 128b/132b AUX RD INTERVAL)
+	// To be safe, allow 300ms per LTTPR and 10ms for no LTTPR case
 
 	/* clear training pattern set */
 	status = dpcd_set_training_pattern(link, DP_TRAINING_PATTERN_VIDEOIDLE);
@@ -1022,7 +1027,7 @@ static enum link_training_result dpcd_exit_training_mode(struct dc_link *link, e
 
 	if (encoding == DP_128b_132b_ENCODING) {
 		/* poll for intra-hop disable */
-		for (i = 0; i < 10; i++) {
+		for (i = 0; i < intra_hop_disable_time_ms; i++) {
 			if ((core_link_read_dpcd(link, DP_SINK_STATUS, &sink_status, 1) == DC_OK) &&
 					(sink_status & DP_INTRA_HOP_AUX_REPLY_INDICATION) == 0)
 				break;
-- 
2.51.0



