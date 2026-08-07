Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA314746A5;
	Fri,  7 Aug 2026 15:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115044; cv=none; b=G/K6V3oq5TCUVlU1+7bZvZxgGdPozF1BrMH1bNeHTILAEaE3cqaFAIiNMome++agsNiOT3um6a0jIKqVyzrYAZ0kxOl8RLi2U/JCupB0MGO5GUuoqCeCTfiEQretYP9gJNAW8sTcGqRKWlItsZQNUpyPGDW1Fywewe1Nuh8LOKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115044; c=relaxed/simple;
	bh=4tKwkd47cRj+N0sVgMDOL4mtxyuYEPsfNVbqIspK/FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENWumchBhqNArN75tNatH0ENZbWftcLP9J2j/fSRdJBRDdmONHugx2N4LJuXZqQKFcMBXcEWj2vNCGP+J/EHQ9qEQV3g8y8o89HcW0917EwlI/7fPDD+tTj1nyapbl82zUk6vGg5EL/oXw3s+V7uHKEqnZ+K9KTsR+9rEbJXZXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJzSBuqB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJzSBuqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0525A1F00A3A;
	Fri,  7 Aug 2026 15:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115039;
	bh=fDCZOXbqB+b+FTqqcmZhX1xWGa/uS9x0GB1rpfqjd4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJzSBuqBE9I5z/sDdiLMyKIaytti+w5F3qprvAjKNTr4ve3W2KOb0hjeBqKINYNJo
	 99WoAo8ibKZ6l8RNiVCKBF+pz4jueqo+/M23qqJ5ojghV3cBCs/EoTr9RyHytCJHMm
	 9UMeif+g2Apcd7AR7fAiekfUlvvXlCNNbrQxmuFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 134/396] net: sxgbe: free TX rings on RX allocation failure
Date: Fri,  7 Aug 2026 16:34:54 +0200
Message-ID: <20260807143427.195468576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit c870f7e2890b9f78ac84515a9809cc5c183c975e ]

When RX descriptor ring allocation fails, init_dma_desc_rings() only
frees the partially allocated RX rings and returns. The TX rings that
were allocated earlier in the same function are leaked.

Rearrange error labels to clean up TX rings upon RX failures.

Fixes: 1edb9ca69e8a ("net: sxgbe: add basic framework for Samsung 10Gb ethernet driver")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 849c5a6c2af1e..5eb8e7c232f8b 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -599,14 +599,13 @@ static int init_dma_desc_rings(struct net_device *netd)
 
 	return 0;
 
-txalloc_err:
-	while (queue_num--)
-		free_tx_ring(priv->device, priv->txq[queue_num], tx_rsize);
-	return ret;
-
 rxalloc_err:
 	while (queue_num--)
 		free_rx_ring(priv->device, priv->rxq[queue_num], rx_rsize);
+	queue_num = SXGBE_TX_QUEUES;
+txalloc_err:
+	while (queue_num--)
+		free_tx_ring(priv->device, priv->txq[queue_num], tx_rsize);
 	return ret;
 }
 
-- 
2.53.0



