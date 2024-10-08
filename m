Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9E01779B1;
	Tue,  8 Oct 2024 12:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391205; cv=none; b=CbtBDhXdMKa0i/tbbIIsxnPljl43TxpLl5ozBFpx1xN1WuMK532PI05FshL49RlEOF/ga8uCOGYdMHduqIZv3uUL+xuyoLMI6m/1QHoJNQVgzKk5OF9Co6rYFIFyfl3UuK0Azpo2OkJWzkarYGLJ9G2LXT9dcyEW+jVoYXON4p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391205; c=relaxed/simple;
	bh=gGIDhfyx35eDxjNQHlnbUUaxGqTLs0sTaQsnUTe9YzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Thy1QIZjjEmEDqkLDOFRNKTIafOl09+OUXzJZu68qQB8ec0gyYKeTp3rsVMcXMhKxHRiosoNu8byndA5hnkIb9T4K1q6KkVMwC8E0Hdx5opdcJusixCbSXTlhEcPrunw4dNBR2FZ+N3Ew0fLu8CrplcZ6hvbOzqzWTwdWTMMp0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQTvS0pa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQTvS0pa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647E2C4CEC7;
	Tue,  8 Oct 2024 12:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391204;
	bh=gGIDhfyx35eDxjNQHlnbUUaxGqTLs0sTaQsnUTe9YzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQTvS0pahD5j4MLZAHILkxzFiZ6fI+wTCRX1Esb1V0vyjUuI6B0Jn4tFOSuLngJB6
	 TI60lXLMozkwsjodTKj1hStJKoeiAJ9Vz0Wz+TC83skW7mlajMm2shT7MIXs743SLX
	 7r6VG/0GhCuQqQUVoghPBVGaj67/OqL+yx3Ey6Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 010/558] drm/amd/display: handle nulled pipe context in DCE110s set_drr()
Date: Tue,  8 Oct 2024 14:00:40 +0200
Message-ID: <20241008115702.627481440@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

[ Upstream commit e7d4e1438533abe448813bdc45691f9c230aa307 ]

As set_drr() is called from IRQ context, it can happen that the
pipe context has been nulled by dc_state_destruct().

Apply the same protection here that is already present for
dcn35_set_drr() and dcn10_set_drr(). I.e. fetch the tg pointer
first (to avoid a race with dc_state_destruct()), and then
check the local copy before using it.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3142
Fixes: 06ad7e164256 ("drm/amd/display: Destroy DC context while keeping DML and DML2")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/hwss/dce110/dce110_hwseq.c | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 4d6e90c49ad53..fc0d2077aaec4 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -2085,13 +2085,20 @@ static void set_drr(struct pipe_ctx **pipe_ctx,
 	 * as well.
 	 */
 	for (i = 0; i < num_pipes; i++) {
-		pipe_ctx[i]->stream_res.tg->funcs->set_drr(
-			pipe_ctx[i]->stream_res.tg, &params);
-
-		if (adjust.v_total_max != 0 && adjust.v_total_min != 0)
-			pipe_ctx[i]->stream_res.tg->funcs->set_static_screen_control(
-					pipe_ctx[i]->stream_res.tg,
-					event_triggers, num_frames);
+		/* dc_state_destruct() might null the stream resources, so fetch tg
+		 * here first to avoid a race condition. The lifetime of the pointee
+		 * itself (the timing_generator object) is not a problem here.
+		 */
+		struct timing_generator *tg = pipe_ctx[i]->stream_res.tg;
+
+		if ((tg != NULL) && tg->funcs) {
+			if (tg->funcs->set_drr)
+				tg->funcs->set_drr(tg, &params);
+			if (adjust.v_total_max != 0 && adjust.v_total_min != 0)
+				if (tg->funcs->set_static_screen_control)
+					tg->funcs->set_static_screen_control(
+						tg, event_triggers, num_frames);
+		}
 	}
 }
 
-- 
2.43.0



