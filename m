Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58729372EDE;
	Wed, 20 May 2026 17:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296441; cv=none; b=RyY8AySEdqn76iLQQUuRIM/5FbPfw1uCihAVJ8E2iofq5YNyxubnCVhVVk1jttXqbxW0w8/n7RDlI6mrSg6IIdzYzFJgxWuXaCeHrAwwngzEXrXDvXK2yDsQQFWYgbpU2ZCvQZbkKjUtAKTrmho4NJodVewE0m9/38uLsXxJDys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296441; c=relaxed/simple;
	bh=SJjrahMoCKN6GVCsfLvVmLFdHLPXMugwL1Pxz5Cpwzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5detk0QDcKgqm1OGfdAXP8vVBm+/q3fG3HM0SDjYDKZU6U93JpRLZjED95bENZZ51AgoGbNulu9bFNV4I9ALS/hh7azrZtMCmmzNFR+YFdwJYC3WLcE6a2t5GJVCfmujyf6xLYdxeUx8umhSLJzeo8+o2ig6o47yzWzV0r7dAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVBQo8nR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVBQo8nR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27321F000E9;
	Wed, 20 May 2026 17:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296440;
	bh=O1m5iIefo/7+sHvs1gkE+2XG0MOi8tiyB3s3DIp3b8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UVBQo8nRsroT6O9s93mJ4ShQdmPazUkzBbmu4YW0VbZuCLsL3GyfxqqXOgPpMFamc
	 27nM1Ef4XC15PrWQsGnEpYjVshWD1rkijq/MqlpS/ZFmPocCgi7Eq1EijY0/8ctltW
	 25JRdo+gYG11g66IUk8SVKZYRu9A2CBe+wjk+TZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <kohei@enjuk.jp>,
	Paul Greenwalt <paul.greenwalt@intel.com>,
	Rinitha S <sx.rinitha@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0800/1146] ice: fix potential NULL pointer deref in error path of ice_set_ringparam()
Date: Wed, 20 May 2026 18:17:30 +0200
Message-ID: <20260520162206.331289266@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kohei Enju <kohei@enjuk.jp>

[ Upstream commit fa28351f970fa5138c7c5dedfe5dea480a0ee065 ]

ice_set_ringparam nullifies tstamp_ring of temporary tx_rings, without
clearing ICE_TX_RING_FLAGS_TXTIME bit.
When ICE_TX_RING_FLAGS_TXTIME is set and the subsequent
ice_setup_tx_ring() call fails, a NULL pointer dereference could happen
in the unwinding sequence:

ice_clean_tx_ring()
-> ice_is_txtime_cfg() == true (ICE_TX_RING_FLAGS_TXTIME is set)
-> ice_free_tx_tstamp_ring()
  -> ice_free_tstamp_ring()
    -> tstamp_ring->desc (NULL deref)

Clear ICE_TX_RING_FLAGS_TXTIME bit to avoid the potential issue.

Note that this potential issue is found by manual code review.
Compile test only since unfortunately I don't have E830 devices.

Fixes: ccde82e90946 ("ice: add E830 Earliest TxTime First Offload support")
Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Reviewed-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260416-iwl-net-submission-2026-04-14-v2-8-686c33c9828d@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index e6a20af6f63de..f28416a707d77 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3290,6 +3290,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 		tx_rings[i].desc = NULL;
 		tx_rings[i].tx_buf = NULL;
 		tx_rings[i].tstamp_ring = NULL;
+		clear_bit(ICE_TX_RING_FLAGS_TXTIME, tx_rings[i].flags);
 		tx_rings[i].tx_tstamps = &pf->ptp.port.tx;
 		err = ice_setup_tx_ring(&tx_rings[i]);
 		if (err) {
-- 
2.53.0



