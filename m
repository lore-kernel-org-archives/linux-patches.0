Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DD41A6166;
	Tue, 30 Jul 2024 16:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357931; cv=none; b=JPtwPPclqiFrGQoAPGbmFNwmTK3CojwBKlbFhESu6jceAgQMqjKCXGQzRNjOS2zuHxfSY3UHm5S/tL3ulJ5UhuthdgFIJCkvgHendLERINSZW7+jQ8YIO20qpnhi0+c3TycHkBSzEf6fQDPIA8U2Rqc6Id1QyUNn9rGMfBEo1g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357931; c=relaxed/simple;
	bh=35jQ8mJAONIFePkPHNUTT6fiGea48KRKfg6lrdjEOHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFqvLeMCdcrMNIThmT/4PzPXiOLtm631qTphvGZTO3UCvKw0d6a38PZalTvVNwhF5rQJAq+1OXHMRc9zMRVSd0LiyJYXbj1zY5dtL354upVrhAuISvJ7iTfS+4Z2fQrT+5/GzysU57lPO9kpaX8xTRb2q/63zoXysXDYzmZgn+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJsPdvq7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJsPdvq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE534C32782;
	Tue, 30 Jul 2024 16:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357931;
	bh=35jQ8mJAONIFePkPHNUTT6fiGea48KRKfg6lrdjEOHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJsPdvq7p/YxsOR7Mm4D8u6cGzPfxej3zb4fngdhAmtm9t9Oq9VawZdv9aMyJrWta
	 rpoks3iyuEoZO8UwsPKiOkkyPuChUacEQh8iAWiEqJ/ItxsKBa/dYjXaP01n16fQz/
	 Rui+0eRjiMkffHMTYn+N/UGKxndoDlzk9X1oVY4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.1 340/440] ice: Add a per-VF limit on number of FDIR filters
Date: Tue, 30 Jul 2024 17:49:33 +0200
Message-ID: <20240730151629.095193848@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Ahmed Zaki <ahmed.zaki@intel.com>

commit 6ebbe97a488179f5dc85f2f1e0c89b486e99ee97 upstream.

While the iavf driver adds a s/w limit (128) on the number of FDIR
filters that the VF can request, a malicious VF driver can request more
than that and exhaust the resources for other VFs.

Add a similar limit in ice.

CC: stable@vger.kernel.org
Fixes: 1f7ea1cd6a37 ("ice: Enable FDIR Configure for AVF")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Suggested-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |    2 +-
 drivers/net/ethernet/intel/ice/ice_fdir.h          |    3 +++
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |   16 ++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.h |    1 +
 4 files changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -531,7 +531,7 @@ ice_parse_rx_flow_user_data(struct ethto
  *
  * Returns the number of available flow director filters to this VSI
  */
-static int ice_fdir_num_avail_fltr(struct ice_hw *hw, struct ice_vsi *vsi)
+int ice_fdir_num_avail_fltr(struct ice_hw *hw, struct ice_vsi *vsi)
 {
 	u16 vsi_num = ice_get_hw_vsi_num(hw, vsi->idx);
 	u16 num_guar;
--- a/drivers/net/ethernet/intel/ice/ice_fdir.h
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.h
@@ -202,6 +202,8 @@ struct ice_fdir_base_pkt {
 	const u8 *tun_pkt;
 };
 
+struct ice_vsi;
+
 int ice_alloc_fd_res_cntr(struct ice_hw *hw, u16 *cntr_id);
 int ice_free_fd_res_cntr(struct ice_hw *hw, u16 cntr_id);
 int ice_alloc_fd_guar_item(struct ice_hw *hw, u16 *cntr_id, u16 num_fltr);
@@ -213,6 +215,7 @@ int
 ice_fdir_get_gen_prgm_pkt(struct ice_hw *hw, struct ice_fdir_fltr *input,
 			  u8 *pkt, bool frag, bool tun);
 int ice_get_fdir_cnt_all(struct ice_hw *hw);
+int ice_fdir_num_avail_fltr(struct ice_hw *hw, struct ice_vsi *vsi);
 bool ice_fdir_is_dup_fltr(struct ice_hw *hw, struct ice_fdir_fltr *input);
 bool ice_fdir_has_frag(enum ice_fltr_ptype flow);
 struct ice_fdir_fltr *
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -551,6 +551,8 @@ static void ice_vc_fdir_reset_cnt_all(st
 		fdir->fdir_fltr_cnt[flow][0] = 0;
 		fdir->fdir_fltr_cnt[flow][1] = 0;
 	}
+
+	fdir->fdir_fltr_cnt_total = 0;
 }
 
 /**
@@ -1567,6 +1569,7 @@ ice_vc_add_fdir_fltr_post(struct ice_vf
 	resp->status = status;
 	resp->flow_id = conf->flow_id;
 	vf->fdir.fdir_fltr_cnt[conf->input.flow_type][is_tun]++;
+	vf->fdir.fdir_fltr_cnt_total++;
 
 	ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
 				    (u8 *)resp, len);
@@ -1631,6 +1634,7 @@ ice_vc_del_fdir_fltr_post(struct ice_vf
 	resp->status = status;
 	ice_vc_fdir_remove_entry(vf, conf, conf->flow_id);
 	vf->fdir.fdir_fltr_cnt[conf->input.flow_type][is_tun]--;
+	vf->fdir.fdir_fltr_cnt_total--;
 
 	ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
 				    (u8 *)resp, len);
@@ -1797,6 +1801,7 @@ int ice_vc_add_fdir_fltr(struct ice_vf *
 	struct virtchnl_fdir_add *stat = NULL;
 	struct virtchnl_fdir_fltr_conf *conf;
 	enum virtchnl_status_code v_ret;
+	struct ice_vsi *vf_vsi;
 	struct device *dev;
 	struct ice_pf *pf;
 	int is_tun = 0;
@@ -1805,6 +1810,17 @@ int ice_vc_add_fdir_fltr(struct ice_vf *
 
 	pf = vf->pf;
 	dev = ice_pf_to_dev(pf);
+	vf_vsi = ice_get_vf_vsi(vf);
+
+#define ICE_VF_MAX_FDIR_FILTERS	128
+	if (!ice_fdir_num_avail_fltr(&pf->hw, vf_vsi) ||
+	    vf->fdir.fdir_fltr_cnt_total >= ICE_VF_MAX_FDIR_FILTERS) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		dev_err(dev, "Max number of FDIR filters for VF %d is reached\n",
+			vf->vf_id);
+		goto err_exit;
+	}
+
 	ret = ice_vc_fdir_param_check(vf, fltr->vsi_id);
 	if (ret) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.h
@@ -29,6 +29,7 @@ struct ice_vf_fdir_ctx {
 struct ice_vf_fdir {
 	u16 fdir_fltr_cnt[ICE_FLTR_PTYPE_MAX][ICE_FD_HW_SEG_MAX];
 	int prof_entry_cnt[ICE_FLTR_PTYPE_MAX][ICE_FD_HW_SEG_MAX];
+	u16 fdir_fltr_cnt_total;
 	struct ice_fd_hw_prof **fdir_prof;
 
 	struct idr fdir_rule_idr;


