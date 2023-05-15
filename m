Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EC4FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C966C433EF;
	Mon, 15 May 2023 17:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170569;
	bh=Oe3d2mE8HoXShW3L6u3vBtRWyKR6JiJQU1jOsPhl+oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gwEA/4v7G3zxNc+mOmo7a1O5Ek7o5eulJs0icx78AgNN8Cd2caa/GUJLHLAqDoz9
	 sEQ6FHF7VXySdee6htO//N/qNwsMjDLv+f5dMiXmk4vjoEiJrgsjSDdyF+NAAyKTgn
	 2MetKT/y2S09ix3cdUJ7i7lEt689l8imotfrCtjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nevenko Stupar <Nevenko.Stupar@amd.com>,
	Jun Lei <Jun.Lei@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.1 172/239] drm/amd/display: Enforce 60us prefetch for 200Mhz DCFCLK modes
Date: Mon, 15 May 2023 18:27:15 +0200
Message-Id: <20230515161726.830739782@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alvin Lee <Alvin.Lee2@amd.com>

commit b504f99ccaa64da364443431e388ecf30b604e38 upstream.

[Description]
- Due to bandwidth / arbitration issues at 200Mhz DCFCLK,
  we want to enforce minimum 60us of prefetch to avoid
  intermittent underflow issues
- Since 60us prefetch is already enforced for UCLK DPM0,
  and many DCFCLK's > 200Mhz are mapped to UCLK DPM1, in
  theory there should not be any UCLK DPM regressions by
  enforcing greater prefetch

Reviewed-by: Nevenko Stupar <Nevenko.Stupar@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c |    5 +++--
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -807,7 +807,8 @@ static void DISPCLKDPPCLKDCFCLKDeepSleep
 					v->SwathHeightY[k],
 					v->SwathHeightC[k],
 					TWait,
-					v->DRAMSpeedPerState[mode_lib->vba.VoltageLevel] <= MEM_STROBE_FREQ_MHZ ?
+					(v->DRAMSpeedPerState[mode_lib->vba.VoltageLevel] <= MEM_STROBE_FREQ_MHZ ||
+						v->DCFCLKPerState[mode_lib->vba.VoltageLevel] <= MIN_DCFCLK_FREQ_MHZ) ?
 							mode_lib->vba.ip.min_prefetch_in_strobe_us : 0,
 					/* Output */
 					&v->DSTXAfterScaler[k],
@@ -3288,7 +3289,7 @@ void dml32_ModeSupportAndSystemConfigura
 							v->swath_width_chroma_ub_this_state[k],
 							v->SwathHeightYThisState[k],
 							v->SwathHeightCThisState[k], v->TWait,
-							v->DRAMSpeedPerState[i] <= MEM_STROBE_FREQ_MHZ ?
+							(v->DRAMSpeedPerState[i] <= MEM_STROBE_FREQ_MHZ || v->DCFCLKState[i][j] <= MIN_DCFCLK_FREQ_MHZ) ?
 									mode_lib->vba.ip.min_prefetch_in_strobe_us : 0,
 
 							/* Output */
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.h
@@ -52,6 +52,7 @@
 #define BPP_BLENDED_PIPE 0xffffffff
 
 #define MEM_STROBE_FREQ_MHZ 1600
+#define MIN_DCFCLK_FREQ_MHZ 200
 #define MEM_STROBE_MAX_DELIVERY_TIME_US 60.0
 
 struct display_mode_lib;


