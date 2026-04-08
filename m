Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7691C3D88E1;
	Wed,  8 Apr 2026 18:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671732; cv=none; b=QGamp8tb1Yi1+Az1uTcx04d43w1WR7RN4KzO/Dm7v1097IsGe5SvB+nnMVqUtSpnxOlLkenHFxCZQRMP5Uo2SszXs4nzU/3nZk0Qh00R9vQZmOxLWvBAkWZwU14peyB27EfhQ58ZKshMjH38g4H2M7CyosagV0WTc1NyvKMIpAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671732; c=relaxed/simple;
	bh=LuMiLukWfwOwVdb9H7ugnhlkOk+etmW+RMJNFW4U2vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnPCC1+AikWDjh+ZzBmvyedl5vIXvtZ98dgNbnG11WAok4KU/bqyy5mIhTI9iwnpgcEypUld6HhKVKa/J123vP09xIBQPxwWSTdv6dwjgUfKT9MiVUWj0W7f3202qSv1cGstUxrPHfQTv1W1frZjT62eGlKaiPgoQNNBa6O04mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0KsJGsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0KsJGsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C33EC19421;
	Wed,  8 Apr 2026 18:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671732;
	bh=LuMiLukWfwOwVdb9H7ugnhlkOk+etmW+RMJNFW4U2vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0KsJGsL2Lm9d+u/9oh1LXAVirpb5vLzYpanYd4FoSH+Bhz7SuzsHlqKS1yMpCAbi
	 2kfUMb/GbQYdspq+F74koEjWSqA7UAfGGM1hxY8syNwIWNnlRfaaj1FAfJcU97Zdz9
	 uQ8kNAq8NSgmS3C9iH+ZJAfLOaY50xWUOqAL2wdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Patryk Holda <patryk.holda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/312] ice: use ice_update_eth_stats() for representor stats
Date: Wed,  8 Apr 2026 19:59:22 +0200
Message-ID: <20260408175935.419064774@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Petr Oros <poros@redhat.com>

[ Upstream commit 2526e440df2725e7328d59b835a164826f179b93 ]

ice_repr_get_stats64() and __ice_get_ethtool_stats() call
ice_update_vsi_stats() on the VF's src_vsi. This always returns early
because ICE_VSI_DOWN is permanently set for VF VSIs - ice_up() is never
called on them since queues are managed by iavf through virtchnl.

In __ice_get_ethtool_stats() the original code called
ice_update_vsi_stats() for all VSIs including representors, iterated
over ice_gstrings_vsi_stats[] to populate the data, and then bailed out
with an early return before the per-queue ring stats section. That early
return was necessary because representor VSIs have no rings on the PF
side - the rings belong to the VF driver (iavf), so accessing per-queue
stats would be invalid.

Move the representor handling to the top of __ice_get_ethtool_stats()
and call ice_update_eth_stats() directly to read the hardware GLV_*
counters. This matches ice_get_vf_stats() which already uses
ice_update_eth_stats() for the same VF VSI in legacy mode. Apply the
same fix to ice_repr_get_stats64().

Note that ice_gstrings_vsi_stats[] contains five software ring counters
(rx_buf_failed, rx_page_failed, tx_linearize, tx_busy, tx_restart) that
are always zero for representors since the PF never processes packets on
VF rings. This is pre-existing behavior unchanged by this patch.

Fixes: 7aae80cef7ba ("ice: add port representor ethtool ops and stats")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Patryk Holda <patryk.holda@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 14 +++++++++++---
 drivers/net/ethernet/intel/ice/ice_repr.c    |  3 ++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index bcaa2f66dd825..49c524304a412 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1358,6 +1358,17 @@ __ice_get_ethtool_stats(struct net_device *netdev,
 	int i = 0;
 	char *p;
 
+	if (ice_is_port_repr_netdev(netdev)) {
+		ice_update_eth_stats(vsi);
+
+		for (j = 0; j < ICE_VSI_STATS_LEN; j++) {
+			p = (char *)vsi + ice_gstrings_vsi_stats[j].stat_offset;
+			data[i++] = (ice_gstrings_vsi_stats[j].sizeof_stat ==
+				     sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
+		}
+		return;
+	}
+
 	ice_update_pf_stats(pf);
 	ice_update_vsi_stats(vsi);
 
@@ -1367,9 +1378,6 @@ __ice_get_ethtool_stats(struct net_device *netdev,
 			     sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
 	}
 
-	if (ice_is_port_repr_netdev(netdev))
-		return;
-
 	/* populate per queue stats */
 	rcu_read_lock();
 
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index bd31748aae1b4..d442b386a664d 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2019-2021, Intel Corporation. */
 
 #include "ice.h"
+#include "ice_lib.h"
 #include "ice_eswitch.h"
 #include "ice_devlink.h"
 #include "ice_sriov.h"
@@ -56,7 +57,7 @@ ice_repr_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 		return;
 	vsi = np->repr->src_vsi;
 
-	ice_update_vsi_stats(vsi);
+	ice_update_eth_stats(vsi);
 	eth_stats = &vsi->eth_stats;
 
 	stats->tx_packets = eth_stats->tx_unicast + eth_stats->tx_broadcast +
-- 
2.51.0



