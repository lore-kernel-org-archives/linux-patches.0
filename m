Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D40385D7B;
	Sat, 17 Oct 2026 17:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258870; cv=none; b=Jfk1WY0KFXlgiw5qMgzd+4Zjms5J6n5mdNJHXZRi6gBisQTDp6sPtuH4wZSGMQxZIKQpZzaSSD/20oMgSmI8ZCbkS/FYE1EHiqKaA/Gmp3eXIwnJy/Ld2S1uYAHAl3QXIaYZDbuGfVqkmsVUDHdvTVTOeBejM6zwx8IP4me7ouI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258870; c=relaxed/simple;
	bh=fUa2l01yw4Yul6UCutvgt6Dcni/+xMPoxLL+Vz9Q1pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYrZ2kJUJTe+3HIffdYOrHCDL96BzQNLcn0+ZGMiS4mdgaSYpuvXag9u6Cyg+B1Qd+m0v2SKciQ8QVGgGQsKsFaXxPcfZXzFS2JQ5/Y/cE414GLTOH92A42ZdYDOCYj/tn9R7QrkhYjt4A8VRbPqMKf+TEuKnXLFZd0jOf3SjFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwW9dtic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwW9dtic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A712C1F000C4;
	Sat, 17 Oct 2026 17:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258869;
	bh=h/1FTauSHL5NS5kO0iJwyiwIGSq24DHEn/9HnuWZ8e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EwW9dticY9NhLlS7UOOnB3MRnQ3h68KuF2lMR+/t0s/yfoMh3z9zl4jQhjjKsHx4h
	 7eAm9QKNc/NbkvkJb9U66a3JmEVP/5KWQKV/Thvc2bNWRwFkH0HxEJxYkxP4cvlAyy
	 DZ36FxvD8c8zxldB+XeXUtoq4Hq7Uar7D+ktvlvs=
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
Subject: [PATCH 6.6 1027/1674] drm/amd/display: Avoid NULL dereference in dc_dmub_srv error paths
Date: Sat, 17 Oct 2026 17:54:59 +0200
Message-ID: <20261017160457.495067939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 3dd1761d5a932..624e93e22b06c 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -793,7 +793,10 @@ void dc_dmub_srv_log_diagnostic_data(struct dc_dmub_srv *dc_dmub_srv)
 {
 	struct dmub_diagnostic_data diag_data = {0};
 
-	if (!dc_dmub_srv || !dc_dmub_srv->dmub) {
+	if (!dc_dmub_srv)
+		return;
+
+	if (!dc_dmub_srv->dmub) {
 		DC_LOG_ERROR("%s: invalid parameters.", __func__);
 		return;
 	}
@@ -1034,7 +1037,10 @@ void dc_dmub_srv_enable_dpia_trace(const struct dc *dc)
 	enum dmub_status status;
 	static const uint32_t timeout_us = 30;
 
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



