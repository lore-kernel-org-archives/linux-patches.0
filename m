Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C63C466B5E;
	Fri,  7 Aug 2026 15:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117006; cv=none; b=qTnZsGdASIMLwzZAb5wlPDpLD3Z7eokZsSQJ5df6fUrgPg9wt2FJF9Dpn2NQ0QircX8an6DyDpOkwMMmuPUi+ERpAxdFvushYM/7KMG9ZCawsp9jXL/hY1lmcFPVjixTF3895J5h1Fm00RQaWxgbgK+NpBeoWSuSISxFnqDKHek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117006; c=relaxed/simple;
	bh=mG2p4tu+vBrETuT1BdqvsdGJpwG+xVxd/zaPmcfEADo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fP4fUhZJpe++slCSRMxpNmQmyDqhHtNJtL0CkOyDAjUw6oQ1fI3z/XgDsVasJ6VYYwGbqHqYiZVbqumRApgda+6b9B8ejemqCJZEX6akjqughWCNpchD7DC/avEpVrjNkK72if1UKh1USF5PurRH954KfYJvpfmUX8nrHb77dKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEsCdUrd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEsCdUrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F921F000E9;
	Fri,  7 Aug 2026 15:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117005;
	bh=XDTewr82kqoDxg+wRWU9FAN08OQWBJCho/lDMnjMALA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEsCdUrd74zMML1FwoDXhaGWioJV9MZLDPr+5hUimXxmoYimigMam+fahj5BZbfGK
	 qrmcqFuCY08hZtLSR29W5jPfvY8BFp7GOQhrQ6IQYFQXEHqBP1QUiy/7a+KRdpSyp9
	 PGoku3M6s/NQ8SRDMCnw50/QC9bG1i5rVEiIeJU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 122/438] net: ethernet: mtk_eth_soc: pass eth to mtk_handle_irq_rx in poll_controller
Date: Fri,  7 Aug 2026 16:35:18 +0200
Message-ID: <20260807143430.596314118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit e095f249e2209674f6366f6db0383a2b96e19239 ]

mtk_handle_irq_rx expects a struct mtk_eth * (matching the request_irq
cookie), but mtk_poll_controller incorrectly passed the net_device *.
Calling ndo_poll_controller with CONFIG_NET_POLL_CONTROLLER enabled
would then crash.

Fixes: 8186f6e382d8 ("net-next: mediatek: fix compile error inside mtk_poll_controller()")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Link: https://patch.msgid.link/20260723055735.885112-1-chenguang.zhao@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 5d291e50a47bb..351444fb48716 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3467,7 +3467,7 @@ static void mtk_poll_controller(struct net_device *dev)
 
 	mtk_tx_irq_disable(eth, MTK_TX_DONE_INT);
 	mtk_rx_irq_disable(eth, eth->soc->rx.irq_done_mask);
-	mtk_handle_irq_rx(eth->irq[MTK_FE_IRQ_RX], dev);
+	mtk_handle_irq_rx(eth->irq[MTK_FE_IRQ_RX], eth);
 	mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
 	mtk_rx_irq_enable(eth, eth->soc->rx.irq_done_mask);
 }
-- 
2.53.0



