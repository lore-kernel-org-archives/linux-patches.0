Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EAE3C1986;
	Wed, 30 Sep 2026 19:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795428; cv=none; b=Ho5ync4tSGF0xeg5LTyV23e6bxTj3kf5O/WecrJflXsYaPmqw5pDvrqMG8fskfirUr9/A/Q1IwYjN3HzYQ2A518QmQKZaE8tuODVVGJtyoHkhyXn/RLi+k8nMQYlTec+QH349FSdWXIOJEk7rmtEn/95VHO1MGiLEhFOpe9vVaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795428; c=relaxed/simple;
	bh=OQU6Q864jT46wZ40yKI/Bw0koov3HVXh417TMjOz0t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ancBRiMzpjwmcA3xnImh4D/KHGv7U6HxOtyl200umKXocFUVI0FLf7ikBC/awF9mXGhk6mGMpNP9nbGGj68ZX5lMazPFcc9aPPUJITB4bO7yNAUtd6GyianE9nuhS7W91vGi/zXCLBFIfpN5z/RKUnVzKF0Th4Accu6ME2fLh/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmIGJcmD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmIGJcmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F021F000FF;
	Wed, 30 Sep 2026 19:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795427;
	bh=YuQYJZ1KsYvfu2eYoMJvfDvD6ULgRau6v2Oh0DacJs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmIGJcmDfaztAwCNMFRvObXtCELQGupUNw1iETFzlO0VUPnc29OwSCemgulZRzeQZ
	 I7AMUGGJ/qdxLiL1Qhv5Mg6kjux6Cf4sRImsCMjBNyh8XOfMllXa0dcuYpcQVkDt+U
	 xpecwqq3O1craehoZsO4KB7aJNUwusUntLpTKGtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0556/1193] net: macb: destroy the phylink instance on the probe error path
Date: Wed, 30 Sep 2026 17:20:40 +0200
Message-ID: <20260930152446.589443164@linuxfoundation.org>
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
index 7642829240151..1dfd199cb97d3 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5309,6 +5309,7 @@ static int macb_probe(struct platform_device *pdev)
 		mdiobus_unregister(bp->mii_bus);
 		mdiobus_free(bp->mii_bus);
 	}
+	phylink_destroy(bp->phylink);
 
 err_out_phy_exit:
 	phy_exit(bp->phy);
-- 
2.53.0



