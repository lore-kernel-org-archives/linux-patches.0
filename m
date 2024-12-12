Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EC12EAE5;
	Thu, 12 Dec 2024 15:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015766; cv=none; b=sHPgg0/uudiCgM2fswJWKMYOIjxn39ohn+G5CIyXcnyo7MG/Tpn55lcgX8PZZ6sGaWLTjhOFpTsL1Mqzw8hu2QR3M3F2H+AnsJ3FuJiq4u8h35fHqFowLBErMGtSm3WLFjRCFWEwr0wMd40uIpE6vLZ+wRvc7ODrqSyp1tHeCA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015766; c=relaxed/simple;
	bh=KEHhE+lZbZ3xt7bJM60c1r5efS2cK+DG2L1/tb0cUI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bh9ZTtAPkGBCugBubLHP3O9brBhC4ZOHmkeN2cacjCCb3Z+BkT36heb7BQfatEFNqd9Df4OZXc3+dc8OGI2Yq2tUBWpsaZeNI8IIYLXxxPl/z+mm7JKUOMyou5vNjhmCfTpAEP4Trl0W83QDvduHpxKEyeliEbuasJALqxfjDvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hx7Re2Sh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hx7Re2Sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C11DC4CECE;
	Thu, 12 Dec 2024 15:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015766;
	bh=KEHhE+lZbZ3xt7bJM60c1r5efS2cK+DG2L1/tb0cUI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hx7Re2ShWunhzNQoG8s0VD/avMSADSW8xF1PJB7EznBoSvdjPkE/giNd8GgMXlT/f
	 dtTyWfJECIiOZQlHLeCM7BSeoGu/vI7rfea/UU3pM9w71jk8c5507QPZPWn525Bazp
	 5T/UpFUbCfepWSQgvG1s+seCzVon9vshCA5TLUSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Priya Singh <priyax.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/466] ice: Fix VLAN pruning in switchdev mode
Date: Thu, 12 Dec 2024 15:53:28 +0100
Message-ID: <20241212144308.231400635@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit 761e0be2888a931465e0d7bbeecce797f9c311a3 ]

In switchdev mode the uplink VSI should receive all unmatched packets,
including VLANs. Therefore, VLAN pruning should be disabled if uplink is
in switchdev mode. It is already being done in ice_eswitch_setup_env(),
however the addition of ice_up() in commit 44ba608db509 ("ice: do
switchdev slow-path Rx using PF VSI") caused VLAN pruning to be
re-enabled after disabling it.

Add a check to ice_set_vlan_filtering_features() to ensure VLAN
filtering will not be enabled if uplink is in switchdev mode. Note that
ice_is_eswitch_mode_switchdev() is being used instead of
ice_is_switchdev_running(), as the latter would only return true after
the whole switchdev setup completes.

Fixes: 44ba608db509 ("ice: do switchdev slow-path Rx using PF VSI")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Tested-by: Priya Singh <priyax.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b1e7727b8677f..8f2e758c39427 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6361,10 +6361,12 @@ ice_set_vlan_filtering_features(struct ice_vsi *vsi, netdev_features_t features)
 	int err = 0;
 
 	/* support Single VLAN Mode (SVM) and Double VLAN Mode (DVM) by checking
-	 * if either bit is set
+	 * if either bit is set. In switchdev mode Rx filtering should never be
+	 * enabled.
 	 */
-	if (features &
-	    (NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER))
+	if ((features &
+	     (NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER)) &&
+	     !ice_is_eswitch_mode_switchdev(vsi->back))
 		err = vlan_ops->ena_rx_filtering(vsi);
 	else
 		err = vlan_ops->dis_rx_filtering(vsi);
-- 
2.43.0



