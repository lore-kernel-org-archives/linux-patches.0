Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A955813B2B4;
	Tue, 27 Feb 2024 13:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041399; cv=none; b=szJ0rCge0zlciG57WYBmfzQY8N6GFO+6fT3pcD/4MtJKMpHK5EoY4CInZt/DfL2ebdF65onDixNfHBvpzy3EBLfctFRKb2kuQNbT01S37hGt707tSSQZsVPLHFZaEi+E6hmxw2o+vdgpI5rSZLm26td94273wTI5jw3S75ja0rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041399; c=relaxed/simple;
	bh=fr58hyORh0N1DrI8TqY6TA2Wd6wQGXxlUMAlaEzZKjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nt3SLDYyCzd0gt6TCLjFuKN1th9udjRaB8ubMXvqNS9MtjcNgLJc5gU+BENXMFNf0Dh4UVUhRcoaA/fgsmk3c6holtJQNO69SnB5seohPXgBw4ACjzwFt+YV7hKO2R0yhl1m4a6FbC2mQ9LXDXyh+i0akHT0j46eKhXcPZwoiDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZzzP1IM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZzzP1IM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071A3C433F1;
	Tue, 27 Feb 2024 13:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041399;
	bh=fr58hyORh0N1DrI8TqY6TA2Wd6wQGXxlUMAlaEzZKjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZzzP1IMMeEn5pt2y6KVueKy2p/oxpscMCtLRUMdo/lSMdrODpuch6c0wEjiC3VFF
	 cGXwV4ar8tnG4bbIbmsNVo0tbzF8+r8KX7cHsudC1bnM6UBVXUN4in7flyLv44cTp7
	 K6Njd32vqte0omAsJsAnKxNFg/mssn7lKS3x58N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"JinZe.Xu" <jinze.xu@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Josip Pavic <josip.pavic@amd.com>,
	Roman Li <roman.li@amd.com>,
	Qingqing Zhuo <Qingqing.Zhuo@amd.com>,
	Harry Wentland <Harry.Wentland@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 326/334] drm/amd/display: Fix potential null pointer dereference in dc_dmub_srv
Date: Tue, 27 Feb 2024 14:23:04 +0100
Message-ID: <20240227131641.642322567@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit d2b48f340d9e4a8fbeb1cdc84cd8da6ad143a907 ]

Fixes potential null pointer dereference warnings in the
dc_dmub_srv_cmd_list_queue_execute() and dc_dmub_srv_is_hw_pwr_up()
functions.

In both functions, the 'dc_dmub_srv' variable was being dereferenced
before it was checked for null. This could lead to a null pointer
dereference if 'dc_dmub_srv' is null. The fix is to check if
'dc_dmub_srv' is null before dereferencing it.

Thus moving the null checks for 'dc_dmub_srv' to the beginning of the
functions to ensure that 'dc_dmub_srv' is not null when it is
dereferenced.

Found by smatch & thus fixing the below:
drivers/gpu/drm/amd/amdgpu/../display/dc/dc_dmub_srv.c:133 dc_dmub_srv_cmd_list_queue_execute() warn: variable dereferenced before check 'dc_dmub_srv' (see line 128)
drivers/gpu/drm/amd/amdgpu/../display/dc/dc_dmub_srv.c:1167 dc_dmub_srv_is_hw_pwr_up() warn: variable dereferenced before check 'dc_dmub_srv' (see line 1164)

Fixes: 028bac583449 ("drm/amd/display: decouple dmcub execution to reduce lock granularity")
Fixes: 65138eb72e1f ("drm/amd/display: Add DCN35 DMUB")
Cc: JinZe.Xu <jinze.xu@amd.com>
Cc: Hersen Wu <hersenxs.wu@amd.com>
Cc: Josip Pavic <josip.pavic@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Qingqing Zhuo <Qingqing.Zhuo@amd.com>
Cc: Harry Wentland <Harry.Wentland@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index 61d1b4eadbee3..05b3433cbb0b4 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -124,7 +124,7 @@ bool dc_dmub_srv_cmd_list_queue_execute(struct dc_dmub_srv *dc_dmub_srv,
 		unsigned int count,
 		union dmub_rb_cmd *cmd_list)
 {
-	struct dc_context *dc_ctx = dc_dmub_srv->ctx;
+	struct dc_context *dc_ctx;
 	struct dmub_srv *dmub;
 	enum dmub_status status;
 	int i;
@@ -132,6 +132,7 @@ bool dc_dmub_srv_cmd_list_queue_execute(struct dc_dmub_srv *dc_dmub_srv,
 	if (!dc_dmub_srv || !dc_dmub_srv->dmub)
 		return false;
 
+	dc_ctx = dc_dmub_srv->ctx;
 	dmub = dc_dmub_srv->dmub;
 
 	for (i = 0 ; i < count; i++) {
@@ -1129,7 +1130,7 @@ void dc_dmub_srv_subvp_save_surf_addr(const struct dc_dmub_srv *dc_dmub_srv, con
 
 bool dc_dmub_srv_is_hw_pwr_up(struct dc_dmub_srv *dc_dmub_srv, bool wait)
 {
-	struct dc_context *dc_ctx = dc_dmub_srv->ctx;
+	struct dc_context *dc_ctx;
 	enum dmub_status status;
 
 	if (!dc_dmub_srv || !dc_dmub_srv->dmub)
@@ -1138,6 +1139,8 @@ bool dc_dmub_srv_is_hw_pwr_up(struct dc_dmub_srv *dc_dmub_srv, bool wait)
 	if (dc_dmub_srv->ctx->dc->debug.dmcub_emulation)
 		return true;
 
+	dc_ctx = dc_dmub_srv->ctx;
+
 	if (wait) {
 		status = dmub_srv_wait_for_hw_pwr_up(dc_dmub_srv->dmub, 500000);
 		if (status != DMUB_STATUS_OK) {
-- 
2.43.0



