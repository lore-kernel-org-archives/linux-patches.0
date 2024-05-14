Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9AF13D51B;
	Tue, 14 May 2024 11:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685917; cv=none; b=J5E+lJf3S8rA/WNpAynBWhzpHJowEQsViYGkGB3XjngblFn9MJnVtd6yQcUWK7ONAhgkA2b+YgYp/P4lu2qe0nokBmTuJNsue8cOvc8XkaKwgJ1NSJqwt0EHho20FS7mm7wybyHDN0Ag7kEmlJQZmRTuLoI5tzNbDHQIxYmHIQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685917; c=relaxed/simple;
	bh=QLyZrdSLAaTaYCma3fZZ0S1Fs8VcAkYM7pczrpUEPB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RA0dmw9V6tADwkcTrv4rG5ynrW8MN4tn4NEOu8ypWVdTcnxeeNoyNPIiXytf1lZ0wYfVGvpoHFRNsyIgRb91mrl2qmXz64pDdwojVd1vLDf+kg1Zftj4lEut/9+vBDlWJnHitHnXcjh5/vqxAOauQ7Uhd2kTnk9+IG5HCPuKtm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19yV+qbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19yV+qbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58241C2BD10;
	Tue, 14 May 2024 11:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685917;
	bh=QLyZrdSLAaTaYCma3fZZ0S1Fs8VcAkYM7pczrpUEPB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19yV+qbUN7x3CqlNmkOJz87K6HdEiV+xwAcSOmNTz+JfB8r1rkLWM82DjsRH2yuHs
	 Lbt2ArF7NfS6o/xAnyegKwtGX8YTYJDeDPEG2jvCTdR4vAmo7RJ0kT57f47A6n9Arz
	 TDEnnfT0RTCiXC2GToQJwFUxMeXM7hlHravTow18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 276/301] drm/amd/display: Fix incorrect DSC instance for MST
Date: Tue, 14 May 2024 12:19:07 +0200
Message-ID: <20240514101042.687617246@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Hersen Wu <hersenxs.wu@amd.com>

commit 892b41b16f6163e6556545835abba668fcab4eea upstream.

[Why] DSC debugfs, such as dp_dsc_clock_en_read,
use aconnector->dc_link to find pipe_ctx for display.
Displays connected to MST hub share the same dc_link.
DSC instance is from pipe_ctx. This causes incorrect
DSC instance for display connected to MST hub.

[How] Add aconnector->sink check to find pipe_ctx.

CC: stable@vger.kernel.org
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |   48 ++++++++++----
 1 file changed, 36 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -1465,7 +1465,9 @@ static ssize_t dp_dsc_clock_en_read(stru
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
 		if (pipe_ctx->stream &&
-		    pipe_ctx->stream->link == aconnector->dc_link)
+		    pipe_ctx->stream->link == aconnector->dc_link &&
+		    pipe_ctx->stream->sink &&
+		    pipe_ctx->stream->sink == aconnector->dc_sink)
 			break;
 	}
 
@@ -1566,7 +1568,9 @@ static ssize_t dp_dsc_clock_en_write(str
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
 		if (pipe_ctx->stream &&
-		    pipe_ctx->stream->link == aconnector->dc_link)
+		    pipe_ctx->stream->link == aconnector->dc_link &&
+		    pipe_ctx->stream->sink &&
+		    pipe_ctx->stream->sink == aconnector->dc_sink)
 			break;
 	}
 
@@ -1651,7 +1655,9 @@ static ssize_t dp_dsc_slice_width_read(s
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
 		if (pipe_ctx->stream &&
-		    pipe_ctx->stream->link == aconnector->dc_link)
+		    pipe_ctx->stream->link == aconnector->dc_link &&
+		    pipe_ctx->stream->sink &&
+		    pipe_ctx->stream->sink == aconnector->dc_sink)
 			break;
 	}
 
@@ -1750,7 +1756,9 @@ static ssize_t dp_dsc_slice_width_write(
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
 		if (pipe_ctx->stream &&
-		    pipe_ctx->stream->link == aconnector->dc_link)
+		    pipe_ctx->stream->link == aconnector->dc_link &&
+		    pipe_ctx->stream->sink &&
+		    pipe_ctx->stream->sink == aconnector->dc_sink)
 			break;
 	}
 
@@ -1835,7 +1843,9 @@ static ssize_t dp_dsc_slice_height_read(
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
 		if (pipe_ctx->stream &&
-		    pipe_ctx->stream->link == aconnector->dc_link)
+		    pipe_ctx->stream->link == aconnector->dc_link &&
+		    pipe_ctx->stream->sink &&
+		    pipe_ctx->stream->sink == aconnector->dc_sink)
 			break;
 	}
 
@@ -1934,7 +1944,9 @@ static ssize_t dp_dsc_slice_height_write
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
 		if (pipe_ctx->stream &&
-		    pipe_ctx->stream->link == aconnector->dc_link)
+		    pipe_ctx->stream->link == aconnector->dc_link &&
+		    pipe_ctx->stream->sink &&
+		    pipe_ctx->stream->sink == aconnector->dc_sink)
 			break;
 	}
 
@@ -2015,7 +2027,9 @@ static ssize_t dp_dsc_bits_per_pixel_rea
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
 		if (pipe_ctx->stream &&
-		    pipe_ctx->stream->link == aconnector->dc_link)
+		    pipe_ctx->stream->link == aconnector->dc_link &&
+		    pipe_ctx->stream->sink &&
+		    pipe_ctx->stream->sink == aconnector->dc_sink)
 			break;
 	}
 
@@ -2111,7 +2125,9 @@ static ssize_t dp_dsc_bits_per_pixel_wri
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
 		if (pipe_ctx->stream &&
-		    pipe_ctx->stream->link == aconnector->dc_link)
+		    pipe_ctx->stream->link == aconnector->dc_link &&
+		    pipe_ctx->stream->sink &&
+		    pipe_ctx->stream->sink == aconnector->dc_sink)
 			break;
 	}
 
@@ -2190,7 +2206,9 @@ static ssize_t dp_dsc_pic_width_read(str
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
 		if (pipe_ctx->stream &&
-		    pipe_ctx->stream->link == aconnector->dc_link)
+		    pipe_ctx->stream->link == aconnector->dc_link &&
+		    pipe_ctx->stream->sink &&
+		    pipe_ctx->stream->sink == aconnector->dc_sink)
 			break;
 	}
 
@@ -2246,7 +2264,9 @@ static ssize_t dp_dsc_pic_height_read(st
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
 		if (pipe_ctx->stream &&
-		    pipe_ctx->stream->link == aconnector->dc_link)
+		    pipe_ctx->stream->link == aconnector->dc_link &&
+		    pipe_ctx->stream->sink &&
+		    pipe_ctx->stream->sink == aconnector->dc_sink)
 			break;
 	}
 
@@ -2317,7 +2337,9 @@ static ssize_t dp_dsc_chunk_size_read(st
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
 		if (pipe_ctx->stream &&
-		    pipe_ctx->stream->link == aconnector->dc_link)
+		    pipe_ctx->stream->link == aconnector->dc_link &&
+		    pipe_ctx->stream->sink &&
+		    pipe_ctx->stream->sink == aconnector->dc_sink)
 			break;
 	}
 
@@ -2388,7 +2410,9 @@ static ssize_t dp_dsc_slice_bpg_offset_r
 	for (i = 0; i < MAX_PIPES; i++) {
 		pipe_ctx = &aconnector->dc_link->dc->current_state->res_ctx.pipe_ctx[i];
 		if (pipe_ctx->stream &&
-		    pipe_ctx->stream->link == aconnector->dc_link)
+		    pipe_ctx->stream->link == aconnector->dc_link &&
+		    pipe_ctx->stream->sink &&
+		    pipe_ctx->stream->sink == aconnector->dc_sink)
 			break;
 	}
 


