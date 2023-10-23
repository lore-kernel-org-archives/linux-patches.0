Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB78101D9
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0HGtIC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFA6C433C7;
	Mon, 23 Oct 2023 11:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061645;
	bh=c/huPisZ/7Z69OLoRa2oVbcpZXQ4mHbnjTeT3c3iQgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0HGtIC+QK0z8xD7aRzZabKvOvqgYjXbP+yidXKUpCFjQAXtpIob4CifkxGQPd8OO
	 bYOYXXFR7FOWpPCscul+9z32G4aR0wAUMnn2N3KIavF8CP7CGwTBpKLs7Sxcyr3j6d
	 2BwpOnjX21uXssWBxNSKwRJQ966J1WM2kmPxvnHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 116/202] net: dsa: bcm_sf2: Fix possible memory leak in bcm_sf2_mdio_register()
Date: Mon, 23 Oct 2023 12:57:03 +0200
Message-ID: <20231023104829.924372650@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 61b40cefe51af005c72dbdcf975a3d166c6e6406 upstream.

In bcm_sf2_mdio_register(), the class_find_device() will call get_device()
to increment reference count for priv->master_mii_bus->dev if
of_mdio_find_bus() succeeds. If mdiobus_alloc() or mdiobus_register()
fails, it will call get_device() twice without decrement reference count
for the device. And it is the same if bcm_sf2_mdio_register() succeeds but
fails in bcm_sf2_sw_probe(), or if bcm_sf2_sw_probe() succeeds. If the
reference count has not decremented to zero, the dev related resource will
not be freed.

So remove the get_device() in bcm_sf2_mdio_register(), and call
put_device() if mdiobus_alloc() or mdiobus_register() fails and in
bcm_sf2_mdio_unregister() to solve the issue.

And as Simon suggested, unwind from errors for bcm_sf2_mdio_register() and
just return 0 if it succeeds to make it cleaner.

Fixes: 461cd1b03e32 ("net: dsa: bcm_sf2: Register our slave MDIO bus")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Simon Horman <horms@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20231011032419.2423290-1-ruanjinjie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/bcm_sf2.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -497,17 +497,16 @@ static int bcm_sf2_mdio_register(struct
 	dn = of_find_compatible_node(NULL, NULL, "brcm,unimac-mdio");
 	priv->master_mii_bus = of_mdio_find_bus(dn);
 	if (!priv->master_mii_bus) {
-		of_node_put(dn);
-		return -EPROBE_DEFER;
+		err = -EPROBE_DEFER;
+		goto err_of_node_put;
 	}
 
-	get_device(&priv->master_mii_bus->dev);
 	priv->master_mii_dn = dn;
 
 	priv->slave_mii_bus = mdiobus_alloc();
 	if (!priv->slave_mii_bus) {
-		of_node_put(dn);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_put_master_mii_bus_dev;
 	}
 
 	priv->slave_mii_bus->priv = priv;
@@ -564,11 +563,17 @@ static int bcm_sf2_mdio_register(struct
 	}
 
 	err = mdiobus_register(priv->slave_mii_bus);
-	if (err && dn) {
-		mdiobus_free(priv->slave_mii_bus);
-		of_node_put(dn);
-	}
+	if (err && dn)
+		goto err_free_slave_mii_bus;
+
+	return 0;
 
+err_free_slave_mii_bus:
+	mdiobus_free(priv->slave_mii_bus);
+err_put_master_mii_bus_dev:
+	put_device(&priv->master_mii_bus->dev);
+err_of_node_put:
+	of_node_put(dn);
 	return err;
 }
 
@@ -576,6 +581,7 @@ static void bcm_sf2_mdio_unregister(stru
 {
 	mdiobus_unregister(priv->slave_mii_bus);
 	mdiobus_free(priv->slave_mii_bus);
+	put_device(&priv->master_mii_bus->dev);
 	of_node_put(priv->master_mii_dn);
 }
 


