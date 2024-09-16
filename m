Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27793156222;
	Mon, 16 Sep 2024 12:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488413; cv=none; b=WFEV8meOcN5R+abC9cqgggLclVj9PoBPX3VWJqKOrFOciB5l83X1XNu3h0IY0sVvhO7/5XounXBe5aGw8960Pnexrgr9NcrnzxEuRZWC78P/J8JfsQ94dN2jY+EjwrdG74vsCg9Vm4rmqw/E75lLwpC9oFHKELf3GnRQtwfvtRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488413; c=relaxed/simple;
	bh=irGgRJXBUbo2ZYUkSFP9PdW70Oq1mP1juUVqJSyrgfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXY9SL9M0MtOaWLkYej/vi51AkWJqkYJzky5EbPFJDYfBYEtRgeBGS/lLPylV3RWuMdM1HnQcV5XgIjwWxmlYBzYwn8bhmmTJmgf6rSvY2xjudAXGjJ/Z4t2rWmvhfF6s/kEmJL14eJYSOmR2VXOG3uMB/s/cbEdnE4KDaSqyrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PrSDOYdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PrSDOYdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE8BC4CEC4;
	Mon, 16 Sep 2024 12:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488413;
	bh=irGgRJXBUbo2ZYUkSFP9PdW70Oq1mP1juUVqJSyrgfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrSDOYdlLSU5nH7KEX56a4mmNYGM2bVAC3IMnicSnL2U7jb4WjQFFGobFn7FxpOPR
	 IPCCJ3gexj3VR9hNDjuV0S1vFRQYRl1lwXXqVVzAssxpVSnIblfkZbYUyFq1/NMd2U
	 8iv+KtQwYypa+upH57cfAf+9SKCZaS4LQN81oNH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	Harry Wentland <harry.wentland@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 105/121] drm/amd/display: Avoid race between dcn35_set_drr() and dc_state_destruct()
Date: Mon, 16 Sep 2024 13:44:39 +0200
Message-ID: <20240916114232.579597839@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

commit e835d5144f5ef78e4f8828c63e2f0d61144f283a upstream.

dc_state_destruct() nulls the resource context of the DC state. The pipe
context passed to dcn35_set_drr() is a member of this resource context.

If dc_state_destruct() is called parallel to the IRQ processing (which
calls dcn35_set_drr() at some point), we can end up using already nulled
function callback fields of struct stream_resource.

The logic in dcn35_set_drr() already tries to avoid this, by checking tg
against NULL. But if the nulling happens exactly after the NULL check and
before the next access, then we get a race.

Avoid this by copying tg first to a local variable, and then use this
variable for all the operations. This should work, as long as nobody
frees the resource pool where the timing generators live.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3142
Fixes: 06ad7e164256 ("drm/amd/display: Destroy DC context while keeping DML and DML2")
Signed-off-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0607a50c004798a96e62c089a4c34c220179dcb5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c |   20 +++++++++-------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -1371,7 +1371,13 @@ void dcn35_set_drr(struct pipe_ctx **pip
 	params.vertical_total_mid_frame_num = adjust.v_total_mid_frame_num;
 
 	for (i = 0; i < num_pipes; i++) {
-		if ((pipe_ctx[i]->stream_res.tg != NULL) && pipe_ctx[i]->stream_res.tg->funcs) {
+		/* dc_state_destruct() might null the stream resources, so fetch tg
+		 * here first to avoid a race condition. The lifetime of the pointee
+		 * itself (the timing_generator object) is not a problem here.
+		 */
+		struct timing_generator *tg = pipe_ctx[i]->stream_res.tg;
+
+		if ((tg != NULL) && tg->funcs) {
 			struct dc_crtc_timing *timing = &pipe_ctx[i]->stream->timing;
 			struct dc *dc = pipe_ctx[i]->stream->ctx->dc;
 
@@ -1384,14 +1390,12 @@ void dcn35_set_drr(struct pipe_ctx **pip
 					num_frames = 2 * (frame_rate % 60);
 				}
 			}
-			if (pipe_ctx[i]->stream_res.tg->funcs->set_drr)
-				pipe_ctx[i]->stream_res.tg->funcs->set_drr(
-					pipe_ctx[i]->stream_res.tg, &params);
+			if (tg->funcs->set_drr)
+				tg->funcs->set_drr(tg, &params);
 			if (adjust.v_total_max != 0 && adjust.v_total_min != 0)
-				if (pipe_ctx[i]->stream_res.tg->funcs->set_static_screen_control)
-					pipe_ctx[i]->stream_res.tg->funcs->set_static_screen_control(
-						pipe_ctx[i]->stream_res.tg,
-						event_triggers, num_frames);
+				if (tg->funcs->set_static_screen_control)
+					tg->funcs->set_static_screen_control(
+						tg, event_triggers, num_frames);
 		}
 	}
 }


