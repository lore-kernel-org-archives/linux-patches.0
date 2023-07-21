Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E3E1F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F5AC433C7;
	Fri, 21 Jul 2023 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955806;
	bh=vFb9m783xJIvC3aPlcuyv0v0nqHaFfFynC8gtJKsVr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/UwlIY9/8qWPaF3yRzwMnS573EgDGRgrY+vWt0BbCdz4RsNjeWsgvR//wqegIBEm
	 iWI34aAg9fVY6QllvAGjXjVLHrOZ2W0JB+rGPAX1On85mLDhTWwQmUS52QlF0yRpxc
	 s3merYR5wtXNit/CNMGDZZaCLxF1CsyiMel6VXbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tan Tee Min <tee.min.tan@linux.intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 036/292] igc: Include the length/type field and VLAN tag in queueMaxSDU
Date: Fri, 21 Jul 2023 18:02:25 +0200
Message-ID: <20230721160530.350071548@linuxfoundation.org>
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

From: Tan Tee Min <tee.min.tan@linux.intel.com>

[ Upstream commit 25102893e409bc02761ab82dbcfa092006404790 ]

IEEE 802.1Q does not have clear definitions of what constitutes an
SDU (Service Data Unit), but IEEE Std 802.3 clause 3.1.2 does define
the MAC service primitives and clause 3.2.7 does define the MAC Client
Data for Q-tagged frames.

It shows that the mac_service_data_unit (MSDU) does NOT contain the
preamble, destination and source address, or FCS. The MSDU does contain
the length/type field, MAC client data, VLAN tag and any padding
data (prior to the FCS).

Thus, the maximum 802.3 frame size that is allowed to be transmitted
should be QueueMaxSDU (MSDU) + 16 (6 byte SA + 6 byte DA + 4 byte FCS).

Fixes: 92a0dcb8427d ("igc: offload queue max SDU from tc-taprio")
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Reviewed-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 826556e609800..e7bd2c60ee383 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1575,16 +1575,9 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 	if (adapter->qbv_transition || tx_ring->oper_gate_closed)
 		goto out_drop;
 
-	if (tx_ring->max_sdu > 0) {
-		u32 max_sdu = 0;
-
-		max_sdu = tx_ring->max_sdu +
-			  (skb_vlan_tagged(first->skb) ? VLAN_HLEN : 0);
-
-		if (first->bytecount > max_sdu) {
-			adapter->stats.txdrop++;
-			goto out_drop;
-		}
+	if (tx_ring->max_sdu > 0 && first->bytecount > tx_ring->max_sdu) {
+		adapter->stats.txdrop++;
+		goto out_drop;
 	}
 
 	if (unlikely(test_bit(IGC_RING_FLAG_TX_HWTSTAMP, &tx_ring->flags) &&
@@ -6215,7 +6208,7 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 		struct net_device *dev = adapter->netdev;
 
 		if (qopt->max_sdu[i])
-			ring->max_sdu = qopt->max_sdu[i] + dev->hard_header_len;
+			ring->max_sdu = qopt->max_sdu[i] + dev->hard_header_len - ETH_TLEN;
 		else
 			ring->max_sdu = 0;
 	}
-- 
2.39.2



