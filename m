Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EC249659;
	Mon, 14 Oct 2024 15:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919963; cv=none; b=j7gRXH53uGhHYtth4WvP8WnYPbXR7+nBqnsKMTJFqNf9fLYtlGekE08HHaCAMWmcDc4xxHA2C1dJFtGaIWuHuR/kEYfo+nBmrSu/JyvuYAfecm+ddw7BAuQUCeqHMUjSEKrLlduwfe7E7Aq1ibovPv29E5MsoiOXeDdgdVWE1bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919963; c=relaxed/simple;
	bh=Ec93hXZF0LM9ZLpuxSTZ7zQO8Cl1cqhdcNFcmEaDZKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICv0xHAoVoUtq5WcxjX+ZBrvn48gRXogXbgZ6aNbizJJWnKGeRU4kx/KYk4QEpNxdZrYSXebIqbUFNwXK59Jl1YDAnP2i3Y1VbftiphNKiUqvd1wGFFp7q3d768bKY5BcySZiQ2RBpqVVMICcnbRnUIE9d6QuEICMSoINfcwU68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmHZTvbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmHZTvbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5608CC4CEC3;
	Mon, 14 Oct 2024 15:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919962;
	bh=Ec93hXZF0LM9ZLpuxSTZ7zQO8Cl1cqhdcNFcmEaDZKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmHZTvbcD535J1plJk2FpDWMdGxGpBnUrsOrSxaoZx0pjQGu6e3ZZUw8lbTiYtumB
	 WXltTAaF4xOiMxRk2VzqNSBN2IXgio5ZoEil/gAM6sb6goTr8V5FbYjBJruT4sw80A
	 lBJclSaVtlA3ZKG1nfFqU2H93t7fGfmwAcmNWkI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 758/798] net: ibm/emac: allocate dummy net_device dynamically
Date: Mon, 14 Oct 2024 16:21:52 +0200
Message-ID: <20241014141247.847669086@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 2eb5e25d84956c264dc03fc45deb3701f3a0ccea ]

Embedding net_device into structures prohibits the usage of flexible
arrays in the net_device structure. For more details, see the discussion
at [1].

Un-embed the net_device from the private struct by converting it
into a pointer. Then use the leverage the new alloc_netdev_dummy()
helper to allocate and initialize dummy devices.

[1] https://lore.kernel.org/all/20240229225910.79e224cf@kernel.org/

Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 080ddc22f3b0 ("net: ibm: emac: mal: add dcr_unmap to _remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/mal.c | 14 +++++++++++---
 drivers/net/ethernet/ibm/emac/mal.h |  2 +-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index a93c9230e982f..7a74975c15fa5 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -603,9 +603,13 @@ static int mal_probe(struct platform_device *ofdev)
 	INIT_LIST_HEAD(&mal->list);
 	spin_lock_init(&mal->lock);
 
-	init_dummy_netdev(&mal->dummy_dev);
+	mal->dummy_dev = alloc_netdev_dummy(0);
+	if (!mal->dummy_dev) {
+		err = -ENOMEM;
+		goto fail_unmap;
+	}
 
-	netif_napi_add_weight(&mal->dummy_dev, &mal->napi, mal_poll,
+	netif_napi_add_weight(mal->dummy_dev, &mal->napi, mal_poll,
 			      CONFIG_IBM_EMAC_POLL_WEIGHT);
 
 	/* Load power-on reset defaults */
@@ -635,7 +639,7 @@ static int mal_probe(struct platform_device *ofdev)
 					  GFP_KERNEL);
 	if (mal->bd_virt == NULL) {
 		err = -ENOMEM;
-		goto fail_unmap;
+		goto fail_dummy;
 	}
 
 	for (i = 0; i < mal->num_tx_chans; ++i)
@@ -701,6 +705,8 @@ static int mal_probe(struct platform_device *ofdev)
 	free_irq(mal->serr_irq, mal);
  fail2:
 	dma_free_coherent(&ofdev->dev, bd_size, mal->bd_virt, mal->bd_dma);
+ fail_dummy:
+	free_netdev(mal->dummy_dev);
  fail_unmap:
 	dcr_unmap(mal->dcr_host, 0x100);
  fail:
@@ -732,6 +738,8 @@ static int mal_remove(struct platform_device *ofdev)
 
 	mal_reset(mal);
 
+	free_netdev(mal->dummy_dev);
+
 	dma_free_coherent(&ofdev->dev,
 			  sizeof(struct mal_descriptor) *
 			  (NUM_TX_BUFF * mal->num_tx_chans +
diff --git a/drivers/net/ethernet/ibm/emac/mal.h b/drivers/net/ethernet/ibm/emac/mal.h
index d212373a72e7c..e0ddc41186a28 100644
--- a/drivers/net/ethernet/ibm/emac/mal.h
+++ b/drivers/net/ethernet/ibm/emac/mal.h
@@ -205,7 +205,7 @@ struct mal_instance {
 	int			index;
 	spinlock_t		lock;
 
-	struct net_device	dummy_dev;
+	struct net_device	*dummy_dev;
 
 	unsigned int features;
 };
-- 
2.43.0



