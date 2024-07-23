Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF32B13D896;
	Tue, 23 Jul 2024 18:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760216; cv=none; b=VEgNVZso6p3s3dmw5CpAt9Yy2DntBUe/3DpS1vYphMBFRHcq/kO06OujCnBDikxuQ+AmeU8jGkJIW2pznMoAXSd0NuNoZPPc5W60naNVhUqEQzWS9X5DgBMHN25lOhXO2PlXNRdoepYrSRJZdt782Y/lCU74CHX6gzuzdw38+BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760216; c=relaxed/simple;
	bh=Kkbc8PzlEaeqcadowVGwaCpxnc5OKwd5s15lzhu2UnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3k76KFwnhctWsBaRCk1Jf9NC/8vJFqkIgjKN2LSKEpi+qQwkUJEL+r0RAxenpd3HuWnXczgsQ97Zoomd3egrqZlCRmbC3ENS2zJRnKZDEH6JBv4lBXjnC2w6eq693BRpX/aHNwxLl0hiW0IimYB/M+NImMPaOnO20CyTALYRco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QoxBjtdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QoxBjtdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3899BC4AF09;
	Tue, 23 Jul 2024 18:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760216;
	bh=Kkbc8PzlEaeqcadowVGwaCpxnc5OKwd5s15lzhu2UnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QoxBjtdbIBBl7vLQQWaGEGExDvpxlYxQEucV2DIL/I+qTEJTi+N55Ia0Jj8B/OfhW
	 DTJ7dbRsdrZwucWXg83sUbH1A6iQtAqEEdGdKVA7/tqBlrdFFvYwbZZE6Xf8y+b7/J
	 Im6ewx4a5y20qygXEiBXsmhRikjnmJ7XiH3/o7/4=
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
Subject: [PATCH 6.9 134/163] drm/amd/display: Account for cursor prefetch BW in DML1 mode support
Date: Tue, 23 Jul 2024 20:24:23 +0200
Message-ID: <20240723180148.651115110@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



