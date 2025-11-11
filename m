Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCF12DEA9D;
	Tue, 11 Nov 2025 01:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823140; cv=none; b=t8NWSoUt1OlOv+kQhccnyZqRjpH6qD7ynygSgMzP11Fey9905M8OD9mKn1n6pTXcRDeS7PIcZ4Zr1xBIZ2t/MASoRGvD4pFlR36FCYNbhwGcPKvB2QPdGZvAP/tlDX4//t80oi4H/8fJPhPUQ3KMyandGfJz0N8APZMdpvNBY4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823140; c=relaxed/simple;
	bh=JnF02ApenazAgjaRg5roIeHbSXOzbPCcQ1edTPbuW90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVym2MDckU2PSb8+sz4QLu+pBPYECsS+NTVu9RyMpIEMBQcd+b7MLcBpbwhC5X9OCpYBdtIDF4hb7mMwWAlVP3NkjfWBmSn/pIm0lpghD0pTmEhSzXvNsjqhh0/Th2FC5ep7SI90SCpndWj/PHKl5Llq1t+bKCWyJPO+XtJwRwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQfJ3PLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQfJ3PLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5157AC4CEFB;
	Tue, 11 Nov 2025 01:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823139;
	bh=JnF02ApenazAgjaRg5roIeHbSXOzbPCcQ1edTPbuW90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQfJ3PLLZADTeOjL2PqbfPdP578GYlilTX4IdZ9KHKeVk4aNw6+OJSZYmDggOI962
	 Z6irjMHNlIuZAakiaHoVXiBTqMJTutDxDei2EuUNk8wdNgfWG0KKsnKRVBii1Lge+W
	 6mK+Kgpd6pbz7+KKBwqwHZRZe3Je8wmf+a3wn5bA=
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
Subject: [PATCH 6.17 238/849] drm/amd/display: Increase AUX Intra-Hop Done Max Wait Duration
Date: Tue, 11 Nov 2025 09:36:48 +0900
Message-ID: <20251111004542.194942759@linuxfoundation.org>
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
index 2dc1a660e5045..134093ce5a8e8 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
@@ -1018,7 +1018,12 @@ static enum link_training_result dpcd_exit_training_mode(struct dc_link *link, e
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
@@ -1028,7 +1033,7 @@ static enum link_training_result dpcd_exit_training_mode(struct dc_link *link, e
 
 	if (encoding == DP_128b_132b_ENCODING) {
 		/* poll for intra-hop disable */
-		for (i = 0; i < 10; i++) {
+		for (i = 0; i < intra_hop_disable_time_ms; i++) {
 			if ((core_link_read_dpcd(link, DP_SINK_STATUS, &sink_status, 1) == DC_OK) &&
 					(sink_status & DP_INTRA_HOP_AUX_REPLY_INDICATION) == 0)
 				break;
-- 
2.51.0



