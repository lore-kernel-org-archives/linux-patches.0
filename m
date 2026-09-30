Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D705F3DD86F;
	Wed, 30 Sep 2026 19:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796167; cv=none; b=toRHLTAC+vMHbr647bcLnh9DDlc+NKEJT9UEar8YehNI1mwLiaLDoz4hcG1BxvSyVYYdaOL/m3sFPD5e9UdqWyolJ6VQnW1X11UEoAVp11fdTMIXugaEF/bUPNWaF0zNIHxyK0YUYCzddI9Wz6PlOFxRyxFn2jZPpzUxgtda1ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796167; c=relaxed/simple;
	bh=CncCImA/kpvK97qYBf3FGlDIykbYeivKg1P1KpW55q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3ypykYe7JryADSSItFPo1nkGxPNdHmu5drrv4H6fcLIzDZvuHUi0PXE88dAGS8klsTsK31PciJ265mETd0YZPtD8Zciyi638du6qdM8vuymjkjVPIqNDSqIAs/7U2xeBRXnrkIwteBJ7BgI8Vp1Gq/2tRO4gxsBWI0j2wxWNGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3wAKpo9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3wAKpo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55CB1F000FF;
	Wed, 30 Sep 2026 19:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796165;
	bh=M/lRgoijyGSw8+zBdQrE3gV/i3rVYDzD5oKYJ/AS0OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s3wAKpo9PZgG3dLxQO8H2QPW7FuJ4rJZmHnrOUuKrZ0D2lPJzGrPBvxZ7TC8U8Csy
	 IePxWEWqyQQ6L2JVpYzO1gTsdtae0taX45gW0HRumt1gQHFouO+/Ds76sNnII3hV7U
	 xiKftNUh28YkJijV1goiAQmKFH/SiMi3TElSms0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yige Jiang <yigejiang86@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0818/1193] net: netsec: fix device_node reference leak on phy_np
Date: Wed, 30 Sep 2026 17:25:02 +0200
Message-ID: <20260930152452.419733337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index b834b129639f0..7389efcdde0b4 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -2144,6 +2144,7 @@ static int netsec_probe(struct platform_device *pdev)
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 free_ndev:
+	of_node_put(priv->phy_np);
 	free_netdev(ndev);
 	dev_err(&pdev->dev, "init failed\n");
 
@@ -2161,6 +2162,7 @@ static int netsec_remove(struct platform_device *pdev)
 	netif_napi_del(&priv->napi);
 
 	pm_runtime_disable(&pdev->dev);
+	of_node_put(priv->phy_np);
 	free_netdev(priv->ndev);
 
 	return 0;
-- 
2.53.0



