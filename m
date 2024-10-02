Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D481D1E69;
	Wed,  2 Oct 2024 14:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880264; cv=none; b=Z4weLLomjJTxIbijzYKr64z0WCkIHKBNoAZRDGduCspQj7alHIJFQHE36xJbmjX21pO3bTMLdj68h1SI14Aw6TQoMAAT9XWXqFVT4vKPOYeu+02SAs9KdYcJEP7aBEXCB47cmEn1PYHQR+6ouJ9wJJsjucqXcJLy2Ln/M+8G+KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880264; c=relaxed/simple;
	bh=Lt1r2ZEewgPqEM1GJ+watjsDoDeq9tRa1ND25rcZaho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMTuANUVSgJZ4cMbrDw0rlnUtf5GXNS2HzBBlJ/gTXbXM/aXYwcU7vP+oqFQQWKvkBsJBpQP6+oOmqEgBEczo2SYugnq7Ozn0+CTuU8Q6dFQPdWfM1LAKhpRN0MotsWMw63vkw4/uH6d8DIps11TqkYWtUL/nuVL1mUAHZXPxKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcvFD5/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcvFD5/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0D0C4CEC2;
	Wed,  2 Oct 2024 14:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880263;
	bh=Lt1r2ZEewgPqEM1GJ+watjsDoDeq9tRa1ND25rcZaho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bcvFD5/TNE3QoVSxrl6Q9PrLZaaHEzxAuK1pLFaoqnBwkQrWy3FlXtztLGEZ+B3BZ
	 hctdSrR3cRhtBTeCReTqyEGBzIG/8Ab3c1iPH4cuR/9Q9vcqPLj02YgKFS4FZe0acO
	 998qG4YAVpi52ATYpqBAhtC+0QH8ft25rh1QTqQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 369/538] net: xilinx: axienet: Schedule NAPI in two steps
Date: Wed,  2 Oct 2024 15:00:08 +0200
Message-ID: <20241002125806.994204375@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit ba0da2dc934ec5ac32bbeecbd0670da16ba03565 ]

As advised by Documentation/networking/napi.rst, masking IRQs after
calling napi_schedule can be racy. Avoid this by only masking/scheduling
if napi_schedule_prep returns true.

Fixes: 9e2bc267e780 ("net: axienet: Use NAPI for TX completion path")
Fixes: cc37610caaf8 ("net: axienet: implement NAPI and GRO receive")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240913145711.2284295-1-sean.anderson@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 65d7aaad43fe9..f869d61e3b867 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1042,9 +1042,10 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
 		u32 cr = lp->tx_dma_cr;
 
 		cr &= ~(XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK);
-		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
-
-		napi_schedule(&lp->napi_tx);
+		if (napi_schedule_prep(&lp->napi_tx)) {
+			axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
+			__napi_schedule(&lp->napi_tx);
+		}
 	}
 
 	return IRQ_HANDLED;
@@ -1086,9 +1087,10 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
 		u32 cr = lp->rx_dma_cr;
 
 		cr &= ~(XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK);
-		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
-
-		napi_schedule(&lp->napi_rx);
+		if (napi_schedule_prep(&lp->napi_rx)) {
+			axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
+			__napi_schedule(&lp->napi_rx);
+		}
 	}
 
 	return IRQ_HANDLED;
-- 
2.43.0



