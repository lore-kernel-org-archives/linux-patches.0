Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3E937898;
	Mon, 18 Dec 2023 14:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuldTJgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30011C433C8;
	Mon, 18 Dec 2023 14:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908062;
	bh=stjxwB6NO3mmof5+Nq4aNRdfVZtVuom+VHP2CMgBJjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuldTJguPT4rMRyF7Md18yrmrMNTLipkagxIFftZhLQ1oFs3dEACg6LV3B3eEjtW6
	 89eMNMYGuWSs+wRZbeb99bp+lE85E1DZynk3WtHhjJDN4n/Biyfq3eTWg3nVR73ozB
	 0nnL5jCs+UFv0b4UXsvNON0gqyqGSxsKG2OOX/Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Gardocki <piotrx.gardocki@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Ranganatha Rao <ranganatha.rao@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/166] iavf: Handle ntuple on/off based on new state machines for flow director
Date: Mon, 18 Dec 2023 14:50:06 +0100
Message-ID: <20231218135106.786019459@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Gardocki <piotrx.gardocki@intel.com>

[ Upstream commit 09d23b8918f9ab0f8114f6b94f2faf8bde3fb52a ]

ntuple-filter feature on/off:
Default is on. If turned off, the filters will be removed from both
PF and iavf list. The removal is irrespective of current filter state.

Steps to reproduce:
-------------------

1. Ensure ntuple is on.

ethtool -K enp8s0 ntuple-filters on

2. Create a filter to receive the traffic into non-default rx-queue like 15
and ensure traffic is flowing into queue into 15.
Now, turn off ntuple. Traffic should not flow to configured queue 15.
It should flow to default RX queue.

Fixes: 0dbfbabb840d ("iavf: Add framework to enable ethtool ntuple filters")
Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Ranganatha Rao <ranganatha.rao@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 59 +++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 5158addc0aa96..af8eb27a3615c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4409,6 +4409,49 @@ static int iavf_change_mtu(struct net_device *netdev, int new_mtu)
 	return ret;
 }
 
+/**
+ * iavf_disable_fdir - disable Flow Director and clear existing filters
+ * @adapter: board private structure
+ **/
+static void iavf_disable_fdir(struct iavf_adapter *adapter)
+{
+	struct iavf_fdir_fltr *fdir, *fdirtmp;
+	bool del_filters = false;
+
+	adapter->flags &= ~IAVF_FLAG_FDIR_ENABLED;
+
+	/* remove all Flow Director filters */
+	spin_lock_bh(&adapter->fdir_fltr_lock);
+	list_for_each_entry_safe(fdir, fdirtmp, &adapter->fdir_list_head,
+				 list) {
+		if (fdir->state == IAVF_FDIR_FLTR_ADD_REQUEST ||
+		    fdir->state == IAVF_FDIR_FLTR_INACTIVE) {
+			/* Delete filters not registered in PF */
+			list_del(&fdir->list);
+			kfree(fdir);
+			adapter->fdir_active_fltr--;
+		} else if (fdir->state == IAVF_FDIR_FLTR_ADD_PENDING ||
+			   fdir->state == IAVF_FDIR_FLTR_DIS_REQUEST ||
+			   fdir->state == IAVF_FDIR_FLTR_ACTIVE) {
+			/* Filters registered in PF, schedule their deletion */
+			fdir->state = IAVF_FDIR_FLTR_DEL_REQUEST;
+			del_filters = true;
+		} else if (fdir->state == IAVF_FDIR_FLTR_DIS_PENDING) {
+			/* Request to delete filter already sent to PF, change
+			 * state to DEL_PENDING to delete filter after PF's
+			 * response, not set as INACTIVE
+			 */
+			fdir->state = IAVF_FDIR_FLTR_DEL_PENDING;
+		}
+	}
+	spin_unlock_bh(&adapter->fdir_fltr_lock);
+
+	if (del_filters) {
+		adapter->aq_required |= IAVF_FLAG_AQ_DEL_FDIR_FILTER;
+		mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
+	}
+}
+
 #define NETIF_VLAN_OFFLOAD_FEATURES	(NETIF_F_HW_VLAN_CTAG_RX | \
 					 NETIF_F_HW_VLAN_CTAG_TX | \
 					 NETIF_F_HW_VLAN_STAG_RX | \
@@ -4431,6 +4474,13 @@ static int iavf_set_features(struct net_device *netdev,
 		iavf_set_vlan_offload_features(adapter, netdev->features,
 					       features);
 
+	if ((netdev->features & NETIF_F_NTUPLE) ^ (features & NETIF_F_NTUPLE)) {
+		if (features & NETIF_F_NTUPLE)
+			adapter->flags |= IAVF_FLAG_FDIR_ENABLED;
+		else
+			iavf_disable_fdir(adapter);
+	}
+
 	return 0;
 }
 
@@ -4726,6 +4776,9 @@ static netdev_features_t iavf_fix_features(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
+	if (!FDIR_FLTR_SUPPORT(adapter))
+		features &= ~NETIF_F_NTUPLE;
+
 	return iavf_fix_netdev_vlan_features(adapter, features);
 }
 
@@ -4843,6 +4896,12 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN)
 		netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 
+	if (FDIR_FLTR_SUPPORT(adapter)) {
+		netdev->hw_features |= NETIF_F_NTUPLE;
+		netdev->features |= NETIF_F_NTUPLE;
+		adapter->flags |= IAVF_FLAG_FDIR_ENABLED;
+	}
+
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* Do not turn on offloads when they are requested to be turned off.
-- 
2.43.0



