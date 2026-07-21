Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAF53AF676;
	Tue, 21 Jul 2026 20:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666762; cv=none; b=AUmoRmnhSzx0/nou1gKBDCnDLAg2SrGdfUb7S94FBH6DLF8kTVHheX0vPMCZXKED9pODFBMJgVNsvPnO8SmWAY9rvE4lKeDpLTOrFHIGvIDTH2E977+IRX8v93V6DzKUbq4B5TqkQEdj4gTa7m9KRYat+SOr4dJlGb/SldvtDh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666762; c=relaxed/simple;
	bh=/cej6u9xvwJk1x7V0rtyfiKAgkgLBo+5FqaHH/IEE2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzdB2OiRiUemnF8q8el9V6ekFlDgHHO1nvbC4VahKicTvdox1QIHiWg1qHHCQdFTPdXN5JJFUgXwVSvp5e002zTvzCtYVOV6y6Tciq1dx52iaXgnAafBwcnxEyjOIYqaHUaxlzb4d3lc+Ht43uD7Y/cT75irOJ006ErGVfojBaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwTb/43V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwTb/43V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D2C1F000E9;
	Tue, 21 Jul 2026 20:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666760;
	bh=udHjcOpnwdpVpKZ8Dp20WccbypIiLulmZoTByJ6vpJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwTb/43V8xMlek1iBFJzYkK4fzYed9XbL56PrBqm7jGYmX+8CxkoFf6bCnej5/X1F
	 mcyBKJ8Ie9Q/DjuxHglhd04XcFjnbpdgAmyyR9yGeLGdJ2lYvMgk07i+PTFpgUBvg2
	 FYa3ik1EEhlvu0YAEGXZmBH06zro8DvoiKnCYkls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0805/1266] net: enetc: check the number of BDs needed for xdp_frame
Date: Tue, 21 Jul 2026 17:20:42 +0200
Message-ID: <20260721152459.871893343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e3ab6f4f8dbba7..3ee6995bc7d256 100644
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



