Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B541F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B62C433C9;
	Fri, 21 Jul 2023 16:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955832;
	bh=HlHVg7sILA105b6/BTSFvexzyUyCvTv8hFL+JQm6lcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmG7XwDijCxv5oDEtvRD/s28slqT5ZIVzIBc1ZeyTXKf0FDNMbtxDZ2N5FN8cEGGa
	 0iDpm0bEnRs4wvldTBHyNilS94gSURet/rpWCbEwsj8dxWoG570bw0OC9kxL20Fk8C
	 gF82QzpKG+edbl0XflTpdaeKnHaQqswKYpfQwjGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 021/292] igc: Add condition for qbv_config_change_errors counter
Date: Fri, 21 Jul 2023 18:02:10 +0200
Message-ID: <20230721160529.716133838@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

[ Upstream commit ed89b74d2dc920cb61d3094e0e97ec8775b13086 ]

Add condition to increase the qbv counter during taprio qbv
configuration only.

There might be a case when TC already been setup then user configure
the ETF/CBS qdisc and this counter will increase if no condition above.

Fixes: ae4fe4698300 ("igc: Add qbv_config_change_errors counter")
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc.h      | 1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 2 ++
 drivers/net/ethernet/intel/igc/igc_tsn.c  | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 9dc9b982a7ea6..9902f726f06a9 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -184,6 +184,7 @@ struct igc_adapter {
 	u32 max_frame_size;
 	u32 min_frame_size;
 
+	int tc_setup_type;
 	ktime_t base_time;
 	ktime_t cycle_time;
 	bool qbv_enable;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 5f2e8bcd75973..a8815ccf7887d 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6295,6 +6295,8 @@ static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
 {
 	struct igc_adapter *adapter = netdev_priv(dev);
 
+	adapter->tc_setup_type = type;
+
 	switch (type) {
 	case TC_QUERY_CAPS:
 		return igc_tc_query_caps(adapter, type_data);
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 94a2b0dfb54d4..6b299b83e7ef2 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -249,6 +249,7 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 		 * Gate Control List (GCL) is running.
 		 */
 		if ((rd32(IGC_BASET_H) || rd32(IGC_BASET_L)) &&
+		    (adapter->tc_setup_type == TC_SETUP_QDISC_TAPRIO) &&
 		    tsn_mode_reconfig)
 			adapter->qbv_config_change_errors++;
 	} else {
-- 
2.39.2



