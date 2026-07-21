Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFCF3B9D9D;
	Tue, 21 Jul 2026 21:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669602; cv=none; b=aywRk8XTE7hpJCvsR3AeWKtr74CtcfYR/mFh3MJsOje9II3Lcm+LFI4RWBMh/QqEj5vE8cF/eM0W0VN4PVIcVKLOrgFf6ZJEdzegpUiU4B+KQXrCYmzlEdNUSf5bIIu/1oQSSNLDdh6gUAur+JR6csVHbitaOsnj/4LflqYJC9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669602; c=relaxed/simple;
	bh=ji0RUNOyGpaQD5R74BOnafRBnJtBNxUV5+WgusRKS10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJ7Fu+xgrImf6oACLsiMxbOd47MqPvqr9ZPKVBzBze6a4vcmkUliu2D8tla8gjAQf0iHy0MQT5Xcgk5Axrup01daFvrbuTFI74X36WH5+SQRDq7JPyN8fIwwgAhvJ7GSCyoH6o2w0RRdpXF+u1CjTXVoXhEUp63I/KH0jT++gTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y41Ksfov; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y41Ksfov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E764E1F000E9;
	Tue, 21 Jul 2026 21:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669600;
	bh=nRR39JE9pWvp1W5g9EqQMitFmkLoUEL7pmx5E2QLkNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y41KsfovJS4U4N20C015yyTu5tVhahGJ18DxIlGXd0BIDaMQ4m9qnlcdL1xMhjphR
	 DEAAbqPFGoBCrCz4H8abvAEcXO5wW1b4nYDj7HqdSx/IYstj8wy+NDW5TWE2rVE0cV
	 MTXGBjgOmcb1Rlr/spU5r6sYYleq+h88zCmMvO2g=
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
Subject: [PATCH 6.1 0617/1067] ice: fix AQ error code comparison in ice_set_pauseparam()
Date: Tue, 21 Jul 2026 17:20:18 +0200
Message-ID: <20260721152438.402418138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ea92a66c6c6669..b917cfba1f4ed5 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3347,7 +3347,6 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 	if (!pi || !aq_failures)
 		return -EINVAL;
 
-	*aq_failures = 0;
 	hw = pi->hw;
 
 	pcaps = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*pcaps), GFP_KERNEL);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 7774292a5bdbe6..1ef57db5e6562e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3059,7 +3059,7 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_hw *hw = &pf->hw;
 	struct ice_port_info *pi;
-	u8 aq_failures;
+	u8 aq_failures = 0;
 	bool link_up;
 	u32 is_an;
 	int err;
@@ -3130,18 +3130,22 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 	/* Set the FC mode and only restart AN if link is up */
 	err = ice_set_fc(pi, &aq_failures, link_up);
 
-	if (aq_failures & ICE_SET_FC_AQ_FAIL_GET) {
+	switch (aq_failures) {
+	case ICE_SET_FC_AQ_FAIL_GET:
 		netdev_info(netdev, "Set fc failed on the get_phy_capabilities call with err %d aq_err %s\n",
 			    err, ice_aq_str(hw->adminq.sq_last_status));
 		err = -EAGAIN;
-	} else if (aq_failures & ICE_SET_FC_AQ_FAIL_SET) {
+		break;
+	case ICE_SET_FC_AQ_FAIL_SET:
 		netdev_info(netdev, "Set fc failed on the set_phy_config call with err %d aq_err %s\n",
 			    err, ice_aq_str(hw->adminq.sq_last_status));
 		err = -EAGAIN;
-	} else if (aq_failures & ICE_SET_FC_AQ_FAIL_UPDATE) {
+		break;
+	case ICE_SET_FC_AQ_FAIL_UPDATE:
 		netdev_info(netdev, "Set fc failed on the get_link_info call with err %d aq_err %s\n",
 			    err, ice_aq_str(hw->adminq.sq_last_status));
 		err = -EAGAIN;
+		break;
 	}
 
 	return err;
-- 
2.53.0



