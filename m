Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7876A25BACC;
	Tue, 11 Mar 2025 15:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706523; cv=none; b=OiZ/0lb73x/AH71y7h9YJcP/nTs2TeRijD3uRJ1pedWFPnqAdmoudmDgcugYL72PMktCDrtzKOer0PiPalAhUICUw76M+68gJrFImYCjT5fo1xR31HYcDnl/z1NibKEEzDYsA8hS9n4cMw+4ixYeElgWhVXaF/QuIOUagUQ5nX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706523; c=relaxed/simple;
	bh=XVOiLU3eI5hpzTtD707Stg1hU6kGXlm672b3XBU+3GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/Ky0jFNqJ/S6IZ8SNKg1OB/ojCifSMDOfWINBIK1pU4Ck3Izrsnmi9KkWiv2m3JPRaUjsPvqcION41x107M8pZRm/Dz3QH6Fjt5uaf+nMwQjsNHG72q5ee8n+gp58/43OmE6GhO/Eu9ozLSofmQbNA4HvCcMJQfld9oUHAxLMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlBLl0CP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlBLl0CP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA0FC4CEE9;
	Tue, 11 Mar 2025 15:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706523;
	bh=XVOiLU3eI5hpzTtD707Stg1hU6kGXlm672b3XBU+3GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlBLl0CPuDGFd943s4sHuXQCCPJomfkYKUUt99GVMlKIuyrq2TGhZaeKkLG1Ruv8B
	 7AM9HfVA5PDhOFB6OBsB8H8yt5SYR/zY/0G4SKBqWQIjrKMxivQuOIVMBuxobQWGh1
	 qh2brAKvinQL2Hdu/dqJbZWFc1v9NdYzIl0vNBPE=
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
Subject: [PATCH 5.10 047/462] net: ethernet: ti: am65-cpsw: fix freeing IRQ in am65_cpsw_nuss_remove_tx_chns()
Date: Tue, 11 Mar 2025 15:55:13 +0100
Message-ID: <20250311145800.211566111@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 94e36deefe88a..07510e068742e 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1425,7 +1425,7 @@ void am65_cpsw_nuss_remove_tx_chns(struct am65_cpsw_common *common)
 	for (i = 0; i < common->tx_ch_num; i++) {
 		struct am65_cpsw_tx_chn *tx_chn = &common->tx_chns[i];
 
-		if (tx_chn->irq)
+		if (tx_chn->irq > 0)
 			devm_free_irq(dev, tx_chn->irq, tx_chn);
 
 		netif_napi_del(&tx_chn->napi_tx);
-- 
2.39.5



