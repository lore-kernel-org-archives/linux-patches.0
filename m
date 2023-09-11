Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9553013AC1
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D4FC433CD;
	Mon, 11 Sep 2023 15:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446150;
	bh=mLi0Uu84ne3seEo7ESlfczfWxXikSNQ5gb5bUL/CuEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iv/QJcHTtkpZGZ/2bjqqELg0NRlxAHXAOJlEzkZT54+hpvZXJI3KroepFUEGxKoe/
	 yhf8MFPd/pErVWCjvAgEcW93yqWenUzzhGE7kIKUd9xEXm5DVal1FNI8qbkDpu7uRU
	 in9YrPsSonmuGExTQ3DIugcXkgGyr54Sg1DzBWDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	Ivan Bornyakov <i.bornyakov@metrotek.ru>,
	Rob Herring <robh@kernel.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.1 599/600] treewide: Fix probing of devices in DT overlays
Date: Mon, 11 Sep 2023 15:50:32 +0200
Message-ID: <20230911134651.343027257@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 1a50d9403fb90cbe4dea0ec9fd0351d2ecbd8924 upstream.

When loading a DT overlay that creates a device, the device is not
probed, unless the DT overlay is unloaded and reloaded again.

After the recent refactoring to improve fw_devlink, it no longer depends
on the "compatible" property to identify which device tree nodes will
become struct devices.   fw_devlink now picks up dangling consumers
(consumers pointing to descendent device tree nodes of a device that
aren't converted to child devices) when a device is successfully bound
to a driver.  See __fw_devlink_pickup_dangling_consumers().

However, during DT overlay, a device's device tree node can have
sub-nodes added/removed without unbinding/rebinding the driver.  This
difference in behavior between the normal device instantiation and
probing flow vs. the DT overlay flow has a bunch of implications that
are pointed out elsewhere[1].  One of them is that the fw_devlink logic
to pick up dangling consumers is never exercised.

This patch solves the fw_devlink issue by marking all DT nodes added by
DT overlays with FWNODE_FLAG_NOT_DEVICE (fwnode that won't become
device), and by clearing the flag when a struct device is actually
created for the DT node.  This way, fw_devlink knows not to have
consumers waiting on these newly added DT nodes, and to propagate the
dependency to an ancestor DT node that has the corresponding struct
device.

Based on a patch by Saravana Kannan, which covered only platform and spi
devices.

[1] https://lore.kernel.org/r/CAGETcx_bkuFaLCiPrAWCPQz+w79ccDp6=9e881qmK=vx3hBMyg@mail.gmail.com

Fixes: 4a032827daa89350 ("of: property: Simplify of_link_to_phandle()")
Link: https://lore.kernel.org/r/CAGETcx_+rhHvaC_HJXGrr5_WAd2+k5f=rWYnkCZ6z5bGX-wj4w@mail.gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Mark Brown <broonie@kernel.org>
Acked-by: Wolfram Sang <wsa@kernel.org> # for I2C
Acked-by: Shawn Guo <shawnguo@kernel.org>
Acked-by: Saravana Kannan <saravanak@google.com>
Tested-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
Link: https://lore.kernel.org/r/e1fa546682ea4c8474ff997ab6244c5e11b6f8bc.1680182615.git.geert+renesas@glider.be
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/imx-weim.c    |    6 ++++++
 drivers/i2c/i2c-core-of.c |    5 +++++
 drivers/of/dynamic.c      |    1 +
 drivers/of/platform.c     |    5 +++++
 drivers/spi/spi.c         |    5 +++++
 5 files changed, 22 insertions(+)

--- a/drivers/bus/imx-weim.c
+++ b/drivers/bus/imx-weim.c
@@ -331,6 +331,12 @@ static int of_weim_notify(struct notifie
 				 "Failed to setup timing for '%pOF'\n", rd->dn);
 
 		if (!of_node_check_flag(rd->dn, OF_POPULATED)) {
+			/*
+			 * Clear the flag before adding the device so that
+			 * fw_devlink doesn't skip adding consumers to this
+			 * device.
+			 */
+			rd->dn->fwnode.flags &= ~FWNODE_FLAG_NOT_DEVICE;
 			if (!of_platform_device_create(rd->dn, NULL, &pdev->dev)) {
 				dev_err(&pdev->dev,
 					"Failed to create child device '%pOF'\n",
--- a/drivers/i2c/i2c-core-of.c
+++ b/drivers/i2c/i2c-core-of.c
@@ -244,6 +244,11 @@ static int of_i2c_notify(struct notifier
 			return NOTIFY_OK;
 		}
 
+		/*
+		 * Clear the flag before adding the device so that fw_devlink
+		 * doesn't skip adding consumers to this device.
+		 */
+		rd->dn->fwnode.flags &= ~FWNODE_FLAG_NOT_DEVICE;
 		client = of_i2c_register_device(adap, rd->dn);
 		if (IS_ERR(client)) {
 			dev_err(&adap->dev, "failed to create client for '%pOF'\n",
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -225,6 +225,7 @@ static void __of_attach_node(struct devi
 	np->sibling = np->parent->child;
 	np->parent->child = np;
 	of_node_clear_flag(np, OF_DETACHED);
+	np->fwnode.flags |= FWNODE_FLAG_NOT_DEVICE;
 }
 
 /**
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -741,6 +741,11 @@ static int of_platform_notify(struct not
 		if (of_node_check_flag(rd->dn, OF_POPULATED))
 			return NOTIFY_OK;
 
+		/*
+		 * Clear the flag before adding the device so that fw_devlink
+		 * doesn't skip adding consumers to this device.
+		 */
+		rd->dn->fwnode.flags &= ~FWNODE_FLAG_NOT_DEVICE;
 		/* pdev_parent may be NULL when no bus platform device */
 		pdev_parent = of_find_device_by_node(rd->dn->parent);
 		pdev = of_platform_device_create(rd->dn, NULL,
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -4370,6 +4370,11 @@ static int of_spi_notify(struct notifier
 			return NOTIFY_OK;
 		}
 
+		/*
+		 * Clear the flag before adding the device so that fw_devlink
+		 * doesn't skip adding consumers to this device.
+		 */
+		rd->dn->fwnode.flags &= ~FWNODE_FLAG_NOT_DEVICE;
 		spi = of_register_spi_device(ctlr, rd->dn);
 		put_device(&ctlr->dev);
 


