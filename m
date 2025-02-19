Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F121DED40;
	Wed, 19 Feb 2025 09:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956201; cv=none; b=dX/IA/dLuoRlIw1RsZLT7+MjvWD6jvhAoxIVFa0FB98VNHulQpC4w72iPOPmL8KjRrKAXnGkEJxqj7VznvuWZyJv2ae01nBgRKiw2OBS5bge9ufyv/18bs2O/OdKXu463S0PevBPPETSqKieDkKjyzBvohs1EuSHOMJEBK2NduA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956201; c=relaxed/simple;
	bh=nabQoq2iPycl5DYgcwi6qpTe8a2wl5URKe28EGw787Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ei70iSq/e+5sR0JwMPJIqkd7Zs4TFi3oKEuw79dsYxHwzrm7O+lEJQ//S4GOhFl2G/MD0vF/MKfGpTffJy4jbgHP2nkGtNOnq9HtZSleli0JEl/b3ZZNJ/V+om/Uo91/TuNOyqYJlO6e+UlRuYvDz2oZAusy5S5GNXRpP9WntBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvfiqtng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvfiqtng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C13C4CED1;
	Wed, 19 Feb 2025 09:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956201;
	bh=nabQoq2iPycl5DYgcwi6qpTe8a2wl5URKe28EGw787Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvfiqtngBQcAU0Asuy8eBSbGuHVUhV505oaVy/cb7iGXkDluEHKNroq9Ywvu7h2+q
	 x5vpZ3YY+Mr7ENMsdm16LqBTDkjGPznYpQdiMvneeD2P9MFuWxlQfvWSH+JS80JF00
	 I3189Gex9pxbMKJRElbU2c9RVfTCNq6OhRuO61Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/578] net: ethernet: ti: am65-cpsw: fix freeing IRQ in am65_cpsw_nuss_remove_tx_chns()
Date: Wed, 19 Feb 2025 09:21:43 +0100
Message-ID: <20250219082656.851096155@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit 4395a44acb15850e492dd1de9ec4b6479d96bc80 ]

When getting the IRQ we use k3_udma_glue_tx_get_irq() which returns
negative error value on error. So not NULL check is not sufficient
to deteremine if IRQ is valid. Check that IRQ is greater then zero
to ensure it is valid.

There is no issue at probe time but at runtime user can invoke
.set_channels which results in the following call chain.
am65_cpsw_set_channels()
 am65_cpsw_nuss_update_tx_rx_chns()
  am65_cpsw_nuss_remove_tx_chns()
  am65_cpsw_nuss_init_tx_chns()

At this point if am65_cpsw_nuss_init_tx_chns() fails due to
k3_udma_glue_tx_get_irq() then tx_chn->irq will be set to a
negative value.

Then, at subsequent .set_channels with higher channel count we
will attempt to free an invalid IRQ in am65_cpsw_nuss_remove_tx_chns()
leading to a kernel warning.

The issue is present in the original commit that introduced this driver,
although there, am65_cpsw_nuss_update_tx_rx_chns() existed as
am65_cpsw_nuss_update_tx_chns().

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 33df06a2de13a..32828d4ac64ce 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1541,7 +1541,7 @@ void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common)
 	for (i = 0; i < common->tx_ch_num; i++) {
 		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
 
-		if (tx_chn->irq)
+		if (tx_chn->irq > 0)
 			devm_free_irq(dev, tx_chn->irq, tx_chn);
 
 		netif_napi_del(&tx_chn->napi_tx);
-- 
2.39.5



