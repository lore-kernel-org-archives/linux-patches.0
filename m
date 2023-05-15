Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCE1FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0184FC4339B;
	Mon, 15 May 2023 16:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169636;
	bh=Cqb/5prK+GtLc9etubAqPtZl8Fl28ThhRPbEFfboDTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1my3xUxmY8gxAAaeQHnvB6C6JazIuH4R60TIcXOu0rr3B+e2qE6Lb7/us8jHfk3z
	 EsFF4RkXTJISSwDk+9OIKu47N1NzyWUZxSOdwLAlvX0JEOI/RAe8yqfs/7pDDMSV2g
	 2jYyzcgadRy5U21AL9+BayAAZK8yB23mdy+CTLAI=
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
Subject: [PATCH 6.3 092/246] ice: block LAN in case of VF to VF offload
Date: Mon, 15 May 2023 18:25:04 +0200
Message-Id: <20230515161725.338820794@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
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
index 76f29a5bf8d73..d1a31f236d26a 100644
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



