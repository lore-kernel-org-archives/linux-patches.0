Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA2F15484
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rd34gTEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6207C433C7;
	Mon, 23 Oct 2023 11:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059987;
	bh=Pw+i/hax5RXYbY6WuvClTHoUNIvBWK22VeYkE0gSLgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rd34gTEZesTHfpfb60sjsLRdxOjaKrkwi/20OuhnkB8P1y4eCVQQGT153DsJkBQq4
	 E/xo/AQaH/qPo6AroLIa8Ar4CI/DkOzNEibYJ74JGa1IbVPZPJbt4HcxLEZ780rHMV
	 KfbzEzOlAJA2yyNHbpPDFWorEPMZH6imFiRKptiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.1 004/196] igc: Remove reset adapter task for i226 during disable tsn config
Date: Mon, 23 Oct 2023 12:54:29 +0200
Message-ID: <20231023104828.614150817@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

commit 1d1b4c63ba739c6ca695cb2ea13fefa9dfbff60d upstream.

I225 have limitation when programming the BaseTime register which required
a power cycle of the controller. This limitation already lifted in I226.
This patch removes the restriction so that when user configure/remove any
TSN mode, it would not go into power cycle reset adapter.

How to test:

Schedule any gate control list configuration or delete it.

Example:

1)

BASE_TIME=$(date +%s%N)
tc qdisc replace dev $interface_name parent root handle 100 taprio \
    num_tc 4 \
    map 3 1 0 2 3 3 3 3 3 3 3 3 3 3 3 3 \
    queues 1@0 1@1 1@2 1@3 \
    base-time $BASE_TIME \
    sched-entry S 0F 1000000 \
    flags 0x2

2) tc qdisc del dev $intername_name root

Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c |    6 +++---
 drivers/net/ethernet/intel/igc/igc_tsn.c  |   11 +++--------
 drivers/net/ethernet/intel/igc/igc_tsn.h  |    2 +-
 3 files changed, 7 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6097,7 +6097,7 @@ static int igc_tsn_enable_launchtime(str
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter, qopt->enable);
+	return igc_tsn_offload_apply(adapter);
 }
 
 static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
@@ -6211,7 +6211,7 @@ static int igc_tsn_enable_qbv_scheduling
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter, qopt->enable);
+	return igc_tsn_offload_apply(adapter);
 }
 
 static int igc_save_cbs_params(struct igc_adapter *adapter, int queue,
@@ -6279,7 +6279,7 @@ static int igc_tsn_enable_cbs(struct igc
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter, qopt->enable);
+	return igc_tsn_offload_apply(adapter);
 }
 
 static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -259,21 +259,16 @@ int igc_tsn_reset(struct igc_adapter *ad
 	return err;
 }
 
-int igc_tsn_offload_apply(struct igc_adapter *adapter, bool enable)
+int igc_tsn_offload_apply(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
-	int err;
 
-	if (netif_running(adapter->netdev) &&
-	    (igc_is_device_id_i225(hw) || !enable)) {
+	if (netif_running(adapter->netdev) && igc_is_device_id_i225(hw)) {
 		schedule_work(&adapter->reset_task);
 		return 0;
 	}
 
-	err = igc_tsn_enable_offload(adapter);
-	if (err < 0)
-		return err;
+	igc_tsn_reset(adapter);
 
-	adapter->flags = igc_tsn_new_flags(adapter);
 	return 0;
 }
--- a/drivers/net/ethernet/intel/igc/igc_tsn.h
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.h
@@ -4,7 +4,7 @@
 #ifndef _IGC_TSN_H_
 #define _IGC_TSN_H_
 
-int igc_tsn_offload_apply(struct igc_adapter *adapter, bool enable);
+int igc_tsn_offload_apply(struct igc_adapter *adapter);
 int igc_tsn_reset(struct igc_adapter *adapter);
 
 #endif /* _IGC_BASE_H */


