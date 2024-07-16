Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AF51A00D0;
	Tue, 16 Jul 2024 15:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145514; cv=none; b=hP/lzMvctw22QDHHg6BSFZORFpaKO7D1z5CjxeuY2fhWdHRvhPYngn+Unn/4Rnx0+qB32pWQ0O+JaLxoDR7JXaz/8NgtUh+HLDvR3o6O11lK3zfkQWjJCebCfNNnvxS7Wuw/VsJdamRJ9Hamk+YcoFuEWwYBwMMQ4uYFtimdFI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145514; c=relaxed/simple;
	bh=krllarJqHcVddqFrqpmegJfglR4I1PRxKj5hU4xR8l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tj9rbYcccdr9Vf/i/H4BlF5TnWfj7+EEcXE2eRJYo2RC9lDDiMm3UEmWLt2TPoLef/7P4ZPecEpmtKJUH1D02wHYg4l5J8r++sRvpSxTDzVOGQXzzO6Uc18O9/HMaSQAfdl6jYfozQeFSgubqyB0RVjEAxI59pxiQ3qsxNj1xj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+8rtrFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+8rtrFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5BEC4AF0D;
	Tue, 16 Jul 2024 15:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145514;
	bh=krllarJqHcVddqFrqpmegJfglR4I1PRxKj5hU4xR8l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+8rtrFhOYcpWkhekBBAEtG48LIigoGPSUpSPr6t1UcOgH5x60P/iHNVg7nSSXLAA
	 2vxscS6kex87AQayeetsIgYMCU6IASeAyOWkP4HXGX0frln5BP6E1oyyTpBW/WeQ1N
	 pGAvXrT07PCXX4/c0pWH30GkMfi0Yx9iqB+0bUEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 90/96] i2c: rcar: ensure Gen3+ reset does not disturb local targets
Date: Tue, 16 Jul 2024 17:32:41 +0200
Message-ID: <20240716152749.974786156@linuxfoundation.org>
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
index 975bba5e4a344..c7a51e0876cf5 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -824,6 +824,10 @@ static int rcar_i2c_do_reset(struct rcar_i2c_priv *priv)
 {
 	int ret;
 
+	/* Don't reset if a slave instance is currently running */
+	if (priv->slave)
+		return -EISCONN;
+
 	ret = reset_control_reset(priv->rstc);
 	if (ret)
 		return ret;
@@ -1114,6 +1118,7 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	if (of_property_read_bool(dev->of_node, "smbus"))
 		priv->flags |= ID_P_HOST_NOTIFY;
 
+	/* R-Car Gen3+ needs a reset before every transfer */
 	if (priv->devtype >= I2C_RCAR_GEN3) {
 		priv->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
 		if (IS_ERR(priv->rstc))
@@ -1122,6 +1127,9 @@ static int rcar_i2c_probe(struct platform_device *pdev)
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



