Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04C019DF88;
	Tue, 16 Jul 2024 15:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144818; cv=none; b=EMcJMntdrNwPxmvJ+6KgjhPx/GuuvluuAabnxOh9zX+hUehyCn8NLO05+GTwa2KIbaBPyCka3GeiVyaFQlG79L6KCVLSKWT9pe4HWyc1UDTXS/DyeDJxZSWp6GyT9zAq1sasCuhhg3wv1Qm+AIWYpp/RUA6ZIFEgNwVzICLvsV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144818; c=relaxed/simple;
	bh=BTZOg4KdGwhKUt4xufC/unAO8TA3lrIr9Ho/5o0u7GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kN0pXFsjPlFE0CJxSwQ1tNyt9QRGF9vbnqH92Qxp0eItFlphugjb3RsCo87fnyQKtWNG0AI4DebLfxxFfZiD0BFnPqZY4Z76yCGfjxChkmRkvyYgoiu3Pzra+tzDq9HADg49Y4z1xkqFRLj2wmKaMhD6Bbov7tc2BNnZHauvS5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyfVbCY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyfVbCY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2A8C4AF11;
	Tue, 16 Jul 2024 15:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144818;
	bh=BTZOg4KdGwhKUt4xufC/unAO8TA3lrIr9Ho/5o0u7GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyfVbCY2moT3uYPAm4nMteMQx10Uvb313Vj0lA7qViBzYSN+Mcfl3pxm0nTwwmsfa
	 4ccOR9J58WYVKorMakWFvVAwqPZw9ElQjPS/jE9qMtJiwuXvW8GPFC4tpabZ6I6O2d
	 hz8wXr45BvkAe+pqz5CwRirgt1CaY9O52agFq6gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/108] i2c: rcar: reset controller is mandatory for Gen3+
Date: Tue, 16 Jul 2024 17:31:59 +0200
Message-ID: <20240716152749.990740694@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 0e864b552b2302e40b2277629ebac79544a5c433 ]

Initially, we only needed a reset controller to make sure RXDMA works at
least once per transfer. Meanwhile, documentation has been updated. It
now says that a reset has to be performed prior every transaction, even
if it is non-DMA. So, make the reset controller a requirement instead of
being optional. And bail out if resetting fails.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: ea5ea84c9d35 ("i2c: rcar: ensure Gen3+ reset does not disturb local targets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 720c3fd757ef2..4b0222e5f584c 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -821,12 +821,10 @@ static int rcar_i2c_master_xfer(struct i2c_adapter *adap,
 
 	/* Gen3 needs a reset before allowing RXDMA once */
 	if (priv->devtype == I2C_RCAR_GEN3) {
-		priv->flags |= ID_P_NO_RXDMA;
-		if (!IS_ERR(priv->rstc)) {
-			ret = rcar_i2c_do_reset(priv);
-			if (ret == 0)
-				priv->flags &= ~ID_P_NO_RXDMA;
-		}
+		priv->flags &= ~ID_P_NO_RXDMA;
+		ret = rcar_i2c_do_reset(priv);
+		if (ret)
+			goto out;
 	}
 
 	rcar_i2c_init(priv);
@@ -1019,15 +1017,6 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 		irqhandler = rcar_i2c_gen2_irq;
 	}
 
-	if (priv->devtype == I2C_RCAR_GEN3) {
-		priv->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
-		if (!IS_ERR(priv->rstc)) {
-			ret = reset_control_status(priv->rstc);
-			if (ret < 0)
-				priv->rstc = ERR_PTR(-ENOTSUPP);
-		}
-	}
-
 	/* Stay always active when multi-master to keep arbitration working */
 	if (of_property_read_bool(dev->of_node, "multi-master"))
 		priv->flags |= ID_P_PM_BLOCKED;
@@ -1037,6 +1026,16 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	if (of_property_read_bool(dev->of_node, "smbus"))
 		priv->flags |= ID_P_HOST_NOTIFY;
 
+	if (priv->devtype == I2C_RCAR_GEN3) {
+		priv->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
+		if (IS_ERR(priv->rstc))
+			goto out_pm_put;
+
+		ret = reset_control_status(priv->rstc);
+		if (ret < 0)
+			goto out_pm_put;
+	}
+
 	ret = platform_get_irq(pdev, 0);
 	if (ret < 0)
 		goto out_pm_put;
-- 
2.43.0



