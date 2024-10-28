Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC1D18E779;
	Mon, 28 Oct 2024 06:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097837; cv=none; b=j6gU9jVlje2Z/E31XdrbKgntmyxOSW1q4pL4djtN+e95QxzC7C9/NE72Z1oFl4i8AP1iGyudJYyNMS6+Y7Z3Ulqkd629TAUdTUGZDni8HakARbfk1sUh5Z6NUXPzpqRXRWQP43I5L2DPZBQIvezxObP+vxqwZ7ne4k3e5qdQB6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097837; c=relaxed/simple;
	bh=dBzZx1wITAc54GpB65+c6eQmygu1ya4I2/33tDtqdDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS2F2okTvdf92Bd6IvL0GQXJx9BIOM+L4+x3jz4M3DkywFzmu5rY6/1t1NIMp3NzE3wLNAD94CMxqnXkbR5gndMcOydS6ILv8eYxyfLG/Mbq4NuWJnOWFtTS6reOBS9OM20lB9UdU3zafOCx4+AnRnkX+bg1Uqp4O5uNQYpkC4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnpM+k7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnpM+k7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E25DC4CEE8;
	Mon, 28 Oct 2024 06:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097837;
	bh=dBzZx1wITAc54GpB65+c6eQmygu1ya4I2/33tDtqdDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnpM+k7mh8ZjrDlArbeJqM6zc6v62ld3GoFu+NN5o0DQuEumK63iyS0pNAhBoSqHg
	 8CvFTACWjJZf/BYEHRVkLat6v6tchhl9H8b+dKauNFiYJqSKMPZmSPmwyEVBX56RfG
	 zNYJA7MyuA6YJ57GMrhNqjKAGscZjCuSFtnR+QYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 142/208] fsl/fman: Save device references taken in mac_probe()
Date: Mon, 28 Oct 2024 07:25:22 +0100
Message-ID: <20241028062310.130358813@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit efeddd552ec6767e4c8884caa516ac80b65f8823 ]

In mac_probe() there are calls to of_find_device_by_node() which takes
references to of_dev->dev. These references are not saved and not released
later on error path in mac_probe() and in mac_remove().

Add new fields into mac_device structure to save references taken for
future use in mac_probe() and mac_remove().

This is a preparation for further reference leaks fix.

Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 1dec67e0d9fb ("fsl/fman: Fix refcount handling of fman-related devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fman/mac.c | 6 ++++--
 drivers/net/ethernet/freescale/fman/mac.h | 6 +++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 9767586b4eb32..9b863db0bf087 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -197,6 +197,7 @@ static int mac_probe(struct platform_device *_of_dev)
 		err = -EINVAL;
 		goto _return_of_node_put;
 	}
+	mac_dev->fman_dev = &of_dev->dev;
 
 	/* Get the FMan cell-index */
 	err = of_property_read_u32(dev_node, "cell-index", &val);
@@ -208,7 +209,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	/* cell-index 0 => FMan id 1 */
 	fman_id = (u8)(val + 1);
 
-	priv->fman = fman_bind(&of_dev->dev);
+	priv->fman = fman_bind(mac_dev->fman_dev);
 	if (!priv->fman) {
 		dev_err(dev, "fman_bind(%pOF) failed\n", dev_node);
 		err = -ENODEV;
@@ -284,8 +285,9 @@ static int mac_probe(struct platform_device *_of_dev)
 			err = -EINVAL;
 			goto _return_of_node_put;
 		}
+		mac_dev->fman_port_devs[i] = &of_dev->dev;
 
-		mac_dev->port[i] = fman_port_bind(&of_dev->dev);
+		mac_dev->port[i] = fman_port_bind(mac_dev->fman_port_devs[i]);
 		if (!mac_dev->port[i]) {
 			dev_err(dev, "dev_get_drvdata(%pOF) failed\n",
 				dev_node);
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index fe747915cc737..8b5b43d50f8ef 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -19,12 +19,13 @@
 struct fman_mac;
 struct mac_priv_s;
 
+#define PORT_NUM 2
 struct mac_device {
 	void __iomem		*vaddr;
 	struct device		*dev;
 	struct resource		*res;
 	u8			 addr[ETH_ALEN];
-	struct fman_port	*port[2];
+	struct fman_port	*port[PORT_NUM];
 	struct phylink		*phylink;
 	struct phylink_config	phylink_config;
 	phy_interface_t		phy_if;
@@ -52,6 +53,9 @@ struct mac_device {
 
 	struct fman_mac		*fman_mac;
 	struct mac_priv_s	*priv;
+
+	struct device		*fman_dev;
+	struct device		*fman_port_devs[PORT_NUM];
 };
 
 static inline struct mac_device
-- 
2.43.0



