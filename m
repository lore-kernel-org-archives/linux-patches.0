Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CCB221719;
	Tue, 29 Apr 2025 17:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948543; cv=none; b=kNEnHJkCWGuT6OqKKNmpehKAVjzS+SRtRiWGMuTKz+AlObdFjcK0vvuNbg2mnV5OvVRwF42CNq7+/RPUSuZfEb4VznOfMQDj76owTpbdD0yx0evWbyqse7AIjFpOmNUjmcuh8eN7ApKyQjeDRALeyQSu8MSif8IHiwOZZhvASLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948543; c=relaxed/simple;
	bh=jemcAf6RbPFu92XUCmgC3sSJoJS1jzbe5tZ4mG/zCfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPrnW7W+FmZtVfSr7swpndGS3UN8P3AFaakfCfgu7w54eaWtcwRJeu+lwLkVxZEyuGzsxvt+t3gat7dFvigOAqV1u635eIaSvgvElxGbX/lWoHXOkg7JA0Sng2dWAialed2i9sTNOd8ygeVSt0FCqYDvYq+YZ/Km8gDZQ/vAVNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaD2Icmb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaD2Icmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24829C4CEE3;
	Tue, 29 Apr 2025 17:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948542;
	bh=jemcAf6RbPFu92XUCmgC3sSJoJS1jzbe5tZ4mG/zCfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaD2IcmbgixO5oK7jDSL8CWkvIGU3+xilCIgf/nVgBLiZajP0rAgIEqQ4JnRHfsl8
	 F9L1pa+zqzkckI5a2mYfZW1OYXNAeSbZY6LANhRnCeHq6oG4zpKB9H7rzeAJI0LVHf
	 rWNOZ9TzhJuqHlK3wR1xUy7BAxBx1pjfimW5NBp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Zhikai Zhai <zhikai.zhai@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/373] drm/amd/display: Update Cursor request mode to the beginning prefetch always
Date: Tue, 29 Apr 2025 18:38:37 +0200
Message-ID: <20250429161124.777943309@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhikai Zhai <zhikai.zhai@amd.com>

[ Upstream commit 4a4077b4b63a8404efd6d37fc2926f03fb25bace ]

[Why]
The double buffer cursor registers is updated by the cursor
vupdate event. There is a gap between vupdate and cursor data
fetch if cursor fetch data reletive to cursor position.
Cursor corruption will happen if we update the cursor surface
in this gap.

[How]
Modify the cursor request mode to the beginning prefetch always
and avoid wraparound calculation issues.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Zhikai Zhai <zhikai.zhai@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c | 22 ++++++++-----------
 .../gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c |  2 +-
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index bc603c8af3b66..b31c31c39783f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1838,20 +1838,11 @@ static void delay_cursor_until_vupdate(struct dc *dc, struct pipe_ctx *pipe_ctx)
 	dc->hwss.get_position(&pipe_ctx, 1, &position);
 	vpos = position.vertical_count;
 
-	/* Avoid wraparound calculation issues */
-	vupdate_start += stream->timing.v_total;
-	vupdate_end += stream->timing.v_total;
-	vpos += stream->timing.v_total;
-
 	if (vpos <= vupdate_start) {
 		/* VPOS is in VACTIVE or back porch. */
 		lines_to_vupdate = vupdate_start - vpos;
-	} else if (vpos > vupdate_end) {
-		/* VPOS is in the front porch. */
-		return;
 	} else {
-		/* VPOS is in VUPDATE. */
-		lines_to_vupdate = 0;
+		lines_to_vupdate = stream->timing.v_total - vpos + vupdate_start;
 	}
 
 	/* Calculate time until VUPDATE in microseconds. */
@@ -1859,13 +1850,18 @@ static void delay_cursor_until_vupdate(struct dc *dc, struct pipe_ctx *pipe_ctx)
 		stream->timing.h_total * 10000u / stream->timing.pix_clk_100hz;
 	us_to_vupdate = lines_to_vupdate * us_per_line;
 
+	/* Stall out until the cursor update completes. */
+	if (vupdate_end < vupdate_start)
+		vupdate_end += stream->timing.v_total;
+
+	/* Position is in the range of vupdate start and end*/
+	if (lines_to_vupdate > stream->timing.v_total - vupdate_end + vupdate_start)
+		us_to_vupdate = 0;
+
 	/* 70 us is a conservative estimate of cursor update time*/
 	if (us_to_vupdate > 70)
 		return;
 
-	/* Stall out until the cursor update completes. */
-	if (vupdate_end < vupdate_start)
-		vupdate_end += stream->timing.v_total;
 	us_vupdate = (vupdate_end - vupdate_start + 1) * us_per_line;
 	udelay(us_to_vupdate + us_vupdate);
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c
index 127055044cf1a..faab14e343a4e 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c
@@ -44,7 +44,7 @@ void hubp31_set_unbounded_requesting(struct hubp *hubp, bool enable)
 	struct dcn20_hubp *hubp2 = TO_DCN20_HUBP(hubp);
 
 	REG_UPDATE(DCHUBP_CNTL, HUBP_UNBOUNDED_REQ_MODE, enable);
-	REG_UPDATE(CURSOR_CONTROL, CURSOR_REQ_MODE, enable);
+	REG_UPDATE(CURSOR_CONTROL, CURSOR_REQ_MODE, 1);
 }
 
 void hubp31_soft_reset(struct hubp *hubp, bool reset)
-- 
2.39.5



