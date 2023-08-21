Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D133511703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEECC433C8;
	Mon, 21 Aug 2023 19:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647861;
	bh=VOQpoypfLjWa59tiI0PD1o+6erCu/gxfB3BlOvWXHVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajfJgTEIv48Np9tFy1Kb96OvZ8TD0dXmDEhzz7vVz88g2J2bDL0L7GDXl5DnLNFVR
	 Qa/vRJGq0vps0JwaLpSWj7jciWwkQYq9ZaykL7ptcj5FeKNx47dOoa8F84zfbkPGPR
	 k0z619pTPDqgdb1m3g5RFgeBN9QlQeddXGCYzLXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/194] ice: Block switchdev mode when ADQ is active and vice versa
Date: Mon, 21 Aug 2023 21:41:53 +0200
Message-ID: <20230821194128.577807299@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit 43d00e102d9ecbe2635d7e3f2e14d2e90183d6af ]

ADQ and switchdev are not supported simultaneously. Enabling both at the
same time can result in nullptr dereference.

To prevent this, check if ADQ is active when changing devlink mode to
switchdev mode, and check if switchdev is active when enabling ADQ.

Fixes: fbc7b27af0f9 ("ice: enable ndo_setup_tc support for mqprio_qdisc")
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230816193405.1307580-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c | 6 ++++++
 drivers/net/ethernet/intel/ice/ice_main.c    | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index f9f15acae90a0..2ffe5708a045b 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -562,6 +562,12 @@ ice_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		break;
 	case DEVLINK_ESWITCH_MODE_SWITCHDEV:
 	{
+		if (ice_is_adq_active(pf)) {
+			dev_err(ice_pf_to_dev(pf), "Couldn't change eswitch mode to switchdev - ADQ is active. Delete ADQ configs and try again, e.g. tc qdisc del dev $PF root");
+			NL_SET_ERR_MSG_MOD(extack, "Couldn't change eswitch mode to switchdev - ADQ is active. Delete ADQ configs and try again, e.g. tc qdisc del dev $PF root");
+			return -EOPNOTSUPP;
+		}
+
 		dev_info(ice_pf_to_dev(pf), "PF %d changed eswitch mode to switchdev",
 			 pf->hw.pf_id);
 		NL_SET_ERR_MSG_MOD(extack, "Changed eswitch mode to switchdev");
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a771e597795d3..7a00d297be3a9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -8787,6 +8787,11 @@ ice_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 						  ice_setup_tc_block_cb,
 						  np, np, true);
 	case TC_SETUP_QDISC_MQPRIO:
+		if (ice_is_eswitch_mode_switchdev(pf)) {
+			netdev_err(netdev, "TC MQPRIO offload not supported, switchdev is enabled\n");
+			return -EOPNOTSUPP;
+		}
+
 		if (pf->adev) {
 			mutex_lock(&pf->adev_mutex);
 			device_lock(&pf->adev->dev);
-- 
2.40.1



