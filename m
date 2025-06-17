Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FB52DFF03;
	Tue, 17 Jun 2025 16:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176186; cv=none; b=ZCWaKUNn9UwOtjAW9b0pKP/e2RnfJaCIN//cHYgQq2ARBXIUvx3WtFhx6vpMhiiRNAZ/QOxF0ghRUAb0qwCKbyJMWPx/fT6l67gm0ezi2KYg45ew0Ru0Lu8/z9QPTSEn68jTllp3qlSpi7zskYptf1bVQ45ndt9Hal5MLlXSk2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176186; c=relaxed/simple;
	bh=yGnXqj7YK2R76c7n2ZA0HTIu4irUBtCUh/Xuyb8XLSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpAdlOV/03ysl/JQuRjg/3eSVjVnRyCdp/CoK1L8HA+yh/+Zk/0tOsnrT+p2mfffxE5Xeg1NJrGYCoyyPw2G122/eD2XsuB8w5SkOqoskczV/0NXZKhMJ9dPGda8ZLbgtp97tw3AJl1JUFMHwYmfMgm1utnwIlRroVsUDp+jxVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYLM6mtW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYLM6mtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD62C4CEE3;
	Tue, 17 Jun 2025 16:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176186;
	bh=yGnXqj7YK2R76c7n2ZA0HTIu4irUBtCUh/Xuyb8XLSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYLM6mtWuLTZa4WsCfJbBpuxTZsjQej9i0WFuMYEVkzdPXQ61r2uaTgV/Wonapyd+
	 dv6mj8lVQRb76qfC1eRiMcfCzo8niL6wokvVt0ifARLo/rjRrfpwAz4QV7AiLgaqfQ
	 X+T5ulgsYII+UaUWdgNDJODgYXod+JdKmkWkAYjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jesse Brandeburg <jbrandeburg@cloudflare.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Saritha Sanigani <sarithax.sanigani@intel.com>
Subject: [PATCH 6.6 253/356] ice: create new Tx scheduler nodes for new queues only
Date: Tue, 17 Jun 2025 17:26:08 +0200
Message-ID: <20250617152348.392250755@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Michal Kubiak <michal.kubiak@intel.com>

[ Upstream commit 6fa2942578472c9cab13a8fc1dae0d830193e0a1 ]

The current implementation of the Tx scheduler tree attempts
to create nodes for all Tx queues, ignoring the fact that some
queues may already exist in the tree. For example, if the VSI
already has 128 Tx queues and the user requests for 16 new queues,
the Tx scheduler will compute the tree for 272 queues (128 existing
queues + 144 new queues), instead of 144 queues (128 existing queues
and 16 new queues).
Fix that by modifying the node count calculation algorithm to skip
the queues that already exist in the tree.

Fixes: 5513b920a4f7 ("ice: Update Tx scheduler tree for VSI multi-Tx queue support")
Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Jesse Brandeburg <jbrandeburg@cloudflare.com>
Tested-by: Saritha Sanigani <sarithax.sanigani@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 908bcd0738033..e40a5f9a893d5 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1614,16 +1614,16 @@ ice_sched_get_agg_node(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 /**
  * ice_sched_calc_vsi_child_nodes - calculate number of VSI child nodes
  * @hw: pointer to the HW struct
- * @num_qs: number of queues
+ * @num_new_qs: number of new queues that will be added to the tree
  * @num_nodes: num nodes array
  *
  * This function calculates the number of VSI child nodes based on the
  * number of queues.
  */
 static void
-ice_sched_calc_vsi_child_nodes(struct ice_hw *hw, u16 num_qs, u16 *num_nodes)
+ice_sched_calc_vsi_child_nodes(struct ice_hw *hw, u16 num_new_qs, u16 *num_nodes)
 {
-	u16 num = num_qs;
+	u16 num = num_new_qs;
 	u8 i, qgl, vsil;
 
 	qgl = ice_sched_get_qgrp_layer(hw);
@@ -1873,8 +1873,9 @@ ice_sched_update_vsi_child_nodes(struct ice_port_info *pi, u16 vsi_handle,
 			return status;
 	}
 
-	if (new_numqs)
-		ice_sched_calc_vsi_child_nodes(hw, new_numqs, new_num_nodes);
+	ice_sched_calc_vsi_child_nodes(hw, new_numqs - prev_numqs,
+				       new_num_nodes);
+
 	/* Keep the max number of queue configuration all the time. Update the
 	 * tree only if number of queues > previous number of queues. This may
 	 * leave some extra nodes in the tree if number of queues < previous
-- 
2.39.5



