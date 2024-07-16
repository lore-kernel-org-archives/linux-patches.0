Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D45117623C;
	Tue, 16 Jul 2024 16:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146349; cv=none; b=hVPMVmYF5/8Kv1y90v0x5tjOahjYH4eJ4/ku4FuGueuKL/X+p5RJeOZaZjp0JZjMQdePS8maTjZuPOJd9GMCP0H2UXAe12bjs6/3QBDMBVmgi2RjiYgDc+eFQxP69y+lotmP1SL/CmyV5oSKJhUgET8BR+YjWfW9edZ7bIH64h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146349; c=relaxed/simple;
	bh=sSphdmHIBJda2FEp98jQlehT7GeliKFjv6cvmTU1xjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPIQJwhntfHP5hsH+ARD9dmSiP87W+ol8kJfcBonXIbHonX/Yi8wgBpVVcPLnPJhqKmt2B/i30EAsH765u61Pot1j7F4H4/Q8vjzJc8pUFLwUZ9kZRXniqoDo3iznF6VMRqXT0Z6HET9llU8l9m35YbyTHvoVTuKUquMQWljx5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XO+xfyec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XO+xfyec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A027C116B1;
	Tue, 16 Jul 2024 16:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146349;
	bh=sSphdmHIBJda2FEp98jQlehT7GeliKFjv6cvmTU1xjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XO+xfyecLx/RJyLzDJrmO9oPq3slpdClNW+LxJd1L61uqcXpVf99Ly/SIrlANZmz0
	 RkSm7vb72RjILjGndt/AOD/ez4AtxzxgCQorsnfYTPrLVK4FpIMYBaL7lrSgSDxyyR
	 Bk11NteMOIknbD25j4dGQkJhZ0kNChuA03t+w1mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/144] i2c: rcar: ensure Gen3+ reset does not disturb local targets
Date: Tue, 16 Jul 2024 17:33:27 +0200
Message-ID: <20240716152757.817322250@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit ea5ea84c9d3570dc06e8fc5ee2273eaa584aa3ac ]

R-Car Gen3+ needs a reset before every controller transfer. That erases
configuration of a potentially in parallel running local target
instance. To avoid this disruption, avoid controller transfers if a
local target is running. Also, disable SMBusHostNotify because it
requires being a controller and local target at the same time.

Fixes: 3b770017b03a ("i2c: rcar: handle RXDMA HW behaviour on Gen3")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 1efc0230c2cba..e24ced623c9ad 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -803,6 +803,10 @@ static int rcar_i2c_do_reset(struct rcar_i2c_priv *priv)
 {
 	int ret;
 
+	/* Don't reset if a slave instance is currently running */
+	if (priv->slave)
+		return -EISCONN;
+
 	ret = reset_control_reset(priv->rstc);
 	if (ret)
 		return ret;
@@ -1098,6 +1102,7 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	if (of_property_read_bool(dev->of_node, "smbus"))
 		priv->flags |= ID_P_HOST_NOTIFY;
 
+	/* R-Car Gen3+ needs a reset before every transfer */
 	if (priv->devtype >= I2C_RCAR_GEN3) {
 		priv->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
 		if (IS_ERR(priv->rstc))
@@ -1106,6 +1111,9 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 		ret = reset_control_status(priv->rstc);
 		if (ret < 0)
 			goto out_pm_put;
+
+		/* hard reset disturbs HostNotify local target, so disable it */
+		priv->flags &= ~ID_P_HOST_NOTIFY;
 	}
 
 	ret = platform_get_irq(pdev, 0);
-- 
2.43.0



