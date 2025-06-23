Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32AC1E5B71;
	Mon, 23 Jun 2025 21:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714169; cv=none; b=OPJA+vMJPW21IvwXNo5drt/gH7IRQz5kMHadvPWTXAVs895yeXTbBTgFTEO1xtMR3F8zWUQ0nKt+jTk502C4tiEFfldUcsg+cQjofV+V4tYIIVvm5lNyePqbfCA5Y4bqEp/UWJKi6Pq8FEKPCJqhiY2QSAWnjvoecXrxu5+SniI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714169; c=relaxed/simple;
	bh=4KtJ674DQ2EYXE6oK26sJkSzq/vNamm1qIN+kqNs854=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWSutaMFBPU6WyVkLf1BkboBZ8k4HdNcUCP6mS4tDCCt0mDspg22wG8A/qP+8XQQSn2/ZN1ujtAxUviFnsvjZBNTF7e2x6yQiBMksrabxmt2A6Ryr6SfsddEOCw9PayieDwehTjRk4KE4i+HfonC62Qw4esF/fUe1terEGjWn9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPS338AA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPS338AA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D55C4CEEA;
	Mon, 23 Jun 2025 21:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714169;
	bh=4KtJ674DQ2EYXE6oK26sJkSzq/vNamm1qIN+kqNs854=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPS338AAeVVjbqhzZGizlXGfNfa1asJ6uaYmjPRzCK2eY1VMEv5GhK0TXsmQGNKHc
	 joCcYOTxLvf1jCGdtHkyPp50gCRyc9/WLtJ5xnrIgdcpoFbOZvdF51c1x/zlc7NtAt
	 k0qMFxJyYS10knZ7sDYfsVzyAV0lkwEo/QNKyQrs=
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
Subject: [PATCH 6.1 176/508] ice: create new Tx scheduler nodes for new queues only
Date: Mon, 23 Jun 2025 15:03:41 +0200
Message-ID: <20250623130649.604827216@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b07bd0c059f75..3baa9d161a0bf 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1591,16 +1591,16 @@ ice_sched_get_agg_node(struct ice_port_info *pi, struct ice_sched_node *tc_node,
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
@@ -1848,8 +1848,9 @@ ice_sched_update_vsi_child_nodes(struct ice_port_info *pi, u16 vsi_handle,
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



