Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4BD46DFEF;
	Tue, 21 Jul 2026 19:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661040; cv=none; b=gkJHnOih/dtpbWU7eUp2LtRzfbgABqFFg+Ofdp7YT1meizjbPWVCp+lj5WaQYctIvbo7bzvQncdptm0mGL94mib363ODFOVKoqqwSaWiuEsXUzrOnghqA0Xezii5zMK1CcwFBDlCLveME08Reu9AkhN/y5I2F2ZjDVY1xMzSKQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661040; c=relaxed/simple;
	bh=RjF/xXU00IZ7vBKtstkbVQ311p9OJNM2Vy0QHCt2XZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIY+4hxx/omz1Qed/GKBMiURmwzXrzXwU4FoEUGamblWh9eOW34sNQLXdz4ZEbvrE3WI0HGI3Puo/o5VHEHP8vlBAz0Xg2RZwkLtkfTPU56wxzevUTrnRTVdTmuG2umY1oDtWDb0fn5Ehljuso3J1iRsDu6GotrEu5HjkVrfH48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqNPNC3j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqNPNC3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72BA1F000E9;
	Tue, 21 Jul 2026 19:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661039;
	bh=x24co2IFQ9ah9+t2zx3NXOfqjznen/mLNL6T9QLvar8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tqNPNC3j8h3+LJTwBpt2ML94XlhNm8IlCv3XUjDXiNu+tcAqtAw2GCWOWMY9g6h42
	 J2DhbfR6wLvbD4dAo/ZDUN8rtPhhKhOLz8aoOW33Rus76hVT0+xY6p4obp8g6g85/q
	 3muQ8l8vNXr/xtGUMeWadIUgQ9HK3Rayq6hNs8Ig=
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
Subject: [PATCH 7.1 1209/2077] ice: fix AQ error code comparison in ice_set_pauseparam()
Date: Tue, 21 Jul 2026 17:14:42 +0200
Message-ID: <20260721152621.330304330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index b617a6bff89134..98960d3cbdd1de 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3882,7 +3882,6 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 	if (!pi || !aq_failures)
 		return -EINVAL;
 
-	*aq_failures = 0;
 	hw = pi->hw;
 
 	pcaps = kzalloc_obj(*pcaps);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index f28416a707d77c..cf6f3bd29f8409 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3508,7 +3508,7 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_hw *hw = &pf->hw;
 	struct ice_port_info *pi;
-	u8 aq_failures;
+	u8 aq_failures = 0;
 	bool link_up;
 	u32 is_an;
 	int err;
@@ -3579,18 +3579,22 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
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



