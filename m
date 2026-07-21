Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0233D3337;
	Tue, 21 Jul 2026 17:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653413; cv=none; b=NOG8FOZOK3cXXF+9D2n+EfhwdbHsJIjv6zc3xyqm0FgTXU3/w+yu6AW/On1KHjuLolwFKgBCR5gTiDK8v8AU24fKNweIVAPtTJwO0GN54ovoRUDeIRiCZ6Om9klcZyXHgo6p3QpAOzEoeRUZoblRUoQHHmr7MPpAhQ14Mxy/AZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653413; c=relaxed/simple;
	bh=B+4BhxmMajdDjawTEucQr4OAxRarr7aqrNw7mdpGCGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPDeJQuKsrSin1eeGagXMSV2Vv2UlvwDSVBi8C1nx/uk0JOIZr8i0+lGxa9SlxA6Cda9BF+R8XK4wwWSGvC0bg0u1AwiPIhNDAc3tKZhz00UTyh2w20L/33SD46jRWdGolLOfwCIJJWplGqdwATlCH/0t4t+6r0AW+IOPiPtkPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ooduCPVZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ooduCPVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4771F000E9;
	Tue, 21 Jul 2026 17:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653412;
	bh=Doczx5uCLNkIvp6i7mwu+AY/8eVcn/a0WPN15SPv7Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooduCPVZR71M/ivP6mtFQbuB+8E4jNQ5nc3IqAQ8uuevbulJeJFVwNFJCbw0WnUy/
	 4ikxOUP/KsXha173f4+X6A3H6ENpSSvdAJHNT4THGjGoS/3c6HjVlM4I5wTIHxk9bQ
	 QVR/or3Vumet2ncNVSmh1xt4FIWRc+t2bLURV28g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1317/2077] net: enetc: check the number of BDs needed for xdp_frame
Date: Tue, 21 Jul 2026 17:16:30 +0200
Message-ID: <20260721152623.883358527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index aa8a87124b1032..8e3f345dd9aacb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1783,6 +1783,7 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 {
 	struct enetc_tx_swbd xdp_redirect_arr[ENETC_MAX_SKB_FRAGS] = {0};
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct skb_shared_info *shinfo;
 	struct enetc_bdr *tx_ring;
 	int xdp_tx_bd_cnt, i, k;
 	int xdp_tx_frm_cnt = 0;
@@ -1798,6 +1799,12 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
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



