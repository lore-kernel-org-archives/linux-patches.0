Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B72F1D7E31;
	Tue,  8 Oct 2024 12:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390064; cv=none; b=nV3o41QJ7HTzfF1msHutcJC4Zw6jjhJDSzU+Qk4Siz1YLVBWTaM0boNuoh9fR8zf9Yx91nisuO+N78mbe2J1CflURsnNlDVNWOviUCRjseqKI0+O/Kiil0j3qJTS2QzP/Lgz9mZR2v71RoZmbxpVziptSmtLdRhOgIY85cguzuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390064; c=relaxed/simple;
	bh=D3x5/K+SsDqCQOFlrBTfmukUvfFcvXFUQzNYK8a5k5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQ9eG+/9ohjoBPTcOmpBhOyh/tAuFahvAQKqHqGGm4lcTuI+SNgCUPQdJS2UKPUfx/a9fxQ1N0pSfsZrxX1OIqWrgld4p9mVJ7erEG7lUTjsF5yK/HvUWXYvtx76sPI3+rmnIBqWGm6t1pYixKGnvwhJTrj2KsLlRicp255REzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBc52f7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBc52f7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464ADC4CECC;
	Tue,  8 Oct 2024 12:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390064;
	bh=D3x5/K+SsDqCQOFlrBTfmukUvfFcvXFUQzNYK8a5k5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBc52f7wpCsyGTrGUQC6Q5lirBNE4vPDyGCxdqsAPJ0yGMyhMhdXyS0vZVLwEnjHa
	 nksaHviJ3TNSeNnOj0xNTWaN4ar2j4fsgeGRtkbZEGVpBbIHGauJCDRLUPmM5f7o7z
	 oM+TAvei6/DG73l5drpqA2y6BnXPMZBfx9+OBqPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 179/482] drm/amd/display: Add null check for head_pipe in dcn32_acquire_idle_pipe_for_head_pipe_in_layer
Date: Tue,  8 Oct 2024 14:04:02 +0200
Message-ID: <20241008115655.348529813@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

[ Upstream commit ac2140449184a26eac99585b7f69814bd3ba8f2d ]

This commit addresses a potential null pointer dereference issue in the
`dcn32_acquire_idle_pipe_for_head_pipe_in_layer` function. The issue
could occur when `head_pipe` is null.

The fix adds a check to ensure `head_pipe` is not null before asserting
it. If `head_pipe` is null, the function returns NULL to prevent a
potential null pointer dereference.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/resource/dcn32/dcn32_resource.c:2690 dcn32_acquire_idle_pipe_for_head_pipe_in_layer() error: we previously assumed 'head_pipe' could be null (see line 2681)

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c    | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
index d84c8e0e5c2f0..9209bcad699a8 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -2664,8 +2664,10 @@ static struct pipe_ctx *dcn32_acquire_idle_pipe_for_head_pipe_in_layer(
 	struct resource_context *old_ctx = &stream->ctx->dc->current_state->res_ctx;
 	int head_index;
 
-	if (!head_pipe)
+	if (!head_pipe) {
 		ASSERT(0);
+		return NULL;
+	}
 
 	/*
 	 * Modified from dcn20_acquire_idle_pipe_for_layer
-- 
2.43.0



