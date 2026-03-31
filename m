Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA35421A1D;
	Tue, 31 Mar 2026 16:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974351; cv=none; b=rZSSJ6yrAQ6ozFLYdQo/7MOYfAY/H4G8sZQOl5B0nBywuORryN0qn93yuclGugymSFZzBV6DthxBXW537bgYytLskzf7adGOYkU/uN12xkM7pFRY73cQuBRHYmFwfKBCuiDeeoC7MXne650QIuwu2QPGJMVhOhNDR0OKgoQPxRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974351; c=relaxed/simple;
	bh=KVwCAIan2hkPzQNjHen7mTTFdn1zhvrLNKMpWer6X4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzbjmMP/lIiHJuel2mcztOF9Cd2YDQjH9hphu/SB0oxYdBA9r12XKMl2+PAwsrYOhha9d8j+LqTPz65kEDj7xEIdDVEGtVcoD0jH9j15+Iv/6JTmgOWocIa3Pay665vPVQw3yT2B0Z+z+L9uCStpzJhoNhkVlgrrFltdLgXa8+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msx+adWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msx+adWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37B6C19423;
	Tue, 31 Mar 2026 16:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974351;
	bh=KVwCAIan2hkPzQNjHen7mTTFdn1zhvrLNKMpWer6X4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msx+adWKgXREDg95lfyEL/4obk2RlwLLeb0Xj3RWKXwGfzd9TOGwel+um+WiUv92k
	 Lyr94WEa7J+gwyx+M7/qQZjp59OlCxGCXDjOocjrSNHR3lSNvkt2X9D5NnsArJfuqA
	 NJys/k27SuuPIYavQalEu5KxUZVOeJ+IJLgAiay0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Patryk Holda <patryk.holda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/175] ice: use ice_update_eth_stats() for representor stats
Date: Tue, 31 Mar 2026 18:20:36 +0200
Message-ID: <20260331161731.697015678@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1c91f1ba11889..448ca855df901 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1528,6 +1528,17 @@ __ice_get_ethtool_stats(struct net_device *netdev,
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
 
@@ -1537,9 +1548,6 @@ __ice_get_ethtool_stats(struct net_device *netdev,
 			     sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
 	}
 
-	if (ice_is_port_repr_netdev(netdev))
-		return;
-
 	/* populate per queue stats */
 	rcu_read_lock();
 
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index c686ac0935ebe..23c243d544462 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2019-2021, Intel Corporation. */
 
 #include "ice.h"
+#include "ice_lib.h"
 #include "ice_eswitch.h"
 #include "ice_devlink.h"
 #include "ice_sriov.h"
@@ -57,7 +58,7 @@ ice_repr_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 		return;
 	vsi = np->repr->src_vsi;
 
-	ice_update_vsi_stats(vsi);
+	ice_update_eth_stats(vsi);
 	eth_stats = &vsi->eth_stats;
 
 	stats->tx_packets = eth_stats->tx_unicast + eth_stats->tx_broadcast +
-- 
2.51.0



