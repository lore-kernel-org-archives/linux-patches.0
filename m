Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B073B2FCA;
	Sat, 17 Oct 2026 17:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258458; cv=none; b=TojySNbLu8cz7BonX3dLuIyAN8OxquYf3pEPoEWAuv7/bSe9ze2hLSKhFPQrCCToE3SRsSSgPEdAFt1IUhlnjtKhc38WsmVpw8CYZXhUWX88rFXsrBsBl9cqNQHaSBpSFoEK4kxM5qYzc5bd8QwiXEWJBP+s0RpwjeH8yxaFkms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258458; c=relaxed/simple;
	bh=s8qxU1lzvwgagEB4AzgkbamrEQOyfj8OM9FlS85GUUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y07X/0FKwWxCVqHRq7PRIcUq4cFSN+d17S/sBjJcrDWI00BlAlbfBw+z3Sx5c7WQhrjjJYLA3ppg2/UaF6muix/U3UB+hatcVwrexFHZ9Nl9zcvzT5WGMNY4V03BPu0gKuErurwJYXYOPl3br+GAWyYCHm37ChSG9kNiZNIA3YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4T3U5at; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4T3U5at"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39FB1F000C4;
	Sat, 17 Oct 2026 17:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258457;
	bh=5+RlU1XUedVCW79ZURNdyXzsUAKHUQL7edqwA/3ktfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4T3U5atgrww27qKJuD/efpQHZWHd0lJ/eAWZZZ+kFYATsEUKUKK14mp8aSjmnJXo
	 gsUd9tEEo8NqOMr6FkVqM4pELM5AbqSDrJI3CitPE3+sEBBUIL/4vHG2Q3aenwip8G
	 BeZqVsYwXZmLhofhr3403mTOqlGls7NNY7i8pyFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0884/1674] net: lan966x: fix page pool leak in error paths
Date: Sat, 17 Oct 2026 17:52:36 +0200
Message-ID: <20261017160453.803524680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 076344a6ad9d1308faaed1402fdcfdda68b604ab ]

lan966x_fdma_rx_alloc() creates a page pool but does not destroy it if
the subsequent fdma_alloc_coherent() call fails, leaking the pool.

Similarly, lan966x_fdma_init() frees the coherent DMA memory when
lan966x_fdma_tx_alloc() fails but does not destroy the page pool that
was successfully created by lan966x_fdma_rx_alloc(), leaking it.

Add the missing page_pool_destroy() calls in both error paths.

Fixes: 11871aba1974 ("net: lan96x: Use page_pool API")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260405055241.35767-3-devnexen@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index e717d68bf45aa..a99feb266c36c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -120,8 +120,10 @@ static int lan966x_fdma_rx_alloc(struct lan966x_rx *rx)
 	size = ALIGN(size, PAGE_SIZE);
 
 	rx->dcbs = dma_alloc_coherent(lan966x->dev, size, &rx->dma, GFP_KERNEL);
-	if (!rx->dcbs)
+	if (!rx->dcbs) {
+		page_pool_destroy(rx->page_pool);
 		return -ENOMEM;
+	}
 
 	rx->last_entry = rx->dcbs;
 	rx->db_index = 0;
@@ -1048,7 +1050,9 @@ int lan966x_fdma_init(struct lan966x *lan966x)
 
 	err = lan966x_fdma_tx_alloc(&lan966x->tx);
 	if (err) {
+		lan966x_fdma_rx_free_pages(&lan966x->rx);
 		lan966x_fdma_rx_free(&lan966x->rx);
+		page_pool_destroy(lan966x->rx.page_pool);
 		return err;
 	}
 
-- 
2.53.0



