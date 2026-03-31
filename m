Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251202EBB8D;
	Tue, 31 Mar 2026 17:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976490; cv=none; b=o9jkabFBiMSw78vvKFFTrQ/fMwipUrjMGCcIdJPn+9C90ybTzM29hKTyf7hqtLpw3wcYN313yYtoRksK6kbDKYBNGGauuaDJ+B84gdmafhYJfL62zgskhwCoY0iJSjDYk/UTLeAZ2D79BpCXNUenOcX/W1oIjr1TJPcl6vUmR0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976490; c=relaxed/simple;
	bh=nyosvTAkg1IgJlwKlQlJ8qso5HJxqtTXN/wzBMU6Cw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPXbzmaW/+qlMLlTqF1ZgpXJcu6GgedqH0okA89/PpphT5h9/IIATQqAttsehqJb03JGzYzrXA9mhvwfGf5/hBeLdfsd9KEerwp2/Q2+dCENneZ3/Sy96YzTwXF7mjU3wvVjJUMz2SIKciyGAIrVlgkBbP5h4twbnTxFxs/Rl8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdZoWX8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdZoWX8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DFFC19423;
	Tue, 31 Mar 2026 17:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976490;
	bh=nyosvTAkg1IgJlwKlQlJ8qso5HJxqtTXN/wzBMU6Cw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdZoWX8G+14ljHkoeeIxGsTR2173S48/cKUfoix92hlmbxHDUzv/LfxQEg1rxxrIh
	 J1CQfGqRaRieqWGLpt73iwPSff9WfQNnUqRxtVy+O3zv/y4fClGBfUoGrjfu+kc67x
	 Bm2GFtjryb8do27bIMHEJHSQ8g6CKgAbpMhy5VlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/309] net: enetc: fix the output issue of ethtool --show-ring
Date: Tue, 31 Mar 2026 18:20:15 +0200
Message-ID: <20260331161757.608131651@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
index 71d052de669ab..0250ed95e48ca 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -788,6 +788,8 @@ static void enetc_get_ringparam(struct net_device *ndev,
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 
+	ring->rx_max_pending = priv->rx_bd_count;
+	ring->tx_max_pending = priv->tx_bd_count;
 	ring->rx_pending = priv->rx_bd_count;
 	ring->tx_pending = priv->tx_bd_count;
 
-- 
2.51.0



