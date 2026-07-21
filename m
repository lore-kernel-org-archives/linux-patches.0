Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B10430CDC;
	Tue, 21 Jul 2026 19:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663219; cv=none; b=eSEU4xzHWa54ubuwmtUL+hR8ZjlCwN/g53DUzuy6cXWEDZjUtVRAwBM4H1iqEBBK6Mv0hwQFX1toyxsVkJrvQPHmQQ9A4ULTVegWBbj/1CnzOVOEDLWGxkegC6J7NwWCCQDw9PLsTLorJ/WYup4tDpygQ1Ex74DR5QumCjz//HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663219; c=relaxed/simple;
	bh=Vjm0VIe+htPfpazNqXHquFSqIJhWKVAik4RYxAYuK6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQDWpInPTZkL95srh4zlc2bH2+dvuDG9wLWy20AXsWRUV1WWnszqk8zsC0pDBmCyFOTa50k8DHSwYw7PLJ+qQlTXJEgG2dJt6pRvZhN1ZSeux2al7GT4jtxz3MCUFBn0IKZMWqSYjmWFGjKcgLQ1edXiW1qghh+WudffDL8C/jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i26W/WC8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i26W/WC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DC81F000E9;
	Tue, 21 Jul 2026 19:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663218;
	bh=65qLc2FnmLLLjOxooyQ6ehphLG0CquuP4Njkq+Blyow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i26W/WC8hnh3ipFzK6Zj4VA2CfIa/c/lkzO9R9kE2KGEJ6VayPQ1+xITCwf0cNa7D
	 Nx/nfu0zbIgbo7OQsgY7WwyBoxOgkVMdOIaXGZiBLbfmeJwlunOS8fFUqyebxDwsAB
	 b+AazhHUCpR2XCu7j49VJaLpccRQ0cdyhq6oaURE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0696/1276] net: enetc: check the number of BDs needed for xdp_frame
Date: Tue, 21 Jul 2026 17:18:59 +0200
Message-ID: <20260721152501.672185776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 555c5475e787802eeae0d2b91c2f66c330db2767 ]

The size of xdp_redirect_arr array is ENETC_MAX_SKB_FRAGS. However, the
number of fragments contained in xdp_frame may be greater than or equal
to ENETC_MAX_SKB_FRAGS, which will cause the access to xdp_redirect_arr
to be out of bounds.

Fixes: 9d2b68cc108d ("net: enetc: add support for XDP_REDIRECT")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20260626073244.2168214-1-wei.fang@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index c58e44144c2fa7..e999671af46d2f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1425,6 +1425,7 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 {
 	struct enetc_tx_swbd xdp_redirect_arr[ENETC_MAX_SKB_FRAGS] = {0};
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct skb_shared_info *shinfo;
 	struct enetc_bdr *tx_ring;
 	int xdp_tx_bd_cnt, i, k;
 	int xdp_tx_frm_cnt = 0;
@@ -1440,6 +1441,12 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 	prefetchw(ENETC_TXBD(*tx_ring, tx_ring->next_to_use));
 
 	for (k = 0; k < num_frames; k++) {
+		if (xdp_frame_has_frags(frames[k])) {
+			shinfo = xdp_get_shared_info_from_frame(frames[k]);
+			if (unlikely((shinfo->nr_frags + 1) > ENETC_MAX_SKB_FRAGS))
+				break;
+		}
+
 		xdp_tx_bd_cnt = enetc_xdp_frame_to_xdp_tx_swbd(tx_ring,
 							       xdp_redirect_arr,
 							       frames[k]);
-- 
2.53.0



