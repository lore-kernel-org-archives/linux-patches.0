Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D008634E;
	Wed,  5 Feb 2025 14:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765568; cv=none; b=ISouSmO9OsFKWvN2HsmIz55eTC3BRR6IbtLb645k42pU9NKC9b8+nv0kTmVYzJbRT45zTgocIdlCFUfW5glBOh19bsgBm/iow5I1yMEMxWFw+91ibASSxnQj1mga7xk+31bbD8jWM5xfY/pBA8ZDXa2YvE9T+VWfTvAOOCf8jjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765568; c=relaxed/simple;
	bh=G0FBo35xLbiXRKZZl9eTnp1Xn5tARDAMhv+Xcs/go2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoIz0zwcz8qmUQrsSxsUPzRNIN5CcVpOmP5eBU40mggw5iiuDP/qIXlM2RqUrZ+89BGP5I5M7e+WGti3lfmd8ovG8fZnsE8kTVxEsrTEtL/Hwhc4K2+5MEH2NGVa+xXLV5VY6ebPaAt+untEyg47G0s4UNIHdMIVul2JgzRdhnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/h4Th5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/h4Th5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6335CC4CED1;
	Wed,  5 Feb 2025 14:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765567;
	bh=G0FBo35xLbiXRKZZl9eTnp1Xn5tARDAMhv+Xcs/go2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/h4Th5saBc4/deM0cWL+dAhvijafWfGh5SQrIOOwVUrIGcPYpjgba3dKd5a3SzwJ
	 Ac5ZwGmiPPHDZ6H7CWf7vyGovcLZQw8/+WcnZXiUVIA2LC9VYFjfH/Yx4F9aVdxeJf
	 jGt3oevSt6QgAxUodG7uYly+0UIvLedKW3cuYC9M=
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
Subject: [PATCH 6.12 231/590] net: ethernet: ti: am65-cpsw: fix freeing IRQ in am65_cpsw_nuss_remove_tx_chns()
Date: Wed,  5 Feb 2025 14:39:46 +0100
Message-ID: <20250205134504.117815467@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index dfca13b82bdce..b13c7e958e6b4 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2207,7 +2207,7 @@ static void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common)
 	for (i = 0; i < common->tx_ch_num; i++) {
 		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
 
-		if (tx_chn->irq)
+		if (tx_chn->irq > 0)
 			devm_free_irq(dev, tx_chn->irq, tx_chn);
 
 		netif_napi_del(&tx_chn->napi_tx);
-- 
2.39.5



