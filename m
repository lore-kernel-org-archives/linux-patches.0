Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10678F52;
	Sat, 30 Dec 2023 12:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELGr3tXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA56C433C8;
	Sat, 30 Dec 2023 12:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937836;
	bh=njcN8CUhY5BS6kH30tjJmcYMaJL2Uu4MKIO527qyslU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELGr3tXaCKfJO5qxZYPNVnTWq4dMytNFGRNP9GJMavzrVUvu2YPhHjvr5ltKc3oQ6
	 qLAZpCnEmsCNt67bUS1C+5JC2KF9kVpwllEtMtId/LSqjSCebm0D0yumH/Z/UJOlbi
	 BJdUF6VcqW6eC5gWjuxT26hU69evRLIWwoLGI0Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/156] ice: stop trashing VF VSI aggregator node ID information
Date: Sat, 30 Dec 2023 11:58:31 +0000
Message-ID: <20231230115814.203352963@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 7d881346121a97756f34e00e6296a5d63f001f7f ]

When creating new VSIs, they are assigned into an aggregator node in the
scheduler tree. Information about which aggregator node a VSI is assigned
into is maintained by the vsi->agg_node structure. In ice_vsi_decfg(), this
information is being destroyed, by overwriting the valid flag and the
agg_id field to zero.

For VF VSIs, this breaks the aggregator node configuration replay, which
depends on this information. This results in VFs being inserted into the
default aggregator node. The resulting configuration will have unexpected
Tx bandwidth sharing behavior.

This was broken by commit 6624e780a577 ("ice: split ice_vsi_setup into
smaller functions"), which added the block to reset the agg_node data.

The vsi->agg_node structure is not managed by the scheduler code, but is
instead a wrapper around an aggregator node ID that is tracked at the VSI
layer. Its been around for a long time, and its primary purpose was for
handling VFs. The SR-IOV VF reset flow does not make use of the standard VSI
rebuild/replay logic, and uses vsi->agg_node as part of its handling to
rebuild the aggregator node configuration.

The logic for aggregator nodes stretches  back to early ice driver code from
commit b126bd6bcd67 ("ice: create scheduler aggregator node config and move
VSIs")

The logic in ice_vsi_decfg() which trashes the ice_agg_node data is clearly
wrong. It destroys information that is necessary for handling VF reset,. It
is also not the correct way to actually remove a VSI from an aggregator
node. For that, we need to implement logic in the scheduler code. Further,
non-VF VSIs properly replay their aggregator configuration using existing
scheduler replay logic.

To fix the VF replay logic, remove this broken aggregator node cleanup
logic. This is the simplest way to immediately fix this.

This ensures that VFs will have proper aggregate configuration after a
reset. This is especially important since VFs often perform resets as part
of their reconfiguration flows. Without fixing this, VFs will be placed in
the default aggregator node and Tx bandwidth will not be shared in the
expected and configured manner.

Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 73bbf06a76db9..8dbf7a381e49b 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2633,10 +2633,6 @@ void ice_vsi_decfg(struct ice_vsi *vsi)
 	if (vsi->type == ICE_VSI_VF &&
 	    vsi->agg_node && vsi->agg_node->valid)
 		vsi->agg_node->num_vsis--;
-	if (vsi->agg_node) {
-		vsi->agg_node->valid = false;
-		vsi->agg_node->agg_id = 0;
-	}
 }
 
 /**
-- 
2.43.0



