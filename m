Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2838171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51715C433D2;
	Mon, 22 May 2023 19:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784971;
	bh=8y8k5HKu2Gy7jCzPPpooktNEXUth/6pNtdpqHz3eh1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRRuPM0MNXRd96mTtAWeKn7VGndXMt+byZKtMmVw/Pi3ms/H8wNiIgUncLBB23CGb
	 rc10FpaefFCN20DhwW1kGJr7uAhcy8ll/l+XYS6nLQB08YQlLRH5/KNdfHMosU9x4j
	 vNIHuamEY/Zv+WBRcQkn5VZMzbx/34Evpv3Vl/94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 265/364] iavf: send VLAN offloading caps once after VFR
Date: Mon, 22 May 2023 20:09:30 +0100
Message-Id: <20230522190419.342641287@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ahmed Zaki <ahmed.zaki@intel.com>

[ Upstream commit 7dcbdf29282fbcdb646dc785e8a57ed2c2fec8ba ]

When the user disables rxvlan offloading and then changes the number of
channels, all VLAN ports are unable to receive traffic.

Changing the number of channels triggers a VFR reset. During re-init, when
VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS is received, we do:
1 - set the IAVF_FLAG_SETUP_NETDEV_FEATURES flag
2 - call
    iavf_set_vlan_offload_features(adapter, 0, netdev->features);

The second step sends to the PF the __default__ features, in this case
aq_required |= IAVF_FLAG_AQ_ENABLE_CTAG_VLAN_STRIPPING

While the first step forces the watchdog task to call
netdev_update_features() ->  iavf_set_features() ->
iavf_set_vlan_offload_features(adapter, netdev->features, features).
Since the user disabled the "rxvlan", this sets:
aq_required |= IAVF_FLAG_AQ_DISABLE_CTAG_VLAN_STRIPPING

When we start processing the AQ commands, both flags are enabled. Since we
process DISABLE_XTAG first then ENABLE_XTAG, this results in the PF
enabling the rxvlan offload. This breaks all communications on the VLAN
net devices.

Fix by removing the call to iavf_set_vlan_offload_features() (second
step). Calling netdev_update_features() from watchdog task is enough for
both init and reset paths.

Fixes: 7598f4b40bd6 ("iavf: Move netdev_update_features() into watchdog task")
Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 9afbbdac35903..7c0578b5457b9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2238,11 +2238,6 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		iavf_process_config(adapter);
 		adapter->flags |= IAVF_FLAG_SETUP_NETDEV_FEATURES;
 
-		/* Request VLAN offload settings */
-		if (VLAN_V2_ALLOWED(adapter))
-			iavf_set_vlan_offload_features(adapter, 0,
-						       netdev->features);
-
 		iavf_set_queue_vlan_tag_loc(adapter);
 
 		was_mac_changed = !ether_addr_equal(netdev->dev_addr,
-- 
2.39.2



