Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739EB1586CB;
	Tue, 23 Jul 2024 18:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759712; cv=none; b=XlysvejWqx6fZiUYV/4rR0EZTa5kGuWm531oWeYuGrpC7xgXhXUlTOpncR/dbGtEXlqG1Nts1GcEqfmarpJaVAvvb6orpN8Oa+Kmlae9ctbTlXpPBgvHozL5vLHupmQh+cFsu38Jt5sARyNEbgWIo0guZiuWYQULmaOsr+/z25I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759712; c=relaxed/simple;
	bh=EVgnMeJbF9Y7dqjSTEPXaZ1koadNAFO4Mh7wqk66sSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTuTU8fX2Oi44AelGnKjTSDuy5ir6IsF5VSeHBXHFuGHarMZ6p1LBN80vE6OGjZKGuJFB3v2g401Ua4K8GfZxP0L/jlkCfXh8S8a+xQh1feGPyutskvuXhGxQzhiKko1pKeLd/5QXOw2d6uEgy+sNFFauxAWoT6Ujh6m32dJYDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emWxGHvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emWxGHvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB57C4AF09;
	Tue, 23 Jul 2024 18:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759712;
	bh=EVgnMeJbF9Y7dqjSTEPXaZ1koadNAFO4Mh7wqk66sSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emWxGHvtbJuqJXiyzorwdNgSvSkgTOoVowZfa7H/zWYu9k/h65yMeCkEeTTRU6vdM
	 0wG9pvBaR/Se+QR7+N8Gb85pSdybgoM7hG1/Zee7UZJjMeSCLSZH0FuQZIzYMWNzVo
	 loEKxdKuJAsU+1F1xshK8q3PG86VZAsU/wcbx3B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Dhere <chaitanya.dhere@amd.com>,
	Nevenko Stupar <nevenko.stupar@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/129] drm/amd/display: Account for cursor prefetch BW in DML1 mode support
Date: Tue, 23 Jul 2024 20:24:11 +0200
Message-ID: <20240723180408.773140075@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alvin Lee <alvin.lee2@amd.com>

[ Upstream commit 074b3a886713f69d98d30bb348b1e4cb3ce52b22 ]

[Description]
We need to ensure to take into account cursor prefetch BW in
mode support or we may pass ModeQuery but fail an actual flip
which will cause a hang. Flip may fail because the cursor_pre_bw
is populated during mode programming (and mode programming is
never called prior to ModeQuery).

Reviewed-by: Chaitanya Dhere <chaitanya.dhere@amd.com>
Reviewed-by: Nevenko Stupar <nevenko.stupar@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
index 6c84b0fa40f44..0782a34689a00 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -3364,6 +3364,9 @@ void dml32_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 							&mode_lib->vba.UrgentBurstFactorLumaPre[k],
 							&mode_lib->vba.UrgentBurstFactorChromaPre[k],
 							&mode_lib->vba.NotUrgentLatencyHidingPre[k]);
+
+					v->cursor_bw_pre[k] = mode_lib->vba.NumberOfCursors[k] * mode_lib->vba.CursorWidth[k][0] * mode_lib->vba.CursorBPP[k][0] /
+							8.0 / (mode_lib->vba.HTotal[k] / mode_lib->vba.PixelClock[k]) * v->VRatioPreY[i][j][k];
 				}
 
 				{
-- 
2.43.0



