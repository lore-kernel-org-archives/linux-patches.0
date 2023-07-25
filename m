Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE0A1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFCDC433CB;
	Tue, 25 Jul 2023 11:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283052;
	bh=NRcQl61gVXxNvBZ5MaiNnY6A13ZaPN67RPmvZE5nCj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cr8mhT+CTZQU8Ddhb6jGn99coq/iAqfHTXOFQitUio9BXni0jCL3hUf8g+LKxtD0d
	 5KJ6qcj6QogGKGPwGClEWMi5sL9CmHGhZrclVkrfrF+xxpnnpV1L9RYgP6YMQxljVc
	 FOYWzSK05k4B0ozHn1FNhZW6lIXTS9Dx0Hd1M54o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phani Burra <phani.r.burra@intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Marek Szlosek <marek.szlosek@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/183] iavf: Move netdev_update_features() into watchdog task
Date: Tue, 25 Jul 2023 12:45:49 +0200
Message-ID: <20230725104512.304160035@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit 7598f4b40bd60e4a4280de645eb2893eea80b59d ]

Remove netdev_update_features() from iavf_adminq_task(), as it can cause
deadlocks due to needing rtnl_lock. Instead use the
IAVF_FLAG_SETUP_NETDEV_FEATURES flag to indicate that netdev features need
to be updated in the watchdog task. iavf_set_vlan_offload_features()
and iavf_set_queue_vlan_tag_loc() can be called directly from
iavf_virtchnl_completion().

Suggested-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: c2ed2403f12c ("iavf: Wait for reset in callbacks which trigger it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 27 +++++++------------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  8 ++++++
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 104de9a071449..68e951fe5e210 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2689,6 +2689,15 @@ static void iavf_watchdog_task(struct work_struct *work)
 		goto restart_watchdog;
 	}
 
+	if ((adapter->flags & IAVF_FLAG_SETUP_NETDEV_FEATURES) &&
+	    adapter->netdev_registered &&
+	    !test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section) &&
+	    rtnl_trylock()) {
+		netdev_update_features(adapter->netdev);
+		rtnl_unlock();
+		adapter->flags &= ~IAVF_FLAG_SETUP_NETDEV_FEATURES;
+	}
+
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
 		iavf_change_state(adapter, __IAVF_COMM_FAILED);
 
@@ -3228,24 +3237,6 @@ static void iavf_adminq_task(struct work_struct *work)
 	} while (pending);
 	mutex_unlock(&adapter->crit_lock);
 
-	if ((adapter->flags & IAVF_FLAG_SETUP_NETDEV_FEATURES)) {
-		if (adapter->netdev_registered ||
-		    !test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section)) {
-			struct net_device *netdev = adapter->netdev;
-
-			rtnl_lock();
-			netdev_update_features(netdev);
-			rtnl_unlock();
-			/* Request VLAN offload settings */
-			if (VLAN_V2_ALLOWED(adapter))
-				iavf_set_vlan_offload_features
-					(adapter, 0, netdev->features);
-
-			iavf_set_queue_vlan_tag_loc(adapter);
-		}
-
-		adapter->flags &= ~IAVF_FLAG_SETUP_NETDEV_FEATURES;
-	}
 	if ((adapter->flags &
 	     (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED)) ||
 	    adapter->state == __IAVF_RESETTING)
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 00dccdd290dce..07d37402a0df5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2237,6 +2237,14 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 
 		iavf_process_config(adapter);
 		adapter->flags |= IAVF_FLAG_SETUP_NETDEV_FEATURES;
+
+		/* Request VLAN offload settings */
+		if (VLAN_V2_ALLOWED(adapter))
+			iavf_set_vlan_offload_features(adapter, 0,
+						       netdev->features);
+
+		iavf_set_queue_vlan_tag_loc(adapter);
+
 		was_mac_changed = !ether_addr_equal(netdev->dev_addr,
 						    adapter->hw.mac.addr);
 
-- 
2.39.2



