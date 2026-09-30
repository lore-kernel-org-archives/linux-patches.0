Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D34E4F30C4;
	Wed, 30 Sep 2026 16:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785230; cv=none; b=tDkHYLYKAq6V8HLFziIS+PpA9fowNpzIEpGCOn9U59OIqT+51Or3wvqkpqgAOvgJSGH4xGnSJMsrjnuBMdf7qzn9RLwjPHeUezN8KNAzu1//KwGPJElvfhiQbTZLw/U1dpIcIgicgZ5v+iptYHd0LPGS5b0A8iImulsOcUEO2Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785230; c=relaxed/simple;
	bh=nMHKp8O0jIH6BfPWEXnJoRM1urAvJZo7eb+2EaP8jrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gosv2xWduKLB5QAqibsaD3kL9iknGmO8cw37mmfWiuTALSuvogWjQAnbIlhB88Wsh2cIb2m4R2QluLbsP4z2uXgmmwXXOYCn1hfLoCupUyJ8/XQgOCffGPxzIjbdmGsp2zr8fnK7tmtFvSyirdQ1ez7rJYrA7tTK29uj5cY4Pyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOqRlyQt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOqRlyQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9837B1F00893;
	Wed, 30 Sep 2026 16:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785223;
	bh=N+34bOqHRvT625L/EFfNTClZfeClTNLXraL0Lmp4O60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOqRlyQtbs50EpaxN1cy0IB7MjLD9PqoaQXfcRU7M1gcRDOyYuV4fBQ8k4ll8hs/i
	 bdQNWH6X6fDY4/nI2b5eXotm0T65QuFY0ihUZ4nvq0wALOzw1z9TakbC488pZ96p78
	 rrZGRdSll9zdf8V0qIgHjQt/e8gup9NlHEeBYBGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Karumanchi <vineeth.karumanchi@amd.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 432/982] net: macb: fix NULL pointer dereference on unbind with fixed-link
Date: Wed, 30 Sep 2026 17:19:28 +0200
Message-ID: <20260930152426.075479359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineeth Karumanchi <vineeth.karumanchi@amd.com>

[ Upstream commit 38b6be101006d3e7af972999f45d4f1e8250587a ]

When the device tree describes a fixed-link and has no "mdio" child
node, macb_mii_init() returns early without allocating the MDIO bus,
leaving bp->mii_bus as NULL.

Two cleanup paths then dereference this NULL bus:

1. On driver unbind, macb_remove() unconditionally calls
   mdiobus_unregister(bp->mii_bus), which oopses:

  Unable to handle kernel NULL pointer dereference at virtual address 00000000000004a8
  pc : mdiobus_unregister+0x14/0xa4
  lr : macb_remove+0x38/0xa4
  Call trace:
   mdiobus_unregister+0x14/0xa4 (P)
   macb_remove+0x38/0xa4
   platform_remove+0x20/0x30
   device_release_driver_internal+0x1c8/0x224
   unbind_store+0xb4/0xbc

2. On the probe error path in macb_probe(), reached when
   macb_mii_init() has succeeded but a subsequent step fails, the
   err_out_unregister_mdio label runs the same unconditional cleanup.

mdiobus_unregister() and mdiobus_free() do not guard against a NULL
bus, so guard the calls in both macb_remove() and the probe error
path.

Fixes: d0c3601f2c4e ("net: macb: Avoid 20s boot delay by skipping MDIO bus registration for fixed-link PHY")
Signed-off-by: Vineeth Karumanchi <vineeth.karumanchi@amd.com>
Reviewed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260902102836.2019355-1-vineeth.karumanchi@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e33ff04797f7d..ba9032c3542d9 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5191,8 +5191,10 @@ static int macb_probe(struct platform_device *pdev)
 	return 0;
 
 err_out_unregister_mdio:
-	mdiobus_unregister(bp->mii_bus);
-	mdiobus_free(bp->mii_bus);
+	if (bp->mii_bus) {
+		mdiobus_unregister(bp->mii_bus);
+		mdiobus_free(bp->mii_bus);
+	}
 
 err_out_phy_exit:
 	phy_exit(bp->phy);
@@ -5220,8 +5222,10 @@ static int macb_remove(struct platform_device *pdev)
 		bp = netdev_priv(dev);
 		unregister_netdev(dev);
 		phy_exit(bp->phy);
-		mdiobus_unregister(bp->mii_bus);
-		mdiobus_free(bp->mii_bus);
+		if (bp->mii_bus) {
+			mdiobus_unregister(bp->mii_bus);
+			mdiobus_free(bp->mii_bus);
+		}
 
 		tasklet_kill(&bp->hresp_err_tasklet);
 		pm_runtime_disable(&pdev->dev);
-- 
2.53.0



