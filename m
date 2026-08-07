Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63430476CDD;
	Fri,  7 Aug 2026 15:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116992; cv=none; b=YJOg7dI/Vt7HsdUjJQeIhqESnQbWaU6eMQfY8AxnUfW7dHreNI9KFWdBc/YtH2CpXO24gfPdAmlotbmW2OET/KjUCW/rvyFICrSmepJzpQkbw/9ARTiVnEVBzM7AkhDs9mPsi9uQycZaonl5F2H2uidZ6ugbthJSdGsPe3O3Q70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116992; c=relaxed/simple;
	bh=Vj0jeo9VPZm1G9dvV8ZXJg7RFZxcygOc/hodTMNgKcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwiokYgrAXvvQBpcP7XeX9G1AJbs3xc+wtTIB5Tq/hcS7ZVi1F9cI+ev4o39v30fQD89RWcUFd7MiaLtkrka/BHCjNgxTaadiEisCivTyrq03NKP5A4jcgspAN7fYVesnOkp40Hqsd1NczTKisEV9y52h/fVDpCrU8zQUb+9dDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9iA+CU3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9iA+CU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEE71F00A3E;
	Fri,  7 Aug 2026 15:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116991;
	bh=gSrynSg9Q/1l+agq8z+SN8Ibjl09gQnwR9AEKPO0kx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9iA+CU3NUt2KLz790fKLB+t0a93Y9A60kz3mBZA4N9yjlZrwl4A5q47kv7fAg3F4
	 4e5nodxDw4dknJUX1uVpaPuIzeoqBFLB6f7jnjjjKorpjTbaHav5sKEpc9YKvk4AwY
	 jyJP3aPzrtPw4W4eZbt9AsyKuiy7xCPgk8s+L/bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 160/438] net: sxgbe: free TX rings on RX allocation failure
Date: Fri,  7 Aug 2026 16:35:56 +0200
Message-ID: <20260807143431.446536239@linuxfoundation.org>
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
index 5051ada43d2fa..9b48a587d5c2e 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -597,14 +597,13 @@ static int init_dma_desc_rings(struct net_device *netd)
 
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



