Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AAB1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29AAC433D6;
	Wed, 23 Nov 2022 09:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196517;
	bh=xoSLsihZiT1ArA1txjFg65HFkeQ/l8/kgQEA+n7cWCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjnMcH3uFgHpszegfUSpQcvlpAksyXs2Oy02MOiAF+sP79xBaxKPyzrPfStqoZ/LV
	 1EjJHcclUk3BMQFi8bikpecLU5RPjti33JhGlDn154lEhF7ad+jfnEX8sTf+mj1Tk1
	 uUJ4JM/nixxzCp45ZcAUIRkjuDSAXp+EoXiREJYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	George Shen <george.shen@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 054/314] drm/amd/display: Use forced DSC bpp in DML
Date: Wed, 23 Nov 2022 09:48:19 +0100
Message-Id: <20221123084627.948487632@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: George Shen <george.shen@amd.com>

[ Upstream commit ab007e5db5d3b8b8975c7eec69992ff38fe2a46c ]

[Why]
DSC config is calculated separately from DML calculations.
DML should use these separately calculated DSC params. The issue is
that the calculated bpp is not properly propagated into DML.

[How]
Correctly used forced_bpp value in DML.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c | 2 +-
 drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
index 52525833a99b..6704465fe5b6 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -1627,7 +1627,7 @@ static void mode_support_configuration(struct vba_vars_st *v,
 				&& !mode_lib->vba.MSOOrODMSplitWithNonDPLink
 				&& !mode_lib->vba.NotEnoughLanesForMSO
 				&& mode_lib->vba.LinkCapacitySupport[i] == true && !mode_lib->vba.P2IWith420
-				&& !mode_lib->vba.DSCOnlyIfNecessaryWithBPP
+				//&& !mode_lib->vba.DSCOnlyIfNecessaryWithBPP
 				&& !mode_lib->vba.DSC422NativeNotSupported
 				&& !mode_lib->vba.MPCCombineMethodIncompatible
 				&& mode_lib->vba.ODMCombine2To1SupportCheckOK[i] == true
diff --git a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c
index 503e7d984ff0..cb34ac0af349 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c
@@ -624,7 +624,7 @@ static void fetch_pipe_params(struct display_mode_lib *mode_lib)
 		mode_lib->vba.skip_dio_check[mode_lib->vba.NumberOfActivePlanes] =
 				dout->is_virtual;
 
-		if (!dout->dsc_enable)
+		if (dout->dsc_enable)
 			mode_lib->vba.ForcedOutputLinkBPP[mode_lib->vba.NumberOfActivePlanes] = dout->output_bpp;
 		else
 			mode_lib->vba.ForcedOutputLinkBPP[mode_lib->vba.NumberOfActivePlanes] = 0.0;
-- 
2.35.1



