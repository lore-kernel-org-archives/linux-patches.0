Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8DD1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDBBC433C8;
	Mon, 21 Aug 2023 20:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648127;
	bh=JXO/TYkCF6WLEdDwoIchcqc9RFlzlJuWCwq5kXNoC0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZPGyQADWz4HTVVTVOEi3ImKMhhKSkWAXUlmKxBGe2agaHsz+1JDsIKMl9GV9Mzpb
	 5T0YoL3J9EU+h7pfhOIC6DXderir4YCrRnR0rjxeG34739lNo0kyfw+zt/ClqXLTA2
	 NJ09H5xKtBFxQD7RBurBA2pf3f2xoaGhcK9SNJVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nevenko Stupar <nevenko.stupar@amd.com>,
	Jun Lei <jun.lei@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 035/234] drm/amd/display: Apply 60us prefetch for DCFCLK <= 300Mhz
Date: Mon, 21 Aug 2023 21:39:58 +0200
Message-ID: <20230821194130.278360643@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alvin Lee <alvin.lee2@amd.com>

[ Upstream commit 7e60ab4eb3e4ba2adac46d737fdbbc5732bebd58 ]

[Description]
- Previously we wanted to apply extra 60us of prefetch for min DCFCLK
  (200Mhz), but DCFCLK can be calculated to be 201Mhz which underflows
  also without the extra prefetch
- Instead, apply the the extra 60us prefetch for any DCFCLK freq <=
  300Mhz

Reviewed-by: Nevenko Stupar <nevenko.stupar@amd.com>
Reviewed-by: Jun Lei <jun.lei@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c    | 4 ++--
 .../gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.h    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
index d75248b6cae99..9a5150e96017a 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -811,7 +811,7 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 					v->SwathHeightC[k],
 					TWait,
 					(v->DRAMSpeedPerState[mode_lib->vba.VoltageLevel] <= MEM_STROBE_FREQ_MHZ ||
-						v->DCFCLKPerState[mode_lib->vba.VoltageLevel] <= MIN_DCFCLK_FREQ_MHZ) ?
+						v->DCFCLKPerState[mode_lib->vba.VoltageLevel] <= DCFCLK_FREQ_EXTRA_PREFETCH_REQ_MHZ) ?
 							mode_lib->vba.ip.min_prefetch_in_strobe_us : 0,
 					/* Output */
 					&v->DSTXAfterScaler[k],
@@ -3311,7 +3311,7 @@ void dml32_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 							v->swath_width_chroma_ub_this_state[k],
 							v->SwathHeightYThisState[k],
 							v->SwathHeightCThisState[k], v->TWait,
-							(v->DRAMSpeedPerState[i] <= MEM_STROBE_FREQ_MHZ || v->DCFCLKState[i][j] <= MIN_DCFCLK_FREQ_MHZ) ?
+							(v->DRAMSpeedPerState[i] <= MEM_STROBE_FREQ_MHZ || v->DCFCLKState[i][j] <= DCFCLK_FREQ_EXTRA_PREFETCH_REQ_MHZ) ?
 									mode_lib->vba.ip.min_prefetch_in_strobe_us : 0,
 
 							/* Output */
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.h b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.h
index d98e36a9a09cc..c4745d63039bb 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.h
@@ -53,7 +53,7 @@
 #define BPP_BLENDED_PIPE 0xffffffff
 
 #define MEM_STROBE_FREQ_MHZ 1600
-#define MIN_DCFCLK_FREQ_MHZ 200
+#define DCFCLK_FREQ_EXTRA_PREFETCH_REQ_MHZ 300
 #define MEM_STROBE_MAX_DELIVERY_TIME_US 60.0
 
 struct display_mode_lib;
-- 
2.40.1



