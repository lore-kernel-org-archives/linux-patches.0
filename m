Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031B83839B2;
	Sat, 17 Oct 2026 17:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257988; cv=none; b=oGK/O9u6wgXvuLact/IKfUBsaPjatuKYGkaTLnrvJIU84hVENI4MawW6I8t5BAGc5dbakUw33hjICYcCIrzEB5lhJssLo96GaNpwLTs6BG5bU1EYEbzqtNASGzmyhH9/a6n0BGki9XXilVfAxBmuvyjqGi8HZRCn7CBNNYarmIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257988; c=relaxed/simple;
	bh=oEdyfMGfB760AINLyXyUrCoPK725SKlD4eihLjM6XXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPzMLybx4fuZnCcyb0J3rbJ1uQyau+UnFe204CGOyBgWivjnx8nPzvcV54CIbF3sLr85i55n8iLEWwOGtJHsyraATqF2wIYpAg+Se2EfvIP1EEw1vJAyYMOR1HpVN6WVvi1XTZpCqLe5MHJPYBicLNIztbUmmHkqOFcz1PP2yR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BYBvWLzh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BYBvWLzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502881F000C4;
	Sat, 17 Oct 2026 17:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257986;
	bh=3lQFht/mQXlDuYjC1/ptTJYrgpiZaCiTwbKtJP+AK5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BYBvWLzh+k7DgldYhDpgk/0we9quxUQn5OW+FQu9XAQFEth+Bc5DMrTJnc4styCvr
	 zO6kqooAnd0WLnBkC0WqVbT1k/wD7gCZ8IGSQEmlgFwFCHOgYcB75ADWdiaBrXyC/g
	 nvJndfojlptD3Qv5P5KMgxHRqmt74KxviJCfz55Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0734/1674] sfc: fix NULL dereferences in ef100_process_design_param()
Date: Sat, 17 Oct 2026 17:50:06 +0200
Message-ID: <20261017160449.943469521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Edward Cree <ecree.xilinx@gmail.com>

[ Upstream commit 8241ecec1cdc6699ae197d52d58e76bddd995fa5 ]

Since cited commit, ef100_probe_main() and hence also
 ef100_check_design_params() run before efx->net_dev is created;
 consequently, we cannot netif_set_tso_max_size() or _segs() at this
 point.
Move those netif calls to ef100_probe_netdev(), and also replace
 netif_err within the design params code with pci_err.

Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Fixes: 98ff4c7c8ac7 ("sfc: Separate netdev probe/remove from PCI probe/remove")
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250401225439.2401047-1-edward.cree@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef100_netdev.c |  6 ++--
 drivers/net/ethernet/sfc/ef100_nic.c    | 47 +++++++++++--------------
 2 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index d941f073f1ebf..3a06e3b1bd6bf 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -450,8 +450,9 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	net_dev->hw_enc_features |= efx->type->offload_features;
 	net_dev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_SG |
 				  NETIF_F_HIGHDMA | NETIF_F_ALL_TSO;
-	netif_set_tso_max_segs(net_dev,
-			       ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT);
+	nic_data = efx->nic_data;
+	netif_set_tso_max_size(efx->net_dev, nic_data->tso_max_payload_len);
+	netif_set_tso_max_segs(efx->net_dev, nic_data->tso_max_payload_num_segs);
 
 	rc = efx_ef100_init_datapath_caps(efx);
 	if (rc < 0)
@@ -477,7 +478,6 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	/* Don't fail init if RSS setup doesn't work. */
 	efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
 
-	nic_data = efx->nic_data;
 	rc = ef100_get_mac_address(efx, net_dev->perm_addr, CLIENT_HANDLE_SELF,
 				   efx->type->is_vf);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 6da06931187d6..5b1bdcac81d99 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -887,8 +887,7 @@ static int ef100_process_design_param(struct efx_nic *efx,
 	case ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS:
 		/* We always put HDR_NUM_SEGS=1 in our TSO descriptors */
 		if (!reader->value) {
-			netif_err(efx, probe, efx->net_dev,
-				  "TSO_MAX_HDR_NUM_SEGS < 1\n");
+			pci_err(efx->pci_dev, "TSO_MAX_HDR_NUM_SEGS < 1\n");
 			return -EOPNOTSUPP;
 		}
 		return 0;
@@ -901,32 +900,28 @@ static int ef100_process_design_param(struct efx_nic *efx,
 		 */
 		if (!reader->value || reader->value > EFX_MIN_DMAQ_SIZE ||
 		    EFX_MIN_DMAQ_SIZE % (u32)reader->value) {
-			netif_err(efx, probe, efx->net_dev,
-				  "%s size granularity is %llu, can't guarantee safety\n",
-				  reader->type == ESE_EF100_DP_GZ_RXQ_SIZE_GRANULARITY ? "RXQ" : "TXQ",
-				  reader->value);
+			pci_err(efx->pci_dev,
+				"%s size granularity is %llu, can't guarantee safety\n",
+				reader->type == ESE_EF100_DP_GZ_RXQ_SIZE_GRANULARITY ? "RXQ" : "TXQ",
+				reader->value);
 			return -EOPNOTSUPP;
 		}
 		return 0;
 	case ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_LEN:
 		nic_data->tso_max_payload_len = min_t(u64, reader->value,
 						      GSO_LEGACY_MAX_SIZE);
-		netif_set_tso_max_size(efx->net_dev,
-				       nic_data->tso_max_payload_len);
 		return 0;
 	case ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_NUM_SEGS:
 		nic_data->tso_max_payload_num_segs = min_t(u64, reader->value, 0xffff);
-		netif_set_tso_max_segs(efx->net_dev,
-				       nic_data->tso_max_payload_num_segs);
 		return 0;
 	case ESE_EF100_DP_GZ_TSO_MAX_NUM_FRAMES:
 		nic_data->tso_max_frames = min_t(u64, reader->value, 0xffff);
 		return 0;
 	case ESE_EF100_DP_GZ_COMPAT:
 		if (reader->value) {
-			netif_err(efx, probe, efx->net_dev,
-				  "DP_COMPAT has unknown bits %#llx, driver not compatible with this hw\n",
-				  reader->value);
+			pci_err(efx->pci_dev,
+				"DP_COMPAT has unknown bits %#llx, driver not compatible with this hw\n",
+				reader->value);
 			return -EOPNOTSUPP;
 		}
 		return 0;
@@ -946,10 +941,10 @@ static int ef100_process_design_param(struct efx_nic *efx,
 		 * So the value of this shouldn't matter.
 		 */
 		if (reader->value != ESE_EF100_DP_GZ_VI_STRIDES_DEFAULT)
-			netif_dbg(efx, probe, efx->net_dev,
-				  "NIC has other than default VI_STRIDES (mask "
-				  "%#llx), early probing might use wrong one\n",
-				  reader->value);
+			pci_dbg(efx->pci_dev,
+				"NIC has other than default VI_STRIDES (mask "
+				"%#llx), early probing might use wrong one\n",
+				reader->value);
 		return 0;
 	case ESE_EF100_DP_GZ_RX_MAX_RUNT:
 		/* Driver doesn't look at L2_STATUS:LEN_ERR bit, so we don't
@@ -961,9 +956,9 @@ static int ef100_process_design_param(struct efx_nic *efx,
 		/* Host interface says "Drivers should ignore design parameters
 		 * that they do not recognise."
 		 */
-		netif_dbg(efx, probe, efx->net_dev,
-			  "Ignoring unrecognised design parameter %u\n",
-			  reader->type);
+		pci_dbg(efx->pci_dev,
+			"Ignoring unrecognised design parameter %u\n",
+			reader->type);
 		return 0;
 	}
 }
@@ -999,13 +994,13 @@ static int ef100_check_design_params(struct efx_nic *efx)
 	 */
 	if (reader.state != EF100_TLV_TYPE) {
 		if (reader.state == EF100_TLV_TYPE_CONT)
-			netif_err(efx, probe, efx->net_dev,
-				  "truncated design parameter (incomplete type %u)\n",
-				  reader.type);
+			pci_err(efx->pci_dev,
+				"truncated design parameter (incomplete type %u)\n",
+				reader.type);
 		else
-			netif_err(efx, probe, efx->net_dev,
-				  "truncated design parameter %u\n",
-				  reader.type);
+			pci_err(efx->pci_dev,
+				"truncated design parameter %u\n",
+				reader.type);
 		rc = -EIO;
 	}
 out:
-- 
2.53.0



