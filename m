Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97503469FB;
	Mon, 18 Aug 2025 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525503; cv=none; b=DFlu6fFCCOSV/WesF6sW9vcw4r8fcpGmlIn6Av/3TCN+i15EteCMM8A2T4Z6U8VBLOvtOqw549ZtvID8DExqWLJf8pfXxbeV9P1BDshcowtuxOCvT4sBEMseMAKp5dw/5j4YdYvDmdu9q8BUg6mZ78ukPkRNLHvt5TFUpHNf+o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525503; c=relaxed/simple;
	bh=POF+Rsmmj8gsVm2HJiG5H7oFGG7x1i74qNuBe6ZBrvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=my9JuzOxzmIp2DMr6cM0SEDGDb2xGj/8FXJiXhST2sx6FP5DkawuTBYI+TorOJjCfWUonct3WiCLDNVnlo3SGeNdTh5mGGKI7mUy+H4JAJ5sjgtCOsl4jwseIJwYNCEsB2RIlME7mS+ZzmsZ1hiBAzj+yrVQK1r2IuwI//fwTng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guHuYQrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guHuYQrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB0EC4CEEB;
	Mon, 18 Aug 2025 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525503;
	bh=POF+Rsmmj8gsVm2HJiG5H7oFGG7x1i74qNuBe6ZBrvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guHuYQrh7ZOshrJ1hKM4+b2yGlj0zwpGc/MTxyq6qqMApTBr/9mLiy2g9l2QhhdH4
	 N5nfbY0tfChHovi0fyhtv3YKNzvbKfeH5yqirInatScRVRYTuHu0k83r4RZCmmUUL6
	 kqVwSv4hJe0vY9nBOQWZoVIDs4kg3CqPLzcgQ7tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	zhangjianrong <zhangjianrong5@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 283/570] net: thunderbolt: Fix the parameter passing of tb_xdomain_enable_paths()/tb_xdomain_disable_paths()
Date: Mon, 18 Aug 2025 14:44:30 +0200
Message-ID: <20250818124516.744232555@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



