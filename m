Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5430526D4C7;
	Tue, 11 Nov 2025 01:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823761; cv=none; b=CMumNt7RGPBwO6LQG2pPyNKdC3PXcP1fkk1cLImtvr3Z+jLedf09gGXOFziGyWX4GpeuTVez6T3t9BsuTCiSzWeYl3kvajXI0VbL8Uww57m4D0vsFYLDw+qcifupII0B0hUUqxDYSr2uXAaVdi1klYGGPxUaFdYC8t3lO1kP0wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823761; c=relaxed/simple;
	bh=r/n5asBX7EAJkbs3h7bj1JLLnYrBsKu9LuAq1oOhoos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOVosrjeZWCQYH37QrW9Cf/2Fi3FF+aG6gqbJ+hOhEyvLstQ98XP/nAvn05AH0XOIBAoZCSXi3/P9HjEbQJfCEqpUzkFZ71DE0ojjY7h9fY9qv308TkSQ+hzqbfLVmUlVlRqZ69QygZhzSUaYdNdfYjluB+EYN+Ox//eXzgOE7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqjYJS07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqjYJS07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E87C16AAE;
	Tue, 11 Nov 2025 01:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823761;
	bh=r/n5asBX7EAJkbs3h7bj1JLLnYrBsKu9LuAq1oOhoos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqjYJS07yP+5gtErKJ/JWxqP06md7daeZ9ebdtD3rcCNjMecLGq3PLJCvj1YPGgn2
	 9Ks44JggQZ/dMO2fc8MRV2k37g+BfsWLi2Sonb1RycZcsd7r9NZiMQLq6VfLoklfOb
	 KjU9Uby7WNBq/W6h/4iWJc7YFlwxwZslxnAYOG0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 364/849] net: phy: fixed_phy: let fixed_phy_unregister free the phy_device
Date: Tue, 11 Nov 2025 09:38:54 +0900
Message-ID: <20251111004545.220471135@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit a0f849c1cc6df0db9083b4c81c05a5456b1ed0fb ]

fixed_phy_register() creates and registers the phy_device. To be
symmetric, we should not only unregister, but also free the phy_device
in fixed_phy_unregister(). This allows to simplify code in users.

Note wrt of_phy_deregister_fixed_link():
put_device(&phydev->mdio.dev) and phy_device_free(phydev) are identical.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/ad8dda9a-10ed-4060-916b-3f13bdbb899d@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/dsa_loop.c  | 9 +++------
 drivers/net/mdio/of_mdio.c  | 1 -
 drivers/net/phy/fixed_phy.c | 1 +
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index d8a35f25a4c82..ad907287a853a 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -386,13 +386,10 @@ static struct mdio_driver dsa_loop_drv = {
 
 static void dsa_loop_phydevs_unregister(void)
 {
-	unsigned int i;
-
-	for (i = 0; i < NUM_FIXED_PHYS; i++)
-		if (!IS_ERR(phydevs[i])) {
+	for (int i = 0; i < NUM_FIXED_PHYS; i++) {
+		if (!IS_ERR(phydevs[i]))
 			fixed_phy_unregister(phydevs[i]);
-			phy_device_free(phydevs[i]);
-		}
+	}
 }
 
 static int __init dsa_loop_init(void)
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 98f667b121f7d..d8ca63ed87194 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -473,6 +473,5 @@ void of_phy_deregister_fixed_link(struct device_node *np)
 	fixed_phy_unregister(phydev);
 
 	put_device(&phydev->mdio.dev);	/* of_phy_find_device() */
-	phy_device_free(phydev);	/* fixed_phy_register() */
 }
 EXPORT_SYMBOL(of_phy_deregister_fixed_link);
diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 033656d574b89..b8bec7600ef8e 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -309,6 +309,7 @@ void fixed_phy_unregister(struct phy_device *phy)
 	phy_device_remove(phy);
 	of_node_put(phy->mdio.dev.of_node);
 	fixed_phy_del(phy->mdio.addr);
+	phy_device_free(phy);
 }
 EXPORT_SYMBOL_GPL(fixed_phy_unregister);
 
-- 
2.51.0



