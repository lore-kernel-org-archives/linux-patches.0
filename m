Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410CF8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9B2C433D2;
	Tue, 28 Mar 2023 14:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015429;
	bh=Bf8r+lBaYO4Qd16Br9uPru4EPAgU/2weusegXFFDtlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nu/f6EcnmxGWDhQe8d2vIomVBf/LHzV/PnUqz+tbN5cYRDSoIdpxMNnE+r+qp5mk5
	 JRGwCHwKhTaq64MpIH0VeBnch63yaCbXCCOU9HCLdtdy08S3XsQx9SuzTYy2WoD4Qp
	 hi5Ul4LSUv39umo9eBRHeTjXTaQ7Gh8ATnzV6BGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Bizon <mbizon@freebox.fr>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/224] net: mdio: fix owner field for mdio buses registered using ACPI
Date: Tue, 28 Mar 2023 16:40:40 +0200
Message-Id: <20230328142619.200316630@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 30b605b8501e321f79e19c3238aa6ca31da6087c ]

Bus ownership is wrong when using acpi_mdiobus_register() to register an
mdio bus. That function is not inline, so when it calls
mdiobus_register() the wrong THIS_MODULE value is captured.

CC: Maxime Bizon <mbizon@freebox.fr>
Fixes: 803ca24d2f92 ("net: mdio: Add ACPI support code for mdio")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/acpi_mdio.c | 10 ++++++----
 include/linux/acpi_mdio.h    |  9 ++++++++-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/mdio/acpi_mdio.c b/drivers/net/mdio/acpi_mdio.c
index d77c987fda9cd..4630dde019749 100644
--- a/drivers/net/mdio/acpi_mdio.c
+++ b/drivers/net/mdio/acpi_mdio.c
@@ -18,16 +18,18 @@ MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
 MODULE_LICENSE("GPL");
 
 /**
- * acpi_mdiobus_register - Register mii_bus and create PHYs from the ACPI ASL.
+ * __acpi_mdiobus_register - Register mii_bus and create PHYs from the ACPI ASL.
  * @mdio: pointer to mii_bus structure
  * @fwnode: pointer to fwnode of MDIO bus. This fwnode is expected to represent
+ * @owner: module owning this @mdio object.
  * an ACPI device object corresponding to the MDIO bus and its children are
  * expected to correspond to the PHY devices on that bus.
  *
  * This function registers the mii_bus structure and registers a phy_device
  * for each child node of @fwnode.
  */
-int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
+int __acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode,
+			    struct module *owner)
 {
 	struct fwnode_handle *child;
 	u32 addr;
@@ -35,7 +37,7 @@ int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
 
 	/* Mask out all PHYs from auto probing. */
 	mdio->phy_mask = GENMASK(31, 0);
-	ret = mdiobus_register(mdio);
+	ret = __mdiobus_register(mdio, owner);
 	if (ret)
 		return ret;
 
@@ -55,4 +57,4 @@ int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(acpi_mdiobus_register);
+EXPORT_SYMBOL(__acpi_mdiobus_register);
diff --git a/include/linux/acpi_mdio.h b/include/linux/acpi_mdio.h
index 0a24ab7cb66fa..8e2eefa9fbc0f 100644
--- a/include/linux/acpi_mdio.h
+++ b/include/linux/acpi_mdio.h
@@ -9,7 +9,14 @@
 #include <linux/phy.h>
 
 #if IS_ENABLED(CONFIG_ACPI_MDIO)
-int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
+int __acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode,
+			    struct module *owner);
+
+static inline int
+acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *handle)
+{
+	return __acpi_mdiobus_register(mdio, handle, THIS_MODULE);
+}
 #else /* CONFIG_ACPI_MDIO */
 static inline int
 acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
-- 
2.39.2



