Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80BB197A92;
	Thu,  5 Sep 2024 09:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529879; cv=none; b=nLbo4AV72rhFYlSdmqp1caaLcqN25nKOBCPVk8+Jz6+UwLNIWBggugtGGLUwUcZYMWgLVx9xMkvZ59OOU9DN0XVAXL9Z+YIMoJ6dnwkRCc49tB7X50haWhYiQmJ++bem34mDR+ZitUGc67QjTHarmON82pCM8piVRHC27Opb8c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529879; c=relaxed/simple;
	bh=ik38IIOy0w3RGj6pI+jSETbLtxmd1KpvEH4wOzgBvEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvBvaPMV9YPw5XiNTXhKNrBWQJXHNnZU3MN/aVZyYtTT/aEoKGNFybnK8nUT8eXpgmzoQ0aNEzcdxWlTNelU9BN7gOkm+H4d9UvnYBSsg4eHeyIWqXZRlq/ynQRf6Egfx3ruL0HnDrt7KpDfd6GJRHdIGkh71MLd+rlBM+zrNQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2zG3m7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2zG3m7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E2DC4CEC3;
	Thu,  5 Sep 2024 09:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529879;
	bh=ik38IIOy0w3RGj6pI+jSETbLtxmd1KpvEH4wOzgBvEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2zG3m7YKsKnxq9fR2SgxrrFQPAk73LMDLuKVUP6N8NGeA2Z8WUNxvJsKmzQrpCCZ
	 X4jZ3u1LjtWDt2F+SW1ZcL+KW0EpiOha90nJQOKD3iBHya6gR4jrkBqM5n7s5CZia9
	 at+oPtuZqW2ph5xb7l5w+opKm6cejxsu+OkE6mqc=
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
Subject: [PATCH 6.10 171/184] drm/amd/display: use preferred link settings for dp signal only
Date: Thu,  5 Sep 2024 11:41:24 +0200
Message-ID: <20240905093739.015118059@linuxfoundation.org>
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
index b26faed3bb20..a3df1b55e48b 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -914,21 +914,17 @@ bool link_decide_link_settings(struct dc_stream_state *stream,
 
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



