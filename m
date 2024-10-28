Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B80318E37C;
	Mon, 28 Oct 2024 06:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097858; cv=none; b=IoQj0L07JdWxt6WuR4TtrMV6dFMcHtZFH+oSedtGfFTr1XBs2/Z40p5Gzv2rbnpTVGruIw/Lu7gKxILxyiaS7bsU/dNWl2BGKYnYjB0ew08uSpkR/vaWa6FKxFl+Ui4fTL5GpNfkg5mDyBB89IxD+Ptxvsl9eaUM3UhleMWDZSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097858; c=relaxed/simple;
	bh=J1IpFZZEdqQ7dPxgr6vGGf1HzrskV0EHIc5eLIMqRqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jp5hM9CtH7Hj520omDWMeuqdYCI9cjQR8eonIH5WgkVuUQSXeJtCehAX6aTMRt6jBCEEMrqx1G3ucK4+fKB8erfFjtHYykhXM49YaC68W16V3t2PdtuyjD1Mzgt3m0o3L9PXDFpbhZuqnh+X+cctgvPvd0Zqlv9HZz6lEl4rKQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1G05Ods; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1G05Ods"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E55C4CEC3;
	Mon, 28 Oct 2024 06:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097857;
	bh=J1IpFZZEdqQ7dPxgr6vGGf1HzrskV0EHIc5eLIMqRqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1G05Ods+v3Ck6QAsgljVSuiVUudRc1kLXWozEeUKeRXhxmgGLphCvO0kocE2plF3
	 KIWKjjhTcyVvRbK1S9zGbtauMt//Xq6+bijl/JagWl9DoyeOkyDhvw9PRyJrYugZrG
	 bYOt9/uG4C/bMcl51iM/zfRgsL5iY6yG5c81B5RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/208] fsl/fman: Fix refcount handling of fman-related devices
Date: Mon, 28 Oct 2024 07:25:23 +0100
Message-ID: <20241028062310.154401676@linuxfoundation.org>
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

[ Upstream commit 1dec67e0d9fbb087c2ab17bf1bd17208231c3bb1 ]

In mac_probe() there are multiple calls to of_find_device_by_node(),
fman_bind() and fman_port_bind() which takes references to of_dev->dev.
Not all references taken by these calls are released later on error path
in mac_probe() and in mac_remove() which lead to reference leaks.

Add references release.

Fixes: 3933961682a3 ("fsl/fman: Add FMan MAC driver")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fman/mac.c | 62 +++++++++++++++++------
 1 file changed, 47 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 9b863db0bf087..11da139082e1b 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -204,7 +204,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err) {
 		dev_err(dev, "failed to read cell-index for %pOF\n", dev_node);
 		err = -EINVAL;
-		goto _return_of_node_put;
+		goto _return_dev_put;
 	}
 	/* cell-index 0 => FMan id 1 */
 	fman_id = (u8)(val + 1);
@@ -213,40 +213,51 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (!priv->fman) {
 		dev_err(dev, "fman_bind(%pOF) failed\n", dev_node);
 		err = -ENODEV;
-		goto _return_of_node_put;
+		goto _return_dev_put;
 	}
 
+	/* Two references have been taken in of_find_device_by_node()
+	 * and fman_bind(). Release one of them here. The second one
+	 * will be released in mac_remove().
+	 */
+	put_device(mac_dev->fman_dev);
 	of_node_put(dev_node);
+	dev_node = NULL;
 
 	/* Get the address of the memory mapped registers */
 	mac_dev->res = platform_get_mem_or_io(_of_dev, 0);
 	if (!mac_dev->res) {
 		dev_err(dev, "could not get registers\n");
-		return -EINVAL;
+		err = -EINVAL;
+		goto _return_dev_put;
 	}
 
 	err = devm_request_resource(dev, fman_get_mem_region(priv->fman),
 				    mac_dev->res);
 	if (err) {
 		dev_err_probe(dev, err, "could not request resource\n");
-		return err;
+		goto _return_dev_put;
 	}
 
 	mac_dev->vaddr = devm_ioremap(dev, mac_dev->res->start,
 				      resource_size(mac_dev->res));
 	if (!mac_dev->vaddr) {
 		dev_err(dev, "devm_ioremap() failed\n");
-		return -EIO;
+		err = -EIO;
+		goto _return_dev_put;
 	}
 
-	if (!of_device_is_available(mac_node))
-		return -ENODEV;
+	if (!of_device_is_available(mac_node)) {
+		err = -ENODEV;
+		goto _return_dev_put;
+	}
 
 	/* Get the cell-index */
 	err = of_property_read_u32(mac_node, "cell-index", &val);
 	if (err) {
 		dev_err(dev, "failed to read cell-index for %pOF\n", mac_node);
-		return -EINVAL;
+		err = -EINVAL;
+		goto _return_dev_put;
 	}
 	priv->cell_index = (u8)val;
 
@@ -260,22 +271,26 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (unlikely(nph < 0)) {
 		dev_err(dev, "of_count_phandle_with_args(%pOF, fsl,fman-ports) failed\n",
 			mac_node);
-		return nph;
+		err = nph;
+		goto _return_dev_put;
 	}
 
 	if (nph != ARRAY_SIZE(mac_dev->port)) {
 		dev_err(dev, "Not supported number of fman-ports handles of mac node %pOF from device tree\n",
 			mac_node);
-		return -EINVAL;
+		err = -EINVAL;
+		goto _return_dev_put;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
+	/* PORT_NUM determines the size of the port array */
+	for (i = 0; i < PORT_NUM; i++) {
 		/* Find the port node */
 		dev_node = of_parse_phandle(mac_node, "fsl,fman-ports", i);
 		if (!dev_node) {
 			dev_err(dev, "of_parse_phandle(%pOF, fsl,fman-ports) failed\n",
 				mac_node);
-			return -EINVAL;
+			err = -EINVAL;
+			goto _return_dev_arr_put;
 		}
 
 		of_dev = of_find_device_by_node(dev_node);
@@ -283,7 +298,7 @@ static int mac_probe(struct platform_device *_of_dev)
 			dev_err(dev, "of_find_device_by_node(%pOF) failed\n",
 				dev_node);
 			err = -EINVAL;
-			goto _return_of_node_put;
+			goto _return_dev_arr_put;
 		}
 		mac_dev->fman_port_devs[i] = &of_dev->dev;
 
@@ -292,9 +307,15 @@ static int mac_probe(struct platform_device *_of_dev)
 			dev_err(dev, "dev_get_drvdata(%pOF) failed\n",
 				dev_node);
 			err = -EINVAL;
-			goto _return_of_node_put;
+			goto _return_dev_arr_put;
 		}
+		/* Two references have been taken in of_find_device_by_node()
+		 * and fman_port_bind(). Release one of them here. The second
+		 * one will be released in mac_remove().
+		 */
+		put_device(mac_dev->fman_port_devs[i]);
 		of_node_put(dev_node);
+		dev_node = NULL;
 	}
 
 	/* Get the PHY connection type */
@@ -314,7 +335,7 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	err = init(mac_dev, mac_node, &params);
 	if (err < 0)
-		return err;
+		goto _return_dev_arr_put;
 
 	if (!is_zero_ether_addr(mac_dev->addr))
 		dev_info(dev, "FMan MAC address: %pM\n", mac_dev->addr);
@@ -329,6 +350,12 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	return err;
 
+_return_dev_arr_put:
+	/* mac_dev is kzalloc'ed */
+	for (i = 0; i < PORT_NUM; i++)
+		put_device(mac_dev->fman_port_devs[i]);
+_return_dev_put:
+	put_device(mac_dev->fman_dev);
 _return_of_node_put:
 	of_node_put(dev_node);
 	return err;
@@ -337,6 +364,11 @@ static int mac_probe(struct platform_device *_of_dev)
 static void mac_remove(struct platform_device *pdev)
 {
 	struct mac_device *mac_dev = platform_get_drvdata(pdev);
+	int		   i;
+
+	for (i = 0; i < PORT_NUM; i++)
+		put_device(mac_dev->fman_port_devs[i]);
+	put_device(mac_dev->fman_dev);
 
 	platform_device_unregister(mac_dev->priv->eth_dev);
 }
-- 
2.43.0



