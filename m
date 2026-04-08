Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BB13D890E;
	Wed,  8 Apr 2026 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671789; cv=none; b=Bd2o9uiVjigcv/qrPKso0xZD2JKiYVyXmxb9TDT2Tnal8GKJE2vsXFmTgwIcVVjvXjS6gsCBq4wLyj5pI+wnpzzORQe79n61IyH0TbDOlkZ/Gubv67SQGW6DouUSRJhXuD3BKcHtlp1W4ig1dx0tLiG6bZ66z5AhMJSRdFr9EDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671789; c=relaxed/simple;
	bh=vIaeKSV+0GHZNxl1aCMA2q52JSq/9Fxu8IX5ZfhChPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXWtm75EExoS/1YFjW+MMWVnI80AUxT2ZrM8PMi1XN6bOsNw3lrswUHdrzdycfIo+fQZpc8oCTBNt4PUNyHmNawcDbw8xzNxPRnMVD5XAnk1Iv4cFX8DmDCBTdtxJquGmkEbJRFb+2LcIh5F0UP8xGVFb6l1fChVa5R2OosXtf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rydPE0yK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rydPE0yK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12F1C19421;
	Wed,  8 Apr 2026 18:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671789;
	bh=vIaeKSV+0GHZNxl1aCMA2q52JSq/9Fxu8IX5ZfhChPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rydPE0yK2niZn7V1e/k++uYXYATsLG2y5+HGaVfmMJfhzzdgIDCe76gy6MgaZODxM
	 FRTITp09ZlvJT0PbTDeOeomtCesKph7Q1HwMQEYo7V9MQY5ttylCkVlwLSxLZrNg/S
	 TihcPsBAnLgthkmevNbQS32ZrfKg/gYhb4M+7grc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/312] net: enetc: fix the output issue of ethtool --show-ring
Date: Wed,  8 Apr 2026 19:59:28 +0200
Message-ID: <20260408175935.642396090@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c8369e3752b0e..d4623a41f0137 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -677,6 +677,8 @@ static void enetc_get_ringparam(struct net_device *ndev,
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 
+	ring->rx_max_pending = priv->rx_bd_count;
+	ring->tx_max_pending = priv->tx_bd_count;
 	ring->rx_pending = priv->rx_bd_count;
 	ring->tx_pending = priv->tx_bd_count;
 
-- 
2.51.0



