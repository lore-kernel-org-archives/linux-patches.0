Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0596D3E3C40;
	Tue, 31 Mar 2026 16:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974977; cv=none; b=FfoicIDqEPUV0NrrteZeyT7lH5Y5jr0w+Hhzpm3NAhJkZHpGHLLPv4HIIsC1n55eoM4kJogjam99Kl+nsz+FsosO8Buk4KRkFuthf2x9vsS+9KcfZ4mjxLzBwQHXAgGp6LLei02g1X4wyzGZSee40Z1nboz+fcAXtQAjgjWgW3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974977; c=relaxed/simple;
	bh=/NyQi87fLxD8vEY9o1zW5rMsaZrLbzOpd3li9A3sZp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wl/oiI0NhCYnoWCBx/BA+3lg3JF0Fd7M+RrA2/BCeYsWCPZmaaoiRfEZKZ+Rk3FwnVi2RymbQ9BtSkyTFdxW6QrYmzpshdY9etZLitiFy4FpL7oqnVen228LLvFdbKIJgYW8wb2xi5/7h1o3a1cWiqSUNhpnbYrWiP9ttgRRnCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAsqbGN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAsqbGN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8822FC19423;
	Tue, 31 Mar 2026 16:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974976;
	bh=/NyQi87fLxD8vEY9o1zW5rMsaZrLbzOpd3li9A3sZp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAsqbGN0wn0x2srO8HSO7nPASorYp/vVg7TeAbneED7UoOdyHXexVlQqoFIbqmeXY
	 QQF45K7GOzlLnMoaNC19gooxMzXSXZqHX3MilbdUlIX7wh8/5VfqqMqOkoJu8j39X4
	 nvXAQgdDJ5eaPYuKpbGJ7tNjMCpoBEdTNBgy9qLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Patryk Holda <patryk.holda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 116/342] ice: use ice_update_eth_stats() for representor stats
Date: Tue, 31 Mar 2026 18:19:09 +0200
Message-ID: <20260331161803.279311889@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index fa4c7ae9ff6b1..3125dc1b27654 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1930,6 +1930,17 @@ __ice_get_ethtool_stats(struct net_device *netdev,
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
 
@@ -1939,9 +1950,6 @@ __ice_get_ethtool_stats(struct net_device *netdev,
 			     sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
 	}
 
-	if (ice_is_port_repr_netdev(netdev))
-		return;
-
 	/* populate per queue stats */
 	rcu_read_lock();
 
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index 2a84f65640582..f1e82ba155cff 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2019-2021, Intel Corporation. */
 
 #include "ice.h"
+#include "ice_lib.h"
 #include "ice_eswitch.h"
 #include "devlink/devlink.h"
 #include "devlink/port.h"
@@ -67,7 +68,7 @@ ice_repr_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 		return;
 	vsi = repr->src_vsi;
 
-	ice_update_vsi_stats(vsi);
+	ice_update_eth_stats(vsi);
 	eth_stats = &vsi->eth_stats;
 
 	stats->tx_packets = eth_stats->tx_unicast + eth_stats->tx_broadcast +
-- 
2.51.0



