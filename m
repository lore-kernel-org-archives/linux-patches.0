Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3C453B356;
	Wed, 23 Sep 2026 14:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174727; cv=none; b=ZydOU4irSf+SOnMmH+3Yk1ftj+uAABteRK5prGEB8LI/wGuqPVVQlvAD4fmhyaJPlzbnaPTKhtZlLtrYdwWTSpB8Dm/YkQQU6yK078Hb7estEAzCrTKdfozi98XZM58HE2p08NNkMt/wbV2siNl8EYwGZXPnoNLq/2ngoe1c7n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174727; c=relaxed/simple;
	bh=R9QgQijAIcqr5ijFE4eDCDvb167fCqAG3IhQ9b56Q98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OplpbK4LWp6/Sl/LOTB6OV55rOBwW7srBRfpdwJedGSDrMWvtJlWryRQOe5nz+Ku9WtoHsjrXYJTWZhuFUYRd+ZeVwIIOW6YEKFmWQ18RM6J6fXhIs+JRYfzgbsPkRtDE32JlfcXn68ImBP2Ph4JI5RxilvBUQiRytGdYMZVBE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fr9zZISP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fr9zZISP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1531A1F000FF;
	Wed, 23 Sep 2026 14:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174725;
	bh=cHQWvhuJD/jnsj9sqYrgPmOKNoQVLaV/Sc96CWfH/3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fr9zZISPuw5OLOyLWoCCfLoPcq58mSBqHfkoyhlH3IS1292Pu4fGDgULrIr9xciGD
	 /AWpJjSSc+uhDat3KdNr4FtzPfPnehXjVqfvbZfypqvV+J5A1dulCeUA5CIW44cRSb
	 wNqXafdE9loV40TWhePTzkH7MZQCygIflWLj7zHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yige Jiang <yigejiang86@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 175/398] net: netsec: fix device_node reference leak on phy_np
Date: Wed, 23 Sep 2026 16:04:09 +0200
Message-ID: <20260923140647.969635939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Yige Jiang <yigejiang86@gmail.com>

[ Upstream commit 5ae916fabca141b79b32e2e57f3c915c0f1e1b2e ]

netsec_of_probe() takes a reference on the PHY device_node with
of_parse_phandle() and stores it in priv->phy_np, but the driver never
drops it.  One device_node reference is leaked per probe, on the success
path as well as on every error path reached after netsec_of_probe().

Neither consumer takes ownership.  of_mdio_parse_addr() is a static
inline taking a const struct device_node * that only reads the "reg"
property.  of_phy_connect() borrows as well: of_phy_get_and_connect() in
drivers/net/mdio/of_mdio.c brackets its own call with of_node_get() at
:364 and of_node_put() at :373, which would be a double put if
of_phy_connect() consumed the reference.

The node is still in use at netsec_netdev_open() time, where it is
passed to of_phy_connect(), so it has device lifetime.  Release it at
the probe error label, which every failure path after the acquire
funnels through, and in netsec_remove().  Both releases precede
free_netdev(), since priv is netdev_priv(ndev).  The ACPI probe path
leaves priv->phy_np NULL and of_node_put(NULL) is a no-op.

There is no end-user visible symptom on currently supported platforms:
a device_node is only freed once OF_DYNAMIC is enabled and the node has
been detached, so on a static device tree the imbalance is inert.  It is
observable as a refcount that grows across bind/unbind cycles, and would
matter under device tree overlays.

Found by static analysis of reference acquire/release pairing rather
than from a runtime report.  No reproducer was produced and the change
has not been runtime tested; it is compile-tested only (arm64,
CONFIG_SNI_NETSEC=m via COMPILE_TEST).

Fixes: 533dd11a12f6 ("net: socionext: Add Synquacer NetSec driver")
Signed-off-by: Yige Jiang <yigejiang86@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260913064102.37452-1-yigejiang86@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index ee890de69ffe7..a432eb354049c 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -2149,6 +2149,7 @@ static int netsec_probe(struct platform_device *pdev)
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 free_ndev:
+	of_node_put(priv->phy_np);
 	free_netdev(ndev);
 	dev_err(&pdev->dev, "init failed\n");
 
@@ -2166,6 +2167,7 @@ static void netsec_remove(struct platform_device *pdev)
 	netif_napi_del(&priv->napi);
 
 	pm_runtime_disable(&pdev->dev);
+	of_node_put(priv->phy_np);
 	free_netdev(priv->ndev);
 }
 
-- 
2.53.0



