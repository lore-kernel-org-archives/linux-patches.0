Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22003B641;
	Tue, 16 Jul 2024 15:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144456; cv=none; b=FNcqTzt6JGL4joRapKoQqpAo8L2WCoHD5lCXSDcfEqU/ljh3iMVDhDNqGTlTSKq19/bV5uwKqZ8mNxjBFU/PXgeJHP0Bq4C8ldj/5ZIl3p5XZigsvLuxFlHtPRX7rduwjze57r6vR4BE+zmdkQfmghV15mOuPk5UjI8wQ8FBNqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144456; c=relaxed/simple;
	bh=6cOGXXeICmr4F/t3XQKGMfyymWyHNdIA818gghA7pLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoPjAtdKllTBeZKALh60XLw4aLWGD4IMXMo5iN2Gl7eNvk6e+L5VuSbzI+e8PpDDZm59p5rCJMnXftknVZATomPUYVv/pcZjMFMs3uwODi4CJX7NgO/KK9IagIExYRLsNpEgyHme80j5PpHYwux0lGDB/Wi/kZxK5SInQk0QxqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9O4e7yc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9O4e7yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9946AC116B1;
	Tue, 16 Jul 2024 15:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144456;
	bh=6cOGXXeICmr4F/t3XQKGMfyymWyHNdIA818gghA7pLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9O4e7yc8zWCNIwQetcmd0YQ3maRm2BYEs/p2kVVbEJbrgLgE0endib6YeWYRqwNN
	 GJNIU+f9VKUBoamzkAw6hiKI0o0UurZUlRa3bOQCdH6+SdcL6AaIfFPZrYt7NpAK3u
	 hZQZn/GOY/wLUQHYUyExteb/ZMR36W63K7B4rqd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Behme <dirk.behme@de.bosch.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 78/78] i2c: rcar: bring hardware to known state when probing
Date: Tue, 16 Jul 2024 17:31:50 +0200
Message-ID: <20240716152743.659406897@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d0c4b3019e41e..1327f29f1e93b 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -218,6 +218,14 @@ static void rcar_i2c_init(struct rcar_i2c_priv *priv)
 
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
 	int i;
@@ -863,11 +871,8 @@ static int rcar_unreg_slave(struct i2c_client *slave)
 
 	/* ensure no irq is running before clearing ptr */
 	disable_irq(priv->irq);
-	rcar_i2c_write(priv, ICSIER, 0);
-	rcar_i2c_write(priv, ICSSR, 0);
+	rcar_i2c_reset_slave(priv);
 	enable_irq(priv->irq);
-	rcar_i2c_write(priv, ICSCR, SDBS);
-	rcar_i2c_write(priv, ICSAR, 0); /* Gen2: must be 0 if not using slave */
 
 	priv->slave = NULL;
 
@@ -973,7 +978,9 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto out_pm_put;
 
-	rcar_i2c_write(priv, ICSAR, 0); /* Gen2: must be 0 if not using slave */
+	/* Bring hardware to known state */
+	rcar_i2c_init(priv);
+	rcar_i2c_reset_slave(priv);
 
 	if (priv->devtype == I2C_RCAR_GEN3) {
 		priv->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
-- 
2.43.0



