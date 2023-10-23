Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7245A15484
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OsaHBpWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E716AC433C7;
	Mon, 23 Oct 2023 11:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059984;
	bh=+lfd1ASHF/agqTrZ31RpNn4I3Ffj8F5m/xh8JT24yzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OsaHBpWFwd7W87i4MEU54Lcd8Tk8NqXJlQLwREP9k7ek11Fd1Zq+rW9bC9hhE81sq
	 m/4NcxpQOhTZVmSpwfln5eSdADARuHlw+vbcml9rkCH2SfeZ8+tb3M7Kni6a25+fb/
	 R6YvPV6R9+BoaBbsEHrWZOUHxL4PKX624D98l2ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tan Tee Min <tee.min.tan@linux.intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.1 003/196] igc: enable Qbv configuration for 2nd GCL
Date: Mon, 23 Oct 2023 12:54:28 +0200
Message-ID: <20231023104828.586508815@linuxfoundation.org>
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

From: Tan Tee Min <tee.min.tan@linux.intel.com>

commit 5ac1231ac14d1b8a1098048e51cad45f11b85c0a upstream.

Make reset task only executes for i225 and Qbv disabling to allow
i226 configure for 2nd GCL without resetting the adapter.

In i226, Tx won't hang if there is a GCL is already running, so in
this case we don't need to set FutScdDis bit.

Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c |    9 +++++----
 drivers/net/ethernet/intel/igc/igc_tsn.c  |   13 +++++++++----
 drivers/net/ethernet/intel/igc/igc_tsn.h  |    2 +-
 3 files changed, 15 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6097,7 +6097,7 @@ static int igc_tsn_enable_launchtime(str
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter);
+	return igc_tsn_offload_apply(adapter, qopt->enable);
 }
 
 static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
@@ -6121,6 +6121,7 @@ static int igc_save_qbv_schedule(struct
 				 struct tc_taprio_qopt_offload *qopt)
 {
 	bool queue_configured[IGC_MAX_TX_QUEUES] = { };
+	struct igc_hw *hw = &adapter->hw;
 	u32 start_time = 0, end_time = 0;
 	size_t n;
 	int i;
@@ -6133,7 +6134,7 @@ static int igc_save_qbv_schedule(struct
 	if (qopt->base_time < 0)
 		return -ERANGE;
 
-	if (adapter->base_time)
+	if (igc_is_device_id_i225(hw) && adapter->base_time)
 		return -EALREADY;
 
 	if (!validate_schedule(adapter, qopt))
@@ -6210,7 +6211,7 @@ static int igc_tsn_enable_qbv_scheduling
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter);
+	return igc_tsn_offload_apply(adapter, qopt->enable);
 }
 
 static int igc_save_cbs_params(struct igc_adapter *adapter, int queue,
@@ -6278,7 +6279,7 @@ static int igc_tsn_enable_cbs(struct igc
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter);
+	return igc_tsn_offload_apply(adapter, qopt->enable);
 }
 
 static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -195,7 +195,7 @@ skip_cbs:
 		wr32(IGC_TXQCTL(i), txqctl);
 	}
 
-	tqavctrl = rd32(IGC_TQAVCTRL);
+	tqavctrl = rd32(IGC_TQAVCTRL) & ~IGC_TQAVCTRL_FUTSCDDIS;
 	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
 
 	cycle = adapter->cycle_time;
@@ -212,8 +212,11 @@ skip_cbs:
 	} else {
 		/* According to datasheet section 7.5.2.9.3.3, FutScdDis bit
 		 * has to be configured before the cycle time and base time.
+		 * Tx won't hang if there is a GCL is already running,
+		 * so in this case we don't need to set FutScdDis.
 		 */
-		if (igc_is_device_id_i226(hw))
+		if (igc_is_device_id_i226(hw) &&
+		    !(rd32(IGC_BASET_H) || rd32(IGC_BASET_L)))
 			tqavctrl |= IGC_TQAVCTRL_FUTSCDDIS;
 	}
 
@@ -256,11 +259,13 @@ int igc_tsn_reset(struct igc_adapter *ad
 	return err;
 }
 
-int igc_tsn_offload_apply(struct igc_adapter *adapter)
+int igc_tsn_offload_apply(struct igc_adapter *adapter, bool enable)
 {
+	struct igc_hw *hw = &adapter->hw;
 	int err;
 
-	if (netif_running(adapter->netdev)) {
+	if (netif_running(adapter->netdev) &&
+	    (igc_is_device_id_i225(hw) || !enable)) {
 		schedule_work(&adapter->reset_task);
 		return 0;
 	}
--- a/drivers/net/ethernet/intel/igc/igc_tsn.h
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.h
@@ -4,7 +4,7 @@
 #ifndef _IGC_TSN_H_
 #define _IGC_TSN_H_
 
-int igc_tsn_offload_apply(struct igc_adapter *adapter);
+int igc_tsn_offload_apply(struct igc_adapter *adapter, bool enable);
 int igc_tsn_reset(struct igc_adapter *adapter);
 
 #endif /* _IGC_BASE_H */


