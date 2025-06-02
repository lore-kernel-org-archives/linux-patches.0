Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3432F22FE19;
	Mon,  2 Jun 2025 14:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873879; cv=none; b=m9IbnONQDrgW0qTTZm1hmYQ2UrfvV9+OXJtKXS7T3tJ4pR6myD4Kj55VQlEFjoujtursQvn872Hk/deGL2At16wZPlY9ab1rG22SkarjACwTRL8cdZe2m/TSGjmL+WGES7bLAuZpYtwyn+YMEMkP0PXurPw3+cIdJQ9eJhWMboM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873879; c=relaxed/simple;
	bh=azkTUu7NuyrR0HP9OSmyZmbxFgDvxgXohl7/KdwX4d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2hcl7aQGF91d+d1WFnoz1Kd99gmodZlX8EbbyjuNYVH2gfFzT5MXcoH8lSlVfq84K4LrlT0Qwg8D3zT6PIDMSfP2ELNco36YpJHlt0gEU8gO28640teEIMjRAI2sTTD3gy2XcRzSvhVHo/sYjtC9la20x7OTqutBflEzscMORo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGs6Unkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGs6Unkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23BCC4CEEB;
	Mon,  2 Jun 2025 14:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873879;
	bh=azkTUu7NuyrR0HP9OSmyZmbxFgDvxgXohl7/KdwX4d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGs6UnkvFwlA6/SD4QQvx4y1VDDtXwMZWNKVOJ9p+/0fzf78WxRine/EMpeeGU/gR
	 c1H8HoEBSnlWV6je05UTBIZygZdW9lCLEf3uofetgBOSKG7g0M1QzIHNrccODHozKX
	 Kvsaf73vw/e4e3h43Z23OqpmnZagW/VOD9wKWjIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 284/444] ice: count combined queues using Rx/Tx count
Date: Mon,  2 Jun 2025 15:45:48 +0200
Message-ID: <20250602134352.487160076@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit c3a392bdd31adc474f1009ee85c13fdd01fe800d ]

Previous implementation assumes that there is 1:1 matching between
vectors and queues. It isn't always true.

Get minimum value from Rx/Tx queues to determine combined queues number.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 39b5f24be7e4f..dd58b2372dc0c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3329,8 +3329,7 @@ static u32 ice_get_combined_cnt(struct ice_vsi *vsi)
 	ice_for_each_q_vector(vsi, q_idx) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[q_idx];
 
-		if (q_vector->rx.rx_ring && q_vector->tx.tx_ring)
-			combined++;
+		combined += min(q_vector->num_ring_tx, q_vector->num_ring_rx);
 	}
 
 	return combined;
-- 
2.39.5



