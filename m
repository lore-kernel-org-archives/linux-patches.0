Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60115374A0E;
	Thu, 17 Sep 2026 18:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670710; cv=none; b=qBsuGSyncubggv1ztHF9ZVC80kPNfoLpENFg4Ag8UzI6Pgi2rVlQb/lVB0KPGYkH+NqBy0V9ZdRr7s4bAqSQhjSTD+4I6GnutS2ST4DFEkO/ENmt8Sg67XIqebLl/B7PaMmuv2wkbVaWmNMRLkpQUKytimnAjhC9TQysBBSAUpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670710; c=relaxed/simple;
	bh=kXpuGDQk2/X8FEbfY6CHTyNCWnnyPkFDO6MQPfq3oWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJd8OL/0zVQ9Lq3FqbeoIXRMPNRNFKeK+g3mZRyJEywsw8oenuH3AtJzU08nMkzsps4LTKzu7mnnw5eowlUERwigYQsku/muuEXL5bapG8hfiDkViO45eTb0MvqwOXdp7BY8ViaZRsy2HUADNDIUYn6tw0YlE5K4srPBe475Ltg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8Gz9lH/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8Gz9lH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED471F000FF;
	Thu, 17 Sep 2026 18:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670708;
	bh=HmJy+OkcDkftZRfSTQbNrjtsuxajolp3DRbKGC88gdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8Gz9lH/W622muQZgZsUJUp6OnsUv5M0GOcZ9+e2qhDDe1uOXuVwlL8JxOuHc3Xw+
	 U3UrGIyCqh/qnQinzaK/VsTiflb6O56mb6VcmkJi2i1Zg83J1MtKUKd7a8tzv9L3ul
	 z4pG6lbMsy+zOcRJSXlHQHeQ+ZiiVMebVzPiIxGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0745/1102] net: macb: destroy the phylink instance on the probe error path
Date: Thu, 17 Sep 2026 16:11:28 +0100
Message-ID: <20260917151559.117024203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 7d059f390750152b9bd69df934198651b94fc26d ]

macb_mii_init() creates a phylink instance on both of its success paths,
but the probe unwind frees the netdev without destroying it, so a failing
macb_alloc_tieoff() or register_netdev() leaks the instance.

Destroy it at err_out_unregister_mdio, which is only reachable once
macb_mii_init() has succeeded, so bp->phylink is valid there.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260907210856.1673589-2-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e2e3f8d12fdbc..c8d098e8ca32a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5324,6 +5324,7 @@ static int macb_probe(struct platform_device *pdev)
 		mdiobus_unregister(bp->mii_bus);
 		mdiobus_free(bp->mii_bus);
 	}
+	phylink_destroy(bp->phylink);
 
 err_out_phy_exit:
 	phy_exit(bp->phy);
-- 
2.53.0



