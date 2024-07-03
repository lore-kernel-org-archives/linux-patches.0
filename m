Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158C261FDF;
	Wed,  3 Jul 2024 11:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004697; cv=none; b=mxHZjbfRDl26UNvQxHJabgvf24q4S39YA8QU5n2FCSMGVmr13pMWJ/z/mvoC6Kof0OHyWkM+repa4SnFmtWf8l9BIi1RDyAv26feVif+Eh8Fmnu2szB8XhvvaY29m4Ow8HrC41Gs3EolPSDnhjlKoIqj2McJ3mcN05P4AhjNqUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004697; c=relaxed/simple;
	bh=glfdY6aTCSnt1OWTMlMDrqUbIxFV2DlXm5Tn5Yy+RLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h770rDSuuXHztlFUEhZo5vg+kLF6PsPHwnQy2WxW7eNQ1U1En8TNVzCKj1LL3brDejBLv/e5N+siRJP+XtFXY6r9IA8isEjOkyTbDwgDsk7ddnKmhDE7GXuFtLCygtNQJVVM65HnWdOsFHj4gO4DOLP7MImfKzvjecL9tKR8Ly4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUXY6L15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUXY6L15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B806C4AF0E;
	Wed,  3 Jul 2024 11:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004696;
	bh=glfdY6aTCSnt1OWTMlMDrqUbIxFV2DlXm5Tn5Yy+RLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUXY6L15T2iQpZCU7J3xMBUKkUF7hi2h+lR+uAA5uAZiRmCnYQL9tLw7b8DQufTrV
	 wQ9921HR7PEwCZzz3WL1j3oTILoIPKEsSwprMojVWD/GDRtg8r6IkchhZj5eCZTubu
	 DQzHC6/cW1GFK372fzoFE7MEHa97hsPUx6YKF2h4=
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
Subject: [PATCH 5.10 121/290] drm/amd/display: Exit idle optimizations before HDCP execution
Date: Wed,  3 Jul 2024 12:38:22 +0200
Message-ID: <20240703102908.761106184@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fa8aeec304ef4..c39cb4b6767cf 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c
@@ -86,6 +86,14 @@ static uint8_t is_cp_desired_hdcp2(struct mod_hdcp *hdcp)
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
@@ -448,6 +456,8 @@ enum mod_hdcp_status mod_hdcp_process_event(struct mod_hdcp *hdcp,
 	memset(&event_ctx, 0, sizeof(struct mod_hdcp_event_context));
 	event_ctx.event = event;
 
+	exit_idle_optimizations(hdcp);
+
 	/* execute and transition */
 	exec_status = execution(hdcp, &event_ctx, &hdcp->auth.trans_input);
 	trans_status = transition(
diff --git a/drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h b/drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h
index eed560eecbab4..fb195276fb704 100644
--- a/drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h
+++ b/drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h
@@ -143,6 +143,13 @@ struct mod_hdcp_ddc {
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
@@ -252,6 +259,7 @@ struct mod_hdcp_display_query {
 struct mod_hdcp_config {
 	struct mod_hdcp_psp psp;
 	struct mod_hdcp_ddc ddc;
+	struct mod_hdcp_dm dm;
 	uint8_t index;
 };
 
-- 
2.43.0



