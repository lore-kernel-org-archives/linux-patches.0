Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFACB2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6683FC4339B;
	Tue, 18 Apr 2023 12:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822338;
	bh=5K+7JddlZrFYjRS2PhmvsYrGA2j2H6kx3Hz5/jx7L/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6fCJSWhX3Hz1QNVSVnFfRzjR0AXZqbtRpXPnwSotha/UW5LRIIV5veAhtaV/tD5g
	 BdfVdBKpLxz35BLRYDhjHHuyaAqi0xpY5k4n376uqLPQqa0BcuaPkS3dhUKux31dM2
	 h+7bMsEkAEdF9QBX1OB/P5Vw/OXUldMoY9dl2tMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 113/139] drm/amd/pm: correct the pcie link state check for SMU13
Date: Tue, 18 Apr 2023 14:22:58 +0200
Message-Id: <20230418120318.010994754@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Evan Quan <evan.quan@amd.com>

commit b9a24d8bd51e2db425602fa82d7f4c06aa3db852 upstream.

Update the driver implementations to fit those data exposed
by PMFW.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h         |    6 ++++++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |    4 ++--
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    4 ++--
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -61,6 +61,12 @@
 #define CTF_OFFSET_HOTSPOT		5
 #define CTF_OFFSET_MEM			5
 
+static const int pmfw_decoded_link_speed[5] = {1, 2, 3, 4, 5};
+static const int pmfw_decoded_link_width[7] = {0, 1, 2, 4, 8, 12, 16};
+
+#define DECODE_GEN_SPEED(gen_speed_idx)		(pmfw_decoded_link_speed[gen_speed_idx])
+#define DECODE_LANE_WIDTH(lane_width_idx)	(pmfw_decoded_link_width[lane_width_idx])
+
 struct smu_13_0_max_sustainable_clocks {
 	uint32_t display_clock;
 	uint32_t phy_clock;
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1125,8 +1125,8 @@ static int smu_v13_0_0_print_clk_levels(
 					(pcie_table->pcie_lane[i] == 5) ? "x12" :
 					(pcie_table->pcie_lane[i] == 6) ? "x16" : "",
 					pcie_table->clk_freq[i],
-					((gen_speed - 1) == pcie_table->pcie_gen[i]) &&
-					(lane_width == link_width[pcie_table->pcie_lane[i]]) ?
+					(gen_speed == DECODE_GEN_SPEED(pcie_table->pcie_gen[i])) &&
+					(lane_width == DECODE_LANE_WIDTH(link_width[pcie_table->pcie_lane[i]])) ?
 					"*" : "");
 		break;
 
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1074,8 +1074,8 @@ static int smu_v13_0_7_print_clk_levels(
 					(pcie_table->pcie_lane[i] == 5) ? "x12" :
 					(pcie_table->pcie_lane[i] == 6) ? "x16" : "",
 					pcie_table->clk_freq[i],
-					(gen_speed == pcie_table->pcie_gen[i]) &&
-					(lane_width == pcie_table->pcie_lane[i]) ?
+					(gen_speed == DECODE_GEN_SPEED(pcie_table->pcie_gen[i])) &&
+					(lane_width == DECODE_LANE_WIDTH(pcie_table->pcie_lane[i])) ?
 					"*" : "");
 		break;
 


