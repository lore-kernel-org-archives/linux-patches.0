Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990EC2222AE;
	Thu, 13 Feb 2025 14:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457597; cv=none; b=pM8TjE5bm10Iukbi177blLIMhmwjromk0lphbrn9AMpollc+bxgywJmrxF3qBum45EGjat7qy7yN15EJkToSLm7t09AgctehL583uMFoT0hBmgMTamf4NfW99G0JMf0xjjrJU1knfD2vxCUKLfrsgPgu64vAHUT38JyTC8lBW0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457597; c=relaxed/simple;
	bh=CbQC9HoAPQ1GebOFMNVHtqagVSsX42oI5xD37btGuE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nn8GVaMv5N5ZHDRDAppnMrEXqFH1X7J7VeUcfxS2PeTTJDpQ3N/jciMmADvjTc3rfCKMJLu01cacdIglDcLU1RkoLJzL25jiLOlxSpp7WGUXkbEjakaeUKUaQQ506EIWPjMGBlVDDpZYbQXeizZDk7+mSfvofnLobdGic5ExVb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNyJpibR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNyJpibR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85109C4CED1;
	Thu, 13 Feb 2025 14:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457597;
	bh=CbQC9HoAPQ1GebOFMNVHtqagVSsX42oI5xD37btGuE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNyJpibRgTgZQYA2w2OQjG81b2EuKaG2/GQNdsROMK24O+T6MbvdVzpARZcz4m5mu
	 k60PkRKKuxD6L9T2aSx5xWpkAiuST1/svdLX2mzviUhBlWDny+SO601QGR2iuZx2wp
	 c53KfDZwY9O1xlqLUAgdwExfbRY5EifGVP5odJP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sung Lee <sung.lee@amd.com>,
	Aric Cyr <Aric.Cyr@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 156/422] drm/amd/display: Optimize cursor position updates
Date: Thu, 13 Feb 2025 15:25:05 +0100
Message-ID: <20250213142442.566107031@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aric Cyr <Aric.Cyr@amd.com>

commit 024771f3fb75dc817e9429d5763f1a6eb84b6f21 upstream.

[why]
Updating the cursor enablement register can be a slow operation and accumulates
when high polling rate cursors cause frequent updates asynchronously to the
cursor position.

[how]
Since the cursor enable bit is cached there is no need to update the
enablement register if there is no change to it.  This removes the
read-modify-write from the cursor position programming path in HUBP and
DPP, leaving only the register writes.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sung Lee <sung.lee@amd.com>
Signed-off-by: Aric Cyr <Aric.Cyr@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dpp/dcn10/dcn10_dpp.c      |    7 ++++---
 drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp_cm.c |    6 ++++--
 drivers/gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c    |    8 +++++---
 drivers/gpu/drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c  |   10 ++++++----
 4 files changed, 19 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dpp/dcn10/dcn10_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dpp/dcn10/dcn10_dpp.c
@@ -483,10 +483,11 @@ void dpp1_set_cursor_position(
 	if (src_y_offset + cursor_height <= 0)
 		cur_en = 0;  /* not visible beyond top edge*/
 
-	REG_UPDATE(CURSOR0_CONTROL,
-			CUR0_ENABLE, cur_en);
+	if (dpp_base->pos.cur0_ctl.bits.cur0_enable != cur_en) {
+		REG_UPDATE(CURSOR0_CONTROL, CUR0_ENABLE, cur_en);
 
-	dpp_base->pos.cur0_ctl.bits.cur0_enable = cur_en;
+		dpp_base->pos.cur0_ctl.bits.cur0_enable = cur_en;
+	}
 }
 
 void dpp1_cnv_set_optional_cursor_attributes(
--- a/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp_cm.c
+++ b/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp_cm.c
@@ -154,9 +154,11 @@ void dpp401_set_cursor_position(
 	struct dcn401_dpp *dpp = TO_DCN401_DPP(dpp_base);
 	uint32_t cur_en = pos->enable ? 1 : 0;
 
-	REG_UPDATE(CURSOR0_CONTROL, CUR0_ENABLE, cur_en);
+	if (dpp_base->pos.cur0_ctl.bits.cur0_enable != cur_en) {
+		REG_UPDATE(CURSOR0_CONTROL, CUR0_ENABLE, cur_en);
 
-	dpp_base->pos.cur0_ctl.bits.cur0_enable = cur_en;
+		dpp_base->pos.cur0_ctl.bits.cur0_enable = cur_en;
+	}
 }
 
 void dpp401_set_optional_cursor_attributes(
--- a/drivers/gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/hubp/dcn20/dcn20_hubp.c
@@ -1044,11 +1044,13 @@ void hubp2_cursor_set_position(
 	if (src_y_offset + cursor_height <= 0)
 		cur_en = 0;  /* not visible beyond top edge*/
 
-	if (cur_en && REG_READ(CURSOR_SURFACE_ADDRESS) == 0)
-		hubp->funcs->set_cursor_attributes(hubp, &hubp->curs_attr);
+	if (hubp->pos.cur_ctl.bits.cur_enable != cur_en) {
+		if (cur_en && REG_READ(CURSOR_SURFACE_ADDRESS) == 0)
+			hubp->funcs->set_cursor_attributes(hubp, &hubp->curs_attr);
 
-	REG_UPDATE(CURSOR_CONTROL,
+		REG_UPDATE(CURSOR_CONTROL,
 			CURSOR_ENABLE, cur_en);
+	}
 
 	REG_SET_2(CURSOR_POSITION, 0,
 			CURSOR_X_POSITION, pos->x,
--- a/drivers/gpu/drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c
@@ -718,11 +718,13 @@ void hubp401_cursor_set_position(
 			dc_fixpt_from_int(dst_x_offset),
 			param->h_scale_ratio));
 
-	if (cur_en && REG_READ(CURSOR_SURFACE_ADDRESS) == 0)
-		hubp->funcs->set_cursor_attributes(hubp, &hubp->curs_attr);
+	if (hubp->pos.cur_ctl.bits.cur_enable != cur_en) {
+		if (cur_en && REG_READ(CURSOR_SURFACE_ADDRESS) == 0)
+			hubp->funcs->set_cursor_attributes(hubp, &hubp->curs_attr);
 
-	REG_UPDATE(CURSOR_CONTROL,
-		CURSOR_ENABLE, cur_en);
+		REG_UPDATE(CURSOR_CONTROL,
+			CURSOR_ENABLE, cur_en);
+	}
 
 	REG_SET_2(CURSOR_POSITION, 0,
 		CURSOR_X_POSITION, x_pos,


