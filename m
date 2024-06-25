Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87FF13C90B;
	Tue, 25 Jun 2024 10:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309707; cv=none; b=IGcvsdlAd/HgyXvsj8W7+qODroaHJUiyQjRhZIbum/NU46TZTWZ4dr8ozJG5mI+M4jGz2f0vzxRoIvDA6qiRtZfXl6dGp7NaWECJWl3FG3KtpuPW3QW1zQ/NA1kZB8TQ6murl544q3SElg9391jWPNv3z2C8dl/Q/jJ3it8eFSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309707; c=relaxed/simple;
	bh=uNtTeTcHz5nrUAPkSvo+zmmlyrTZP1RqL+KDYKTjUfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQtrbJznHLH4Dn+zdY9laEQxNH6RFMys4bGbKO+EIxsxeklZ86agsilPEF1IQ0a61eQUfe0TGEIpRijsacUJduZksl9YMniEBq9qVUoQMIC58JaVbqSY5OabHMunwW5p1YdazSFPxucN6WxWD+El2PHZtT3rmGvgE4FlbK35++0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKomIxZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKomIxZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA67C32786;
	Tue, 25 Jun 2024 10:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309706;
	bh=uNtTeTcHz5nrUAPkSvo+zmmlyrTZP1RqL+KDYKTjUfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKomIxZECKhmekMTGHAZfiJhvS/PmEoB1ayHkUT3ys/qAuvyt02OLRT6iA1SVehJh
	 HVKGBnvKD7XNEI/L66qfmcsRYz2aF5zmao+CMSRYnPkAqlLpYQ0RgbSPaqn3T5YinW
	 1v2WQDNEkU/7ORHWrTycQ3SgzYkhXEE4wZst0c0w=
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
Subject: [PATCH 6.1 075/131] ice: Fix VSI list rule with ICE_SW_LKUP_LAST type
Date: Tue, 25 Jun 2024 11:33:50 +0200
Message-ID: <20240625085528.793216959@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5ea6365872571..735f995a3a687 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1838,7 +1838,8 @@ ice_aq_alloc_free_vsi_list(struct ice_hw *hw, u16 *vsi_list_id,
 	    lkup_type == ICE_SW_LKUP_ETHERTYPE_MAC ||
 	    lkup_type == ICE_SW_LKUP_PROMISC ||
 	    lkup_type == ICE_SW_LKUP_PROMISC_VLAN ||
-	    lkup_type == ICE_SW_LKUP_DFLT) {
+	    lkup_type == ICE_SW_LKUP_DFLT ||
+	    lkup_type == ICE_SW_LKUP_LAST) {
 		sw_buf->res_type = cpu_to_le16(ICE_AQC_RES_TYPE_VSI_LIST_REP);
 	} else if (lkup_type == ICE_SW_LKUP_VLAN) {
 		sw_buf->res_type =
@@ -2764,7 +2765,8 @@ ice_update_vsi_list_rule(struct ice_hw *hw, u16 *vsi_handle_arr, u16 num_vsi,
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



