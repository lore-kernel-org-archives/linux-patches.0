Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5181E47CE;
	Mon, 21 Oct 2024 10:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507546; cv=none; b=r8sNgLmePW0LiPxKyHHXi5gDS7cARsDSZclth/oxaBc9ubHlpzFnQsxwb78G1c+2DBHlcpIno6sIR5hyGWoc80hJtR4X5sxeuWBO8BH3SpmLqL7880XjDSZkJfoU0sX/GXOTyk9ym/eb6UHp8DD1nqtdzYJKPk76UqfG7zAGw5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507546; c=relaxed/simple;
	bh=SudJlkPT97ZXKd9WFC4PeI40EjIkRJu1m/TfcYowRcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTZM3yIZJj/+Pt2fGbhVxPHVbe2Yk6Kbjam2TI+Nu0Z2H1q7kH+qramzsgQnjTmDyz27PhNs5d+kfa5MgRC6Soesl135dGYZp2ZX+u+pEpZa5u8Rc8keQrNoyhqqHhpSh78taca7Kvgc+rEnsjqz86mgqPy+AJ/fSb28FGf7qPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5Xpm//E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5Xpm//E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E879C4CEC3;
	Mon, 21 Oct 2024 10:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507546;
	bh=SudJlkPT97ZXKd9WFC4PeI40EjIkRJu1m/TfcYowRcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5Xpm//EWRFR8ZBPUZdWKtwt5ND+eXgQZSIjwtAf7Jc6sQjmhob8WIlM6eHnrQ7XA
	 B1Uv1yIjngvf3dhaM/z3KvtjjSKBuY5LTGEzsTfW8EgaPMH8tNXMy4whFDoQr9+EVm
	 JaGW/RAkag1XXlnm+qvmXFxXv13T5p+Yh9f5AvyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 22/82] net: enetc: remove xdp_drops statistic from enetc_xdp_drop()
Date: Mon, 21 Oct 2024 12:25:03 +0200
Message-ID: <20241021102248.128362675@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1223,7 +1223,6 @@ static void enetc_xdp_drop(struct enetc_
 				  &rx_ring->rx_swbd[rx_ring_first]);
 		enetc_bdr_idx_inc(rx_ring, &rx_ring_first);
 	}
-	rx_ring->stats.xdp_drops++;
 }
 
 static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
@@ -1280,6 +1279,7 @@ static int enetc_clean_rx_ring_xdp(struc
 			fallthrough;
 		case XDP_DROP:
 			enetc_xdp_drop(rx_ring, orig_i, i);
+			rx_ring->stats.xdp_drops++;
 			break;
 		case XDP_PASS:
 			rxbd = orig_rxbd;


