Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DB638945A;
	Tue, 10 Mar 2026 11:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141245; cv=none; b=elNhv0UMF3x3TpTn1Nb1BiRdgpnlpFHbG/kQmcCRh0Iw9drdtO4xQI0DUan2lDil9ZZPKpMI7Rz/qQi0+nwXpzDonr4bb89SAoEkHBQgsQuH7yhyulhVCRD9bPyBCdOiEnQQD1ZHpvaqI9JbLh3KRwnan5Kf/Mml4iv5lat8KPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141245; c=relaxed/simple;
	bh=5CKApni3cl86weyg9wQxOARo/ADknymlIEd3jQX2XyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eA8Zmi5mDmshCB1fOR1V3rKZpDVgd2I1K0UmlK9g1U9DNwQBqKVDyTSXHcewAjXUk/z0OJ0aKr4p8s6j6R62ngKeOUb/kwFrO44N2yQdmGrZHrt/yED+74MBDEUoR20QWQWiAVGie0HP4VLNr9WG8gnMHpLLKCMKP+X1aG2smxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHlNxMrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHlNxMrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB46C2BC9E;
	Tue, 10 Mar 2026 11:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141245;
	bh=5CKApni3cl86weyg9wQxOARo/ADknymlIEd3jQX2XyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHlNxMrNlNHvt+udGyxtvy6+2z1kBe8XdeDd/Moct3wKjQDy+6/NNKCJiwhcPqiz4
	 CGah82z3nD/wsIbLeuqce1+o61UxQx3QEWmL9V2T/EGubEWgMLMP/RNXgI0njF07UY
	 6R/K6h4ahMIOJK9aYf1Ncag4o9y9tcP3qd+C3pFETygBlnkFb/NB0B0if30RIjXrbM
	 wqB+GJCYrFep6yD+7ShYfXqszZK/rwQk4bAKq47y6qE5Gk5JXg0VhOqs/MTRg+bMOv
	 3IB0akpbi4ev7LGKdMI52LtgKtvgBenM0jMVI7Nc0hDOyZXjTmhOkkZDeHy+ihJOUk
	 X7CeykjSd9Z5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Rinitha S <sx.rinitha@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 248/311] ice: Fix memory leak in ice_set_ringparam()
Date: Tue, 10 Mar 2026 07:04:55 -0400
Message-ID: <704d7806a766e3ff0b9c7a9c1a2f8225248230b6.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit fe868b499d16f55bbeea89992edb98043c9de416 ]

In ice_set_ringparam, tx_rings and xdp_rings are allocated before
rx_rings. If the allocation of rx_rings fails, the code jumps to
the done label leaking both tx_rings and xdp_rings. Furthermore, if
the setup of an individual Rx ring fails during the loop, the code jumps
to the free_tx label which releases tx_rings but leaks xdp_rings.

Fix this by introducing a free_xdp label and updating the error paths to
ensure both xdp_rings and tx_rings are properly freed if rx_rings
allocation or setup fails.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: fcea6f3da546 ("ice: Add stats and ethtool support")
Fixes: efc2214b6047 ("ice: Add support for XDP")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index e9f2618950c80..5377550a2b6e1 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3322,7 +3322,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 	rx_rings = kcalloc(vsi->num_rxq, sizeof(*rx_rings), GFP_KERNEL);
 	if (!rx_rings) {
 		err = -ENOMEM;
-		goto done;
+		goto free_xdp;
 	}
 
 	ice_for_each_rxq(vsi, i) {
@@ -3349,7 +3349,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 			}
 			kfree(rx_rings);
 			err = -ENOMEM;
-			goto free_tx;
+			goto free_xdp;
 		}
 	}
 
@@ -3402,6 +3402,13 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 	}
 	goto done;
 
+free_xdp:
+	if (xdp_rings) {
+		ice_for_each_xdp_txq(vsi, i)
+			ice_free_tx_ring(&xdp_rings[i]);
+		kfree(xdp_rings);
+	}
+
 free_tx:
 	/* error cleanup if the Rx allocations failed after getting Tx */
 	if (tx_rings) {
-- 
2.51.0

