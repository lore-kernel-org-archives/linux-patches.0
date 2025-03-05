Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6963023027C;
	Wed,  5 Mar 2025 18:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198507; cv=none; b=jNXADcFwcdn0c5hjq3zR3rnzHeBx86YtwVsOp/qNtOKWTib3+3HKsUgwfTlYitoKNWUxLbybVCjAmH1xNRtpYyjuCZzhqoqVAVg2xv0hlzOsOGrkuT1eRRh+/Rm1C8dAy+9SJmUZ9rznQEx8t0//snpBJk4h5fPvo8N0BHnlSGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198507; c=relaxed/simple;
	bh=/rLTHxvUwjzRnke9yL2ezyoJbMNjal7vG8DHHBcD99E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beW6gZOQq09ujsW148kHSE0JlTak6j322XZFLi5oC0jv3jhE7FFLxWjm7oVOGN9KkGkUxQcSYhW11CvpyWWwubxpAQa1e2wDSrl73FF6JCE8eDl8uTPK+WVh5At6yCuLcePzTX6T6WY+t376jz8jMHhDR+fLL6d/KLnf9H7yVUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vyGCbl9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyGCbl9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4467C4CED1;
	Wed,  5 Mar 2025 18:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198507;
	bh=/rLTHxvUwjzRnke9yL2ezyoJbMNjal7vG8DHHBcD99E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyGCbl9eYsgwHoEmmojR4wPkN4LHQRdP7uxJFLUoss3XXw9sSuicyzgnz6Uv6rgtD
	 U6fbR5Rso2GfqHidvrUEu7qhOF1S9zNlLnwJT/+jywv3ql3Ag5Y6LUOGVBxMvUVnWH
	 e3Nb1/TnnhBlaFevdyG0W0HHmnBkrsDdAsDaY57k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 050/157] ice: Avoid setting default Rx VSI twice in switchdev setup
Date: Wed,  5 Mar 2025 18:48:06 +0100
Message-ID: <20250305174507.319456693@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit 5c07be96d8b3f8447e980f29b967bf2e1d7ac732 ]

As part of switchdev environment setup, uplink VSI is configured as
default for both Tx and Rx. Default Rx VSI is also used by promiscuous
mode. If promisc mode is enabled and an attempt to enter switchdev mode
is made, the setup will fail because Rx VSI is already configured as
default (rule exists).

Reproducer:
  devlink dev eswitch set $PF1_PCI mode switchdev
  ip l s $PF1 up
  ip l s $PF1 promisc on
  echo 1 > /sys/class/net/$PF1/device/sriov_numvfs

In switchdev setup, use ice_set_dflt_vsi() instead of plain
ice_cfg_dflt_vsi(), which avoids repeating setting default VSI for Rx if
it's already configured.

Fixes: 50d62022f455 ("ice: default Tx rule instead of to queue")
Reported-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Closes: https://lore.kernel.org/intel-wired-lan/PH0PR11MB50138B635F2E5CEB7075325D961F2@PH0PR11MB5013.namprd11.prod.outlook.com
Reviewed-by: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20250224190647.3601930-3-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index fb527434b58b1..d649c197cf673 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -38,8 +38,7 @@ static int ice_eswitch_setup_env(struct ice_pf *pf)
 	if (ice_vsi_add_vlan_zero(uplink_vsi))
 		goto err_vlan_zero;
 
-	if (ice_cfg_dflt_vsi(uplink_vsi->port_info, uplink_vsi->idx, true,
-			     ICE_FLTR_RX))
+	if (ice_set_dflt_vsi(uplink_vsi))
 		goto err_def_rx;
 
 	if (ice_cfg_dflt_vsi(uplink_vsi->port_info, uplink_vsi->idx, true,
-- 
2.39.5



