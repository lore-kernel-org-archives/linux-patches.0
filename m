Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D51946D080;
	Tue, 21 Jul 2026 18:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657879; cv=none; b=WDEFIJIMuaaiwWv0Yym4azkgkcbXcuaN1pWZx6XAmBgUy5mPNKDOI094/b0Lqj5LP0/0ioCaidWR3ckxysdkLUcNlzW0LjNyPnh1uID/xJ9FVRak809VJrkTQoEQokDVhlefXBEMM0J3x3afe3xeyrYtJ4dVkLeXAb6FDUYINBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657879; c=relaxed/simple;
	bh=PWWvLzLrHFzrFPYkTr/6bVDbsq8a5mLoK6ro1O1Is24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtvyAYR6LJDAg6xMrInRw7uTEBbMZzWvZzNExrL/QgiFS0yCWekEx9drVfeUDMcwHaJcD+zqTRZMc2yEzrp1uVURQxz1syUqnuRD61LL5K+XBptR+O8JBy8hPnemgybhFGByXu2iS4yCi2d+EYMTwSSDiiMr0uEEhvnIVAbrGdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wl0AG0hy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wl0AG0hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78DA1F000E9;
	Tue, 21 Jul 2026 18:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657873;
	bh=SEh2RFh5/AqpvJoZrs+5RcqWlm+qYsu7SGnpB2CwLAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wl0AG0hyEb8ZQvOFgoVKkm5+94rIA/NAkiUCU5h6/hY8EBMBlL1woXv7Uw1vShIOv
	 UwCOE31PnNoFpVqBv70GhPC4tVjDtc1ZzqxynoWY5tTpVMogW7phb4uNeNMDxgck4p
	 5zoWNg1mAydYQSrkNAX7QNiqdksjauKGNALfQJBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Czapnik <lukasz.czapnik@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 0886/1611] ice: fix AQ error code comparison in ice_set_pauseparam()
Date: Tue, 21 Jul 2026 17:16:42 +0200
Message-ID: <20260721152535.319271055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Czapnik <lukasz.czapnik@intel.com>

[ Upstream commit 2bf7744bc3221a63b95c76c94eab1dad832fa401 ]

Fix unreachable code: the conditionals in ice_set_pauseparam() used
the bitwise-AND operator suggesting aq_failures is a bitmap, but it
is actually an enum, making the third condition logically unreachable.

Replace the if-else ladder with a switch statement.  Also move the
aq_failures initialization to the variable declaration and remove the
redundant zeroing from ice_set_fc().

Fixes: fcea6f3da546 ("ice: Add stats and ethtool support")
Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c  |  1 -
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 12 ++++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 4dcc3b41800b36..f71e45ab809e0f 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3919,7 +3919,6 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 	if (!pi || !aq_failures)
 		return -EINVAL;
 
-	*aq_failures = 0;
 	hw = pi->hw;
 
 	pcaps = kzalloc(sizeof(*pcaps), GFP_KERNEL);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 912bcf9fce52d2..ce0f8106dcd4eb 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3488,7 +3488,7 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_hw *hw = &pf->hw;
 	struct ice_port_info *pi;
-	u8 aq_failures;
+	u8 aq_failures = 0;
 	bool link_up;
 	u32 is_an;
 	int err;
@@ -3559,18 +3559,22 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 	/* Set the FC mode and only restart AN if link is up */
 	err = ice_set_fc(pi, &aq_failures, link_up);
 
-	if (aq_failures & ICE_SET_FC_AQ_FAIL_GET) {
+	switch (aq_failures) {
+	case ICE_SET_FC_AQ_FAIL_GET:
 		netdev_info(netdev, "Set fc failed on the get_phy_capabilities call with err %d aq_err %s\n",
 			    err, libie_aq_str(hw->adminq.sq_last_status));
 		err = -EAGAIN;
-	} else if (aq_failures & ICE_SET_FC_AQ_FAIL_SET) {
+		break;
+	case ICE_SET_FC_AQ_FAIL_SET:
 		netdev_info(netdev, "Set fc failed on the set_phy_config call with err %d aq_err %s\n",
 			    err, libie_aq_str(hw->adminq.sq_last_status));
 		err = -EAGAIN;
-	} else if (aq_failures & ICE_SET_FC_AQ_FAIL_UPDATE) {
+		break;
+	case ICE_SET_FC_AQ_FAIL_UPDATE:
 		netdev_info(netdev, "Set fc failed on the get_link_info call with err %d aq_err %s\n",
 			    err, libie_aq_str(hw->adminq.sq_last_status));
 		err = -EAGAIN;
+		break;
 	}
 
 	return err;
-- 
2.53.0



