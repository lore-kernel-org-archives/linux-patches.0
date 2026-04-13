Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A5C2D0C7E;
	Mon, 13 Apr 2026 16:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098048; cv=none; b=DYjNuXELYi+6UR4DnPhloeRz0Buv+OIADHVCBh2EC0qOjwV8saDuFHBkVO1aopxmPYTSaKbztavdRa/KeQxk8qHLrRIC7zfrzUkQqsZ2SAcY+ifNH/PZiD9qhbb7oXGcCoebjq2qrBNmAlxMzRXzWgIoLPGpOZ/FnH7uhYM74II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098048; c=relaxed/simple;
	bh=ORECXZWhrKB+s3OPOACK92WNpC8xh0VMmlFLQQ0L2rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvFhoXiVrStr4586DXa+NFehkZ7WqfXGATaV0xOespgzP/3xUtxB7R78r84PFrtvgCZfoFB4mlxHkVP5efgP/4tRa4FmWZs0ztOv7Ql+d3qWErMEGJA/pZdOvjG1aGcZHv7kmyQLoeRQ+0tziwY4HKW3LGBKRZyjoZBBnW7h9ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0PcXNLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0PcXNLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC86DC2BCAF;
	Mon, 13 Apr 2026 16:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098048;
	bh=ORECXZWhrKB+s3OPOACK92WNpC8xh0VMmlFLQQ0L2rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0PcXNLXsVoDQ4Avrh+6yQ8eoTxnUHdso2yfrpivqnlA4kQk0uD9y7EOykfMxSAcf
	 HCfFCfClH6ZnnpGrHvbKsoHg6wGlUKZ7mS3pYehEmU+fttBBdE9hxtjK0Ybn2M40BX
	 1qDpgAUOlXpjRnQbMqC9db2NFTmkaEZM5YNBsVb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 330/570] net: enetc: fix the output issue of ethtool --show-ring
Date: Mon, 13 Apr 2026 17:57:41 +0200
Message-ID: <20260413155842.856864604@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d62c188c87480..89234613ef806 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -566,6 +566,8 @@ static void enetc_get_ringparam(struct net_device *ndev,
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 
+	ring->rx_max_pending = priv->rx_bd_count;
+	ring->tx_max_pending = priv->tx_bd_count;
 	ring->rx_pending = priv->rx_bd_count;
 	ring->tx_pending = priv->tx_bd_count;
 
-- 
2.51.0



