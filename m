Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA591C07DF;
	Tue, 15 Oct 2024 13:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997940; cv=none; b=HUyd6UgFz7FQFgShJLENwfKSO7z3FvdNm/AEYMO7B9U/p7YtpBF6F5tRtABPK1kkAE+UCdr+Hteam/G5ye6e+lPrpHQwV2PCW81f3DupmT6PhcmAIoRBN0SRx7y0t3TLknzjCO3be8zmpf0cjW89bCh58gzFWnR8pLeAS8/wNu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997940; c=relaxed/simple;
	bh=KZ+zvw5kKtCOucJgKvskEjz326jfXqJXiO+/Gn77atQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLRqc9X4BomiJfixdHgw7YG7rSG1b9BgLXEaaYe4xWMXyqahyV7HC36UWs2XuvF47vylynS+UEASgAYQPlieoZwpnjKAaBBjuqp/WX8F2g9kVcZ8Erlkl7AmRGPafMCJSHz+fzYIwxZG5G3ThVCYbTS6GQxuMn/87WOk/BzSeNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZXNRQsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZXNRQsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD3AC4CECE;
	Tue, 15 Oct 2024 13:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997940;
	bh=KZ+zvw5kKtCOucJgKvskEjz326jfXqJXiO+/Gn77atQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZXNRQscV49em+GOfhqRkL+faCHi+SyFwDWyTY+/iG6f/sHFR+dWtHefQAQ6vN84K
	 ZnMfjPDR4YVvKGHBg9oOeojCIj43nfyFr8VNUvSnG2vsXHxN2mFD5azSpXN/eH0BCk
	 kaDIjEiv+lPWOmmUhPTuoLk5nhVQTSVmWGWpMf4Y=
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
Subject: [PATCH 5.10 331/518] drm/amd/display: Add null check for top_pipe_to_program in commit_planes_for_stream
Date: Tue, 15 Oct 2024 14:43:55 +0200
Message-ID: <20241015123929.752783459@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 66d71a72539e173a9b00ca0b1852cbaa5f5bf1ad ]

This commit addresses a null pointer dereference issue in the
`commit_planes_for_stream` function at line 4140. The issue could occur
when `top_pipe_to_program` is null.

The fix adds a check to ensure `top_pipe_to_program` is not null before
accessing its stream_res. This prevents a null pointer dereference.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc.c:4140 commit_planes_for_stream() error: we previously assumed 'top_pipe_to_program' could be null (see line 3906)

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
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 272252cd05001..0587598009233 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2614,7 +2614,8 @@ static void commit_planes_for_stream(struct dc *dc,
 		dc->hwss.pipe_control_lock(dc, top_pipe_to_program, false);
 
 	if ((update_type != UPDATE_TYPE_FAST) && stream->update_flags.bits.dsc_changed)
-		if (top_pipe_to_program->stream_res.tg->funcs->lock_doublebuffer_enable) {
+		if (top_pipe_to_program &&
+		    top_pipe_to_program->stream_res.tg->funcs->lock_doublebuffer_enable) {
 			top_pipe_to_program->stream_res.tg->funcs->wait_for_state(
 					top_pipe_to_program->stream_res.tg,
 					CRTC_STATE_VACTIVE);
-- 
2.43.0



