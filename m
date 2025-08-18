Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3A02E717D;
	Mon, 18 Aug 2025 13:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524841; cv=none; b=AB/WSRq7hDbSsKwxW0hyIfVXAHF932wk5y8gY4Oe64G/RV6PGpIepfTAvD2+7gM+MvZp7RL8yUSjeZewqB+W0y6F1wG8i6FYRG1mnCdh9VjjTLdy2yTsTCZO8Kal0U6pW42uCdBG+M1shCR4abEDezPk63kle4rQm++8Xd2lPUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524841; c=relaxed/simple;
	bh=fafiZWfeDY4pdpDKNsPFmEIXWZDLsPPht4/oP7zSl8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=riR5u/edmazayt0HogDCsf6yVeHziHnoYdlX4qp5vtf7NFQtNBEk2JMiv5VrW93Abv/12P+w2uR9+rf+a4jFCvbgLmEmB+VpyOlc1eGNSxXFkoLArjmBBgEHcPAsM/5s19VQe+VNxbRg50DJoaCKUTEd/j1a5dOYYmi67GY4ZAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUFyFbsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUFyFbsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895D1C4CEEB;
	Mon, 18 Aug 2025 13:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524840;
	bh=fafiZWfeDY4pdpDKNsPFmEIXWZDLsPPht4/oP7zSl8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUFyFbsSxk1LF3o7Zj3nmyoK1sXmucecrom6kD4bh+A8V+n6+rOtwJ6IVjq9Adbgv
	 G/LFcylifbnnyI97tkYkKatbAntCQT/UWuk8RPuOSf1bEpowHP9mUYWfKPHfjgZMwe
	 Ld3M8m13bvZQoEt14c3ssCP/KOb0PqM5mBc9PNQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
	Buday Csaba <buday.csaba@prolan.hu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 080/570] net: mdiobus: release reset_gpio in mdiobus_unregister_device()
Date: Mon, 18 Aug 2025 14:41:07 +0200
Message-ID: <20250818124508.901503987@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Buday Csaba <buday.csaba@prolan.hu>

[ Upstream commit 8ea25274ebaf2f6be8be374633b2ed8348ec0e70 ]

reset_gpio is claimed in mdiobus_register_device(), but it is not
released in mdiobus_unregister_device(). It is instead only
released when the whole MDIO bus is unregistered.
When a device uses the reset_gpio property, it becomes impossible
to unregister it and register it again, because the GPIO remains
claimed.
This patch resolves that issue.

Fixes: bafbdd527d56 ("phylib: Add device reset GPIO support") # see notes
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Cc: Csókás Bence <csokas.bence@prolan.hu>
[ csokas.bence: Resolve rebase conflict and clarify msg ]
Signed-off-by: Buday Csaba <buday.csaba@prolan.hu>
Link: https://patch.msgid.link/20250807135449.254254-2-csokas.bence@prolan.hu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c          | 1 +
 drivers/net/phy/mdio_bus_provider.c | 3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index fda2e27c1810..cad6ed3aa10b 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -91,6 +91,7 @@ int mdiobus_unregister_device(struct mdio_device *mdiodev)
 	if (mdiodev->bus->mdio_map[mdiodev->addr] != mdiodev)
 		return -EINVAL;
 
+	gpiod_put(mdiodev->reset_gpio);
 	reset_control_put(mdiodev->reset_ctrl);
 
 	mdiodev->bus->mdio_map[mdiodev->addr] = NULL;
diff --git a/drivers/net/phy/mdio_bus_provider.c b/drivers/net/phy/mdio_bus_provider.c
index 65850e36284d..5401170f14e5 100644
--- a/drivers/net/phy/mdio_bus_provider.c
+++ b/drivers/net/phy/mdio_bus_provider.c
@@ -444,9 +444,6 @@ void mdiobus_unregister(struct mii_bus *bus)
 		if (!mdiodev)
 			continue;
 
-		if (mdiodev->reset_gpio)
-			gpiod_put(mdiodev->reset_gpio);
-
 		mdiodev->device_remove(mdiodev);
 		mdiodev->device_free(mdiodev);
 	}
-- 
2.50.1



