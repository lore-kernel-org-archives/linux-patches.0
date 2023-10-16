Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD0914288
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZ6t67X2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15F2C433C9;
	Mon, 16 Oct 2023 14:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467762;
	bh=Y7XqvhHbM9WJ8/QqG9bw8Hi3z6CPYEMg+RhmWDmkj1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZ6t67X2qxnAv43vOoZYvdX89Z6gJ1bwu+dydjOjIbAgJJnFXVMp4zynLFkKD9Cn1
	 HtAdwJL8qF51dAwH+d8WKsjPeZ27uhmU5QdXhdYAhx75X0+0ZmYu08NNarXOEsn9Bk
	 clu1i5DwkFo7EFkUYPCKt8ldCjvX1focNg1zmV/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 060/191] ravb: Fix up dma_free_coherent() call in ravb_remove()
Date: Mon, 16 Oct 2023 10:40:45 +0200
Message-ID: <20231016084016.802646738@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit e6864af61493113558c502b5cd0d754c19b93277 ]

In ravb_remove(), dma_free_coherent() should be call after
unregister_netdev(). Otherwise, this controller is possible to use
the freed buffer.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20231005011201.14368-2-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 4d6b3b7d6abb3..49726183d264b 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2892,8 +2892,6 @@ static int ravb_remove(struct platform_device *pdev)
 	clk_disable_unprepare(priv->gptp_clk);
 	clk_disable_unprepare(priv->refclk);
 
-	dma_free_coherent(ndev->dev.parent, priv->desc_bat_size, priv->desc_bat,
-			  priv->desc_bat_dma);
 	/* Set reset mode */
 	ravb_write(ndev, CCC_OPC_RESET, CCC);
 	unregister_netdev(ndev);
@@ -2901,6 +2899,8 @@ static int ravb_remove(struct platform_device *pdev)
 		netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
 	ravb_mdio_release(priv);
+	dma_free_coherent(ndev->dev.parent, priv->desc_bat_size, priv->desc_bat,
+			  priv->desc_bat_dma);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	reset_control_assert(priv->rstc);
-- 
2.40.1



