Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528E314A084;
	Tue, 25 Jun 2024 09:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308489; cv=none; b=CXOzlSrviHDzfbNLJIXwu7PihNRd5PYxk3H2PRHEOaUVIWgw71Zvy+Qm8LJr8dJ59TKJbhFkPmwfzizbdvrCMNhmgk2IkuVpBOeYYF5Vv8V5/0uUBjsCMbWz6J144afustv1KSYvmwKnDxzqZo1oItSWV2yKroPWZQS+T95B3Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308489; c=relaxed/simple;
	bh=OaK9mMsKLEJNg6WshsBpjqj0sgN44rHoMSu5ht09D1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzwJlH1oeonuPZNUxnDAatwnfMAE+n4tOKumTHDJ9KBXoHf7OaQnG0cBW4YG1OcEIgd6zM4NH2RLo5jC2Cyj0/UaYYZKacgCOzps/QzSMCYK+LQ+URsqZRNCsU2cmSaNYo7AoQZn43RlmtV/jFDZ0WSzllojwT4qi3+MNemTX5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eY54CJ9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eY54CJ9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAACC32781;
	Tue, 25 Jun 2024 09:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308489;
	bh=OaK9mMsKLEJNg6WshsBpjqj0sgN44rHoMSu5ht09D1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eY54CJ9FQBTKE8F9NzJk6HVXYHi9nrsahKCa1GYXuxCBaJ0fm5cMvkcAbNZMZEbxB
	 nxNhvEhAxBFie7XnNcY8ry4AbvIB/4VRHQB0EwMVfaThUhj8y7PneVxlnDbC0N2uAo
	 xgwBWHXvKMw0KIQaNgurJC6e/grGzpSzmryKUDxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 139/250] ice: Fix VSI list rule with ICE_SW_LKUP_LAST type
Date: Tue, 25 Jun 2024 11:31:37 +0200
Message-ID: <20240625085553.395060446@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit 74382aebc9035470ec4c789bdb0d09d8c14f261e ]

Adding/updating VSI list rule, as well as allocating/freeing VSI list
resource are called several times with type ICE_SW_LKUP_LAST, which fails
because ice_update_vsi_list_rule() and ice_aq_alloc_free_vsi_list()
consider it invalid. Allow calling these functions with ICE_SW_LKUP_LAST.

This fixes at least one issue in switchdev mode, where the same rule with
different action cannot be added, e.g.:

  tc filter add dev $PF1 ingress protocol arp prio 0 flower skip_sw \
    dst_mac ff:ff:ff:ff:ff:ff action mirred egress redirect dev $VF1_PR
  tc filter add dev $PF1 ingress protocol arp prio 0 flower skip_sw \
    dst_mac ff:ff:ff:ff:ff:ff action mirred egress redirect dev $VF2_PR

Fixes: 0f94570d0cae ("ice: allow adding advanced rules")
Suggested-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20240618210206.981885-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index b4ea935e83005..1472385eb68eb 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1825,7 +1825,8 @@ ice_aq_alloc_free_vsi_list(struct ice_hw *hw, u16 *vsi_list_id,
 	    lkup_type == ICE_SW_LKUP_ETHERTYPE_MAC ||
 	    lkup_type == ICE_SW_LKUP_PROMISC ||
 	    lkup_type == ICE_SW_LKUP_PROMISC_VLAN ||
-	    lkup_type == ICE_SW_LKUP_DFLT) {
+	    lkup_type == ICE_SW_LKUP_DFLT ||
+	    lkup_type == ICE_SW_LKUP_LAST) {
 		sw_buf->res_type = cpu_to_le16(ICE_AQC_RES_TYPE_VSI_LIST_REP);
 	} else if (lkup_type == ICE_SW_LKUP_VLAN) {
 		if (opc == ice_aqc_opc_alloc_res)
@@ -2759,7 +2760,8 @@ ice_update_vsi_list_rule(struct ice_hw *hw, u16 *vsi_handle_arr, u16 num_vsi,
 	    lkup_type == ICE_SW_LKUP_ETHERTYPE_MAC ||
 	    lkup_type == ICE_SW_LKUP_PROMISC ||
 	    lkup_type == ICE_SW_LKUP_PROMISC_VLAN ||
-	    lkup_type == ICE_SW_LKUP_DFLT)
+	    lkup_type == ICE_SW_LKUP_DFLT ||
+	    lkup_type == ICE_SW_LKUP_LAST)
 		rule_type = remove ? ICE_AQC_SW_RULES_T_VSI_LIST_CLEAR :
 			ICE_AQC_SW_RULES_T_VSI_LIST_SET;
 	else if (lkup_type == ICE_SW_LKUP_VLAN)
-- 
2.43.0



