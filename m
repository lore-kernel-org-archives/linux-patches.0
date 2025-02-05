Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F1B13C8E2;
	Wed,  5 Feb 2025 15:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767750; cv=none; b=A9gUZ7Bj5V+0WTJfcg1YBecA7kTvs9VR6HODI1XjC1zHvAjn/RAXopaph2KfAVovPRw/5FJpd7Ld7fCyYIYdueMzTsRPU4xDM76WLuivQ3zFUFYDAz6EbOd5QWQzrlgamjvlVmsc7rtGZijUUP1V7csxDmgnGQHdhL/aA8911KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767750; c=relaxed/simple;
	bh=J3FuHgNpmSJjj65N99QREwCs8zSuzj9wZ93HnWEIDXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucbt4VRrFsn90Om2ZqaSECw2yM3eHukMic0nC6JxV1BKQ9YL33BP8VnWeb76owC0VKW7L92ln61gjRFje4PRSyozBOdLORSdyPzY/rzmDbF7t/RX3E83ZVhUUYE5mkJa6G3zgxb9lDi935+HUTGYdv/gAE/VjnlK0dL3ZKeCqPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpDl37Ep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpDl37Ep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4A5C4CED1;
	Wed,  5 Feb 2025 15:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767750;
	bh=J3FuHgNpmSJjj65N99QREwCs8zSuzj9wZ93HnWEIDXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpDl37Ep8u09R94sFJXtEGRskGQI8wxAG3mScZitMiOcoKz4S7+hwm4S3fav97ycB
	 VEXBZZD6WAeNO0FIlfzKX46RWF0yDLF97uryVtpP0RbplSQwv6Ob8Qf2RVLAG0WR0Y
	 jCpX+EuogSW+gImvxjwjlwjpLlPqgGc31P4mT2fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 504/590] net: stmmac: Limit the number of MTL queues to hardware capability
Date: Wed,  5 Feb 2025 14:44:19 +0100
Message-ID: <20250205134514.550299549@linuxfoundation.org>
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

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit f5fb35a3d6b36d378b2e2ecbfb9caa337d5428e6 ]

The number of MTL queues to use is specified by the parameter
"snps,{tx,rx}-queues-to-use" from stmmac_platform layer.

However, the maximum numbers of queues are constrained by upper limits
determined by the capability of each hardware feature. It's appropriate
to limit the values not to exceed the upper limit values and display
a warning message.

This only works if the hardware capability has the upper limit values.

Fixes: d976a525c371 ("net: stmmac: multiple queues dt configuration")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Reviewed-by: Yanteng Si <si.yanteng@linux.dev>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index cf7b59b8cc64b..7b1ae6f397fb9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7236,6 +7236,21 @@ static int stmmac_hw_init(struct stmmac_priv *priv)
 	if (priv->dma_cap.tsoen)
 		dev_info(priv->device, "TSO supported\n");
 
+	if (priv->dma_cap.number_rx_queues &&
+	    priv->plat->rx_queues_to_use > priv->dma_cap.number_rx_queues) {
+		dev_warn(priv->device,
+			 "Number of Rx queues (%u) exceeds dma capability\n",
+			 priv->plat->rx_queues_to_use);
+		priv->plat->rx_queues_to_use = priv->dma_cap.number_rx_queues;
+	}
+	if (priv->dma_cap.number_tx_queues &&
+	    priv->plat->tx_queues_to_use > priv->dma_cap.number_tx_queues) {
+		dev_warn(priv->device,
+			 "Number of Tx queues (%u) exceeds dma capability\n",
+			 priv->plat->tx_queues_to_use);
+		priv->plat->tx_queues_to_use = priv->dma_cap.number_tx_queues;
+	}
+
 	priv->hw->vlan_fail_q_en =
 		(priv->plat->flags & STMMAC_FLAG_VLAN_FAIL_Q_EN);
 	priv->hw->vlan_fail_q = priv->plat->vlan_fail_q;
-- 
2.39.5



