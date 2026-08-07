Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F9B31AAA8;
	Fri,  7 Aug 2026 14:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114409; cv=none; b=tw9GljvT/wuuHnIJaq1zIAZajAnWCK+u64kY4qo6bsvD5ssReicFhQMO03hpxxzXD989bH6wvHTU8N8IlQUKbiS2ZcVVLaL5Dg9e41k4iuYGp+z+iy683iXrX8RhlA5KeO+pTIhxdMZ9Q/wXyxT/22Vdt2aEepw6ZketVPssQKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114409; c=relaxed/simple;
	bh=0WEtaFTLw30HrP3UxRIaQAUhZGMbFa/nBg7MLj6fnaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lp/NmiG8JyBhV+j7Km8Js6hSbH/LEXmUVZnNAzwo4of22b14NYMRoZYVX19hcorDkPtvB0lfvrSevAjF3SkUCmDjna4a8lHW4JmSmLTBKBZCZPHcfb57yC2wOzLINO+YjNTw6b2NA++CyaReJMxa3RCtUX2vm/I+JrHDut8bIyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZC44C+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZC44C+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85E31F000E9;
	Fri,  7 Aug 2026 14:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114408;
	bh=NQ3iEv0dogxmALeuQp8DGnqsp/znOrp9b8Q4FlqbHko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZC44C+maGshGqTbM7zSIgiXT2xvTGJrxC4Mo2+hwEYw766qvo8vYWlgns+fi03/R
	 fiKYbT2I2JnZt/SSLIPBLnotREj/kpR2Z8Ocp88EMlgQLaodKsoSi8FUXhfOnHaS5x
	 EV+6v9sL1nhAa6bRUUO7HbOwRqgbGi5aaq9jHgJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 252/337] drm/amd/display: Increase HDMI AV mute wait from 2 to 3 frames
Date: Fri,  7 Aug 2026 16:37:35 +0200
Message-ID: <20260807143424.010528798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -821,13 +821,19 @@ void dcn30_set_avmute(struct pipe_ctx *p
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


