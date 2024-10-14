Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B1A14AA9;
	Mon, 14 Oct 2024 15:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920124; cv=none; b=CtxRn3z+dG9CaIv46lEhQL7/7ipfFl8xhkIlgEdUpPQoaY5Kq3L2H0lTB1QF5/Bno1aq/282a07u/lXG0UOCba9LlkgN4m4Rj858yK38FuhLbcWMiHtmq+lh0W7nQBIBQNiPeQJeVV0sDA2jF/EdRowgVe/8p6krg0ZKpBTg24Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920124; c=relaxed/simple;
	bh=hY9btfJ5dbv8BVLeuQwZoGwaC4l9sYZ4Bh+GVJkapkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbBNNYEwmTyxJBXt2cOg7Q6fPiDDptwtWVjEiS6CJSCDXIYKOOL7pnZXBApxX+lcP8ItV0SiF2kdOQpg6VkLJLxX7Pc9nqorAbyF5ZOiqzk7T8IX3uUiRTttFttvuN3K7dQJMDaq/DSfO3muYMirU/MHsxywhljw9UIvTHA901o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cn7hgM8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cn7hgM8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36CEC4CEC3;
	Mon, 14 Oct 2024 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920124;
	bh=hY9btfJ5dbv8BVLeuQwZoGwaC4l9sYZ4Bh+GVJkapkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cn7hgM8dtpq/QfkvS4jRt/et0m0ZJHwygJ9+7eeuJ1FM1Zl9syorT2NiX/uoxGhoZ
	 zL8XrB/9rnFa9HdO2U41CH9RaN4SsPiSd677A8yd8IR+0yIcEuHcQb21gOGPJROlAW
	 vxaeM2GD9MpoWbbOJMIgWSFdARyUCQzjnk56rw10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 772/798] Revert "net: ibm/emac: allocate dummy net_device dynamically"
Date: Mon, 14 Oct 2024 16:22:06 +0200
Message-ID: <20241014141248.390237760@linuxfoundation.org>
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

This reverts commit b40eeedbbc0833716b5ccae64cf914f2604a3e5e, which was
upstream commit 2eb5e25d8495 ("net: ibm/emac: allocate dummy net_device
dynamically").

alloc_netdev_dummy(( does not exist in 6.1, so all this backport did was
break the build.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/mal.c | 14 +++-----------
 drivers/net/ethernet/ibm/emac/mal.h |  2 +-
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index 1ebe44804f9d0..f30a2b8a7c173 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -603,13 +603,9 @@ static int mal_probe(struct platform_device *ofdev)
 	INIT_LIST_HEAD(&mal->list);
 	spin_lock_init(&mal->lock);
 
-	mal->dummy_dev = alloc_netdev_dummy(0);
-	if (!mal->dummy_dev) {
-		err = -ENOMEM;
-		goto fail_unmap;
-	}
+	init_dummy_netdev(&mal->dummy_dev);
 
-	netif_napi_add_weight(mal->dummy_dev, &mal->napi, mal_poll,
+	netif_napi_add_weight(&mal->dummy_dev, &mal->napi, mal_poll,
 			      CONFIG_IBM_EMAC_POLL_WEIGHT);
 
 	/* Load power-on reset defaults */
@@ -639,7 +635,7 @@ static int mal_probe(struct platform_device *ofdev)
 					  GFP_KERNEL);
 	if (mal->bd_virt == NULL) {
 		err = -ENOMEM;
-		goto fail_dummy;
+		goto fail_unmap;
 	}
 
 	for (i = 0; i < mal->num_tx_chans; ++i)
@@ -705,8 +701,6 @@ static int mal_probe(struct platform_device *ofdev)
 	free_irq(mal->serr_irq, mal);
  fail2:
 	dma_free_coherent(&ofdev->dev, bd_size, mal->bd_virt, mal->bd_dma);
- fail_dummy:
-	free_netdev(mal->dummy_dev);
  fail_unmap:
 	dcr_unmap(mal->dcr_host, 0x100);
  fail:
@@ -738,8 +732,6 @@ static int mal_remove(struct platform_device *ofdev)
 
 	mal_reset(mal);
 
-	free_netdev(mal->dummy_dev);
-
 	dcr_unmap(mal->dcr_host, 0x100);
 
 	dma_free_coherent(&ofdev->dev,
diff --git a/drivers/net/ethernet/ibm/emac/mal.h b/drivers/net/ethernet/ibm/emac/mal.h
index e0ddc41186a28..d212373a72e7c 100644
--- a/drivers/net/ethernet/ibm/emac/mal.h
+++ b/drivers/net/ethernet/ibm/emac/mal.h
@@ -205,7 +205,7 @@ struct mal_instance {
 	int			index;
 	spinlock_t		lock;
 
-	struct net_device	*dummy_dev;
+	struct net_device	dummy_dev;
 
 	unsigned int features;
 };
-- 
2.43.0



