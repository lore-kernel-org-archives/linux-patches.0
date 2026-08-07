Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83F429C328;
	Fri,  7 Aug 2026 15:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115995; cv=none; b=gnm0kFf2S1fjjzjyXQp7P9k+r/0D4l/6HriQ09NAn0pTWoUV/E2pej7QeZub/GycY7eomAhW3vrBCpWrwAz3st5eMADjTimNNr2lulJbBuEWtUFkCx3ANamKbalPxwx425gs/Df8+qhpOijFCDoIegDP+vXjD9NSMi1PvLBYQfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115995; c=relaxed/simple;
	bh=RqqE6rv5+kSqBtXsVQRjPybBYuae7aXj1nDotbaCXhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEK7aZ3jqts+vrM6uv8O6FhXIja2QCjy+ElVx0pogNRkeaoc1bDRNobFxxCEQqbmOZL1V5EkOv6hPeZ3+I1pR0hOJ47plbwU5jiRWsLhQKkYRXuV6mJZmv3ABMjhJWNsc48QP3N10vjAWomQVu3z3K7b0FcUiAiWKJaZ8WF/zys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iz+YZAtY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iz+YZAtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109481F000E9;
	Fri,  7 Aug 2026 15:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115994;
	bh=ESOLE62ynhgM7CXhdtSGpputUO0HqAso+tpq419aFXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iz+YZAtYsf2aVXaDqq9Jz627XRUsULhIeuPiWNMbZpfjOPPHh+U0tWo4idSeAckpb
	 9x9QLMKKUpijL8k0/pwF9gVkxHp/h1/xVzrPUwls9xz2G2i2HibfHWQGFN0yfqYQnT
	 KlOmvmgHRZrR7NNqyvdQx6Q4Mnri1YGe9sZ14pKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/261] net: sxgbe: free TX rings on RX allocation failure
Date: Fri,  7 Aug 2026 16:37:13 +0200
Message-ID: <20260807143417.024783668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d662679c29832..fc5750396a3f0 100644
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



