Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C7D141995;
	Tue, 27 Feb 2024 14:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043892; cv=none; b=sjruTVdxPUEe901tUhtN5Fdv8go7OA90Iv8VH3sfHu0zrVNiWS6pUyGd5a7Sn0bWwP0Jvz2MCHLbqmictGeP+VMKABIL8rwS5bkckqaatWVhIPMipB/344lfEZpNeZIvy+oroalCYnpq2rS++29USKLd85usZVthDBpyagl2uG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043892; c=relaxed/simple;
	bh=uNeeonUj0LqDImFV/kgqpylNNPbKLjAruc2+7Sqpnjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LC5NK1KZ7wwAap92PbVDR/D3wJfHl3UB3GQxB/7TMDusHeA9fMr+QVCHWYX1iuSjQuR2LoOFfHOp2ZL1OpkeEieAM326jjBQJCcm3OdkltbXiksnrWrM893Wi2itJZKF+ZcMBVJBrnORPvyimONftlRDnlGCi1vsMALUPqrFY24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tN8EMDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tN8EMDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E7BC433F1;
	Tue, 27 Feb 2024 14:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043892;
	bh=uNeeonUj0LqDImFV/kgqpylNNPbKLjAruc2+7Sqpnjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tN8EMDKMCfWkZuko2tR/ve4t4k2kxRQ3n6eExISusfr648s7tYIWGebhleL31Vkv
	 nSkhQmQBfTTmQCeeZ58pwDWWSZ0L8+gmikcfiXtAGYaQXlebN9OXOf4++8xGdjP3Kk
	 y84oVMkbyVCBZX2jjk4orFXhO9jQdNlSP4NYSyJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <icenowy@aosc.io>,
	Jagan Teki <jagan@amarulasolutions.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 44/84] Revert "drm/sun4i: dsi: Change the start delay calculation"
Date: Tue, 27 Feb 2024 14:27:11 +0100
Message-ID: <20240227131554.307138711@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <icenowy@aosc.io>

[ Upstream commit a00d17e0a71ae2e4fdaac46e1c12785d3346c3f2 ]

This reverts commit da676c6aa6413d59ab0a80c97bbc273025e640b2.

The original commit adds a start parameter to the calculation of the
start delay according to some old BSP versions from Allwinner. However,
there're two ways to add this delay -- add it in DSI controller or add
it in the TCON. Add it in both controllers won't work.

The code before this commit is picked from new versions of BSP kernel,
which has a comment for the 1 that says "put start_delay to tcon". By
checking the sun4i_tcon0_mode_set_cpu() in sun4i_tcon driver, it has
already added this delay, so we shouldn't repeat to add the delay in DSI
controller, otherwise the timing won't match.

Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191001080253.6135-2-icenowy@aosc.io
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
index f2b288037b909..a18efd3055199 100644
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
+++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
@@ -365,8 +365,7 @@ static void sun6i_dsi_inst_init(struct sun6i_dsi *dsi,
 static u16 sun6i_dsi_get_video_start_delay(struct sun6i_dsi *dsi,
 					   struct drm_display_mode *mode)
 {
-	u16 start = clamp(mode->vtotal - mode->vdisplay - 10, 8, 100);
-	u16 delay = mode->vtotal - (mode->vsync_end - mode->vdisplay) + start;
+	u16 delay = mode->vtotal - (mode->vsync_end - mode->vdisplay) + 1;
 
 	if (delay > mode->vtotal)
 		delay = delay % mode->vtotal;
-- 
2.43.0



