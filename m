Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5B34B0480;
	Fri,  7 Aug 2026 15:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115578; cv=none; b=rBJPh1utQNOsbVb8Qnuark4XNS/gUTabfEbWuQeyLG2Ql3xt0v4zwYk33Jp3PangdS6qFFuknMjXVoMMCpaQppoP3vGwh0Pj4/K+G14E9tq+ElprqctMBkvuMli0pn2jIgpoboBJu4+X36gfH3cSALafYKvu9ZPU7eOaXDoCJFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115578; c=relaxed/simple;
	bh=yGNl1QrworOvSRqr2Vf9nN+VUz06pkqcG4SV7WwqwjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJfaPILMqhLUPLcg2vt0LQg/uRUqtaeHTlB2+2cFvEiyZV+1kYeWON2739sRd22WVY5SImN7ExJmUU6v+HVkdNrwnbu+khFBM53abRnPVLZhuJu/qupMPliynIcCb3NFEJd3dKddAtIvETcDn/fwzTpL00laHXKfZLMxvUjW4gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLBkbsuC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLBkbsuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1307D1F000E9;
	Fri,  7 Aug 2026 15:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115576;
	bh=UhkwvhCxptx3J3KuhnZueq0vPKqeN73xJArXbnvn8rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLBkbsuCxSN4VdD+Vmrj4fB9wfBJIyheQidJBgF57cnCMVSAl+4n5Pt+ogvyTUlmL
	 pblA3RAp6F857g6g9opnjSScXEgDbc5GrSuOb+95RYTUiIzI/T2HdhjxMr+FsjIRkS
	 0TNNzvkSKmHAtcGTImG54UVG3bvzwTRYLLMsh8so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 323/396] drm/amd/display: Increase HDMI AV mute wait from 2 to 3 frames
Date: Fri,  7 Aug 2026 16:38:03 +0200
Message-ID: <20260807143431.232353771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Ray Wu <ray.wu@amd.com>

commit c216b39fbbc4b007fd6984cffd85039d49a55154 upstream.

Some HDMI sinks need additional GCP packets to properly process the
mute state before the timing generator is disabled, especially after
link re-establishment with HDMI 2.0 scrambling enabled. Waiting for
only 2 frames is insufficient for certain monitor firmware, resulting
in garbled display output on resume from suspend.

Increase the AV mute wait in dcn30_set_avmute() from 2 to 3 frames
to ensure the sink receives enough GCP packets.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5167
Assisted-by: Cursor:Claude-Opus-4.6
Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0c0d5174b09640d8b560764aa5a177630e076e93)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
@@ -837,13 +837,19 @@ void dcn30_set_avmute(struct pipe_ctx *p
 				pipe_ctx->stream_res.stream_enc,
 				enable);
 
-		/* Wait for two frame to make sure AV mute is sent out */
+		/* Wait for three frames to make sure AV mute is sent out.
+		 * Some HDMI sinks need additional GCP packets to properly
+		 * process the mute state, especially after link re-establishment
+		 * with HDMI 2.0 scrambling enabled.
+		 */
 		if (enable && pipe_ctx->stream_res.tg->funcs->is_tg_enabled(pipe_ctx->stream_res.tg)) {
+			int i;
+
 			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
-			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VBLANK);
-			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
-			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VBLANK);
-			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
+			for (i = 0; i < 3; i++) {
+				pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VBLANK);
+				pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
+			}
 		}
 	}
 }


