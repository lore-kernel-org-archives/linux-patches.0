Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E21625332D;
	Tue, 29 Apr 2025 17:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949233; cv=none; b=jIHY3ZZrCJ2F2LcbGtnKPqHIZ9BZtG0W9kT/EWJxsWLKJC25hetPibvIAsYx4hwVHuPojpZ3Q1c4vvoMxYJf5sxGZdRqH2a+31xe0+6J0F6DKBgAmea0XLQuPIteQaGPYKp7SFQzEEmzZwUuGt9Jvrfj41IrTZpQ3F+z7nAmMvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949233; c=relaxed/simple;
	bh=7xa2vWcf/0d3q4uhco7rADcOws83RaB6VEI21gxYn0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gStOY789XBgCeONFfiT5Wl5x/wEIC6dwti+ai5wP2E5zlL12zE4tDzgmvmO3hQNdA2wzSgfHQM/LM39IQUjYnESxNFoc2La5yJNS94WKEruTbIrcasT5i1SVC/z5nGfpg03Lr/S+tt8fV/Atm8R6E9loI8BZHkuAeGKqgxcbEgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qG/dz3KS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qG/dz3KS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFE1C4CEE3;
	Tue, 29 Apr 2025 17:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949233;
	bh=7xa2vWcf/0d3q4uhco7rADcOws83RaB6VEI21gxYn0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qG/dz3KSD3hAKhEuSKnn4HOu/Sxp9COQJWjiZBYPiacgDyhMtdy1FoCwLN5ksLlL8
	 9uLq5jsi1ZzB96HxXUedOnQ9HA7e0YQ4a/t3R0nIZ71N65w/9Z4Sp4iKb11WugLs3b
	 Zknztkr6E0qRRbiF/EWyZnIQS3ZohJKvtTEq7mKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Zhi Yang <Zhi.Yang@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 215/373] drm/amd/display: Add null checks for stream and plane before dereferencing
Date: Tue, 29 Apr 2025 18:41:32 +0200
Message-ID: <20250429161132.001659857@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit 15c2990e0f0108b9c3752d7072a97d45d4283aea upstream.

This commit adds null checks for the 'stream' and 'plane' variables in
the dcn30_apply_idle_power_optimizations function. These variables were
previously assumed to be null at line 922, but they were used later in
the code without checking if they were null. This could potentially lead
to a null pointer dereference, which would cause a crash.

The null checks ensure that 'stream' and 'plane' are not null before
they are used, preventing potential crashes.

Fixes the below static smatch checker:
drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dcn30/dcn30_hwseq.c:938 dcn30_apply_idle_power_optimizations() error: we previously assumed 'stream' could be null (see line 922)
drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dcn30/dcn30_hwseq.c:940 dcn30_apply_idle_power_optimizations() error: we previously assumed 'plane' could be null (see line 922)

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Hersen Wu <hersenxs.wu@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Zhi Yang <Zhi.Yang@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -784,6 +784,9 @@ bool dcn30_apply_idle_power_optimization
 			stream = dc->current_state->streams[0];
 			plane = (stream ? dc->current_state->stream_status[0].plane_states[0] : NULL);
 
+			if (!stream || !plane)
+				return false;
+
 			if (stream && plane) {
 				cursor_cache_enable = stream->cursor_position.enable &&
 						plane->address.grph.cursor_cache_addr.quad_part;


