Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B21034B415;
	Fri, 21 Nov 2025 13:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732567; cv=none; b=TbhioC5jY0R/a7J6tvjqw5Fpd0mw1/hCfkS2CAd0bmHVzCgKkCvZyLCj1X2w0ArHgXBVhl4BLUbyQ9yaVpco2CWKw5QJh/E+s9T+VJO36qLUS7S0UNKkXIJ8ZYAn7C8JaxvH4G25z47ayGdso7dd1fCCdtB3+jKUSQ9m4rzX3tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732567; c=relaxed/simple;
	bh=Q6xGHhB5mxAu14/5gVdOsS8Y+SCl0Qdm6HxRrtwKuXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqPOzHrN7PwbaFK3GJtObmhS3scZJaP/+YHJfvihvjpcDSQP9CjrDJL8xYYfJwW2vDXapuzvhtfzXhgZJiX0Oi9/dMpzX3FDS6iSiCrse1GcrObeIrJHFNIqipdMGSGRRSBfv+J1kzfWLtXCthamZuA9qcgi0MrMTwoCiVhau+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYe7lvmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYe7lvmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA82C4CEF1;
	Fri, 21 Nov 2025 13:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732567;
	bh=Q6xGHhB5mxAu14/5gVdOsS8Y+SCl0Qdm6HxRrtwKuXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYe7lvmSfjw6nh2hQXxqGPH+5cZCSLKXFOeRHyc/dhZ1w4iXZJBClmG9rMTxs0UBz
	 tmP52wl8vIbqZajyqwLZiB4uRq6Q+FbbiChvZWHK6ctdBbAZ91VZkpTdOP0PcLsX/p
	 zav/zcJCYJd9dOdJ/8g4WtCV/eYmyRp4o6pavco8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/529] net: phy: fixed_phy: let fixed_phy_unregister free the phy_device
Date: Fri, 21 Nov 2025 14:07:44 +0100
Message-ID: <20251121130236.890445915@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index 5b139f2206b6e..48cf9d300bbf5 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -378,13 +378,10 @@ static struct mdio_driver dsa_loop_drv = {
 
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
index 7eb32ebb846d8..15b72203a2584 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -440,6 +440,5 @@ void of_phy_deregister_fixed_link(struct device_node *np)
 	fixed_phy_unregister(phydev);
 
 	put_device(&phydev->mdio.dev);	/* of_phy_find_device() */
-	phy_device_free(phydev);	/* fixed_phy_register() */
 }
 EXPORT_SYMBOL(of_phy_deregister_fixed_link);
diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index aef739c20ac4d..4694fb3eaa2ff 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -329,6 +329,7 @@ void fixed_phy_unregister(struct phy_device *phy)
 	phy_device_remove(phy);
 	of_node_put(phy->mdio.dev.of_node);
 	fixed_phy_del(phy->mdio.addr);
+	phy_device_free(phy);
 }
 EXPORT_SYMBOL_GPL(fixed_phy_unregister);
 
-- 
2.51.0



