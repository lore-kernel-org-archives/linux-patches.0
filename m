Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527C9156F29;
	Tue, 23 Jul 2024 18:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759350; cv=none; b=VNxX0TUUvTsYIp/mdg1Cmzt+2fL/qwR5NFWpkynjPavITHohjVAcTmYQGeSFJ9izEloZPPGB6SYWelrQZ42Ixh8GPFIuKVibsPZ39LbVMXadKk+TITc/Gpl5hsBHDbxJL6hr+sN6fY3atGE7mNot6GG+WR3Z6fhHt0sMxoHOWT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759350; c=relaxed/simple;
	bh=OUv0dZTQPVeC2dX+6/F0+qtPReBl0/Ra2fD+TIu5nWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MX7K91C3PzQ/HFo4XNG5x3kddTVjFbSnuQTjz6jdVmdeJN+4/EKf4n8/pISdiAJ0+hNE3B1WkuUQS56SVq8Jm3g4RKCz3gR1TA6CQpdeBwB9eckTc1TSobE7ljoDmfZnQfpRcg9q50XCFB/5fdO4tdEuVy7Vpv1FBXHwUEm1cCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h51Zbmqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h51Zbmqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C887EC4AF0A;
	Tue, 23 Jul 2024 18:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759350;
	bh=OUv0dZTQPVeC2dX+6/F0+qtPReBl0/Ra2fD+TIu5nWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h51Zbmqdl8LwkcGH+Q4sNS2HuivsyKJ2lX0Txjz6oOtBZUaP93WAlO0xapOqNyKpW
	 MXcwkCAxPQAktArcSApkTZMctFNAMh+aUKANGgXCPlkUl9ar1nZSqydbbhWESJievz
	 TYuhYkRPh3FQaroK0pTHckPBO9tivGVqMoiMOniM=
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
Subject: [PATCH 6.1 086/105] drm/amd/display: Account for cursor prefetch BW in DML1 mode support
Date: Tue, 23 Jul 2024 20:24:03 +0200
Message-ID: <20240723180406.558910759@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cc8c1a48c5c4d..76df036fb2f34 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -3338,6 +3338,9 @@ void dml32_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
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



