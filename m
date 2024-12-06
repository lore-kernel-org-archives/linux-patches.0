Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEE21474AF;
	Fri,  6 Dec 2024 14:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497083; cv=none; b=CyigHYDrvKBhDm6w295rsA/9X01h/RK/g7deN7xsWrBsckLcBTRCpL27YwzHqQUS/0A1u/eEE+4J5DwiEZVpc9L3M2VL5TO92oEi03OO9ZjaCVKDyTDXx3qcLbySNrS7Qshh4JqpJnsDyEPLwOrNyl19rb/v1rH/bRzGeXcxIwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497083; c=relaxed/simple;
	bh=NlTZvPAN/sNs3NNfhX050choukdc9xsARJSnwqw8pfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ea9gFL50mPrCrmN2u8Re0gCkkqVT7VT+qqZTQK6i2E53urBITlOa0xi2cRhQyTa0qvGgEvdFquucVd0SdQ87NWHJenrlKlhZDH5UGz5/RGUDi12Q6g0aur/IeVay5qMoIN95zj28IiA1jZtKwRc6EMUEl6Ilg8ndH6o8udvTdHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8AYi/fP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8AYi/fP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8F4C4CED1;
	Fri,  6 Dec 2024 14:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497083;
	bh=NlTZvPAN/sNs3NNfhX050choukdc9xsARJSnwqw8pfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8AYi/fPU5vt8ZpaL/n2G+Bs6twN+unS3HAXmKD6yROzhe6eiW7E5BmX5R+BNKzwv
	 EDzTD12a+7S/DQyeleuCi/wUJcWNZEBHJdYTx1GSBWLScfJ7ySirweIdnNzGmLHpLY
	 9qXa7zlg+IBmAlFyPgpwItznCT2ZY4/xD9gAFcwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/676] virtchnl: Add CRC stripping capability
Date: Fri,  6 Dec 2024 15:30:09 +0100
Message-ID: <20241206143700.768452829@linuxfoundation.org>
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

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

[ Upstream commit 89de9921dfa77e43b985bde99a6031ab66511020 ]

Some VFs may want to disable CRC stripping on incoming packets so create
an offload for that. The VF already sends information about configuring
its RX queues so use that structure to indicate that the CRC stripping
should be enabled or not.

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: a884c304e18a ("ice: consistently use q_idx in ice_vc_cfg_qs_msg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/avf/virtchnl.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 6e950594215a0..99ae7960a8d13 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -245,6 +245,7 @@ VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_vsi_resource);
 #define VIRTCHNL_VF_OFFLOAD_REQ_QUEUES		BIT(6)
 /* used to negotiate communicating link speeds in Mbps */
 #define VIRTCHNL_VF_CAP_ADV_LINK_SPEED		BIT(7)
+#define  VIRTCHNL_VF_OFFLOAD_CRC		BIT(10)
 #define VIRTCHNL_VF_OFFLOAD_VLAN_V2		BIT(15)
 #define VIRTCHNL_VF_OFFLOAD_VLAN		BIT(16)
 #define VIRTCHNL_VF_OFFLOAD_RX_POLLING		BIT(17)
@@ -300,7 +301,13 @@ VIRTCHNL_CHECK_STRUCT_LEN(24, virtchnl_txq_info);
 /* VIRTCHNL_OP_CONFIG_RX_QUEUE
  * VF sends this message to set up parameters for one RX queue.
  * External data buffer contains one instance of virtchnl_rxq_info.
- * PF configures requested queue and returns a status code.
+ * PF configures requested queue and returns a status code. The
+ * crc_disable flag disables CRC stripping on the VF. Setting
+ * the crc_disable flag to 1 will disable CRC stripping for each
+ * queue in the VF where the flag is set. The VIRTCHNL_VF_OFFLOAD_CRC
+ * offload must have been set prior to sending this info or the PF
+ * will ignore the request. This flag should be set the same for
+ * all of the queues for a VF.
  */
 
 /* Rx queue config info */
@@ -312,7 +319,7 @@ struct virtchnl_rxq_info {
 	u16 splithdr_enabled; /* deprecated with AVF 1.0 */
 	u32 databuffer_size;
 	u32 max_pkt_size;
-	u8 pad0;
+	u8 crc_disable;
 	u8 rxdid;
 	u8 pad1[2];
 	u64 dma_ring_addr;
-- 
2.43.0



