Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FA81F3FFE;
	Tue, 21 Jan 2025 18:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482623; cv=none; b=XkX1lab0NlpOuT6NEYUyyXklSRYl1OxlUJQcX8AQ0L2WJn+QnPLjkTw1DLlpyFr5lTglFNVY+v3ePjIZ/U7BWR3CfvmMdWcI4GjXHmwG+ZYtMf0FrPwNydyN9JnsvJwdCXsqt6EeYe4ZVBTXudoHW6Xqx5WsIzSq4tGHG96IXIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482623; c=relaxed/simple;
	bh=DL0Wf3pX2OVzRnzmqBSQk+6+J35Od01fbZkWriomsYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVLDKPTeTYKHxzoTjapxXXCTqC6poGIkaTZviyYXwGIAgDFD9+solstTV/xnj3QTfIYAIVYMSwji0bnZcJY0hBbIAfMPGrI/u1bHVP4zQyYDQNlBpFPn2JVrH12IpyeA1QyKH5BEq6ViHE//bGOXvbwHMfVqCoRUaogUfjRs2tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Scnf+Nvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Scnf+Nvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0063AC4CEDF;
	Tue, 21 Jan 2025 18:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482621;
	bh=DL0Wf3pX2OVzRnzmqBSQk+6+J35Od01fbZkWriomsYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Scnf+NvrHCc2gM0RbSNfUiyjxSxbrPLz6xLBaja7eNGm72lCPOPPvyOujMajdY28l
	 wllE4DtwYCa3x5WtZT9OGNK3HgM7sfEsHYsY+XweUATT/ADaaGeYts0kq8/I0wAncH
	 yBs26rvFbS4ozkJFPpgGrRAILe7V5zSeKvLb15vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 17/64] i2c: rcar: fix NACK handling when being a target
Date: Tue, 21 Jan 2025 18:52:16 +0100
Message-ID: <20250121174522.217304262@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d0098e342ba22..c7f2a9d8bcd56 100644
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



