Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891C418C034;
	Thu, 17 Apr 2025 18:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912872; cv=none; b=N3n2IsRuNTViKLGyvQuFOWANz9T1OLqhj5Se+1LQV9YXuK7B2R0A8Pp6kkxiiVU23wW4iMn5hRUqJFFjCxbD4tLgr8QEuk/n09V3HLpLsQPqPjO7IIBGQMIEUPnJPx3rfvjzpqy/0b2yiNvxSUWZBNArwPeSNxr/0VHGT0C6Heo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912872; c=relaxed/simple;
	bh=jlm/7KJQIsYu8nh0Zwj9CslerRFYlo/+nV2IkFI/QCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlP2L+1AS0fFewLYW7sW3Vy6qDRMrf/Wh9jjuHFoBKVIxCAhpCyifX5XtMUP4XQT9gL+JtlwAlZLWabhebDz8qA8DBg9NLQ6I8sNtBjEMG5t6Wo/wDkcvL3wAl8LsvkjWIgDAKisB5+fmERgB6B5+A7EW0tAZA84eJ3VICeOR5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIHsA5X/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIHsA5X/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1B8C4CEEA;
	Thu, 17 Apr 2025 18:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912872;
	bh=jlm/7KJQIsYu8nh0Zwj9CslerRFYlo/+nV2IkFI/QCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIHsA5X/ObGIOkPtt5pg/W/YNtcLrD+nwt1pbHG+0y7LCExe3HtG96bvyPLQz6cbk
	 MJ1i/U4yVxj359gpfGnIQfujKdCznDVOZFE0bP3zWOUVgLy2ZmNP4B5qpEbPo0cnpd
	 GLuyawnjxoYlGtqSlVbN04yA9GZEcC/jybg9EMGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Aberback <joshua.aberback@amd.com>,
	Sung Lee <Sung.Lee@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 152/449] drm/amd/display: Guard Possible Null Pointer Dereference
Date: Thu, 17 Apr 2025 19:47:20 +0200
Message-ID: <20250417175124.094177860@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sung Lee <Sung.Lee@amd.com>

[ Upstream commit c87d202692de34ee71d1fd4679a549a29095658a ]

[WHY]
In some situations, dc->res_pool may be null.

[HOW]
Check if pointer is null before dereference.

Reviewed-by: Joshua Aberback <joshua.aberback@amd.com>
Signed-off-by: Sung Lee <Sung.Lee@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index f84e795e35f58..4683c7ef4507f 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -5549,9 +5549,11 @@ void dc_allow_idle_optimizations_internal(struct dc *dc, bool allow, char const
 	if (dc->clk_mgr != NULL && dc->clk_mgr->funcs->get_hard_min_memclk)
 		idle_dramclk_khz = dc->clk_mgr->funcs->get_hard_min_memclk(dc->clk_mgr);
 
-	for (i = 0; i < dc->res_pool->pipe_count; i++) {
-		pipe = &context->res_ctx.pipe_ctx[i];
-		subvp_pipe_type[i] = dc_state_get_pipe_subvp_type(context, pipe);
+	if (dc->res_pool && context) {
+		for (i = 0; i < dc->res_pool->pipe_count; i++) {
+			pipe = &context->res_ctx.pipe_ctx[i];
+			subvp_pipe_type[i] = dc_state_get_pipe_subvp_type(context, pipe);
+		}
 	}
 
 	DC_LOG_DC("%s: allow_idle=%d\n HardMinUClk_Khz=%d HardMinDramclk_Khz=%d\n Pipe_0=%d Pipe_1=%d Pipe_2=%d Pipe_3=%d Pipe_4=%d Pipe_5=%d (caller=%s)\n",
-- 
2.39.5



