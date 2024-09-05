Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2BC18D65E;
	Thu,  5 Sep 2024 09:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530340; cv=none; b=rKu66XbyRtHsOlaRNioTHQ1U2iZPXcy28Ub86M+Z98l1U1hRLK1+rhWPSTKPf+SF/Ogs7VY7j17fqBh0cHNscJdD1i6B3MkZNBQDMC+ZtXLTRii23r4ivbsfH0wXA33Pyr1v+0NvIsvoTv7T19Sa3VLsiWSvSu4wwutM8Ru15Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530340; c=relaxed/simple;
	bh=e7opqCsgbJGkUdPSnvj8acKDJyGLDm1usKLzZuJkz+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRslU8LAohJSdelUl19mtIpt8n48E75hL+zKTed2slknU70aO6EWn9vj0x/uGKQEPrW63bZAdR5+Ri5h5qQzbS1/hWShQJ7Hb2iicmeC/UGhqlCUgEGaBoP4SMC84ajuhuSXp9ANHmR0XwTwF3nTUuoILwEzRR7LTB1S2dGWWCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrYDt/5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrYDt/5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FEFC4CEC3;
	Thu,  5 Sep 2024 09:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530340;
	bh=e7opqCsgbJGkUdPSnvj8acKDJyGLDm1usKLzZuJkz+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrYDt/5CMbi+vlmWRTwQM+bqSyoOKS6U67COizFTjH3Q7Sqb6wrsGZpLJhAz0vRju
	 pHj3E2l4JP1jN0LkBhH5pz02/oUSSH8e7Kp/W3XrioN5FpkNHItwCzk9Pg9RglwQIK
	 WORA+OaThJhVqK5Q85qU5fiUM3SfRLvL+5Q1W9Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/132] drm/amd/display: use preferred link settings for dp signal only
Date: Thu,  5 Sep 2024 11:41:53 +0200
Message-ID: <20240905093727.115354776@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Wenjing Liu <wenjing.liu@amd.com>

[ Upstream commit abf34ca465f5cd182b07701d3f3d369c0fc04723 ]

[why]
We set preferred link settings for virtual signal. However we don't support
virtual signal for UHBR link rate. If preferred is set to UHBR link rate, we
will allow virtual signal with UHBR link rate which causes system crashes.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Wenjing Liu <wenjing.liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/link/protocols/link_dp_capability.c    | 24 ++++++++-----------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index 16f4865e4246..3d589072fe30 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -908,21 +908,17 @@ bool link_decide_link_settings(struct dc_stream_state *stream,
 
 	memset(link_setting, 0, sizeof(*link_setting));
 
-	/* if preferred is specified through AMDDP, use it, if it's enough
-	 * to drive the mode
-	 */
-	if (link->preferred_link_setting.lane_count !=
-			LANE_COUNT_UNKNOWN &&
-			link->preferred_link_setting.link_rate !=
-					LINK_RATE_UNKNOWN) {
+	if (dc_is_dp_signal(stream->signal)  &&
+			link->preferred_link_setting.lane_count != LANE_COUNT_UNKNOWN &&
+			link->preferred_link_setting.link_rate != LINK_RATE_UNKNOWN) {
+		/* if preferred is specified through AMDDP, use it, if it's enough
+		 * to drive the mode
+		 */
 		*link_setting = link->preferred_link_setting;
-		return true;
-	}
-
-	/* MST doesn't perform link training for now
-	 * TODO: add MST specific link training routine
-	 */
-	if (stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST) {
+	} else if (stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST) {
+		/* MST doesn't perform link training for now
+		 * TODO: add MST specific link training routine
+		 */
 		decide_mst_link_settings(link, link_setting);
 	} else if (link->connector_signal == SIGNAL_TYPE_EDP) {
 		/* enable edp link optimization for DSC eDP case */
-- 
2.43.0



