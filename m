Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7960931619A;
	Mon, 13 Apr 2026 16:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099235; cv=none; b=MYnK68cKjbvR12GYrkSiOl//QuV3GXYb+MzVk7hfn39Qqu1j/1NjV36Awv2Z9l35j+Kq0gsmZkmIwaRmn2kvyS2cPSLq9kwRtIZQNAfAQdzvQ4ViMpVA8fS/PMAtL1lPJHKod9mNbYhO6wntenKqsAQ6TVrfOdhdJK5QsGqP9Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099235; c=relaxed/simple;
	bh=/MKjKj9Jwks9NMF/1sD4vyCWIhQH//22EEWwmKWoUi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVrg+NTNI8RC5KyYES1Za0reOMduMtdbdY++o6bh1gg68nZZkj7unkFrYBVWMWXcyGHc7ugFGjVTFCZlQIBYiHei8wBgO6sj4Ml+iGnkRSl29+EViAP4XOBGhmBYyknxgQX1Kq4/SXociZZTh+rmVmmdCBkdTgx8jUOEHSqoCuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgUjynHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgUjynHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F038C2BCAF;
	Mon, 13 Apr 2026 16:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099235;
	bh=/MKjKj9Jwks9NMF/1sD4vyCWIhQH//22EEWwmKWoUi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OgUjynHsQ4rNFib4SZXeIVX8vQxekKcgbMl70HwEJRgXKn7u7eD2HG+6ODA/fW4Pd
	 Zrnt1thhyAIKPyZ9fgK38VXy9N8qTT7vI4zVBlyNkI4ZVcW+5x52p2hNuq0pxKuzMl
	 QhM8I8KLM4E7g9D+Uy2Q1Q31Nl5dZwImAx2wPaI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 263/491] net: enetc: fix the output issue of ethtool --show-ring
Date: Mon, 13 Apr 2026 17:58:28 +0200
Message-ID: <20260413155828.898628920@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 70b439bf06f6a12e491f827fa81a9887a11501f9 ]

Currently, enetc_get_ringparam() only provides rx_pending and tx_pending,
but 'ethtool --show-ring' no longer displays these fields. Because the
ringparam retrieval path has moved to the new netlink interface, where
rings_fill_reply() emits the *x_pending only if the *x_max_pending values
are non-zero. So rx_max_pending and tx_max_pending to are added to
enetc_get_ringparam() to fix the issue.

Note that the maximum tx/rx ring size of hardware is 64K, but we haven't
added set_ringparam() to make the ring size configurable. To avoid users
mistakenly believing that the ring size can be increased, so set
the *x_max_pending to priv->*x_bd_count.

Fixes: e4a1717b677c ("ethtool: provide ring sizes with RINGS_GET request")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20260320094222.706339-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index cf98a00296edf..c934cae9f0d41 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -549,6 +549,8 @@ static void enetc_get_ringparam(struct net_device *ndev,
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 
+	ring->rx_max_pending = priv->rx_bd_count;
+	ring->tx_max_pending = priv->tx_bd_count;
 	ring->rx_pending = priv->rx_bd_count;
 	ring->tx_pending = priv->tx_bd_count;
 
-- 
2.51.0



