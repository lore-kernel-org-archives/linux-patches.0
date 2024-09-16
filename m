Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0E11547C4;
	Mon, 16 Sep 2024 12:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488410; cv=none; b=RyfZD55ITkT3LNQLN+CAZzMnFr55xBP8x6irqf20B1uvmJZ4oxYsC9cYrEPkdczp8SQBVnQP+h7oFBqcut5vdXq9OlyXnc6WBVViyOezzgfYNFIAxAflYP+LxbaGqxM/c43tKQAi2dJfIbNY8pBx+5IahnA9Uv0a8bLTJOxrXKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488410; c=relaxed/simple;
	bh=iXu+Ij00PocWuOafB4ddgiBUeelJtmQgwQJG1z3odfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T7FNfkQEDiH4wLE16xmdv4wOjyCyXe7KEZAcCMhg0EFb9mk1JFR8bOain7dVaDOnMTLh+jNS2A1rvA/ZdrLz1ld1lZaTTFsTZme/hXCxq9pB33c33Jwkfex+fxys8EVj3Jd9aojWkAAgNZ7cVBjjf9+JXW2TNhiDBIwBp9ZOevE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JE3g9psr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JE3g9psr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C465FC4CEC4;
	Mon, 16 Sep 2024 12:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488410;
	bh=iXu+Ij00PocWuOafB4ddgiBUeelJtmQgwQJG1z3odfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JE3g9psrzvQZyupdVzIYwtY5ZFeou3tW9DThyDUlDdk2/5HKpo+m2/qLxW0L3sKeJ
	 2uNOBdBvOPKeIw30x71GKl4XqthXQlP7YljVsXZdmyu6OhRSjbdcc+9Exyu/fmAzii
	 Mef19Q5gA2okiF8RkdcVgsKPknEZ62CycId0FoFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	=?UTF-8?q?Raoul=20van=20R=C3=BCschen?= <raoul.van.rueschen@gmail.com>,
	Christopher Snowhill <chris@kode54.net>,
	Harry Wentland <harry.wentland@amd.com>,
	Sefa Eyeoglu <contact@scrumplex.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 104/121] drm/amd/display: Avoid race between dcn10_set_drr() and dc_state_destruct()
Date: Mon, 16 Sep 2024 13:44:38 +0200
Message-ID: <20240916114232.550416383@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

commit a7aeb03888b92304e2fc7d4d1c242f54a312561b upstream.

dc_state_destruct() nulls the resource context of the DC state. The pipe
context passed to dcn10_set_drr() is a member of this resource context.

If dc_state_destruct() is called parallel to the IRQ processing (which
calls dcn10_set_drr() at some point), we can end up using already nulled
function callback fields of struct stream_resource.

The logic in dcn10_set_drr() already tries to avoid this, by checking tg
against NULL. But if the nulling happens exactly after the NULL check and
before the next access, then we get a race.

Avoid this by copying tg first to a local variable, and then use this
variable for all the operations. This should work, as long as nobody
frees the resource pool where the timing generators live.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3142
Fixes: 06ad7e164256 ("drm/amd/display: Destroy DC context while keeping DML and DML2")
Signed-off-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Tested-by: Raoul van Rüschen <raoul.van.rueschen@gmail.com>
Tested-by: Christopher Snowhill <chris@kode54.net>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Tested-by: Sefa Eyeoglu <contact@scrumplex.net>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a3cc326a43bdc48fbdf53443e1027a03e309b643)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c |   20 +++++++++-------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
@@ -3223,15 +3223,19 @@ void dcn10_set_drr(struct pipe_ctx **pip
 	 * as well.
 	 */
 	for (i = 0; i < num_pipes; i++) {
-		if ((pipe_ctx[i]->stream_res.tg != NULL) && pipe_ctx[i]->stream_res.tg->funcs) {
-			if (pipe_ctx[i]->stream_res.tg->funcs->set_drr)
-				pipe_ctx[i]->stream_res.tg->funcs->set_drr(
-					pipe_ctx[i]->stream_res.tg, &params);
+		/* dc_state_destruct() might null the stream resources, so fetch tg
+		 * here first to avoid a race condition. The lifetime of the pointee
+		 * itself (the timing_generator object) is not a problem here.
+		 */
+		struct timing_generator *tg = pipe_ctx[i]->stream_res.tg;
+
+		if ((tg != NULL) && tg->funcs) {
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


