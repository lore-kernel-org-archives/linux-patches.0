Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0031DDCE;
	Tue, 16 Jul 2024 16:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146390; cv=none; b=X6HID01s5cM8OuRBjupG7W1xiRe8jk7dbqe+4ViShrpgobrL3lcH9iqCQnfL7B/av9ol2bhilnB63i3RucfeL6DZAhdoeyuvFoiKJONXMIhmSX7mLHofJBJfjkCTSwFrbjCFlfp7nxvVCnepAJkWkQNsXGCBJS5G1Q+ehcKyeBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146390; c=relaxed/simple;
	bh=3V76RbKLnu5gtfRp+NsYipB/qEqFLjJJybwtD/BWg/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gn9fYC/wDdCp40zhvdf9f5L1ixOuct5x3nK6GPJoWOmCuTJUdwAgV5uKagpp8w7tQxfYcCrKkmgA9qnVSvszC4iFCLK1oXMs0eBl+aKeRDbR7hdydKdQvFIsmSYPO9WuXtJt7c6clGoc/hADKvugthwgwx6tZxTG6dpb665fUeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4tIvJSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4tIvJSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BE3C116B1;
	Tue, 16 Jul 2024 16:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146390;
	bh=3V76RbKLnu5gtfRp+NsYipB/qEqFLjJJybwtD/BWg/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4tIvJSX2kXuBt9QvxXSSynE3ejT95LjiDWhQHEvMF5bMFzIoTUKtsExeXP0+kQS+
	 4Grz3OJ5vZ3ZQaAlF5xQxp5dQbfS3AFxPPDBF2gyW3ZCXYQ00rYzCa8OvT7lPoobCt
	 T/fW8Li5MT2slS3k7Kk6Am1To7RAYZVT/fDRmzS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Behme <dirk.behme@de.bosch.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/144] i2c: rcar: bring hardware to known state when probing
Date: Tue, 16 Jul 2024 17:33:22 +0200
Message-ID: <20240716152757.628106113@linuxfoundation.org>
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

[ Upstream commit 4e36c0f20cb1c74c7bd7ea31ba432c1c4a989031 ]

When probing, the hardware is not brought into a known state. This may
be a problem when a hypervisor restarts Linux without resetting the
hardware, leaving an old state running. Make sure the hardware gets
initialized, especially interrupts should be cleared and disabled.

Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Closes: https://lore.kernel.org/r/20240702045535.2000393-1-dirk.behme@de.bosch.com
Fixes: 6ccbe607132b ("i2c: add Renesas R-Car I2C driver")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 2c016f0299fce..97900fe0c3bcf 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -221,6 +221,14 @@ static void rcar_i2c_init(struct rcar_i2c_priv *priv)
 
 }
 
+static void rcar_i2c_reset_slave(struct rcar_i2c_priv *priv)
+{
+	rcar_i2c_write(priv, ICSIER, 0);
+	rcar_i2c_write(priv, ICSSR, 0);
+	rcar_i2c_write(priv, ICSCR, SDBS);
+	rcar_i2c_write(priv, ICSAR, 0); /* Gen2: must be 0 if not using slave */
+}
+
 static int rcar_i2c_bus_barrier(struct rcar_i2c_priv *priv)
 {
 	int ret;
@@ -959,11 +967,8 @@ static int rcar_unreg_slave(struct i2c_client *slave)
 
 	/* ensure no irq is running before clearing ptr */
 	disable_irq(priv->irq);
-	rcar_i2c_write(priv, ICSIER, 0);
-	rcar_i2c_write(priv, ICSSR, 0);
+	rcar_i2c_reset_slave(priv);
 	enable_irq(priv->irq);
-	rcar_i2c_write(priv, ICSCR, SDBS);
-	rcar_i2c_write(priv, ICSAR, 0); /* Gen2: must be 0 if not using slave */
 
 	priv->slave = NULL;
 
@@ -1075,7 +1080,9 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 		goto out_pm_disable;
 	}
 
-	rcar_i2c_write(priv, ICSAR, 0); /* Gen2: must be 0 if not using slave */
+	/* Bring hardware to known state */
+	rcar_i2c_init(priv);
+	rcar_i2c_reset_slave(priv);
 
 	if (priv->devtype < I2C_RCAR_GEN3) {
 		irqflags |= IRQF_NO_THREAD;
-- 
2.43.0



