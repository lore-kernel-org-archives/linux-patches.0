Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8560012B72;
	Tue, 16 Jul 2024 15:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144786; cv=none; b=dQV6Q2r9G2w+5jaerQcrgNh9RVzJ7HMlzlFpa32HZd9DGSi5zOL/VG1c2SdV9wSi9boFEqkpAT7ey6bV5z9KaA516RQgV2zTYXtN90QvQlh4hK3NVKHkUBfOdO4mJys2I/EB0xDqupsfwBBSbp62m+tf5cSjwvogiYi1mveceAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144786; c=relaxed/simple;
	bh=2icpJDg4vXMX/GZFsyjQ7FWuKbx3XaCMtLGOPBZiLGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6DInpGdktDHkbdHjBLjzEFU4rqrr6ZYj3mESy8Azjgmxl8JnDo16+H+lnDP4KKEQfbVxQoswNBV0g6Fb9rn2bN+qdAuCrTmVgR0k0Y+jFop59ILfLbs55/L07bUrdgbmqtvx7+beA1TBXKhP4dYBb6Hlu1L9+B8XybdqnO/vuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUQoyb1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUQoyb1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D36C116B1;
	Tue, 16 Jul 2024 15:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144786;
	bh=2icpJDg4vXMX/GZFsyjQ7FWuKbx3XaCMtLGOPBZiLGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUQoyb1SgIRr3MlC+s/vRPawWJVSaM9Vj2orL5EweiWIf5XcOpRf8Wv/LtII+0Ptk
	 vTasw6SCkeUtDmPI5NPlbtbDwfOXz+zZGHA2Vgvt2xOowhgUar9Bu4YDzonXK7G15M
	 3bOAzKhko0CZx6NArHAHjBFJ0TSmpfFs+JgvaVC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/108] i2c: rcar: ensure Gen3+ reset does not disturb local targets
Date: Tue, 16 Jul 2024 17:32:01 +0200
Message-ID: <20240716152750.067070776@linuxfoundation.org>
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
index 41c9d15c3bc69..db3a5b80f1aa8 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -796,6 +796,10 @@ static int rcar_i2c_do_reset(struct rcar_i2c_priv *priv)
 {
 	int ret;
 
+	/* Don't reset if a slave instance is currently running */
+	if (priv->slave)
+		return -EISCONN;
+
 	ret = reset_control_reset(priv->rstc);
 	if (ret)
 		return ret;
@@ -1027,6 +1031,7 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	if (of_property_read_bool(dev->of_node, "smbus"))
 		priv->flags |= ID_P_HOST_NOTIFY;
 
+	/* R-Car Gen3+ needs a reset before every transfer */
 	if (priv->devtype >= I2C_RCAR_GEN3) {
 		priv->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
 		if (IS_ERR(priv->rstc))
@@ -1035,6 +1040,9 @@ static int rcar_i2c_probe(struct platform_device *pdev)
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



