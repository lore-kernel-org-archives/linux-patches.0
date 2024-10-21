Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1711F80BC;
	Mon, 21 Oct 2024 10:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507376; cv=none; b=CaAwyDitvL1vRce31/7e2yAVOI/q3rK1me6EaUnTC1i+yl010pxf8HZk7n18uGbxCrrbBmRbY1HpblY86mFb3wn9mzMrfr19XL2z8exl6VPNgGlewyoGXM7yAY5dElhmBiqN60cntayaJcZBxuGRumtNFZBZCXPkQ5zFbIeZ578=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507376; c=relaxed/simple;
	bh=iWUs/cR37ynUbWRSxo3Pij9ETT0nkBSNs0FLNeTH5mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEpppepKoUL3ArfKhhaAVPesKi/DHKvM0crMgDqkGlgN0hbo8sctUZNi4sAzi2n73P/lCYq63oN8w1KYRZw4pXyRWhXWQU1ywEy6wGmvjAKZx7F516EDX2bJm9aJbi0gNIcmnfP7yvkFBhJ4uRdslcUYU7kNIqxAienSMGz5HGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVlrCHIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVlrCHIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D192BC4CEC3;
	Mon, 21 Oct 2024 10:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507376;
	bh=iWUs/cR37ynUbWRSxo3Pij9ETT0nkBSNs0FLNeTH5mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVlrCHIAE2AJY2yFVIMeb529p7lboCEwVHarHIT67/HEDmO1fxPS+fyyYXBnvWCCt
	 dODPinG9v8YC/++86hrz2rIlE7m5fafTHGYe6glB9Vwnn2Z4jwj5kO6Td4/qd7Zynp
	 FUAoJHBWmo3k3wuJqn7/+RjcQ7B+DkhbMN+4jf18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 25/91] net: enetc: remove xdp_drops statistic from enetc_xdp_drop()
Date: Mon, 21 Oct 2024 12:24:39 +0200
Message-ID: <20241021102250.807574482@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

From: Wei Fang <wei.fang@nxp.com>

commit 412950d5746f7aa139e14fe95338694c1f09b595 upstream.

The xdp_drops statistic indicates the number of XDP frames dropped in
the Rx direction. However, enetc_xdp_drop() is also used in XDP_TX and
XDP_REDIRECT actions. If frame loss occurs in these two actions, the
frames loss count should not be included in xdp_drops, because there
are already xdp_tx_drops and xdp_redirect_failures to count the frame
loss of these two actions, so it's better to remove xdp_drops statistic
from enetc_xdp_drop() and increase xdp_drops in XDP_DROP action.

Fixes: 7ed2bc80074e ("net: enetc: add support for XDP_TX")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20241010092056.298128-2-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1492,7 +1492,6 @@ static void enetc_xdp_drop(struct enetc_
 				  &rx_ring->rx_swbd[rx_ring_first]);
 		enetc_bdr_idx_inc(rx_ring, &rx_ring_first);
 	}
-	rx_ring->stats.xdp_drops++;
 }
 
 static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
@@ -1557,6 +1556,7 @@ static int enetc_clean_rx_ring_xdp(struc
 			fallthrough;
 		case XDP_DROP:
 			enetc_xdp_drop(rx_ring, orig_i, i);
+			rx_ring->stats.xdp_drops++;
 			break;
 		case XDP_PASS:
 			rxbd = orig_rxbd;


