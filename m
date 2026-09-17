Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B644E4C45;
	Thu, 17 Sep 2026 15:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659828; cv=none; b=NSeB/m+fHUJCGa8ZM8MjC3syTK61h/Be1vDuuBHcs6pEQyI8Sg1R6JGoSBbUKmiiQoEESHJYwICjuKx0KS0L71VPi8XvlCAHf4YR1BSLdc73m3BL10azEWRy0ho/p28p9KzeMXWasimR1pqiuuD29IFXO97Y6zJsV7UyyBVeI78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659828; c=relaxed/simple;
	bh=Ci0FAVqPP+eIRZE4HM/J8mD9ZxPaY6tRcUMv5tagreg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhwyOTLfH0/q6eOINKRXRAXXhcFKyh3TDjUatkEnAiEXpVKhZEE87ShRY+HoDfjKUMUbymqrPFMEHvoQli8bxgGF4u/X0L2/I11zUMwncmv6zVvDSQScupGVbmKaX5tzD/5a4wmUE5iXVu7SNXRFXCpz51kDtyg5eiCDFoE0LbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMHG9Ru8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMHG9Ru8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B0B1F00898;
	Thu, 17 Sep 2026 15:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659820;
	bh=+81oyHQjjstbGMItcTkZAJJX/7ZZWp4aZC76WrtS4Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kMHG9Ru8mpzUcFAfjvSHirSGYjqAGUvzD8HcWNzEzKSNCYgiIvOxbEamIYybkTVPP
	 jsQUjP5nSE52x3zhUrlu+lPWMXS6H2HOXolqg54ouxHpfTs5A0951PatZvA1wONbNs
	 E7Myq7DVBArEVM5oKM1hmaywayt4jpbgA6bwLd/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 386/733] net: macb: put the "mdio" child node reference on success
Date: Thu, 17 Sep 2026 16:11:34 +0100
Message-ID: <20260917151401.311838105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 382a373d9ea7a6ac4de9c022385b6217f65ae3cc ]

macb_mii_init() holds the reference returned by of_get_child_by_name()
for macb_mdiobus_register() and drops it only on the error paths, so
every successful probe leaks a node reference. On a CM5, overlay
removal after four bind cycles reports

  OF: ERROR: memory leak, expected refcount 1 instead of 5

Drop the reference after registration, where __mdiobus_register() has
already taken its own for the lifetime of the bus.

Fixes: 8a6631f1cece ("net: macb: avoid redundant lookup for "mdio" child node in MDIO setup")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260907210856.1673589-3-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 404aebe01ed01..9a59dd0df61a9 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1164,6 +1164,8 @@ static int macb_mii_init(struct macb *bp)
 	if (err)
 		goto err_out_unregister_bus;
 
+	of_node_put(mdio_np);
+
 	return 0;
 
 err_out_unregister_bus:
-- 
2.53.0



