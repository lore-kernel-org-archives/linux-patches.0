Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D40146A67;
	Tue, 25 Jun 2024 09:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309461; cv=none; b=s/qS++byRYhxnSTLQVo8itbE513IqTL02kwaqCbGadq3O2rkoFKUu3upEXCKvmI9QBFAFkZBu4SGhUyiRW8nNHQ876fROnVJy/G8wuaXAMS0vxFC71gKntHTsYTtJGDvYqVjoLUi8oapMw3lOXgs3gj2yr+ddawaQd4qwMtmi9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309461; c=relaxed/simple;
	bh=U1wen8J/vOvcA/bbjaDkptUjVBbzK6LupYE3oK2/GpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHwoDnE5Wpt6JRj7t81xhQTd2Gc8lWBgZnGPn8KFMHzW4gHSoTqydF1tgjFqE/wRKhy0uDEH7zWDjfH710phA8L1KNFQ2I3w+EKgjCzFPNhdLwAGV5lZKOenvZ3BD/OE1vbJljt4jjrzaF7Mo2e08D4ZvEkHb+tCePAmHO1/s/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPKppZnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPKppZnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405F1C32781;
	Tue, 25 Jun 2024 09:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309461;
	bh=U1wen8J/vOvcA/bbjaDkptUjVBbzK6LupYE3oK2/GpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPKppZnFGpiROTxJ5IZfRu+lF5XiOP11vtWh+H005X+qF2eVU+9m+0q6PFGIV8lQZ
	 BjrnWr8Oj6X9EkGOWTyBH4O0M1+TUIK84e1zn43RGpRz+J2fzPzBThilGAXTjj1S3w
	 Cz3TLGxsa9Jd0uVqZBmembC3CvUjB4/UO6q5nAgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/131] drm/amd/display: Exit idle optimizations before HDCP execution
Date: Tue, 25 Jun 2024 11:32:58 +0200
Message-ID: <20240625085526.829882486@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit f30a3bea92bdab398531129d187629fb1d28f598 ]

[WHY]
PSP can access DCN registers during command submission and we need
to ensure that DCN is not in PG before doing so.

[HOW]
Add a callback to DM to lock and notify DC for idle optimization exit.
It can't be DC directly because of a potential race condition with the
link protection thread and the rest of DM operation.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c    | 10 ++++++++++
 drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c
index 5e01c6e24cbc8..9a5a1726acaf8 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c
@@ -88,6 +88,14 @@ static uint8_t is_cp_desired_hdcp2(struct mod_hdcp *hdcp)
 			!hdcp->connection.is_hdcp2_revoked;
 }
 
+static void exit_idle_optimizations(struct mod_hdcp *hdcp)
+{
+	struct mod_hdcp_dm *dm = &hdcp->config.dm;
+
+	if (dm->funcs.exit_idle_optimizations)
+		dm->funcs.exit_idle_optimizations(dm->handle);
+}
+
 static enum mod_hdcp_status execution(struct mod_hdcp *hdcp,
 		struct mod_hdcp_event_context *event_ctx,
 		union mod_hdcp_transition_input *input)
@@ -543,6 +551,8 @@ enum mod_hdcp_status mod_hdcp_process_event(struct mod_hdcp *hdcp,
 	memset(&event_ctx, 0, sizeof(struct mod_hdcp_event_context));
 	event_ctx.event = event;
 
+	exit_idle_optimizations(hdcp);
+
 	/* execute and transition */
 	exec_status = execution(hdcp, &event_ctx, &hdcp->auth.trans_input);
 	trans_status = transition(
diff --git a/drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h b/drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h
index 3348bb97ef81a..dfa8168e51890 100644
--- a/drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h
+++ b/drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h
@@ -155,6 +155,13 @@ struct mod_hdcp_ddc {
 	} funcs;
 };
 
+struct mod_hdcp_dm {
+	void *handle;
+	struct {
+		void (*exit_idle_optimizations)(void *handle);
+	} funcs;
+};
+
 struct mod_hdcp_psp {
 	void *handle;
 	void *funcs;
@@ -271,6 +278,7 @@ struct mod_hdcp_display_query {
 struct mod_hdcp_config {
 	struct mod_hdcp_psp psp;
 	struct mod_hdcp_ddc ddc;
+	struct mod_hdcp_dm dm;
 	uint8_t index;
 };
 
-- 
2.43.0



