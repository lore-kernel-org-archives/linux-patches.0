Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AA530101A;
	Fri, 21 Nov 2025 13:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732424; cv=none; b=fFHttMqbZyG30LXvpuygQbkT595QDhBm8v3hR53E8cvJVhA9AW/NFH+3Ceyvt4PORm1FtnqWRj6gyj8PkxVJi6UXWHS9XWG7vfMM+kb9fY+ZcqZf7JrK8SC6JtDxLeSBzDVHFdxUY5Wy93m1sJq6T/768zTq0JF3eit+K8zUhxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732424; c=relaxed/simple;
	bh=pMDPfoWQno7woFCvu2BteXVBAYt/o0KyfeOAwmy7RoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DijdrMvqYw/x27sU5J2qZVIbkAPQ8mLuNRqhNQsNvQQjDXN1OP7WfXcJBUpeVhOpu64P3OZqMaEE0zOR92ea0QWh3d6DjVKkbeyfhe3cMUSzQmxomxdK4EixmEuek65941hbpi6GB5W2jnLDRIDBrG/eL9LI5U9T0HHmWZUImPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rDiGuyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rDiGuyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF0AC4CEF1;
	Fri, 21 Nov 2025 13:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732424;
	bh=pMDPfoWQno7woFCvu2BteXVBAYt/o0KyfeOAwmy7RoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rDiGuyX0VkVIrFpXtelOtvOb7m/ZY8jAV0+6HezLOqtqBT+LYChwnRVWzWcx+lqH
	 kAhrcryWKJ97F4Nqn9hmMFaeWgfuT7jKVwEqnTnu1HYS54yH8qrDefNnl3I/49RzdE
	 ylSWjZ2Ok+UmY1oTIHWxrpmtXaUu071Nhmb/8Bv8=
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
Subject: [PATCH 6.6 116/529] drm/amd/display: Increase AUX Intra-Hop Done Max Wait Duration
Date: Fri, 21 Nov 2025 14:06:55 +0100
Message-ID: <20251121130235.151223700@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 51e88efee11e4..08c2f11724140 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
@@ -974,14 +974,19 @@ void repeater_training_done(struct dc_link *link, uint32_t offset)
 static void dpcd_exit_training_mode(struct dc_link *link, enum dp_link_encoding encoding)
 {
 	uint8_t sink_status = 0;
-	uint8_t i;
+	uint32_t i;
+	uint8_t lttpr_count = dp_parse_lttpr_repeater_count(link->dpcd_caps.lttpr_caps.phy_repeater_cnt);
+	uint32_t intra_hop_disable_time_ms = (lttpr_count > 0 ? lttpr_count * 300 : 10);
+
+	// Each hop could theoretically take over 256ms (max 128b/132b AUX RD INTERVAL)
+	// To be safe, allow 300ms per LTTPR and 10ms for no LTTPR case
 
 	/* clear training pattern set */
 	dpcd_set_training_pattern(link, DP_TRAINING_PATTERN_VIDEOIDLE);
 
 	if (encoding == DP_128b_132b_ENCODING) {
 		/* poll for intra-hop disable */
-		for (i = 0; i < 10; i++) {
+		for (i = 0; i < intra_hop_disable_time_ms; i++) {
 			if ((core_link_read_dpcd(link, DP_SINK_STATUS, &sink_status, 1) == DC_OK) &&
 					(sink_status & DP_INTRA_HOP_AUX_REPLY_INDICATION) == 0)
 				break;
-- 
2.51.0



