Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B2A3EC6AE;
	Fri,  4 Sep 2026 05:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500361; cv=none; b=G/tAYVTPgRQJaJAZ/OcCjD95pc+KCkFiflXBMUDCc9dV7HUz8R0doyRsXJ6/LArSBZe1I5c9fAzcTxFbpeQ6UcOAcdat+b2C5WHmake6Cls6KFWaQv4XzZ8tXvnghx2Dz88vF2oJEWNeS6F3kZPxsXUjL0uo76Lf2M3CGgx8H9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500361; c=relaxed/simple;
	bh=Fx1jixvQ5K3B9TxhDHM3EOFBwCcgZ7Szv9CfgxdiJj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGy9ohi5YcDSpmDVfL79DVE2oEZM1SF/Xl3OZ9o/RUE3NHbdsIe0bWJljEzekzpOx3yMyRMb9Qm+IjR0tU9T1cuB6MKrQ0saWYCXoW5IIasWJAq7z4Z+jcBuR6Sa/Mkucfjwv94ZaHFgQR1EcrBDLdXuzXtE9JWs+DOv48DHBcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRRSvQA8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRRSvQA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C471F00A3E;
	Fri,  4 Sep 2026 05:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500360;
	bh=NHgTcOKVmYBODbLQevU1QBy5Z0kzaZUrqs9PnpAeWhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NRRSvQA8ckL/2mnBGKIuTMaoo76in5gyh/PFhZWwBAP9MnB8pW/7YfGm1bN3QnCen
	 EKzGfuziH2v4iyRKut6SUSnqB1SU5j2uvjUASHNZushEAAG1t7CfdAk1Hu2Lsv+nmU
	 eX9RKWPjpygiBRS+BGKaWjlkEM4s6tHfyXgu9T/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/552] drm/amd/display: Avoid NULL dereference in dc_dmub_srv error paths
Date: Fri,  4 Sep 2026 06:52:45 +0200
Message-ID: <20260904045748.016875785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 4ae3e16f4b3bf64140f773629b765d605ee079a9 ]

In dc_dmub_srv_log_diagnostic_data() and
dc_dmub_srv_enable_dpia_trace().

Both functions check:

  if (!dc_dmub_srv || !dc_dmub_srv->dmub)

and then call DC_LOG_ERROR() inside that block.

DC_LOG_ERROR() uses dc_dmub_srv->ctx internally. So if
dc_dmub_srv is NULL, the logging itself can dereference a
NULL pointer and cause a crash.

Fix this by splitting the checks.

First check if dc_dmub_srv is NULL and return immediately.
Then check dc_dmub_srv->dmub and log the error only when
dc_dmub_srv is valid.

Fixes the below:
../display/dc/dc_dmub_srv.c:962 dc_dmub_srv_log_diagnostic_data() error: we previously assumed 'dc_dmub_srv' could be null (see line 961)
../display/dc/dc_dmub_srv.c:1167 dc_dmub_srv_enable_dpia_trace() error: we previously assumed 'dc_dmub_srv' could be null (see line 1166)

Fixes: 2631ac1ac328 ("drm/amd/display: add DMUB registers to crash dump diagnostic data.")
Fixes: 71ba6b577a35 ("drm/amd/display: Add interface to enable DPIA trace")
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index 6518d5639d66a..04bc014906f80 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -949,7 +949,10 @@ void dc_dmub_srv_log_diagnostic_data(struct dc_dmub_srv *dc_dmub_srv)
 {
 	uint32_t i;
 
-	if (!dc_dmub_srv || !dc_dmub_srv->dmub) {
+	if (!dc_dmub_srv)
+		return;
+
+	if (!dc_dmub_srv->dmub) {
 		DC_LOG_ERROR("%s: invalid parameters.", __func__);
 		return;
 	}
@@ -1146,7 +1149,10 @@ void dc_dmub_srv_enable_dpia_trace(const struct dc *dc)
 {
 	struct dc_dmub_srv *dc_dmub_srv = dc->ctx->dmub_srv;
 
-	if (!dc_dmub_srv || !dc_dmub_srv->dmub) {
+	if (!dc_dmub_srv)
+		return;
+
+	if (!dc_dmub_srv->dmub) {
 		DC_LOG_ERROR("%s: invalid parameters.", __func__);
 		return;
 	}
-- 
2.53.0



