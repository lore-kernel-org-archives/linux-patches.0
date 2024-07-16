Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFB91DDCE;
	Tue, 16 Jul 2024 16:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145897; cv=none; b=RtMlC0MGJEdnEqT+0e7Gjs3CKK6mGzOm4fb1olycKhxVmStWWSaaTlOW1uL0q0nMIduNFT+nm91RhVlB6u5muzrIfrHEka+f08vVMLzjPFqlDXomioXVKsGK3AzegNKIxspnQIRoqh4NxqOTwN6MSk3uAYeoPwYdb8mYnHbZ72w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145897; c=relaxed/simple;
	bh=1Iz6akRd0hYOWBf+nfVCQb1pct9GN/MyXpT76MFlYOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R92U03p7xSDWWankS5ihRXA+3lz7e4iQz+OTDeeXZqbJnLbg5/UlMxjXuEYHqSSbOyqGhKePXMRrxGPWKh7UJLVJxmklCv1ZzWJoIXW7XbFl7gITkdMpMTsLuMNYYBs7sswbc0idw1sFZJEa/9gCudsGr+Q3s0Fa9hbG7vnySjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeHHHjAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FeHHHjAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55394C4AF0B;
	Tue, 16 Jul 2024 16:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145897;
	bh=1Iz6akRd0hYOWBf+nfVCQb1pct9GN/MyXpT76MFlYOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeHHHjAttZ2qze3/zEWniM5sXeAVtC0tYwtO/dNxSTf7zDNKtoSpJpcGFdTusfnbv
	 CVEhuRV8MJmXTsX9C9YB35ugH2YAgr8haiM13PMTSB8f0FwrK+hJ0rYhYUJ7qiH5L8
	 NpCUBylGJ8xdLf5FY4OpV/c+uyfu8VkqP5+Zrplw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/121] i2c: rcar: ensure Gen3+ reset does not disturb local targets
Date: Tue, 16 Jul 2024 17:32:56 +0200
Message-ID: <20240716152755.713634830@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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
index 2719bc5a1a771..0ba88d44a7dbe 100644
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



