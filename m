Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCADFFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75065C433EF;
	Mon, 15 May 2023 17:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170384;
	bh=/hCoPzC1Z4mecYydAZNyBRehqRp2i53PfOZdDfeVMpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6h+sFnlpZl35pkcx1XxezZDivRpRoQsDE9RYWW1d7xXmU6vhhILsmLOqeidCHj74
	 gW0j4NPas9kNzdP3fllzOXHgDZPLGlYonBgxJhQmCTHvBakgyCvg+1TKNMVu/HGaHK
	 fOEI0LhuSCf11PmSBJpEMHzfxUXOlkoljIfc3Z0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sujai Buvaneswaran <Sujai.Buvaneswaran@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
	Simon Horman <simon.horman@corigine.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/239] ice: block LAN in case of VF to VF offload
Date: Mon, 15 May 2023 18:25:49 +0200
Message-Id: <20230515161724.256937761@linuxfoundation.org>
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

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 9f699b71c2f31c51bd1483a20e1c8ddc5986a8c9 ]

VF to VF traffic shouldn't go outside. To enforce it, set only the loopback
enable bit in case of all ingress type rules added via the tc tool.

Fixes: 0d08a441fb1a ("ice: ndo_setup_tc implementation for PF")
Reported-by: Sujai Buvaneswaran <Sujai.Buvaneswaran@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 71cb15fcf63b9..652ef09eeb305 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -693,17 +693,18 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 	 * results into order of switch rule evaluation.
 	 */
 	rule_info.priority = 7;
+	rule_info.flags_info.act_valid = true;
 
 	if (fltr->direction == ICE_ESWITCH_FLTR_INGRESS) {
 		rule_info.sw_act.flag |= ICE_FLTR_RX;
 		rule_info.sw_act.src = hw->pf_id;
 		rule_info.rx = true;
+		rule_info.flags_info.act = ICE_SINGLE_ACT_LB_ENABLE;
 	} else {
 		rule_info.sw_act.flag |= ICE_FLTR_TX;
 		rule_info.sw_act.src = vsi->idx;
 		rule_info.rx = false;
 		rule_info.flags_info.act = ICE_SINGLE_ACT_LAN_ENABLE;
-		rule_info.flags_info.act_valid = true;
 	}
 
 	/* specify the cookie as filter_rule_id */
-- 
2.39.2



