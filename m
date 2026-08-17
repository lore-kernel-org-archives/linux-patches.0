Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7616442B2F;
	Mon, 17 Aug 2026 15:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979855; cv=none; b=LiwOK+Xm2xqq8uCSe+jCkJxZy/krW+pZiJPJ4VKv0uSzZ34lyPyYaFCdVlW0/dLdjg+ZOkVSEt7nPSz4L7W8Xcj6UFfwyw5bcT7PTVVrBZfFPk/q602334ysmaNHfjzcI7bO9Dv6yyau6ydygElnQk4KRdK4JCZidJg/sgMlCXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979855; c=relaxed/simple;
	bh=t8OogpTJL3YgHHsXF9Hg8s5Vc1ePpZXX48CaA7J3ltY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciXq0apXByHkOtHWCC6S7gDnt2FtshetlGXrqjnICry3i7AZC6TjhcP0fnc/2NACrdQ13rn6GTwsmXMZHyj56aSUrOgMJYk+BxR1D+gdiF7La3wItSfAV2yC7enz2sAzV2fCG6CCoh6lrDjZ0uPjDpUvVQKGYkYjFu8Zk5HscBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/j9/YZ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/j9/YZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6DF1F00A3A;
	Mon, 17 Aug 2026 15:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979853;
	bh=3tEp20Wo7b9QbgfAR7AIStlp3FsTpcih5zYv5xHRtJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/j9/YZ/le0uVEjGw8ZR0OYuDVWmvGiuizoq0ItZEoHkPTREPRTnpbNwuidjGrlj+
	 yeiQ8AJ7h6D6Bc7EmpjV7byx3u/RKg3iHLXY415ieFQMfOwkhPrnxriQZSnDhnwyC+
	 213mIiT55MwlPieMibgCDlFLkp/iTsIH2O1J1W3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 371/609] net: sxgbe: free TX rings on RX allocation failure
Date: Mon, 17 Aug 2026 15:31:07 +0200
Message-ID: <20260817132556.699165128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f6f99712d562e..2801526f75962 100644
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



