Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2A75101A;
	Mon, 11 Dec 2023 18:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2kK3BEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDD6C433C7;
	Mon, 11 Dec 2023 18:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319356;
	bh=WE99ykXMlddoHyiF/D7HMfHu2FjH8IrZ3sFD4ww2Rxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2kK3BEs4KgI/qUNI5fKVjYnBnhb7QdYyAKh+/OEwGNRUhz49fT3rXZKE40f+5Al0
	 X40+UPvoO/Va1w1TZhDFAOi9QSLAZIfwDQrQExP7i5zWX1poPPumdo+KtaB2Yzsx8F
	 6MaiDragw53Fza9vGvNDM/ENtMsXOGaesIR6WWfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/244] ice: Restore fix disabling RX VLAN filtering
Date: Mon, 11 Dec 2023 19:18:58 +0100
Message-ID: <20231211182047.850995069@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit 4e7f0087b058cc3cab8f3c32141b51aa5457d298 ]

Fix setting dis_rx_filtering depending on whether port vlan is being
turned on or off. This was originally fixed in commit c793f8ea15e3 ("ice:
Fix disabling Rx VLAN filtering with port VLAN enabled"), but while
refactoring ice_vf_vsi_init_vlan_ops(), the fix has been lost. Restore the
fix along with the original comment from that change.

Also delete duplicate lines in ice_port_vlan_on().

Fixes: 2946204b3fa8 ("ice: implement bridge port vlan")
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
index d7b10dc67f035..80dc4bcdd3a41 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
@@ -32,7 +32,6 @@ static void ice_port_vlan_on(struct ice_vsi *vsi)
 		/* setup outer VLAN ops */
 		vlan_ops->set_port_vlan = ice_vsi_set_outer_port_vlan;
 		vlan_ops->clear_port_vlan = ice_vsi_clear_outer_port_vlan;
-		vlan_ops->clear_port_vlan = ice_vsi_clear_outer_port_vlan;
 
 		/* setup inner VLAN ops */
 		vlan_ops = &vsi->inner_vlan_ops;
@@ -47,8 +46,13 @@ static void ice_port_vlan_on(struct ice_vsi *vsi)
 
 		vlan_ops->set_port_vlan = ice_vsi_set_inner_port_vlan;
 		vlan_ops->clear_port_vlan = ice_vsi_clear_inner_port_vlan;
-		vlan_ops->clear_port_vlan = ice_vsi_clear_inner_port_vlan;
 	}
+
+	/* all Rx traffic should be in the domain of the assigned port VLAN,
+	 * so prevent disabling Rx VLAN filtering
+	 */
+	vlan_ops->dis_rx_filtering = noop_vlan;
+
 	vlan_ops->ena_rx_filtering = ice_vsi_ena_rx_vlan_filtering;
 }
 
@@ -77,6 +81,8 @@ static void ice_port_vlan_off(struct ice_vsi *vsi)
 		vlan_ops->del_vlan = ice_vsi_del_vlan;
 	}
 
+	vlan_ops->dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
+
 	if (!test_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags))
 		vlan_ops->ena_rx_filtering = noop_vlan;
 	else
@@ -141,7 +147,6 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 		&vsi->outer_vlan_ops : &vsi->inner_vlan_ops;
 
 	vlan_ops->add_vlan = ice_vsi_add_vlan;
-	vlan_ops->dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
 	vlan_ops->ena_tx_filtering = ice_vsi_ena_tx_vlan_filtering;
 	vlan_ops->dis_tx_filtering = ice_vsi_dis_tx_vlan_filtering;
 }
-- 
2.42.0



