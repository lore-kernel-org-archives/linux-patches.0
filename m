Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D6454705C;
	Wed, 30 Sep 2026 16:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785305; cv=none; b=ekzvC2j/sQgbphlE0AV1DWFQ0bghjJY2aVhFOyZN1GkPLTw2yZ+0BGUXgOxXvcIesVbhBCg9IkYjOsNbOl+pP+sQ8XjxyiFxBsg6eM7VQ4ISYN+sgl7HOjO2O9GllBUvkmxbyaOfMmisy/Ve1iFhzUQzOhpWoN43mdoxu314Q+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785305; c=relaxed/simple;
	bh=y0G474hQxXONaCL/2voIfQKuJaltjbZk9oJILBaI6dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mbhxwuu+06D4C9MiSY88A1xL8aOGO5GiXjWRAUddmSOFJDM33gWyl+/zWjs1fTSGY5yHONMym494tme+MTI0gor5XUWpo8nVqGHokaTuLXtnquEsEKMxRoaPWkcU2x6pRFccP0sZkE3br/HpSKKyBQeLKcR2XlHd97szDmsvEnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkM/vAlb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkM/vAlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C471F0089A;
	Wed, 30 Sep 2026 16:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785296;
	bh=07J4Ks4YY4QGoprRjUpLj0KoyVuzT8o2VpwYT/wRyNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VkM/vAlbpP6ESpsIT+NOGo3b3JZqpiQdowgOm8pGx5ZoD5yShcrgM9d++lBFWLQPW
	 8UQibsSsnmcRATuYW1/DpxXrewd0vZY/gromMtysXvbYSDx9jiDNmAMyGiVcmNVCxk
	 8rHZzCwhbvKnnIsXcIdPeywWxJlyhb0IGa3aa9ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 460/982] net: macb: destroy the phylink instance on the probe error path
Date: Wed, 30 Sep 2026 17:19:56 +0200
Message-ID: <20260930152426.668662768@linuxfoundation.org>
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
index ba9032c3542d9..61f85b54afc9c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5195,6 +5195,7 @@ static int macb_probe(struct platform_device *pdev)
 		mdiobus_unregister(bp->mii_bus);
 		mdiobus_free(bp->mii_bus);
 	}
+	phylink_destroy(bp->phylink);
 
 err_out_phy_exit:
 	phy_exit(bp->phy);
-- 
2.53.0



