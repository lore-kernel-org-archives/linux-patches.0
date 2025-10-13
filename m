Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C22E30AABF;
	Mon, 13 Oct 2025 15:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369512; cv=none; b=ft/CN5t7dUiITWL3+o+nxm9JMAXOVuLnRVTBrsGHGRiixr36jCJjR13aJ+kb9uQrN1WrngtbuvFNh8H9JPNRUi1KH01P6YopujxKmaLw9LRVbCHGU5XKBL9FkmZVLJ4nS1oc9svZ2PUkaYg7/u1jlZ0ZDu6POU9TCksTh+XRxvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369512; c=relaxed/simple;
	bh=+FibxWT76ymBvS0Lwup0XJw+r5h3j/lO1ha7DPOhmuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApyWLBGwJBEGScHUaPi/WOS1uLyiRcW9SVvp0rbxBUpm16pgBSSqrnzbEj7OZ9jEJTNv4y7WOroZEsrmROX2WkvE4QecEscfJa06zte2CvXKUL5d3an7VLKIE5OWnBUY0AzI53XYwC2uBEuM5ULjpDSHkSR8gAOKUoH4R+1j4Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMFLsI6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMFLsI6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BDDC4CEE7;
	Mon, 13 Oct 2025 15:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369512;
	bh=+FibxWT76ymBvS0Lwup0XJw+r5h3j/lO1ha7DPOhmuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMFLsI6MAmcY0vd7GcTgVIHR0nU6xG/Q1bquV/TTCIXK2mM098m4YwicA8GK7U+lw
	 ns703eH3N4sg62aUm3N8ZTCBc3oE4k3+nKLP9nmE8zD0aNtsb3bfR+FyvylOgS9SlY
	 +6yj2XCeDAfkrM8CMWlJbKGz2hWq6csbCnECdwKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alex Hung <alex.hung@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Roman Li <roman.li@amd.com>,
	ChiaHsuan Chung <chiahsuan.chung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Jun Lei <Jun.Lei@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Dillon Varone <Dillon.varone@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 240/563] drm/amd/display: Add NULL pointer checks in dc_stream cursor attribute functions
Date: Mon, 13 Oct 2025 16:41:41 +0200
Message-ID: <20251013144419.980700876@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit bf4e4b97d0fdc66f04fc19d807e24dd8421b8f11 ]

The function dc_stream_set_cursor_attributes() currently dereferences
the `stream` pointer and nested members `stream->ctx->dc->current_state`
without checking for NULL.

All callers of these functions, such as in
`dcn30_apply_idle_power_optimizations()` and
`amdgpu_dm_plane_handle_cursor_update()`, already perform NULL checks
before calling these functions.

Fixes below:
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_stream.c:336 dc_stream_program_cursor_attributes()
error: we previously assumed 'stream' could be null (see line 334)

drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_stream.c
    327 bool dc_stream_program_cursor_attributes(
    328         struct dc_stream_state *stream,
    329         const struct dc_cursor_attributes *attributes)
    330 {
    331         struct dc  *dc;
    332         bool reset_idle_optimizations = false;
    333
    334         dc = stream ? stream->ctx->dc : NULL;
                     ^^^^^^
The old code assumed stream could be NULL.

    335
--> 336         if (dc_stream_set_cursor_attributes(stream, attributes)) {
                                                    ^^^^^^
The refactor added an unchecked dereference.

drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_stream.c
   313  bool dc_stream_set_cursor_attributes(
   314          struct dc_stream_state *stream,
   315          const struct dc_cursor_attributes *attributes)
   316  {
   317          bool result = false;
   318
   319          if (dc_stream_check_cursor_attributes(stream, stream->ctx->dc->current_state, attributes)) {
                                                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Here.
This function used to check for if stream as NULL and return false at
the start. Probably we should add that back.

Fixes: 4465dd0e41e8 ("drm/amd/display: Refactor SubVP cursor limiting logic")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Alvin Lee <alvin.lee2@amd.com>
Cc: Ray Wu <ray.wu@amd.com>
Cc: Dillon Varone <dillon.varone@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: ChiaHsuan Chung <chiahsuan.chung@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Daniel Wheeler <daniel.wheeler@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Wenjing Liu <wenjing.liu@amd.com>
Cc: Jun Lei <Jun.Lei@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Dillon Varone <Dillon.varone@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
index 4d6bc9fd4faa8..9ac2d41f8fcae 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -316,6 +316,9 @@ bool dc_stream_set_cursor_attributes(
 {
 	bool result = false;
 
+	if (!stream)
+		return false;
+
 	if (dc_stream_check_cursor_attributes(stream, stream->ctx->dc->current_state, attributes)) {
 		stream->cursor_attributes = *attributes;
 		result = true;
@@ -331,7 +334,10 @@ bool dc_stream_program_cursor_attributes(
 	struct dc  *dc;
 	bool reset_idle_optimizations = false;
 
-	dc = stream ? stream->ctx->dc : NULL;
+	if (!stream)
+		return false;
+
+	dc = stream->ctx->dc;
 
 	if (dc_stream_set_cursor_attributes(stream, attributes)) {
 		dc_z10_restore(dc);
-- 
2.51.0



