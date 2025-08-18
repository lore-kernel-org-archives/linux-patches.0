Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBEE308F30;
	Mon, 18 Aug 2025 13:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522170; cv=none; b=rce3k/Os54rDaIGadUTrSCrHOP7cm6ef2vv8UfSYbkQ8c3xJokEIk6JVfC9BhNgvQkXSsoSxWameL9UvNw1/PFeS9nL+4S8itHcTF/Z6RvOleZazQ2cvE2qN+tIGp3XgFJNYfDSP+ntu4H6pjxCRwe6tlxc7ZgKK6ZQYiNErhpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522170; c=relaxed/simple;
	bh=c5SsaE3mdqVhovIvuh9C1Y7K9YJIT3fZyzTeNXMsiUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSIREzv5rDP8M2IciZHazhOkMOa3PMLoLCTxJtLGpOiZUg73KV7OZWtkGxLEen0MU1sIDKThB7XpxDO30+l2johcaieuM/NgZLVsdur2LhvP2dICZOMBaQGl8V85QJVLuXf6cpyXf67/DkqBC2yX7Ha2k1b9eLUBmgdoLCPsUSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0avcn/C6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0avcn/C6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EED8C4CEEB;
	Mon, 18 Aug 2025 13:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522170;
	bh=c5SsaE3mdqVhovIvuh9C1Y7K9YJIT3fZyzTeNXMsiUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0avcn/C6JZhr0VhaXK/BpCwJPZb8R0Ztdq0eFt6wTu/av0t5E8dmCYT1KrgM8Az3H
	 vo0g+dnM9SSDZ9817kYWv7jrwh1EagqIvsMpt63rdOqzmA/gYrZQ4ECSzh3aOs2muE
	 7G/UeGcnXZ8x0JnCUay2AJ1uLeXxUTGaT5O1Qy9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	zhangjianrong <zhangjianrong5@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 219/444] net: thunderbolt: Fix the parameter passing of tb_xdomain_enable_paths()/tb_xdomain_disable_paths()
Date: Mon, 18 Aug 2025 14:44:05 +0200
Message-ID: <20250818124457.054407570@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



