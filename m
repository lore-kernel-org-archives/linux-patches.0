Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4691819FA94;
	Tue, 16 Jul 2024 15:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145508; cv=none; b=TPv4EloRovYfvnMzKem4Fm5qpXfNBDLiMFqCjMjhqU6Ra04x0w9IMlVTGC2bwM6m38A1h4Sz2O49TSCDNiVsMif40UiQuFqfUr2eYyzM6ooIjdw4unU6f2caCZJ2jm9niRFKSffxriQy7ZInK0tL/TIqQvRjnDP7SoWRY2nX8as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145508; c=relaxed/simple;
	bh=R6zqRKquDYIIfvKxBeuHNZ88aEvxaJUmQjozLtyJ/eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMcQqSVFdXotyCWVwWgWKCIrArP2/T7HryupVUe2X+YNaQ/HlVa1betevnZ7A1fd740YbST4gp62xpGhhzxdVJyexQRcLPuOENjSZ1JBpg039Ox3eJppdnOSQS8HtF4ys/OmHC9+e+Pt2J6bkpxBsbaGSZA9n1MxN0yqvMwEYWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlSzeFiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlSzeFiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904ECC4AF14;
	Tue, 16 Jul 2024 15:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145508;
	bh=R6zqRKquDYIIfvKxBeuHNZ88aEvxaJUmQjozLtyJ/eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlSzeFiGM5+jZI2FbuzhnU2FLsxehJ7EcYW2uQly9D0AQZCx4991sm8fHCoK/c2Do
	 lu2db5vZvIlb20nEOitOHz/Wy9O03V3+L0L1eZ06eyI7+tdOkuqWtGn2zp9+72Pc3y
	 oKcKiChkFda/vc+L84xpsljmY3FTBV2Gsk5bvHIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 88/96] i2c: rcar: reset controller is mandatory for Gen3+
Date: Tue, 16 Jul 2024 17:32:39 +0200
Message-ID: <20240716152749.898914853@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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
index f8ac1489e1de5..7f08045a61d62 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -851,12 +851,10 @@ static int rcar_i2c_master_xfer(struct i2c_adapter *adap,
 
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
@@ -1106,15 +1104,6 @@ static int rcar_i2c_probe(struct platform_device *pdev)
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
@@ -1124,6 +1113,16 @@ static int rcar_i2c_probe(struct platform_device *pdev)
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



