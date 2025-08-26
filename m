Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6969221290;
	Tue, 26 Aug 2025 13:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215564; cv=none; b=FvoNX/l+hfceh4cWe9Us/viF/Qa/+E1FM8vKHxwpxsoBBXR/pw3GlsmdlFVAD+xZKAoB23BQupyx64hMyMhIGHFhfjYAzMBgHGj13sGL9rzFSM9+nWHfqWFAKOpu8t4f8qMwq9KiaJ8Il3WnQQmu/GPyw10Y1hn34Wu85Kyxln8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215564; c=relaxed/simple;
	bh=sT2tWSy7QGcosys1+orhjy7aAIzbHanfkuuNJKuUyBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ca/ImsDcI0e2hUvbt7Rxd7CqdeBFixqsSXMZ/rUV+LoDqIRRKJaTzQaRfsEkUHI43r7eBnDN4E2aS8Hup6CLyKCZrKeUm9hlh3CzdBlQueAvoT9KerNTaqetROFYeD8m1e+HBp0acLwJr+BHyoJpJ3Djx2Xuy91L0N20/uO0IUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0UGZIlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0UGZIlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7657C4CEF1;
	Tue, 26 Aug 2025 13:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215564;
	bh=sT2tWSy7QGcosys1+orhjy7aAIzbHanfkuuNJKuUyBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0UGZIlNNMlS7IPHIirUuVf9+wlX9wrtGTB/vktvfd0MwLd3xAjCaO88RSfcR++rd
	 UX/o4JxyuMiaCCiyQiBDbukH270rAqM+TerYScVE5qrQLgRv9TrDx6PKK3xOZaw1n8
	 dItyZpcW8vuoPBbfDxhaOz+RNUS7sLXZqHSFidWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yajun Deng <yajun.deng@linux.dev>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH 5.15 081/644] i40e: Add rx_missed_errors for buffer exhaustion
Date: Tue, 26 Aug 2025 13:02:52 +0200
Message-ID: <20250826110948.506780446@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit 5337d294973331660e84e41836a54014de22e5b0 ]

As the comment in struct rtnl_link_stats64, rx_dropped should not
include packets dropped by the device due to buffer exhaustion.
They are counted in rx_missed_errors, procfs folds those two counters
together.

Add rx_missed_errors for buffer exhaustion, rx_missed_errors corresponds
to rx_discards, rx_dropped corresponds to rx_discards_other.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 50b2af451597 ("i40e: report VF tx_dropped with tx_errors instead of tx_discards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |  3 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c    | 18 +++++++-----------
 .../net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  2 +-
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index d0b9ee756b306..504edc8ec531c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -247,6 +247,7 @@ static const struct i40e_stats i40e_gstrings_net_stats[] = {
 	I40E_NETDEV_STAT(rx_errors),
 	I40E_NETDEV_STAT(tx_errors),
 	I40E_NETDEV_STAT(rx_dropped),
+	I40E_NETDEV_STAT(rx_missed_errors),
 	I40E_NETDEV_STAT(tx_dropped),
 	I40E_NETDEV_STAT(collisions),
 	I40E_NETDEV_STAT(rx_length_errors),
@@ -317,7 +318,7 @@ static const struct i40e_stats i40e_gstrings_stats[] = {
 	I40E_PF_STAT("port.rx_broadcast", stats.eth.rx_broadcast),
 	I40E_PF_STAT("port.tx_broadcast", stats.eth.tx_broadcast),
 	I40E_PF_STAT("port.tx_errors", stats.eth.tx_errors),
-	I40E_PF_STAT("port.rx_dropped", stats.eth.rx_discards),
+	I40E_PF_STAT("port.rx_discards", stats.eth.rx_discards),
 	I40E_PF_STAT("port.tx_dropped_link_down", stats.tx_dropped_link_down),
 	I40E_PF_STAT("port.rx_crc_errors", stats.crc_errors),
 	I40E_PF_STAT("port.illegal_bytes", stats.illegal_bytes),
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index bc5da0b8648c1..2a3b8dd72686d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -493,6 +493,7 @@ static void i40e_get_netdev_stats_struct(struct net_device *netdev,
 	stats->tx_dropped	= vsi_stats->tx_dropped;
 	stats->rx_errors	= vsi_stats->rx_errors;
 	stats->rx_dropped	= vsi_stats->rx_dropped;
+	stats->rx_missed_errors	= vsi_stats->rx_missed_errors;
 	stats->rx_crc_errors	= vsi_stats->rx_crc_errors;
 	stats->rx_length_errors	= vsi_stats->rx_length_errors;
 }
@@ -684,17 +685,13 @@ i40e_stats_update_rx_discards(struct i40e_vsi *vsi, struct i40e_hw *hw,
 			      struct i40e_eth_stats *stat_offset,
 			      struct i40e_eth_stats *stat)
 {
-	u64 rx_rdpc, rx_rxerr;
-
 	i40e_stat_update32(hw, I40E_GLV_RDPC(stat_idx), offset_loaded,
-			   &stat_offset->rx_discards, &rx_rdpc);
+			   &stat_offset->rx_discards, &stat->rx_discards);
 	i40e_stat_update64(hw,
 			   I40E_GL_RXERR1H(i40e_compute_pci_to_hw_id(vsi, hw)),
 			   I40E_GL_RXERR1L(i40e_compute_pci_to_hw_id(vsi, hw)),
 			   offset_loaded, &stat_offset->rx_discards_other,
-			   &rx_rxerr);
-
-	stat->rx_discards = rx_rdpc + rx_rxerr;
+			   &stat->rx_discards_other);
 }
 
 /**
@@ -716,9 +713,6 @@ void i40e_update_eth_stats(struct i40e_vsi *vsi)
 	i40e_stat_update32(hw, I40E_GLV_TEPC(stat_idx),
 			   vsi->stat_offsets_loaded,
 			   &oes->tx_errors, &es->tx_errors);
-	i40e_stat_update32(hw, I40E_GLV_RDPC(stat_idx),
-			   vsi->stat_offsets_loaded,
-			   &oes->rx_discards, &es->rx_discards);
 	i40e_stat_update32(hw, I40E_GLV_RUPP(stat_idx),
 			   vsi->stat_offsets_loaded,
 			   &oes->rx_unknown_protocol, &es->rx_unknown_protocol);
@@ -959,8 +953,10 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	ns->tx_errors = es->tx_errors;
 	ons->multicast = oes->rx_multicast;
 	ns->multicast = es->rx_multicast;
-	ons->rx_dropped = oes->rx_discards;
-	ns->rx_dropped = es->rx_discards;
+	ons->rx_dropped = oes->rx_discards_other;
+	ns->rx_dropped = es->rx_discards_other;
+	ons->rx_missed_errors = oes->rx_discards;
+	ns->rx_missed_errors = es->rx_discards;
 	ons->tx_dropped = oes->tx_discards;
 	ns->tx_dropped = es->tx_discards;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index d5b8462aa3eae..cc0c775d5d057 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -4879,7 +4879,7 @@ int i40e_get_vf_stats(struct net_device *netdev, int vf_id,
 	vf_stats->tx_bytes   = stats->tx_bytes;
 	vf_stats->broadcast  = stats->rx_broadcast;
 	vf_stats->multicast  = stats->rx_multicast;
-	vf_stats->rx_dropped = stats->rx_discards;
+	vf_stats->rx_dropped = stats->rx_discards + stats->rx_discards_other;
 	vf_stats->tx_dropped = stats->tx_discards;
 
 	return 0;
-- 
2.39.5



