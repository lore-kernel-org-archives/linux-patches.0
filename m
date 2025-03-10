Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12310230BF9;
	Mon, 10 Mar 2025 17:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628807; cv=none; b=CX1W2hizpBQOAyvLImo7slbB8zqvbV5NDCxB05lv+MQ7ATqalVsitINoGl0KEgNZ0D4jplKHaJbkK0Uv5qvjEaerL7Kmq4/ROPRoiKfF35iBDLU9YA7eb29IDAt5RCF68A93dR+PhTJ58UbxPpuVf0tOR2xc6Q+kIuB2Z1ApkE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628807; c=relaxed/simple;
	bh=VDsGkXmFh/rJY+aKkL6LBVeuWTqpW1mPoNERtvl7mPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbt3tN72X8ZeAi6zq9B6oRySt76Aw7JP1Q3UMMcxiMLrisogBnax6X1QuhTkVlCx10wlX85xSWMNdUx7t2fZr1A1l/504QuISItPh0No+4K6S1DUkSCYMMI658HmwioW1/xbwJjhU+r3+Wfzj+GtpTkP/6fNQrnZ0eppKReSVP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yETpTOHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yETpTOHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDDAC4CEEC;
	Mon, 10 Mar 2025 17:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628806;
	bh=VDsGkXmFh/rJY+aKkL6LBVeuWTqpW1mPoNERtvl7mPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yETpTOHW/exXeCoTjZgrEq7DYu/GdbS1g4n1egq+v3cyhZISyR0Rh/YwhDcJkNpxZ
	 3qq9yz3/koNOlK0mYaIZb9ess3B734cWuKujZVBBBYyJP8PkKWWoZKaGPTRSO0ANNj
	 fT6CKUWVbHag9fP3sUZ+AVHPJ6mMGl5EwUjClsJU=
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
Subject: [PATCH 5.15 074/620] net: ethernet: ti: am65-cpsw: fix freeing IRQ in am65_cpsw_nuss_remove_tx_chns()
Date: Mon, 10 Mar 2025 17:58:40 +0100
Message-ID: <20250310170548.505395595@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4bd57b79a023b..c2700fcfc10e2 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1546,7 +1546,7 @@ void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common)
 	for (i = 0; i < common->tx_ch_num; i++) {
 		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
 
-		if (tx_chn->irq)
+		if (tx_chn->irq > 0)
 			devm_free_irq(dev, tx_chn->irq, tx_chn);
 
 		netif_napi_del(&tx_chn->napi_tx);
-- 
2.39.5



