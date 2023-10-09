Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C9D19464
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkh1E4/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DABC433C7;
	Mon,  9 Oct 2023 13:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857175;
	bh=SHBJhDSM0iVsvHGrMocuMk8iVFW7Ponw726mzh7IwHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkh1E4/2n/Q7fDctJAr8zTJwfQSDI3FmqIjw8qyHq+g5eztIeGMLrAbvWrEg+P2TY
	 CJisHqptguqbdS0MEYgnTE3nV44uosjwDbR2Fv9yZlQcdocT0qC0PZoKVopHba6gM3
	 A2tXUaDNx078+mtTzkO6YPU6DMW1c1l6B1vr6ewA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 096/163] ice: always add legacy 32byte RXDID in supported_rxdids
Date: Mon,  9 Oct 2023 15:01:00 +0200
Message-ID: <20231009130126.680856462@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit c070e51db5e2a98d3aef7c324b15209ba47f3dca ]

When the PF and VF drivers both support flexible rx descriptors and have
negotiated the VIRTCHNL_VF_OFFLOAD_RX_FLEX_DESC capability, the VF driver
queries the PF for the list of supported descriptor formats
(VIRTCHNL_OP_GET_SUPPORTED_RXDIDS). The PF driver is supposed to set the
supported_rxdids bits that correspond to the descriptor formats the
firmware implements. The legacy 32-byte rx desc format is always
supported, even though it is not expressed in GLFLXP_RXDID_FLAGS.

The ice driver does not advertise the legacy 32-byte rx desc support,
which leads to this failure to bring up the VF using the Intel
out-of-tree iavf driver:
 iavf 0000:41:01.0: PF does not list support for default Rx descriptor format
 ...
 iavf 0000:41:01.0: PF returned error -5 (VIRTCHNL_STATUS_ERR_PARAM) to our request 6

The in-tree iavf driver does not expose this bug, because it does not
yet implement VIRTCHNL_VF_OFFLOAD_RX_FLEX_DESC.

The ice driver must always set the ICE_RXDID_LEGACY_1 bit in
supported_rxdids. The Intel out-of-tree ice driver and the ice driver in
DPDK both do this.

I copied this piece of the code and the comment text from the Intel
out-of-tree driver.

Fixes: e753df8fbca5 ("ice: Add support Flex RXD")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://lore.kernel.org/r/20230920115439.61172-1-mschmidt@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index dcf628b1fccd9..33ac6c4a8928f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -2615,12 +2615,14 @@ static int ice_vc_query_rxdid(struct ice_vf *vf)
 		goto err;
 	}
 
-	/* Read flexiflag registers to determine whether the
-	 * corresponding RXDID is configured and supported or not.
-	 * Since Legacy 16byte descriptor format is not supported,
-	 * start from Legacy 32byte descriptor.
+	/* RXDIDs supported by DDP package can be read from the register
+	 * to get the supported RXDID bitmap. But the legacy 32byte RXDID
+	 * is not listed in DDP package, add it in the bitmap manually.
+	 * Legacy 16byte descriptor is not supported.
 	 */
-	for (i = ICE_RXDID_LEGACY_1; i < ICE_FLEX_DESC_RXDID_MAX_NUM; i++) {
+	rxdid->supported_rxdids |= BIT(ICE_RXDID_LEGACY_1);
+
+	for (i = ICE_RXDID_FLEX_NIC; i < ICE_FLEX_DESC_RXDID_MAX_NUM; i++) {
 		regval = rd32(hw, GLFLXP_RXDID_FLAGS(i, 0));
 		if ((regval >> GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_S)
 			& GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_M)
-- 
2.40.1



