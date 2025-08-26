Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAFF1A83ED;
	Tue, 26 Aug 2025 12:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212980; cv=none; b=GhBGXc8ULHr+dEJYHokx31bRII1ZWZS9031kdXmaum6BqTG68qx4VB9tEMZOpCrlL/GVn1gbS6mGKFFN1+uAyFJUdBCi521uiukERm295HNQpHUKj+VSFkWfIEDT5PxrC13+r9give4ut+LPeCtGtcalCg1pMR0cbV4TFCOhjj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212980; c=relaxed/simple;
	bh=cazrtJixyEau+uvU4uSD7/eEnREw3ZYfsL+9hKRBYd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJOHVn+Po3rYDJDr7/GLBpraGbmWA86EhL5taRI8MaimUkKUH4WMZLAu3t2dUyUvCXLuKMD989buT1qUg+9Dzjoy6mcRhIEpKvpxnm8SQRd108hi7wvVfJ6wN7QEFOV31Ckr2U3HnmJfyP8fmGkUiAoOMGdgw/iXLVwsW2yrKNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4wlcvGp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4wlcvGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FDEC4CEF4;
	Tue, 26 Aug 2025 12:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212980;
	bh=cazrtJixyEau+uvU4uSD7/eEnREw3ZYfsL+9hKRBYd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4wlcvGp7xKs+lG7MwF5raXcgO8kZvRMKzMZMpHVsznwLrleMco1+jA3grg+EjkeI
	 RSCBR4CSD+3cFNSJ0qvgt0DzwnSIn0512OOy9HS+RL2uuk6J7S52Fb+E+qanRZHbkT
	 41gvZc+6EBCcwCi/b/YEUxpbb1s7S7742ZANoSO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	zhangjianrong <zhangjianrong5@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/587] net: thunderbolt: Fix the parameter passing of tb_xdomain_enable_paths()/tb_xdomain_disable_paths()
Date: Tue, 26 Aug 2025 13:05:24 +0200
Message-ID: <20250826110957.396214552@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: zhangjianrong <zhangjianrong5@huawei.com>

[ Upstream commit 8ec31cb17cd355cea25cdb8496d9b3fbf1321647 ]

According to the description of tb_xdomain_enable_paths(), the third
parameter represents the transmit ring and the fifth parameter represents
the receive ring. tb_xdomain_disable_paths() is the same case.

[Jakub] Mika says: it works now because both rings ->hop is the same

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/20250625051149.GD2824380@black.fi.intel.com
Signed-off-by: zhangjianrong <zhangjianrong5@huawei.com>
Link: https://patch.msgid.link/20250628094920.656658-1-zhangjianrong5@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/thunderbolt/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
index 643cf67840b5..dcaa62377808 100644
--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -396,9 +396,9 @@ static void tbnet_tear_down(struct tbnet *net, bool send_logout)
 
 		ret = tb_xdomain_disable_paths(net->xd,
 					       net->local_transmit_path,
-					       net->rx_ring.ring->hop,
+					       net->tx_ring.ring->hop,
 					       net->remote_transmit_path,
-					       net->tx_ring.ring->hop);
+					       net->rx_ring.ring->hop);
 		if (ret)
 			netdev_warn(net->dev, "failed to disable DMA paths\n");
 
@@ -662,9 +662,9 @@ static void tbnet_connected_work(struct work_struct *work)
 		goto err_free_rx_buffers;
 
 	ret = tb_xdomain_enable_paths(net->xd, net->local_transmit_path,
-				      net->rx_ring.ring->hop,
+				      net->tx_ring.ring->hop,
 				      net->remote_transmit_path,
-				      net->tx_ring.ring->hop);
+				      net->rx_ring.ring->hop);
 	if (ret) {
 		netdev_err(net->dev, "failed to enable DMA paths\n");
 		goto err_free_tx_buffers;
-- 
2.39.5



