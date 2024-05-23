Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070F314B084;
	Thu, 23 May 2024 13:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470527; cv=none; b=AEtOLkF5sOzGsRFItLbzkJW/RbYvtFu2Sq0Og2abA6AwqyQzFK/5jakXiQRmW2UjXSbhsXynXHLDF8qAE+kVtcddGm9p+PVAjE/pd8kaQEvrZJygReFyrw+uVyP6HvGSgQE09GDeNysWMFVvJtPIxLPB+v5yH7mD1Vk1xtEQlSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470527; c=relaxed/simple;
	bh=AetxclBOhchGfSe/iLDSdYpt7sNp5/kqVmL9oBtbpN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnuoPur3cEclmmBy6+uJQmY4Kdoh1c7yZK1kZFztKOmgiMzYXJwNk+jsskq0o+PmoMP5w9aIyaiTSJbEAO2slQz7bSvRkH19EG2+tr8KfHAQ14WzweMyNzwXkHaD1d0D2PLzhtyeDv0jm4ghqlgrO7qa5wBmmqR9mH0NrHNzppA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aelEZ4Y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aelEZ4Y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829E6C2BD10;
	Thu, 23 May 2024 13:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470526;
	bh=AetxclBOhchGfSe/iLDSdYpt7sNp5/kqVmL9oBtbpN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aelEZ4Y0uZ0uN83B/Sfo+X1CpJSCsHNH1Mq7NXZg/h9Acvv+uvIVHORGxF3/o/cJJ
	 NxgCB9EKDra+5Kq0wJ+hYpKZcxykGuhO67Wpa+DsmyuNfLDj8Tojmxs7KCK8ITEULY
	 I5doWQY77i5OBsRKFZcvtbvU4rzpT+oswCt6Cbgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.8 03/23] ice: pass VSI pointer into ice_vc_isvalid_q_id
Date: Thu, 23 May 2024 15:13:30 +0200
Message-ID: <20240523130329.878315595@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
References: <20240523130329.745905823@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

commit a21605993dd5dfd15edfa7f06705ede17b519026 upstream.

The ice_vc_isvalid_q_id() function takes a VSI index and a queue ID. It
looks up the VSI from its index, and then validates that the queue number
is valid for that VSI.

The VSI ID passed is typically a VSI index from the VF. This VSI number is
validated by the PF to ensure that it matches the VSI associated with the
VF already.

In every flow where ice_vc_isvalid_q_id() is called, the PF driver already
has a pointer to the VSI associated with the VF. This pointer is obtained
using ice_get_vf_vsi(), rather than looking up the VSI using the index sent
by the VF.

Since we already know which VSI to operate on, we can modify
ice_vc_isvalid_q_id() to take a VSI pointer instead of a VSI index. Pass
the VSI we found from ice_get_vf_vsi() instead of re-doing the lookup. This
removes some unnecessary computation and scanning of the VSI list.

It also removes the last place where the driver directly used the VSI
number from the VF. This will pave the way for refactoring to communicate
relative VSI numbers to the VF instead of absolute numbers from the PF
space.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -550,17 +550,15 @@ bool ice_vc_isvalid_vsi_id(struct ice_vf
 
 /**
  * ice_vc_isvalid_q_id
- * @vf: pointer to the VF info
- * @vsi_id: VSI ID
+ * @vsi: VSI to check queue ID against
  * @qid: VSI relative queue ID
  *
  * check for the valid queue ID
  */
-static bool ice_vc_isvalid_q_id(struct ice_vf *vf, u16 vsi_id, u8 qid)
+static bool ice_vc_isvalid_q_id(struct ice_vsi *vsi, u8 qid)
 {
-	struct ice_vsi *vsi = ice_find_vsi(vf->pf, vsi_id);
 	/* allocated Tx and Rx queues should be always equal for VF VSI */
-	return (vsi && (qid < vsi->alloc_txq));
+	return qid < vsi->alloc_txq;
 }
 
 /**
@@ -1318,7 +1316,7 @@ static int ice_vc_ena_qs_msg(struct ice_
 	 */
 	q_map = vqs->rx_queues;
 	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+		if (!ice_vc_isvalid_q_id(vsi, vf_q_id)) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
 		}
@@ -1340,7 +1338,7 @@ static int ice_vc_ena_qs_msg(struct ice_
 
 	q_map = vqs->tx_queues;
 	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+		if (!ice_vc_isvalid_q_id(vsi, vf_q_id)) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
 		}
@@ -1445,7 +1443,7 @@ static int ice_vc_dis_qs_msg(struct ice_
 		q_map = vqs->tx_queues;
 
 		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+			if (!ice_vc_isvalid_q_id(vsi, vf_q_id)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
 			}
@@ -1471,7 +1469,7 @@ static int ice_vc_dis_qs_msg(struct ice_
 		bitmap_zero(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF);
 	} else if (q_map) {
 		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+			if (!ice_vc_isvalid_q_id(vsi, vf_q_id)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
 			}
@@ -1527,7 +1525,7 @@ ice_cfg_interrupt(struct ice_vf *vf, str
 	for_each_set_bit(vsi_q_id_idx, &qmap, ICE_MAX_RSS_QS_PER_VF) {
 		vsi_q_id = vsi_q_id_idx;
 
-		if (!ice_vc_isvalid_q_id(vf, vsi->vsi_num, vsi_q_id))
+		if (!ice_vc_isvalid_q_id(vsi, vsi_q_id))
 			return VIRTCHNL_STATUS_ERR_PARAM;
 
 		q_vector->num_ring_rx++;
@@ -1541,7 +1539,7 @@ ice_cfg_interrupt(struct ice_vf *vf, str
 	for_each_set_bit(vsi_q_id_idx, &qmap, ICE_MAX_RSS_QS_PER_VF) {
 		vsi_q_id = vsi_q_id_idx;
 
-		if (!ice_vc_isvalid_q_id(vf, vsi->vsi_num, vsi_q_id))
+		if (!ice_vc_isvalid_q_id(vsi, vsi_q_id))
 			return VIRTCHNL_STATUS_ERR_PARAM;
 
 		q_vector->num_ring_tx++;
@@ -1698,7 +1696,7 @@ static int ice_vc_cfg_qs_msg(struct ice_
 		    qpi->txq.headwb_enabled ||
 		    !ice_vc_isvalid_ring_len(qpi->txq.ring_len) ||
 		    !ice_vc_isvalid_ring_len(qpi->rxq.ring_len) ||
-		    !ice_vc_isvalid_q_id(vf, qci->vsi_id, qpi->txq.queue_id)) {
+		    !ice_vc_isvalid_q_id(vsi, qpi->txq.queue_id)) {
 			goto error_param;
 		}
 


