Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5635B143C4D;
	Tue, 23 Apr 2024 21:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908471; cv=none; b=fJb4RQ2O+5s9TXg4NfLCEhCu1JU1KYUh6H4WhNA533hX47CyJE6vPlVJ9gju8jTQ5u68D+UpBwNffjfkWKZ9JaxQ+yh1Nk0Py+CD/+hLh8FrBMKBHuAethV4DrEjEtP8OWf5OzCm1PoYkD6FphegNFBaTAAaYGY0fPuvsflu+dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908471; c=relaxed/simple;
	bh=D+tHfRfMJ2Jqj81deDmhN2uDX/gbdBMIhXWKaB07Acs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hluUY3c1M30SiiJcBPgfAPYv9wPWVataMASx9sSxp30L29lb4LZK0y+shrIS/JfHMeFU7qMZ2fPXJ+sGhmxwqxRWWOK8oHS+EIsJJZlrhI4su7HtbGlUNHe6H92LBF9i27zLjMG8Sdf2meJX6l+TLj7H4Fzy5fRitxePMQCsH0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eei2m4Rb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eei2m4Rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A4AC116B1;
	Tue, 23 Apr 2024 21:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908471;
	bh=D+tHfRfMJ2Jqj81deDmhN2uDX/gbdBMIhXWKaB07Acs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eei2m4RbGBM9T4vQhzCsTpNNFyU5KhCohUB+yqkvRbNxOGC9Zo+MCK0ouIrp7ksiw
	 Ngx4uNMAdi7zh4E6UzQmITu/wBYC4+o6StCZRQ1w4m2gfR+YliqZfc33In4B4sIUhD
	 WC20bWgf+8Cq3qPmBQ5UGLx363BCntv/kJfjTFXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 037/158] ice: tc: check src_vsi in case of traffic from VF
Date: Tue, 23 Apr 2024 14:37:39 -0700
Message-ID: <20240423213857.106549939@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 428051600cb4e5a61d81aba3f8009b6c4f5e7582 ]

In case of traffic going from the VF (so ingress for port representor)
source VSI should be consider during packet classification. It is
needed for hardware to not match packets from different ports with
filters added on other port.

It is only for "from VF" traffic, because other traffic direction
doesn't have source VSI.

Set correct ::src_vsi in rule_info to pass it to the hardware filter.

For example this rule should drop only ipv4 packets from eth10, not from
the others VF PRs. It is needed to check source VSI in this case.
$tc filter add dev eth10 ingress protocol ip flower skip_sw action drop

Fixes: 0d08a441fb1a ("ice: ndo_setup_tc implementation for PF")
Reviewed-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index b890410a2bc0b..49ed5fd7db107 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -28,6 +28,8 @@ ice_tc_count_lkups(u32 flags, struct ice_tc_flower_lyr_2_4_hdrs *headers,
 	 * - ICE_TC_FLWR_FIELD_VLAN_TPID (present if specified)
 	 * - Tunnel flag (present if tunnel)
 	 */
+	if (fltr->direction == ICE_ESWITCH_FLTR_EGRESS)
+		lkups_cnt++;
 
 	if (flags & ICE_TC_FLWR_FIELD_TENANT_ID)
 		lkups_cnt++;
@@ -363,6 +365,11 @@ ice_tc_fill_rules(struct ice_hw *hw, u32 flags,
 	/* Always add direction metadata */
 	ice_rule_add_direction_metadata(&list[ICE_TC_METADATA_LKUP_IDX]);
 
+	if (tc_fltr->direction == ICE_ESWITCH_FLTR_EGRESS) {
+		ice_rule_add_src_vsi_metadata(&list[i]);
+		i++;
+	}
+
 	rule_info->tun_type = ice_sw_type_from_tunnel(tc_fltr->tunnel_type);
 	if (tc_fltr->tunnel_type != TNL_LAST) {
 		i = ice_tc_fill_tunnel_outer(flags, tc_fltr, list, i);
@@ -820,6 +827,7 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 
 	/* specify the cookie as filter_rule_id */
 	rule_info.fltr_rule_id = fltr->cookie;
+	rule_info.src_vsi = vsi->idx;
 
 	ret = ice_add_adv_rule(hw, list, lkups_cnt, &rule_info, &rule_added);
 	if (ret == -EEXIST) {
-- 
2.43.0



