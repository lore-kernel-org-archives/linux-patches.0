Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610E413A897;
	Thu, 23 May 2024 13:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470420; cv=none; b=AZn0iqwCc5vM1pSZ86QwR7WfE26gxG1CNrS+ICtVCgeJJs8VrvojzDntViDed/oVOGiB3DDIYdrNoo21Aq/vf8X++8n1BnXmRaL7y/25TSKOz3XJwWmFfUOwTFodpnjPocMNBdSXv0GNw9kAVORp2tBIy66YfBdH5fYd7MwdHcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470420; c=relaxed/simple;
	bh=KzvrKjV+kv2DQZTblJfwcgL4S+ls6oBcHh+nSx9iMf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILjVEzV6KoMNf1K5NvQM9hlRLui5pK8Heqch7yCM6N01vn62ePmIzm4xt/uOlWtkaQECXfF1L86831EFC42wVN/2fAnoVafVriJTtm6pAq5sRrJJlENkD9QCTOkdGc8iJc2KK3OKErvOHdYiby9lha5rtOvEKDChdMCNqAxeL5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKu6sZXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKu6sZXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF07C4AF09;
	Thu, 23 May 2024 13:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470420;
	bh=KzvrKjV+kv2DQZTblJfwcgL4S+ls6oBcHh+nSx9iMf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKu6sZXFDRLNDEW4jdhTziXwiHb15jGKddXoQaEsZjlr71SIFFqCR7AcvPzGjdcE3
	 OjQS3nezK68R6BbjPAxWmeu/O9j67Ql0GMrh7yapEVsPuzVOD22QqaZxoeIh9DnilB
	 8NHbst1LtRCHqPDJYukTVKI7oo/mOY9OsGiZaFGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.1 03/45] ice: pass VSI pointer into ice_vc_isvalid_q_id
Date: Thu, 23 May 2024 15:12:54 +0200
Message-ID: <20240523130332.625877555@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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
@@ -544,17 +544,15 @@ bool ice_vc_isvalid_vsi_id(struct ice_vf
 
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
@@ -1254,7 +1252,7 @@ static int ice_vc_ena_qs_msg(struct ice_
 	 */
 	q_map = vqs->rx_queues;
 	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+		if (!ice_vc_isvalid_q_id(vsi, vf_q_id)) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
 		}
@@ -1276,7 +1274,7 @@ static int ice_vc_ena_qs_msg(struct ice_
 
 	q_map = vqs->tx_queues;
 	for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-		if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+		if (!ice_vc_isvalid_q_id(vsi, vf_q_id)) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			goto error_param;
 		}
@@ -1381,7 +1379,7 @@ static int ice_vc_dis_qs_msg(struct ice_
 		q_map = vqs->tx_queues;
 
 		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+			if (!ice_vc_isvalid_q_id(vsi, vf_q_id)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
 			}
@@ -1407,7 +1405,7 @@ static int ice_vc_dis_qs_msg(struct ice_
 		bitmap_zero(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF);
 	} else if (q_map) {
 		for_each_set_bit(vf_q_id, &q_map, ICE_MAX_RSS_QS_PER_VF) {
-			if (!ice_vc_isvalid_q_id(vf, vqs->vsi_id, vf_q_id)) {
+			if (!ice_vc_isvalid_q_id(vsi, vf_q_id)) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
 			}
@@ -1463,7 +1461,7 @@ ice_cfg_interrupt(struct ice_vf *vf, str
 	for_each_set_bit(vsi_q_id_idx, &qmap, ICE_MAX_RSS_QS_PER_VF) {
 		vsi_q_id = vsi_q_id_idx;
 
-		if (!ice_vc_isvalid_q_id(vf, vsi->vsi_num, vsi_q_id))
+		if (!ice_vc_isvalid_q_id(vsi, vsi_q_id))
 			return VIRTCHNL_STATUS_ERR_PARAM;
 
 		q_vector->num_ring_rx++;
@@ -1477,7 +1475,7 @@ ice_cfg_interrupt(struct ice_vf *vf, str
 	for_each_set_bit(vsi_q_id_idx, &qmap, ICE_MAX_RSS_QS_PER_VF) {
 		vsi_q_id = vsi_q_id_idx;
 
-		if (!ice_vc_isvalid_q_id(vf, vsi->vsi_num, vsi_q_id))
+		if (!ice_vc_isvalid_q_id(vsi, vsi_q_id))
 			return VIRTCHNL_STATUS_ERR_PARAM;
 
 		q_vector->num_ring_tx++;
@@ -1611,7 +1609,7 @@ static int ice_vc_cfg_qs_msg(struct ice_
 		    qpi->txq.headwb_enabled ||
 		    !ice_vc_isvalid_ring_len(qpi->txq.ring_len) ||
 		    !ice_vc_isvalid_ring_len(qpi->rxq.ring_len) ||
-		    !ice_vc_isvalid_q_id(vf, qci->vsi_id, qpi->txq.queue_id)) {
+		    !ice_vc_isvalid_q_id(vsi, qpi->txq.queue_id)) {
 			goto error_param;
 		}
 


