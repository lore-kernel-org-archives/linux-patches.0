Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D6225DD08;
	Tue, 11 Mar 2025 15:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706549; cv=none; b=KJTMXH2ZS3mz5dOTyRLhmYTUC8VPVvFobTHlmLslLin6cXI4sCXXhwgRnqbXFxmdqekrxvUPW8QxxrDqiOpRlvuidIxOk1gnv6hAUi084L4TSgchZ8EdHLWbBeTYlZul3hxYa2e962vre02/AfYFLHh6aFEQLW5SnJYzixicweo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706549; c=relaxed/simple;
	bh=ChAv4ydpYpRbvXCWG1nGxfBZCUajlTy5XqSHZB3Mupo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5OSTVuqp41y/pxf39M7KXlGmRl80CDdhr09zqVAVOXGi3DlToO+8D45ynqmJ1Xj76uSpyY7/dxCe8+yT6nNjmFT+SYgm7PvjDgPYaduyQDf4Be5A/sZWf/ax8V3+dq2hwVcH7A8UBuZUYMao5N9d3LKMGVqu2pUiiROhDBp5yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYlC8CUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYlC8CUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49E3C4CEE9;
	Tue, 11 Mar 2025 15:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706549;
	bh=ChAv4ydpYpRbvXCWG1nGxfBZCUajlTy5XqSHZB3Mupo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYlC8CUSTAx03bco3seZqzCLxqQlzpAl5Ow9n3iT5BOtlrTGJowfAj320dql/dhz0
	 ORgjUtAOBK0dEGqUwYqvrKYYYYSmt5uZolLK+TizBJ5qqXitda6yKcOqN7132H9g2R
	 yXeRv/Kss9yh9g7cURr7VJljo3JPilzbQlFvJ2pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/462] mtd: hyperbus: hbmc-am654: fix an OF node reference leak
Date: Tue, 11 Mar 2025 15:55:53 +0100
Message-ID: <20250311145801.787832794@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit bf5821909eb9c7f5d07d5c6e852ead2c373c94a0 ]

In am654_hbmc_platform_driver, .remove() and the error path of .probe()
do not decrement the refcount of an OF node obtained by
  of_get_next_child(). Fix this by adding of_node_put() calls.

Fixes: aca31ce96814 ("mtd: hyperbus: hbmc-am654: Fix direct mapping setup flash access")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/hyperbus/hbmc-am654.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/mtd/hyperbus/hbmc-am654.c
+++ b/drivers/mtd/hyperbus/hbmc-am654.c
@@ -174,26 +174,30 @@ static int am654_hbmc_probe(struct platf
 	priv->hbdev.np = of_get_next_child(np, NULL);
 	ret = of_address_to_resource(priv->hbdev.np, 0, &res);
 	if (ret)
-		return ret;
+		goto put_node;
 
 	if (of_property_read_bool(dev->of_node, "mux-controls")) {
 		struct mux_control *control = devm_mux_control_get(dev, NULL);
 
-		if (IS_ERR(control))
-			return PTR_ERR(control);
+		if (IS_ERR(control)) {
+			ret = PTR_ERR(control);
+			goto put_node;
+		}
 
 		ret = mux_control_select(control, 1);
 		if (ret) {
 			dev_err(dev, "Failed to select HBMC mux\n");
-			return ret;
+			goto put_node;
 		}
 		priv->mux_ctrl = control;
 	}
 
 	priv->hbdev.map.size = resource_size(&res);
 	priv->hbdev.map.virt = devm_ioremap_resource(dev, &res);
-	if (IS_ERR(priv->hbdev.map.virt))
-		return PTR_ERR(priv->hbdev.map.virt);
+	if (IS_ERR(priv->hbdev.map.virt)) {
+		ret = PTR_ERR(priv->hbdev.map.virt);
+		goto disable_mux;
+	}
 
 	priv->ctlr.dev = dev;
 	priv->ctlr.ops = &am654_hbmc_ops;
@@ -226,6 +230,8 @@ release_dma:
 disable_mux:
 	if (priv->mux_ctrl)
 		mux_control_deselect(priv->mux_ctrl);
+put_node:
+	of_node_put(priv->hbdev.np);
 	return ret;
 }
 
@@ -241,6 +247,7 @@ static int am654_hbmc_remove(struct plat
 
 	if (dev_priv->rx_chan)
 		dma_release_channel(dev_priv->rx_chan);
+	of_node_put(priv->hbdev.np);
 
 	return ret;
 }


