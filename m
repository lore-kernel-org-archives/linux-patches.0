Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F57810E0;
	Fri,  6 Dec 2024 14:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497086; cv=none; b=o721dsMpiIfA9/SgpiLxpGiLvsR1vLBU/Aolf12VeX1b8n+plS3IVd40T/CXbjZVZ0S9op0Y8vIbOwn2lum4gV6skyo0g0qHQcDctC6InOPM3CjZRpRIPcV5gO8w81VZKyEB8+Hn/ne81TkpVcoc/G1BcnOFNw0Yu6dWI6aIeh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497086; c=relaxed/simple;
	bh=VNp9/CeRnWaSGe9lrvSB132GdKF7N7/uWBfYDpUUVts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTGG4R61BQlXZKgYF/yhEWSTO8qqe5O/4sBFWrDrS+5dDbLs+EsLghHNHDfz/PP9FvxRTxlFBdvlkQqH8krPnwXWzVMnXUoVVVXC1jKnV6s68+IDsihlTTDtFXokrfpVkMR7hAGap8m1AvfF6ZmL1lHKQ61G37vyKIGsemdktcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OG6kePo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OG6kePo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04AEC4CED1;
	Fri,  6 Dec 2024 14:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497086;
	bh=VNp9/CeRnWaSGe9lrvSB132GdKF7N7/uWBfYDpUUVts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OG6kePo4zmJ9jehZyIXE/yXwjYQHPHvlGzrt7p420VyRg2u8Ax5BVNKbyk550U/HC
	 nTbWLG2xW5eKRrbYT1pt3ETI2LIsoQqlAuUQDuyQTf1tLsXiAXHOAhEoifFu5SK1pQ
	 +e2imNXDjpTynL1BB1dW5baK0lGNn1ULudP5LjM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyue Wang <haiyue.wang@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/676] ice: Support FCS/CRC strip disable for VF
Date: Fri,  6 Dec 2024 15:30:10 +0100
Message-ID: <20241206143700.806631194@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haiyue Wang <haiyue.wang@intel.com>

[ Upstream commit 730cb741815c71d9dd8d1bc7d0b7d9a0acc615a8 ]

To support CRC strip enable/disable functionality, VF needs the explicit
request VIRTCHNL_VF_OFFLOAD_CRC offload. Then according to crc_disable
flag of Rx queue configuration information to set up the queue context.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: a884c304e18a ("ice: consistently use q_idx in ice_vc_cfg_qs_msg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 6c6f267dcccc3..216c029661db2 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -479,6 +479,9 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_REQ_QUEUES)
 		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_REQ_QUEUES;
 
+	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_CRC)
+		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_CRC;
+
 	if (vf->driver_caps & VIRTCHNL_VF_CAP_ADV_LINK_SPEED)
 		vfres->vf_cap_flags |= VIRTCHNL_VF_CAP_ADV_LINK_SPEED;
 
@@ -1665,6 +1668,18 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			vsi->rx_rings[i]->dma = qpi->rxq.dma_ring_addr;
 			vsi->rx_rings[i]->count = qpi->rxq.ring_len;
 
+			if (qpi->rxq.crc_disable &&
+			    !(vf->driver_caps & VIRTCHNL_VF_OFFLOAD_CRC)) {
+				goto error_param;
+			}
+
+			if (qpi->rxq.crc_disable)
+				vsi->rx_rings[q_idx]->flags |=
+					ICE_RX_FLAGS_CRC_STRIP_DIS;
+			else
+				vsi->rx_rings[q_idx]->flags &=
+					~ICE_RX_FLAGS_CRC_STRIP_DIS;
+
 			if (qpi->rxq.databuffer_size != 0 &&
 			    (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
 			     qpi->rxq.databuffer_size < 1024))
-- 
2.43.0



