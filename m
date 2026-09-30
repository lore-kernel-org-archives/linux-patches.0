Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1916951FCBB;
	Wed, 30 Sep 2026 17:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790314; cv=none; b=di887unwrpWjR6XY+9FwfauZPBYx6TFFI2zYbhez4e5SPPt9N9bCRMlaI0CUcCY2wuC07aKzv9PZEH20MK5FgLE056uSQ8jle/S5JEGAY3H3YIm82mqdH/nSLgHFKiLY1ok6FhG5mV6E2TMm0+F2wWh0TLxHEIfyHMxnT0O2Fjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790314; c=relaxed/simple;
	bh=2kpuZE9zrk1y3mk00Qp2z0Au1WTak/4wHulqUG/JBL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i+56UkZ8TZDRxKKQoQeEZwDvCkhewhhJTw+aGweHUYxmDc31vOyNEWhMTefc1wqJjKiNVVunFhe0wW3GQCxLvlo8BOTkXS/KsYjPo0DK/nP97C9ujjyHmSdtmX7L6l3iF2LP84zFsFMiFYW2BNa3W2nGqKJXOeuL3B4sQywtqPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9qXs0o0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9qXs0o0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747CD1F000FF;
	Wed, 30 Sep 2026 17:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790313;
	bh=7j66NbeOVcWjFttDVF578DqMHGdaDrHwp45izXBHNL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A9qXs0o0BeSmSHfrr0IBcvA9LWHb24MmbEzj/ndJNuSMUmuBF4pJk+xNi+NlqgEus
	 kT9Re5nyeqMqqzDktklfnbFDYznxbFvA4UmInmwDUUf1vr/Hwhk7W68iWISApyNjbR
	 zowY4GicL8y0dayZDfoC1ePg1AXRHIo+XmpuVll8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 740/877] net: macb: unify device pointer naming convention
Date: Wed, 30 Sep 2026 17:27:31 +0200
Message-ID: <20260930152430.659855592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit 07362f68e61d82ee53da0e9ae2c7f981c3538861 ]

Here are all device pointer variable permutations inside MACB:

   struct device *dev;
   struct net_device *dev;
   struct net_device *ndev;
   struct net_device *netdev;
   struct pci_dev *pdev;              // inside macb_pci.c
   struct phy_device *phy;
   struct phy_device *phydev;
   struct platform_device *pdev;
   struct platform_device *plat_dev;  // inside macb_pci.c

Unify to this convention:

   struct device *dev;
   struct net_device *netdev;
   struct pci_dev *pci;
   struct phy_device *phydev;
   struct platform_device *pdev;

Ensure nothing slipped through using ctags tooling:

⟩ ctags -o - --kinds-c='{local}{member}{parameter}' \
    --fields='{typeref}' drivers/net/ethernet/cadence/* | \
  awk -F"\t" '
    $NF~/struct:.*(device|dev) / {print $NF, $1}' | \
  sort -u
typeref:struct:device * dev
typeref:struct:in_device * idev        // ignored
typeref:struct:net_device * netdev
typeref:struct:pci_dev * pci
typeref:struct:phy_device * phydev
typeref:struct:platform_device * pdev

Also fix some printk() calls to use __func__ instead of hardcoding.
This silences some checkpatch.pl warnings and doesn't deserve a
separate commit.

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Link: https://patch.msgid.link/20260812-macb-context-v9-2-7ddbf5f715e0@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Backport note: retain only the dev-to-netdev rename in gem_ptp_init().
The target e1406330d70e ("net: macb: initialize PTP state before
registering clock") needs this spelling in its ptp_clock_register()
context; its macb_probe() hunk already applies to this stable tree.
Drop the unrelated driver-wide renames and logging cleanup. In
particular, do not import newer EEE, interrupt, DMA, queue, or probe
changes absent from this branch. This limited rename changes no
behavior and adds no functions.

[ sashal: Reduced backport -- upstream 07362f68e61d8 touches 4 file(s), this
  backport carries 1. Not backported here:
  drivers/net/ethernet/cadence/macb.h
  drivers/net/ethernet/cadence/macb_main.c
  drivers/net/ethernet/cadence/macb_pci.c
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: e1406330d70e ("net: macb: initialize PTP state before registering clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_ptp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -331,9 +331,9 @@ void gem_ptp_txstamp(struct macb *bp, st
 	skb_tstamp_tx(skb, &shhwtstamps);
 }
 
-void gem_ptp_init(struct net_device *dev)
+void gem_ptp_init(struct net_device *netdev)
 {
-	struct macb *bp = netdev_priv(dev);
+	struct macb *bp = netdev_priv(netdev);
 
 	bp->ptp_clock_info = gem_ptp_caps_template;
 
@@ -341,7 +341,7 @@ void gem_ptp_init(struct net_device *dev
 	bp->tsu_rate = bp->ptp_info->get_tsu_rate(bp);
 	bp->ptp_clock_info.max_adj = bp->ptp_info->get_ptp_max_adj();
 	gem_ptp_init_timer(bp);
-	bp->ptp_clock = ptp_clock_register(&bp->ptp_clock_info, &dev->dev);
+	bp->ptp_clock = ptp_clock_register(&bp->ptp_clock_info, &netdev->dev);
 	if (IS_ERR(bp->ptp_clock)) {
 		pr_err("ptp clock register failed: %ld\n",
 			PTR_ERR(bp->ptp_clock));


