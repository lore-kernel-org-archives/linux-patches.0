Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BCE79DC;
	Sat, 30 Dec 2023 12:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zt5Zgwdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CB1C433C8;
	Sat, 30 Dec 2023 12:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937754;
	bh=oeHFZNkOoMkrkwBcW65HkBBPpntr6evgj0b8p0ypYoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zt5Zgwdqf9ubpqqtSHuoNXMA4AZYpRk33xgNlBOuou7PVxFX5ZyPhhKyK7hYE+o1y
	 3K4DSCWMtuYPJE3dMFSBlJRMxIyzMUA/6IbqaGDjUnoJ2MgjQXEBzaptVxo/jrLjB4
	 ATqsO28IKEjUo8gSvr3WUKRLn2EAX3OXi1+fD298=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Suman Ghosh <sumang@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/156] ethernet: atheros: fix a memleak in atl1e_setup_ring_resources
Date: Sat, 30 Dec 2023 11:58:23 +0000
Message-ID: <20231230115813.954243408@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 309fdb1c33fe726d92d0030481346f24e1b01f07 ]

In the error handling of 'offset > adapter->ring_size', the
tx_ring->tx_buffer allocated by kzalloc should be freed,
instead of 'goto failed' instantly.

Fixes: a6a5325239c2 ("atl1e: Atheros L1E Gigabit Ethernet driver")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Reviewed-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 5935be190b9e2..5f2a6fcba9670 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -866,10 +866,13 @@ static int atl1e_setup_ring_resources(struct atl1e_adapter *adapter)
 		netdev_err(adapter->netdev, "offset(%d) > ring size(%d) !!\n",
 			   offset, adapter->ring_size);
 		err = -1;
-		goto failed;
+		goto free_buffer;
 	}
 
 	return 0;
+free_buffer:
+	kfree(tx_ring->tx_buffer);
+	tx_ring->tx_buffer = NULL;
 failed:
 	if (adapter->ring_vir_addr != NULL) {
 		dma_free_coherent(&pdev->dev, adapter->ring_size,
-- 
2.43.0



