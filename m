Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBC24F7CAA;
	Tue, 13 Oct 2026 12:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893397; cv=none; b=PWn4wL6t/WbhUH6J7F3QFCP1BqQN6k/jmwAHq6XN3Tvrt6zBL/IsCK+3T4q0A/HNslI8V4QR3kJhSCd1gfP3ThrHM0ScA3Ehah7NK5HOzSRE1vPz7YceuAm+emtBynqwcSVZbxmZGRVbhmO5QJESBcYwFoQtspq0pQwVMs0134k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893397; c=relaxed/simple;
	bh=kwTbE2AnWNnxDeGJuwvTFWfQTFBRfxIZJGKkYOe12nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhUlnrbjNDBKn4jaDG2U/wl1bx7dC0uJN2vnOraWyeHalkJv0G5IlMG+YMJkNEnpVgPR+vC+tFR/Iejt1eCNzFO+BlOY24jWFqQs6RFo5dDO/jfwVRYikLs04i2mJqJwVoQtGDZILvA3lesy6fWoBww9RUFqsbczdOC/YjLu53g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECtAm2R2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECtAm2R2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4331F000FF;
	Tue, 13 Oct 2026 12:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893396;
	bh=+GT3iw+YMKO+faKkhvXAko8g10L1MYPH30bbIGiwGlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECtAm2R2dj9SJmE6GOwfCzvEF/pG3U4hy4Y/OwUpoMAxupJRxP0B0bN0Av5It0Ii5
	 PclgpABgdSqaCOxw6hC076nAQYkpanzLedd89HCkRlzB/aZmb6jf1rO3nfCfX1nmpb
	 bFqQmKswbF39y2SfNvXGpdMDDuL4ItUZ7RoLarX0=
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
Subject: [PATCH 6.18 213/621] ice: fix potential NULL pointer deref in error path of ice_set_ringparam()
Date: Tue, 13 Oct 2026 13:33:28 +0200
Message-ID: <20261013112925.916432780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 15efe2f63bdc9..558733788cc1f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3248,6 +3248,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 		tx_rings[i].desc = NULL;
 		tx_rings[i].tx_buf = NULL;
 		tx_rings[i].tstamp_ring = NULL;
+		clear_bit(ICE_TX_RING_FLAGS_TXTIME, tx_rings[i].flags);
 		tx_rings[i].tx_tstamps = &pf->ptp.port.tx;
 		err = ice_setup_tx_ring(&tx_rings[i]);
 		if (err) {
-- 
2.53.0



