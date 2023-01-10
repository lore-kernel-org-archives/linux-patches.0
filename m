Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6036FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B93C433D2;
	Tue, 10 Jan 2023 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374805;
	bh=bdDW3LLmItTeom4b4EPuVajnxo0DYPgkWZ1jf9gfEmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZh0ZdoGADCoU2Sfrq3hdTNar95v7FWYrTkM0Oz5C8mXX56zEn7LiH/voZz4IOxh4
	 SbEAVIxFOTqstNsc4OSN076Bg9XlvOutAQDwn0Nz9FcpJUKkyfRVJPCQND1P2vMyrR
	 +bjS3QjdNVzkJXn6cZF1J217+WkhgwkgMUeohHqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronald Wahl <ronald.wahl@raritan.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 132/159] Revert "net: dsa: qca8k: cache lo and hi for mdio write"
Date: Tue, 10 Jan 2023 19:04:40 +0100
Message-Id: <20230110180022.559245338@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Marangi <ansuelsmth@gmail.com>

commit 03cb9e6d0b32b768e3d9d473c5c4ca1100877664 upstream.

This reverts commit 2481d206fae7884cd07014fd1318e63af35e99eb.

The Documentation is very confusing about the topic.
The cache logic for hi and lo is wrong and actually miss some regs to be
actually written.

What the Documentation actually intended was that it's possible to skip
writing hi OR lo if half of the reg is not needed to be written or read.

Revert the change in favor of a better and correct implementation.

Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v5.18+
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c |   61 +++++++--------------------------------
 drivers/net/dsa/qca/qca8k.h      |    5 ---
 2 files changed, 12 insertions(+), 54 deletions(-)

--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -37,44 +37,6 @@ qca8k_split_addr(u32 regaddr, u16 *r1, u
 }
 
 static int
-qca8k_set_lo(struct qca8k_priv *priv, int phy_id, u32 regnum, u16 lo)
-{
-	u16 *cached_lo = &priv->mdio_cache.lo;
-	struct mii_bus *bus = priv->bus;
-	int ret;
-
-	if (lo == *cached_lo)
-		return 0;
-
-	ret = bus->write(bus, phy_id, regnum, lo);
-	if (ret < 0)
-		dev_err_ratelimited(&bus->dev,
-				    "failed to write qca8k 32bit lo register\n");
-
-	*cached_lo = lo;
-	return 0;
-}
-
-static int
-qca8k_set_hi(struct qca8k_priv *priv, int phy_id, u32 regnum, u16 hi)
-{
-	u16 *cached_hi = &priv->mdio_cache.hi;
-	struct mii_bus *bus = priv->bus;
-	int ret;
-
-	if (hi == *cached_hi)
-		return 0;
-
-	ret = bus->write(bus, phy_id, regnum, hi);
-	if (ret < 0)
-		dev_err_ratelimited(&bus->dev,
-				    "failed to write qca8k 32bit hi register\n");
-
-	*cached_hi = hi;
-	return 0;
-}
-
-static int
 qca8k_mii_read32(struct mii_bus *bus, int phy_id, u32 regnum, u32 *val)
 {
 	int ret;
@@ -97,7 +59,7 @@ qca8k_mii_read32(struct mii_bus *bus, in
 }
 
 static void
-qca8k_mii_write32(struct qca8k_priv *priv, int phy_id, u32 regnum, u32 val)
+qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
 {
 	u16 lo, hi;
 	int ret;
@@ -105,9 +67,12 @@ qca8k_mii_write32(struct qca8k_priv *pri
 	lo = val & 0xffff;
 	hi = (u16)(val >> 16);
 
-	ret = qca8k_set_lo(priv, phy_id, regnum, lo);
+	ret = bus->write(bus, phy_id, regnum, lo);
 	if (ret >= 0)
-		ret = qca8k_set_hi(priv, phy_id, regnum + 1, hi);
+		ret = bus->write(bus, phy_id, regnum + 1, hi);
+	if (ret < 0)
+		dev_err_ratelimited(&bus->dev,
+				    "failed to write qca8k 32bit register\n");
 }
 
 static int
@@ -417,7 +382,7 @@ qca8k_regmap_write(void *ctx, uint32_t r
 	if (ret < 0)
 		goto exit;
 
-	qca8k_mii_write32(priv, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
@@ -450,7 +415,7 @@ qca8k_regmap_update_bits(void *ctx, uint
 
 	val &= ~mask;
 	val |= write_val;
-	qca8k_mii_write32(priv, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
@@ -725,14 +690,14 @@ qca8k_mdio_write(struct qca8k_priv *priv
 	if (ret)
 		goto exit;
 
-	qca8k_mii_write32(priv, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
 	ret = qca8k_mdio_busy_wait(bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(priv, 0x10 | r2, r1, 0);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
 
 	mutex_unlock(&bus->mdio_lock);
 
@@ -762,7 +727,7 @@ qca8k_mdio_read(struct qca8k_priv *priv,
 	if (ret)
 		goto exit;
 
-	qca8k_mii_write32(priv, 0x10 | r2, r1, val);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
 	ret = qca8k_mdio_busy_wait(bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
@@ -773,7 +738,7 @@ qca8k_mdio_read(struct qca8k_priv *priv,
 
 exit:
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_mii_write32(priv, 0x10 | r2, r1, 0);
+	qca8k_mii_write32(bus, 0x10 | r2, r1, 0);
 
 	mutex_unlock(&bus->mdio_lock);
 
@@ -1943,8 +1908,6 @@ qca8k_sw_probe(struct mdio_device *mdiod
 	}
 
 	priv->mdio_cache.page = 0xffff;
-	priv->mdio_cache.lo = 0xffff;
-	priv->mdio_cache.hi = 0xffff;
 
 	/* Check the detected switch id */
 	ret = qca8k_read_switch_id(priv);
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -375,11 +375,6 @@ struct qca8k_mdio_cache {
  * mdio writes
  */
 	u16 page;
-/* lo and hi can also be cached and from Documentation we can skip one
- * extra mdio write if lo or hi is didn't change.
- */
-	u16 lo;
-	u16 hi;
 };
 
 struct qca8k_pcs {


