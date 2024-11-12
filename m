Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96B320F5B6;
	Tue, 12 Nov 2024 10:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407271; cv=none; b=I0AXdS7/GNbvOWM0/f2PdRk7S9ati8P/dKqp/hLWnXwa0RKLiTnDiJv6s7gyzbBdIqLuCnxKUVCCJpOGXuiE+GusHEHQnkPmIOveT1k6pUAfIqn2WjKrwvxKVt5gm3ZNCxpRiwwP+m4R45fZJUeQ6zynUqTiBQaEx/MnGHFuE24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407271; c=relaxed/simple;
	bh=L7QIjf2wxYV9TaeVJTx+RJc5U2NRezECK8bngUA3D7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqyI+5219tcUMiaLhfsDLG29xmmrJooZ2ceinStD++wtYq4mrNsxp5rCdMF7kQ+IqVAopgzQ44P8zRZRgOVV91/tOP+1+08lmgJr0U9L4lK3dnn65kmMDHEzpEKmlOoLOQGSN05Fh5jK4da9M8oviwH4R++oVc/LSdeejdCboj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKnsgdxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKnsgdxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350BCC4CECD;
	Tue, 12 Nov 2024 10:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407271;
	bh=L7QIjf2wxYV9TaeVJTx+RJc5U2NRezECK8bngUA3D7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yKnsgdxWkBLm4mbM6vtRGgYVXGnIFBKnICN7V3CdKfZs9iZM0uBzla1+GAaU3sjBH
	 ccmeDJxhJsmB0awK+f9nDdt5zu9rtqDmeQNNmtZ32TurBqKvrCvaAwHdmHhi32wD78
	 Uw1Bn4cnavl2lMiqUJ2Zs7FixXTOwlX9udzPPyqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.1 26/98] ice: change q_index variable type to s16 to store -1 value
Date: Tue, 12 Nov 2024 11:20:41 +0100
Message-ID: <20241112101845.265093080@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

From: Mateusz Polchlopek <mateusz.polchlopek@intel.com>

[ Upstream commit 64502dac974a5d9951d16015fa2e16a14e5f2bb2 ]

Fix Flow Director not allowing to re-map traffic to 0th queue when action
is configured to drop (and vice versa).

The current implementation of ethtool callback in the ice driver forbids
change Flow Director action from 0 to -1 and from -1 to 0 with an error,
e.g:

 # ethtool -U eth2 flow-type tcp4 src-ip 1.1.1.1 loc 1 action 0
 # ethtool -U eth2 flow-type tcp4 src-ip 1.1.1.1 loc 1 action -1
 rmgr: Cannot insert RX class rule: Invalid argument

We set the value of `u16 q_index = 0` at the beginning of the function
ice_set_fdir_input_set(). In case of "drop traffic" action (which is
equal to -1 in ethtool) we store the 0 value. Later, when want to change
traffic rule to redirect to queue with index 0 it returns an error
caused by duplicate found.

Fix this behaviour by change of the type of field `q_index` from u16 to s16
in `struct ice_fdir_fltr`. This allows to store -1 in the field in case
of "drop traffic" action. What is more, change the variable type in the
function ice_set_fdir_input_set() and assign at the beginning the new
`#define ICE_FDIR_NO_QUEUE_IDX` which is -1. Later, if the action is set
to another value (point specific queue index) the variable value is
overwritten in the function.

Fixes: cac2a27cd9ab ("ice: Support IPv4 Flow Director filters")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c | 3 ++-
 drivers/net/ethernet/intel/ice/ice_fdir.h         | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index 1839a37139dc1..b6bbf2376ef5c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -1694,11 +1694,12 @@ static int
 ice_set_fdir_input_set(struct ice_vsi *vsi, struct ethtool_rx_flow_spec *fsp,
 		       struct ice_fdir_fltr *input)
 {
-	u16 dest_vsi, q_index = 0;
+	s16 q_index = ICE_FDIR_NO_QUEUE_IDX;
 	u16 orig_q_index = 0;
 	struct ice_pf *pf;
 	struct ice_hw *hw;
 	int flow_type;
+	u16 dest_vsi;
 	u8 dest_ctl;
 
 	if (!vsi || !fsp || !input)
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.h b/drivers/net/ethernet/intel/ice/ice_fdir.h
index b384d2a4ab198..063ea3d516532 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.h
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.h
@@ -50,6 +50,8 @@
  */
 #define ICE_FDIR_IPV4_PKT_FLAG_MF		0x20
 
+#define ICE_FDIR_NO_QUEUE_IDX			-1
+
 enum ice_fltr_prgm_desc_dest {
 	ICE_FLTR_PRGM_DESC_DEST_DROP_PKT,
 	ICE_FLTR_PRGM_DESC_DEST_DIRECT_PKT_QINDEX,
@@ -181,7 +183,7 @@ struct ice_fdir_fltr {
 	u16 flex_fltr;
 
 	/* filter control */
-	u16 q_index;
+	s16 q_index;
 	u16 orig_q_index;
 	u16 dest_vsi;
 	u8 dest_ctl;
-- 
2.43.0



