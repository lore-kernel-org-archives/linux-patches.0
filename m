Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1C73BB135;
	Tue, 12 May 2026 17:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608237; cv=none; b=QpWZmjm9co1ohmQj6ykM3q5ariN9O51LQEo2GvQMbdOC8J8ROtUFCrp34ti85hz2UpV6YOQjOXZKrIxgwlMD0Oe71atkM+0QiAkPewuBvdzbZ9CQzM6u7A6fYg/3bW5dnk3viZ8/uq6o/CnVnCV6DGaLbkcHBrYMKABtXWYJifA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608237; c=relaxed/simple;
	bh=SbmYhOw+wbmWBU0DoeoEX+e3U06ifGnzx3Q/5Y7yRy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6Ch8y7HuRVV2JNMvHu4n9HUbQgq4gka2OEm4UqUF/12mMEcLejVCh9Kn2iC6s2q4yEBULOpm8SVtiZvXjXJ2Fxcq34BQz5bOVNuhKTwinLJqSg4FEV5Ch9SfINGIJPVGVmSuIxqayac+TRAQJBQEWPqSIXA/WVca9Brqao2Tzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKoYePeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKoYePeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88DDC2BCC7;
	Tue, 12 May 2026 17:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608237;
	bh=SbmYhOw+wbmWBU0DoeoEX+e3U06ifGnzx3Q/5Y7yRy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKoYePegneNn0jPwnwG3AaHMzvvnahk3K1Q3ds4ZceO1I766asq9ho2BmRtNm2KLd
	 c20ne+F0X3WXXQ9Sxri3/JqFHLWHHV0zoObz80GLNiDJLTDj+ViTx8uY55bUz/hN2i
	 XLlb0D5WoGpOrF2RrkDAijnTj2/m9YpNu8cfWrpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Furong Xu <0x1207@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/206] net: stmmac: avoid shadowing global buf_sz
Date: Tue, 12 May 2026 19:40:51 +0200
Message-ID: <20260512173937.089525511@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

[ Upstream commit 876cfb20e8892143c0c967b3657074f9131f9b5f ]

stmmac_rx() declares a local variable named "buf_sz" but there is also
a global variable for a module parameter which is called the same. To
avoid confusion, rename the local variable.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Furong Xu <0x1207@gmail.com>
Link: https://patch.msgid.link/E1tpswi-005U6C-Py@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0bb05e6adfa9 ("net: stmmac: Prevent NULL deref when RX memory exhausted")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5406,10 +5406,10 @@ static int stmmac_rx(struct stmmac_priv
 	struct sk_buff *skb = NULL;
 	struct stmmac_xdp_buff ctx;
 	int xdp_status = 0;
-	int buf_sz;
+	int bufsz;
 
 	dma_dir = page_pool_get_dma_dir(rx_q->page_pool);
-	buf_sz = DIV_ROUND_UP(priv->dma_conf.dma_buf_sz, PAGE_SIZE) * PAGE_SIZE;
+	bufsz = DIV_ROUND_UP(priv->dma_conf.dma_buf_sz, PAGE_SIZE) * PAGE_SIZE;
 	limit = min(priv->dma_conf.dma_rx_size - 1, (unsigned int)limit);
 
 	if (netif_msg_rx_status(priv)) {
@@ -5524,7 +5524,7 @@ read_again:
 			dma_sync_single_for_cpu(priv->device, buf->addr,
 						buf1_len, dma_dir);
 
-			xdp_init_buff(&ctx.xdp, buf_sz, &rx_q->xdp_rxq);
+			xdp_init_buff(&ctx.xdp, bufsz, &rx_q->xdp_rxq);
 			xdp_prepare_buff(&ctx.xdp, page_address(buf->page),
 					 buf->page_offset, buf1_len, true);
 


