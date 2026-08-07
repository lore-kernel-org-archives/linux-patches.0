Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1A33F0A94;
	Fri,  7 Aug 2026 15:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117801; cv=none; b=dMOiiAkV+QSZ2WeB004SD+DntTYhy2I/WihWmMn4OVW9h78r4oPzbf4qTfaX6TKFX4Jp5++VTy+R8QVJoDHQ6sVOJlFjQ3yalBYh7uCYrVgEWSa89loH73vDqVb/g5FxVShzJjc13XV6D87oWJLPl6QP/hZTHQYQcw1jnvaO0fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117801; c=relaxed/simple;
	bh=4n/ClGM4PlvaQw//Z/tjDn+bQpuBd04kmGHzUUs7DJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4mZ7WdeoiKTWjeMxKGjZDwNASoDy8VtUqTP5PtlN9bdhghaciu10AA312zAOXMp4vDKYxKV66e2hRAtcuAvgjFgWd7UFrcrgXIpP1PViEngL7qI/LvUSFqHqOH/JncBChAu6ij9KvtMAGzIok6wwB3Qe0LgGLDrpSrOUp7PHfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbC0CWYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbC0CWYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F0E1F000E9;
	Fri,  7 Aug 2026 15:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117800;
	bh=UKQxVypSmg9rmivDK9mBctlfXpFCoA4RMczvos8MDcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbC0CWYYT8CW6BGOlk64P3sshFhei8Y0ZN0XiI7eKywETnNHhJu2S3muB23bgsF6F
	 zno56i5GCbLd2skVE7s9Pw6uqoWkPHg0iDZ7DrwEQwb8EvkBtcyTdCOfTw0VypCXFg
	 3TXKaycZTsSemiON9kJ2LilKud+CY1eXfnyzjCrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 399/438] drm/amd/display: Increase HDMI AV mute wait from 2 to 3 frames
Date: Fri,  7 Aug 2026 16:39:55 +0200
Message-ID: <20260807143436.467228149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -841,13 +841,19 @@ void dcn30_set_avmute(struct pipe_ctx *p
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


