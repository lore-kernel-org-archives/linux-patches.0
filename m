Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D271AC8A2;
	Thu, 15 Aug 2024 13:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729128; cv=none; b=j/xJBqqp8bxWte+Zgoig1Fk1xmJGPYAkEcP6cSeDe5AGjJKTPB2+l/sbSqElVaYXO7wlZ2IVXuONyJNoxoKo1kbhssVSZPw9nXwuyd7kk/ny0pTxLEsYT8yVNLiDEKfqz0bGfEQ3NJ7hV5wdtxxKQWrlZkhAuSL/Na2CpGifHdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729128; c=relaxed/simple;
	bh=pCZlyR5SklaQDaxaA9wd6flreForvcy3ExLbALzU8RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+WTAKl1Ak22gQgIsCWcjBPNeZFtA4KENvs9qt+eYM1kngkf7Rdd5Snpx+u0i86UvGWaIRkm3p2vp0E4iLeAYzBrAFmQWKYh+PICSowUunDcug6DQjqZpW1fXFbhgL0H9KJmbWuJhad6te+NxFHtKf8tfmwiyuwVBVIT3ef7dJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8k9N5mV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8k9N5mV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DB9C4AF0C;
	Thu, 15 Aug 2024 13:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729128;
	bh=pCZlyR5SklaQDaxaA9wd6flreForvcy3ExLbALzU8RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8k9N5mVznuCuwiOBz0K7Lh0cUkNIY5OGMrh61o9XIPRWjzK4S6EakWg0I+24Bhgk
	 KbERfnlewVWzAZ7eEkHoan37Jg90hUEJatpslHwmdgdjvT/CrNhUc1tBRneLX2J9PR
	 D0Rqif3v3ovV1d1FrcLMizXA3OgvniJts9PMI7vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 22/22] drm/amdgpu/display: Fix null pointer dereference in dc_stream_program_cursor_position
Date: Thu, 15 Aug 2024 15:25:30 +0200
Message-ID: <20240815131832.111555892@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
References: <20240815131831.265729493@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit fa4c500ce93f4f933c38e6d6388970e121e27b21 upstream.

The fix involves adding a null check for 'stream' at the beginning of
the function. If 'stream' is NULL, the function immediately returns
false. This ensures that 'stream' is not NULL when we dereference it to
access 'ctx' in 'dc = stream->ctx->dc;' the function.

Fixes the below:
	drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_stream.c:398 dc_stream_program_cursor_position()
	error: we previously assumed 'stream' could be null (see line 397)

drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_stream.c
    389 bool dc_stream_program_cursor_position(
    390         struct dc_stream_state *stream,
    391         const struct dc_cursor_position *position)
    392 {
    393         struct dc *dc;
    394         bool reset_idle_optimizations = false;
    395         const struct dc_cursor_position *old_position;
    396
    397         old_position = stream ? &stream->cursor_position : NULL;
                               ^^^^^^^^
The patch adds a NULL check

--> 398         dc = stream->ctx->dc;
                     ^^^^^^^^
The old code didn't check

    399
    400         if (dc_stream_set_cursor_position(stream, position)) {
    401                 dc_z10_restore(dc);
    402
    403                 /* disable idle optimizations if enabling cursor */
    404                 if (dc->idle_optimizations_allowed &&
    405                     (!old_position->enable || dc->debug.exit_idle_opt_for_cursor_updates) &&
    406                     position->enable) {
    407                         dc_allow_idle_optimizations(dc, false);

Fixes: f63f86b5affc ("drm/amd/display: Separate setting and programming of cursor")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -394,7 +394,10 @@ bool dc_stream_program_cursor_position(
 	bool reset_idle_optimizations = false;
 	const struct dc_cursor_position *old_position;
 
-	old_position = stream ? &stream->cursor_position : NULL;
+	if (!stream)
+		return false;
+
+	old_position = &stream->cursor_position;
 	dc = stream->ctx->dc;
 
 	if (dc_stream_set_cursor_position(stream, position)) {


