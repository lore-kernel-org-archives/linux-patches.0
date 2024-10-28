Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A63318E76F;
	Mon, 28 Oct 2024 06:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097344; cv=none; b=STlKlY7sgO547ppu8c9iAt+oC9x1GL20sDnMLTlh1fr04NKstxernGOjphdXF7n8DeryGsSnDmv7MAiSQ0wh3udzyPE9i01z4a24MTV0wKmVtoLfwBS0MSEp98H5NQjt/04ZcEhi8zTwwIdPHL7QnkO8DtLjUVaaP3Ud3ORMA+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097344; c=relaxed/simple;
	bh=/Guv1uEVLCpbhxNnhVScmxfjiuPHljuwQhzJFx+OCYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ie5vyCbhqbOaV0813bh/HJaVjLNwWE9IivpA/sWPuul8jl1yYdXr+qWmQHRRac1zbAxR2euWrK1KxHSGQmvVI1wuleKxS3jVlyEd378AHE0WtUM1ZsligaDfiiPcumiaPByCVmouR+dg+G5+EhDtuST6+sIQ+Iw9c2kDI/npKhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IuQlq+ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IuQlq+ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E225C4CEC3;
	Mon, 28 Oct 2024 06:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097343;
	bh=/Guv1uEVLCpbhxNnhVScmxfjiuPHljuwQhzJFx+OCYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuQlq+mlhk1LgXxk6o6yAZfKwNc3QzoyKQLQCyoh6vWdgUBdscAnOvkqICUjRhdY5
	 zh7DR1ZcK2koGz3BFsH73iPDol8U88WcsMoGSjxdgBpg+08Jzsqy9IJFuOQD1Q/K6S
	 wH/zbhnmQpaIwC9Y9Gnj1Z3Pt4hSPNUNUsVFg/hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/137] be2net: fix potential memory leak in be_xmit()
Date: Mon, 28 Oct 2024 07:25:26 +0100
Message-ID: <20241028062301.212757781@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit e4dd8bfe0f6a23acd305f9b892c00899089bd621 ]

The be_xmit() returns NETDEV_TX_OK without freeing skb
in case of be_xmit_enqueue() fails, add dev_kfree_skb_any() to fix it.

Fixes: 760c295e0e8d ("be2net: Support for OS2BMC.")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Message-ID: <20241015144802.12150-1-wanghai38@huawei.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index a9e4e6464a04c..b0a85c9b952b9 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -1382,10 +1382,8 @@ static netdev_tx_t be_xmit(struct sk_buff *skb, struct net_device *netdev)
 	be_get_wrb_params_from_skb(adapter, skb, &wrb_params);
 
 	wrb_cnt = be_xmit_enqueue(adapter, txo, skb, &wrb_params);
-	if (unlikely(!wrb_cnt)) {
-		dev_kfree_skb_any(skb);
-		goto drop;
-	}
+	if (unlikely(!wrb_cnt))
+		goto drop_skb;
 
 	/* if os2bmc is enabled and if the pkt is destined to bmc,
 	 * enqueue the pkt a 2nd time with mgmt bit set.
@@ -1394,7 +1392,7 @@ static netdev_tx_t be_xmit(struct sk_buff *skb, struct net_device *netdev)
 		BE_WRB_F_SET(wrb_params.features, OS2BMC, 1);
 		wrb_cnt = be_xmit_enqueue(adapter, txo, skb, &wrb_params);
 		if (unlikely(!wrb_cnt))
-			goto drop;
+			goto drop_skb;
 		else
 			skb_get(skb);
 	}
@@ -1408,6 +1406,8 @@ static netdev_tx_t be_xmit(struct sk_buff *skb, struct net_device *netdev)
 		be_xmit_flush(adapter, txo);
 
 	return NETDEV_TX_OK;
+drop_skb:
+	dev_kfree_skb_any(skb);
 drop:
 	tx_stats(txo)->tx_drv_drops++;
 	/* Flush the already enqueued tx requests */
-- 
2.43.0



