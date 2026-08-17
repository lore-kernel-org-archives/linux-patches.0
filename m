Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EACC3FA5E7;
	Mon, 17 Aug 2026 14:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976035; cv=none; b=WQHwxphPeDuWh9dQN1cesgQfBQ2c05f6yH4yE66ofN9NrVpm6gW502hfc+oBRs6aBDCJ6LJqVlWBldBXxT3ajg+yjucfAqL5Yob8a5KwDXIMuKFoBoXloezgRkFHYlBVugFZ5zV7P0Eg7l2jxndieez1JkrkYQ2vswSLLM+ACHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976035; c=relaxed/simple;
	bh=V+5p7CVxcQcyR8HgHZkFOYYDWyx0NHleTcQd0suajPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6j9Z7KUY6bZYKUr/sjt0hXVcj0VwGdse0rSSheDK8K4tMAWWm0nP/oL3yYOdIBKIkpIaDaHIMQvmUPh07IS5rcC3mnFr4JuXRvOEYoS2syVDzY6bnHdeDZyvaYkQ3L0R/kKO8QuVTH3Ibx1qHCuJGk7q8YrHP7d6pzfxudnjaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BpRLnQp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BpRLnQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40151F000E9;
	Mon, 17 Aug 2026 14:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976034;
	bh=xWvb6rJdSDzhpOSgesQU1YiVaPbVYTlGbzfb/oUSDRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0BpRLnQpm7ZiGefb/ZU9x8ChySVLEnEIL5O2WwuwNEHp+SgWZnjrm0lj+QywvVZlU
	 6bP90KveAFXrWa8iMpMdpDxAkOJJ2MLJXOeypTZMR+DQUb8MMpxIg37YJ0KbuQ6B5t
	 zg73O3EzLajK/ae4OZAMmK1NhmFamIApUr0cglhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 232/389] net: sxgbe: free TX rings on RX allocation failure
Date: Mon, 17 Aug 2026 15:31:11 +0200
Message-ID: <20260817132548.310488822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9c745d48f54b0..22405744b2a36 100644
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



