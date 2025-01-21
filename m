Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E7A1F76AF;
	Tue, 21 Jan 2025 18:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483040; cv=none; b=TjFWVHb2KtWyNJGPNKIL7ysFvdLcYnXKYgjLWsKW+E66AUgI7rJr9uEtYO/8tbUVp+4hXI48I11/eQf//3X6Qh14uajgF6Dx/q1aJojBzQmPY5fghp8EPakJ7HQEDUQnFSsDbr4VV1Nj0Ia1poba5BAYg6WGxyd1R/vj8swzAP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483040; c=relaxed/simple;
	bh=2v4nc1GZ53z9RP0Z3kHP5SgffKdOzBKqWBW5qlTQSt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byr1buY5Yx8cu2hiIcXPRBjXE7p9vPEDl6XlKidZmV9BksJMORzR8qVMgcCww5bNNTTf9ewd3me06VCo3eDsTMghAEg4W5qU5r9McG+FRl8kMUDmN/h4Z4W5gCw+pwdgiZk3X45G0jJNB++AzECq49cX8VdlI+2ifh5MReKFODY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPmGBZuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPmGBZuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7312C4CEDF;
	Tue, 21 Jan 2025 18:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483040;
	bh=2v4nc1GZ53z9RP0Z3kHP5SgffKdOzBKqWBW5qlTQSt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPmGBZuck6fkCs0HwYVHMFwoLL6ipAhd3QVMmQS9eeGrImIb7jkDUGiczQ87xKAWx
	 l/QJbjxD5y9yprV3rit7qt3VgJcUwfiuhxWPKZcMzNWKqwsMu6FKzLrgLwBismfQji
	 xcmW7BhhYGr5gMlkbw4ukoUf3y6i2Vwb87bmu6PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/127] i2c: rcar: fix NACK handling when being a target
Date: Tue, 21 Jan 2025 18:52:47 +0100
Message-ID: <20250121174533.310746907@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 316dd378fb8c4..afefe99129001 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -112,6 +112,8 @@
 #define ID_P_PM_BLOCKED		BIT(31)
 #define ID_P_MASK		GENMASK(31, 28)
 
+#define ID_SLAVE_NACK		BIT(0)
+
 enum rcar_i2c_type {
 	I2C_RCAR_GEN1,
 	I2C_RCAR_GEN2,
@@ -146,6 +148,7 @@ struct rcar_i2c_priv {
 	int irq;
 
 	struct i2c_client *host_notify_client;
+	u8 slave_flags;
 };
 
 #define rcar_i2c_priv_to_dev(p)		((p)->adap.dev.parent)
@@ -576,6 +579,7 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
 {
 	u32 ssr_raw, ssr_filtered;
 	u8 value;
+	int ret;
 
 	ssr_raw = rcar_i2c_read(priv, ICSSR) & 0xff;
 	ssr_filtered = ssr_raw & rcar_i2c_read(priv, ICSIER);
@@ -591,7 +595,10 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
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
@@ -604,18 +611,21 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
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



