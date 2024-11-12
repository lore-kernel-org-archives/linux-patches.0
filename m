Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3631C217474;
	Tue, 12 Nov 2024 10:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408065; cv=none; b=OSca41JYt66P2oAEoJt5O3TtykhggdkVw6QXFfMcI88YQ+1auEBypsRcO1mcZVf7oQDODP5j4Zg1sxtyT89+o62ANAEI8pMnp6xJQQ7gZLDvOF2qGJuSTI5GZZqFHpm+Ce/xQ/rFCfKhWWJ18yarG0Ht0sOkotjwlgCUL/B/XJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408065; c=relaxed/simple;
	bh=bcNtHofaHxAhq1ZKD3lDGM7ku3PmOykv4ITpBwEDAzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmLqtFLwC0mpN+LfXbfcBJE+gADdi3V5plLo3I959R6tR+Li46eWyBzf1Y+r64+m+ytBDIWzKm56y+oMk/nQo8Ptn+v167Pqj+vHX6JWUDQ/IyWaP3H73JRMmGLcakkwU1HVdqpw1hfj3MDKbaJYCqeZ0FYrD7GCBXSmGWPrznA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mbm53tOV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mbm53tOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C55C4CECD;
	Tue, 12 Nov 2024 10:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408065;
	bh=bcNtHofaHxAhq1ZKD3lDGM7ku3PmOykv4ITpBwEDAzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mbm53tOVUVq4uDkWlIc1CMOO3ljp+e9tLLuc+hfb0Mjwux9Ji/FvZVjFAFLn7lx/B
	 ByKpFql8QHUV2Bvz3j3gXTaOYt1PExvABM1eIlyr71TINTNUyhmVGGDh8f/iknusuJ
	 niAxj3XbK/rj5su+iuu5C811i9+sqRJ6opHum+e8=
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
Subject: [PATCH 6.11 048/184] ice: change q_index variable type to s16 to store -1 value
Date: Tue, 12 Nov 2024 11:20:06 +0100
Message-ID: <20241112101902.704953155@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 5412eff8ef233..ee9862ddfe15e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -1830,11 +1830,12 @@ static int
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
index ab5b118daa2da..820023c0271fd 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.h
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.h
@@ -53,6 +53,8 @@
  */
 #define ICE_FDIR_IPV4_PKT_FLAG_MF		0x20
 
+#define ICE_FDIR_NO_QUEUE_IDX			-1
+
 enum ice_fltr_prgm_desc_dest {
 	ICE_FLTR_PRGM_DESC_DEST_DROP_PKT,
 	ICE_FLTR_PRGM_DESC_DEST_DIRECT_PKT_QINDEX,
@@ -186,7 +188,7 @@ struct ice_fdir_fltr {
 	u16 flex_fltr;
 
 	/* filter control */
-	u16 q_index;
+	s16 q_index;
 	u16 orig_q_index;
 	u16 dest_vsi;
 	u8 dest_ctl;
-- 
2.43.0



