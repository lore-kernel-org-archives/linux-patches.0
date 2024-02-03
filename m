Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3753C4F883;
	Sat,  3 Feb 2024 04:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933848; cv=none; b=PGg6XgLCVMoM/ICM1PQApFNJsSavTbFCcRkB/2yIv9kC4rZVHqvO6jNtGSRQlJwRkrzxpkuHADCt97Ykl6dn1Dj7TSkRa+SHzgxci1DIHpBwrv5xjsaJXVAzcWGpdxDpy3sLHR9e3VsHJTp/Z3d4a4cAWXo+14AmGZt6PzaQt3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933848; c=relaxed/simple;
	bh=T1eGxRJsT31qXk9eVPyOpaaElOGG1RrmgSpFyW0lMZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taVmi8JImbTo34tTA/7hAAMzX8TbnDanO/Zj2AlR1KJn6dlzXqf+52ZXN7ZigU3L72LRWkj9Hm0ELTlVMOtnmnuhus1SoZMtXD2ftnIgrwMSn+2i5q26s013IQfJiRsnpHQ4ANLeGhaK4IMf+4OEhNdtYRXGoRGqhKYHiS6mqdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mW62JXcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mW62JXcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12E0C433C7;
	Sat,  3 Feb 2024 04:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933848;
	bh=T1eGxRJsT31qXk9eVPyOpaaElOGG1RrmgSpFyW0lMZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mW62JXcV5+0N3hfoNajRVPFYuXqJb/eUXP1o5rDGPTMQGQDPYf3fZrhhWxHdsZ2b6
	 3htsjSuOzFrTjIXXSdoA9tOqbbpC5girFoATYN/NF5+CptRKVbZ+JaLLaJuTYUPfFh
	 KY/Adw6zlEswNksj21c6lR8YmaRw6jo0Q3x+GApE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Robin Chen <robin.chen@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Dennis Chan <dennis.chan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 177/353] drm/amd/display: Fix Replay Desync Error IRQ handler
Date: Fri,  2 Feb 2024 20:04:55 -0800
Message-ID: <20240203035409.248847266@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dennis Chan <dennis.chan@amd.com>

[ Upstream commit dd5c6362ddcd8bdb07704faff8648593885ecfa1 ]

In previous case, Replay didn't identify the IRQ type, This commit fixes
the issues for the interrupt.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Robin Chen <robin.chen@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Dennis Chan <dennis.chan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/link/protocols/link_dp_irq_handler.c  | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c
index 0c00e94e90b1..9eadc2c7f221 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c
@@ -190,9 +190,6 @@ static void handle_hpd_irq_replay_sink(struct dc_link *link)
 	/*AMD Replay version reuse DP_PSR_ERROR_STATUS for REPLAY_ERROR status.*/
 	union psr_error_status replay_error_status;
 
-	if (link->replay_settings.config.force_disable_desync_error_check)
-		return;
-
 	if (!link->replay_settings.replay_feature_enabled)
 		return;
 
@@ -210,9 +207,6 @@ static void handle_hpd_irq_replay_sink(struct dc_link *link)
 		&replay_error_status.raw,
 		sizeof(replay_error_status.raw));
 
-	if (replay_configuration.bits.DESYNC_ERROR_STATUS)
-		link->replay_settings.config.received_desync_error_hpd = 1;
-
 	link->replay_settings.config.replay_error_status.bits.LINK_CRC_ERROR =
 		replay_error_status.bits.LINK_CRC_ERROR;
 	link->replay_settings.config.replay_error_status.bits.DESYNC_ERROR =
@@ -225,6 +219,12 @@ static void handle_hpd_irq_replay_sink(struct dc_link *link)
 		link->replay_settings.config.replay_error_status.bits.STATE_TRANSITION_ERROR) {
 		bool allow_active;
 
+		if (link->replay_settings.config.replay_error_status.bits.DESYNC_ERROR)
+			link->replay_settings.config.received_desync_error_hpd = 1;
+
+		if (link->replay_settings.config.force_disable_desync_error_check)
+			return;
+
 		/* Acknowledge and clear configuration bits */
 		dm_helpers_dp_write_dpcd(
 			link->ctx,
-- 
2.43.0



