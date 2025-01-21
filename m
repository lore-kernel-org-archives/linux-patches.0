Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9A81F7577;
	Tue, 21 Jan 2025 17:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482158; cv=none; b=mCYdp4AR+OelQnH+sV1NtBoJlXsKsp8ITcta3O3KgdKaNFolRxKuEqGXdlRp3qXClMBMVq/PL0/XD0UGiOV4VInEHZP/HNK7gftTMkq56gGv2sDDRt3iKXSPNCCVzlKqvtmgq2bN6JaxTbAHePlKMeLMD278LcyNwGZdQZvC4XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482158; c=relaxed/simple;
	bh=+PqTqKD/RgAXNcJlGdHI09WuIew3Uj+nvssVWvgUYPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrImBDBbstfAzPQlu6MscMqPqjbfWZxXPu6wGy+sppymoMnNw69sSas//LOQBffwLOg5TxJ8J8quPnGxz6pmsKi/v/NO+cC7jJlmBEVXedYPmlwgrPDKdGN7ib0P0+8GH6TA26+POl4zGuYiKQ5Jg3Sc6KbnRzmg4dw1aWNMYL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyAhlvp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyAhlvp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABD2C4CEDF;
	Tue, 21 Jan 2025 17:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482157;
	bh=+PqTqKD/RgAXNcJlGdHI09WuIew3Uj+nvssVWvgUYPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NyAhlvp3igQUwuv7ai2R0vePBQPk42M61LUbBqWGlzCrA9Bz0kl7ioI1EPavyFE0K
	 jesdI+CN2A0RMDszDbIea1sUJsqih0c26swD2NYzQxcoSs9DhujseRoYJHCG9cZ7eh
	 IP09lWh9mUsqpX8NxOVYplRS8FVmxxvkgEpMNTdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 23/72] i2c: rcar: fix NACK handling when being a target
Date: Tue, 21 Jan 2025 18:51:49 +0100
Message-ID: <20250121174524.318777892@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 093f70c134f70e4632b295240f07d2b50b74e247 ]

When this controller is a target, the NACK handling had two issues.
First, the return value from the backend was not checked on the initial
WRITE_REQUESTED. So, the driver missed to send a NACK in this case.
Also, the NACK always arrives one byte late on the bus, even in the
WRITE_RECEIVED case. This seems to be a HW issue. We should then not
rely on the backend to correctly NACK the superfluous byte as well. Fix
both issues by introducing a flag which gets set whenever the backend
requests a NACK and keep sending it until we get a STOP condition.

Fixes: de20d1857dd6 ("i2c: rcar: add slave support")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 84fdd3f5cc844..610df67cedaad 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -110,6 +110,8 @@
 #define ID_P_PM_BLOCKED		BIT(31)
 #define ID_P_MASK		GENMASK(31, 28)
 
+#define ID_SLAVE_NACK		BIT(0)
+
 enum rcar_i2c_type {
 	I2C_RCAR_GEN1,
 	I2C_RCAR_GEN2,
@@ -143,6 +145,7 @@ struct rcar_i2c_priv {
 	int irq;
 
 	struct i2c_client *host_notify_client;
+	u8 slave_flags;
 };
 
 #define rcar_i2c_priv_to_dev(p)		((p)->adap.dev.parent)
@@ -597,6 +600,7 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
 {
 	u32 ssr_raw, ssr_filtered;
 	u8 value;
+	int ret;
 
 	ssr_raw = rcar_i2c_read(priv, ICSSR) & 0xff;
 	ssr_filtered = ssr_raw & rcar_i2c_read(priv, ICSIER);
@@ -612,7 +616,10 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
 			rcar_i2c_write(priv, ICRXTX, value);
 			rcar_i2c_write(priv, ICSIER, SDE | SSR | SAR);
 		} else {
-			i2c_slave_event(priv->slave, I2C_SLAVE_WRITE_REQUESTED, &value);
+			ret = i2c_slave_event(priv->slave, I2C_SLAVE_WRITE_REQUESTED, &value);
+			if (ret)
+				priv->slave_flags |= ID_SLAVE_NACK;
+
 			rcar_i2c_read(priv, ICRXTX);	/* dummy read */
 			rcar_i2c_write(priv, ICSIER, SDR | SSR | SAR);
 		}
@@ -625,18 +632,21 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
 	if (ssr_filtered & SSR) {
 		i2c_slave_event(priv->slave, I2C_SLAVE_STOP, &value);
 		rcar_i2c_write(priv, ICSCR, SIE | SDBS); /* clear our NACK */
+		priv->slave_flags &= ~ID_SLAVE_NACK;
 		rcar_i2c_write(priv, ICSIER, SAR);
 		rcar_i2c_write(priv, ICSSR, ~SSR & 0xff);
 	}
 
 	/* master wants to write to us */
 	if (ssr_filtered & SDR) {
-		int ret;
-
 		value = rcar_i2c_read(priv, ICRXTX);
 		ret = i2c_slave_event(priv->slave, I2C_SLAVE_WRITE_RECEIVED, &value);
-		/* Send NACK in case of error */
-		rcar_i2c_write(priv, ICSCR, SIE | SDBS | (ret < 0 ? FNA : 0));
+		if (ret)
+			priv->slave_flags |= ID_SLAVE_NACK;
+
+		/* Send NACK in case of error, but it will come 1 byte late :( */
+		rcar_i2c_write(priv, ICSCR, SIE | SDBS |
+			       (priv->slave_flags & ID_SLAVE_NACK ? FNA : 0));
 		rcar_i2c_write(priv, ICSSR, ~SDR & 0xff);
 	}
 
-- 
2.39.5



