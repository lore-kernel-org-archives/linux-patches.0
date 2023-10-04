Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D712618E2A
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58962C433C9;
	Wed,  4 Oct 2023 18:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443143;
	bh=0U+/VAF3MBUbpMY4iu4JpoR2p7HESTyVlht8D7WJVTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fxs5raLkdROtPvMqt78UeBu3tPF5cu/mhRxGKb2ysqK+WTs6Q8Dmm2MszePYWd/6p
	 uJtRR94pt1K+nX98EWE/OrzzIR/+TMhRmsD9m5nBaJJzYOoKjmDhWpNkU73OMPIwvs
	 NIyvSavWwH+D1ToNYMbejFP+whdirhwOwgfdPMXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/259] iavf: add iavf_schedule_aq_request() helper
Date: Wed,  4 Oct 2023 19:53:44 +0200
Message-ID: <20231004175219.774908562@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit ed4cad33df9e272feaa6698b33359b29c2929564 ]

Add helper for set iavf aq request AVF_FLAG_AQ_* and immediately
schedule watchdog_task. Helper will be used in cases where it is
necessary to run aq requests asap

Signed-off-by: Petr Oros <poros@redhat.com>
Co-developed-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Co-developed-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 5f3d319a2486 ("iavf: schedule a request immediately after add/delete vlan")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h         |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c    | 10 ++++------
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 543931c06bb17..06cfd567866c2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -521,7 +521,7 @@ void iavf_down(struct iavf_adapter *adapter);
 int iavf_process_config(struct iavf_adapter *adapter);
 int iavf_parse_vf_resource_msg(struct iavf_adapter *adapter);
 void iavf_schedule_reset(struct iavf_adapter *adapter, u64 flags);
-void iavf_schedule_request_stats(struct iavf_adapter *adapter);
+void iavf_schedule_aq_request(struct iavf_adapter *adapter, u64 flags);
 void iavf_schedule_finish_config(struct iavf_adapter *adapter);
 void iavf_reset(struct iavf_adapter *adapter);
 void iavf_set_ethtool_ops(struct net_device *netdev);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index fe912b1c468ef..c13b4fa659ee9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -362,7 +362,7 @@ static void iavf_get_ethtool_stats(struct net_device *netdev,
 	unsigned int i;
 
 	/* Explicitly request stats refresh */
-	iavf_schedule_request_stats(adapter);
+	iavf_schedule_aq_request(adapter, IAVF_FLAG_AQ_REQUEST_STATS);
 
 	iavf_add_ethtool_stats(&data, adapter, iavf_gstrings_stats);
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index a02e8d6a4d1d6..ee04670b77b33 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -322,15 +322,13 @@ void iavf_schedule_reset(struct iavf_adapter *adapter, u64 flags)
 }
 
 /**
- * iavf_schedule_request_stats - Set the flags and schedule statistics request
+ * iavf_schedule_aq_request - Set the flags and schedule aq request
  * @adapter: board private structure
- *
- * Sets IAVF_FLAG_AQ_REQUEST_STATS flag so iavf_watchdog_task() will explicitly
- * request and refresh ethtool stats
+ * @flags: requested aq flags
  **/
-void iavf_schedule_request_stats(struct iavf_adapter *adapter)
+void iavf_schedule_aq_request(struct iavf_adapter *adapter, u64 flags)
 {
-	adapter->aq_required |= IAVF_FLAG_AQ_REQUEST_STATS;
+	adapter->aq_required |= flags;
 	mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
 }
 
-- 
2.40.1



