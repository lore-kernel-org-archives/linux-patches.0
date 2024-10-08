Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87511DACBE;
	Tue,  8 Oct 2024 12:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389542; cv=none; b=bxiOWmNeXibjNQMbOVBCwQb63xqtvmieTlQEjCbuIq2eiU7hheNAVGYovfoAjf9F4VHEJLfl7IKnt2jEfCy2b1IMheporiaoRDllfngN94/NYT4J/SV53luBO/19Whidb300CrD0tjrF0QqD+/clz1YuwoJ15yV2ZP9oFVpRTD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389542; c=relaxed/simple;
	bh=IIyYZVRKhiEDEkXb2T4Tc+Szybli+hZPPpQxkJFhypQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sA7gTtjmhrISyGfwAsn8O3kTXNSh5hYS2MxOTt0/yxYRkiOXLmA/GxBM+lFYU9sbA1dXEzSq2AU2fqmsJEPixIvaJ/iDMNqiwk/KNbzEJ1YUFhQ6CcBUL7dooBeommDsU66MlqBTf9E3la5ZOWiSY4sM1zLhvmjWW+MVW9HRuks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfFQpHF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfFQpHF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C54C4CEC7;
	Tue,  8 Oct 2024 12:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389542;
	bh=IIyYZVRKhiEDEkXb2T4Tc+Szybli+hZPPpQxkJFhypQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfFQpHF6Qu5zajJgRum8A3x+nhNnWRp60Am6BkXIzvE07JAhZOqThdnd9+8wBqnlY
	 kDChOpySNx1QdigL2Kaobzz+/xuxV1ihPLQRUzVCxbfO39m2EHK/YMFv+2JIXShJbE
	 51jDoSOCfpZM4qP5RIKT4APoP6QNkoI49G1CLzpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 009/482] drm/amd/display: handle nulled pipe context in DCE110s set_drr()
Date: Tue,  8 Oct 2024 14:01:12 +0200
Message-ID: <20241008115648.662925788@linuxfoundation.org>
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
index e9e9f80a02a77..542d669bf5e30 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -2020,13 +2020,20 @@ static void set_drr(struct pipe_ctx **pipe_ctx,
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



