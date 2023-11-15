Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAEB3A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpViiL6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F05C433C9;
	Wed, 15 Nov 2023 19:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077918;
	bh=G9b+r4LN+D8HXBPjZJ9Y8dsQnWZKbG8BeJM0ecR+lxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpViiL6W325oFR6TkkHF5/buqnnP5YgD7O2nbCMa3j+dfRkwgMh941WWzM4muV9Gi
	 VyjUFLfNymrbpjS5Xviq9Nn+Ub0YRXtH0cQnpHPGBwwcPkPnqm380chcOG+iR9Z1uI
	 IqjXmiUay56AKnXz0b8mL61AqZY3YUN7W11+XqW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 565/603] ice: Fix VF-VF direction matching in drop rule in switchdev
Date: Wed, 15 Nov 2023 14:18:30 -0500
Message-ID: <20231115191650.682829035@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit 68c51db3a16d258e730dd1c04a1de2f7ab038ddf ]

When adding a drop rule on a VF, rule direction is not being set, which
results in it always being set to ingress (ICE_ESWITCH_FLTR_INGRESS
equals 0). Because of this, drop rules added on port representors don't
match any packets.

To fix it, set rule direction in drop action to egress when netdev is a
port representor, otherwise set it to ingress.

Fixes: 0960a27bd479 ("ice: Add direction metadata")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 24 ++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 0e75fc6b3c060..dd03cb69ad26b 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -670,6 +670,25 @@ static int ice_tc_setup_redirect_action(struct net_device *filter_dev,
 	return 0;
 }
 
+static int
+ice_tc_setup_drop_action(struct net_device *filter_dev,
+			 struct ice_tc_flower_fltr *fltr)
+{
+	fltr->action.fltr_act = ICE_DROP_PACKET;
+
+	if (ice_is_port_repr_netdev(filter_dev)) {
+		fltr->direction = ICE_ESWITCH_FLTR_EGRESS;
+	} else if (ice_tc_is_dev_uplink(filter_dev)) {
+		fltr->direction = ICE_ESWITCH_FLTR_INGRESS;
+	} else {
+		NL_SET_ERR_MSG_MOD(fltr->extack,
+				   "Unsupported netdevice in switchdev mode");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int ice_eswitch_tc_parse_action(struct net_device *filter_dev,
 				       struct ice_tc_flower_fltr *fltr,
 				       struct flow_action_entry *act)
@@ -678,7 +697,10 @@ static int ice_eswitch_tc_parse_action(struct net_device *filter_dev,
 
 	switch (act->id) {
 	case FLOW_ACTION_DROP:
-		fltr->action.fltr_act = ICE_DROP_PACKET;
+		err = ice_tc_setup_drop_action(filter_dev, fltr);
+		if (err)
+			return err;
+
 		break;
 
 	case FLOW_ACTION_REDIRECT:
-- 
2.42.0



