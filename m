Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046FC1F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BFFC433C8;
	Fri, 21 Jul 2023 16:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955829;
	bh=lAXUJcLXPs0Rns19SATx8iePNaRrE9x/l9GzGouUaAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFtN6t0rdGErFb+P8jj7HVza10SdRwXAMpMv2UgsU33rkqZvFfdddLItwAYSBkwRJ
	 N3g2pyJA9loBEHb03U42ysvpxiudorZOUzczX22WUV0zv2N0RyBTMLp+pm6Pff8hSF
	 LbNi69/sYQ8sNmllsQjrANq82eyvd1GOm88FszBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
	Bharathi Sreenivas <bharathi.sreenivas@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 020/292] ice: Fix tx queue rate limit when TCs are configured
Date: Fri, 21 Jul 2023 18:02:09 +0200
Message-ID: <20230721160529.673833708@linuxfoundation.org>
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

From: Sridhar Samudrala <sridhar.samudrala@intel.com>

[ Upstream commit 479cdfe388a04a16fdd127f3e9e9e019e45e5573 ]

Configuring tx_maxrate via sysfs interface
/sys/class/net/eth0/queues/tx-1/tx_maxrate was not working when
TCs are configured because always main VSI was being used. Fix by
using correct VSI in ice_set_tx_maxrate when TCs are configured.

Fixes: 1ddef455f4a8 ("ice: Add NDO callback to set the maximum per-queue bitrate")
Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c   |  7 +++++++
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 22 ++++++++++-----------
 drivers/net/ethernet/intel/ice/ice_tc_lib.h |  1 +
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index eef7c1224887a..1277e0a044ee4 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5969,6 +5969,13 @@ ice_set_tx_maxrate(struct net_device *netdev, int queue_index, u32 maxrate)
 	q_handle = vsi->tx_rings[queue_index]->q_handle;
 	tc = ice_dcb_get_tc(vsi, queue_index);
 
+	vsi = ice_locate_vsi_using_queue(vsi, queue_index);
+	if (!vsi) {
+		netdev_err(netdev, "Invalid VSI for given queue %d\n",
+			   queue_index);
+		return -EINVAL;
+	}
+
 	/* Set BW back to default, when user set maxrate to 0 */
 	if (!maxrate)
 		status = ice_cfg_q_bw_dflt_lmt(vsi->port_info, vsi->idx, tc,
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index d1a31f236d26a..8578dc1cb967d 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -735,17 +735,16 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 /**
  * ice_locate_vsi_using_queue - locate VSI using queue (forward to queue action)
  * @vsi: Pointer to VSI
- * @tc_fltr: Pointer to tc_flower_filter
+ * @queue: Queue index
  *
- * Locate the VSI using specified queue. When ADQ is not enabled, always
- * return input VSI, otherwise locate corresponding VSI based on per channel
- * offset and qcount
+ * Locate the VSI using specified "queue". When ADQ is not enabled,
+ * always return input VSI, otherwise locate corresponding
+ * VSI based on per channel "offset" and "qcount"
  */
-static struct ice_vsi *
-ice_locate_vsi_using_queue(struct ice_vsi *vsi,
-			   struct ice_tc_flower_fltr *tc_fltr)
+struct ice_vsi *
+ice_locate_vsi_using_queue(struct ice_vsi *vsi, int queue)
 {
-	int num_tc, tc, queue;
+	int num_tc, tc;
 
 	/* if ADQ is not active, passed VSI is the candidate VSI */
 	if (!ice_is_adq_active(vsi->back))
@@ -755,7 +754,6 @@ ice_locate_vsi_using_queue(struct ice_vsi *vsi,
 	 * upon queue number)
 	 */
 	num_tc = vsi->mqprio_qopt.qopt.num_tc;
-	queue = tc_fltr->action.fwd.q.queue;
 
 	for (tc = 0; tc < num_tc; tc++) {
 		int qcount = vsi->mqprio_qopt.qopt.count[tc];
@@ -797,6 +795,7 @@ ice_tc_forward_action(struct ice_vsi *vsi, struct ice_tc_flower_fltr *tc_fltr)
 	struct ice_pf *pf = vsi->back;
 	struct device *dev;
 	u32 tc_class;
+	int q;
 
 	dev = ice_pf_to_dev(pf);
 
@@ -825,7 +824,8 @@ ice_tc_forward_action(struct ice_vsi *vsi, struct ice_tc_flower_fltr *tc_fltr)
 		/* Determine destination VSI even though the action is
 		 * FWD_TO_QUEUE, because QUEUE is associated with VSI
 		 */
-		dest_vsi = tc_fltr->dest_vsi;
+		q = tc_fltr->action.fwd.q.queue;
+		dest_vsi = ice_locate_vsi_using_queue(vsi, q);
 		break;
 	default:
 		dev_err(dev,
@@ -1702,7 +1702,7 @@ ice_tc_forward_to_queue(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr,
 	/* If ADQ is configured, and the queue belongs to ADQ VSI, then prepare
 	 * ADQ switch filter
 	 */
-	ch_vsi = ice_locate_vsi_using_queue(vsi, fltr);
+	ch_vsi = ice_locate_vsi_using_queue(vsi, fltr->action.fwd.q.queue);
 	if (!ch_vsi)
 		return -EINVAL;
 	fltr->dest_vsi = ch_vsi;
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.h b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
index 8d5e22ac7023c..189c73d885356 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
@@ -203,6 +203,7 @@ static inline int ice_chnl_dmac_fltr_cnt(struct ice_pf *pf)
 	return pf->num_dmac_chnl_fltrs;
 }
 
+struct ice_vsi *ice_locate_vsi_using_queue(struct ice_vsi *vsi, int queue);
 int
 ice_add_cls_flower(struct net_device *netdev, struct ice_vsi *vsi,
 		   struct flow_cls_offload *cls_flower);
-- 
2.39.2



