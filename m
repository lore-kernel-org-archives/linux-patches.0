Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2772F12C0;
	Fri, 17 Oct 2025 15:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715113; cv=none; b=dAVp/fnGK9CB6bVhMbna4xpxvKJ7yTT3Nt4PPIa59iw0O3U92BgWPTleEx9r2m+y+VH+anKhLzVPhCSLsBxnTEBRi9Hu2GsaDM1oZeQ2a5GeH6GAnggL1xeig0BJsOE0L97lEkdqgSP1AfJ/eWUTXBMW5A2V1KR2BaWykdHmXJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715113; c=relaxed/simple;
	bh=88GfuKTdkEVgl45xtidlXQxtY4ABMDfO1oRObOb81c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiJ5WUUP+AgsHTGnmkos1S8fZ3Q3SZ0tgUm8Ai/6kHJEyfYDqDAxqPQV5Gsk39e6lRsn/BQmsJBoZrUd+lJA64bPYtUAW//maR2G9NylCFfzQEFn1sRlYaqfb3GBqbXPzsHa26xzFLmSD/ebB+R3l8Rym/YKH0W57Abx3sa6s5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Os7xtqtI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Os7xtqtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5E2C4CEE7;
	Fri, 17 Oct 2025 15:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715113;
	bh=88GfuKTdkEVgl45xtidlXQxtY4ABMDfO1oRObOb81c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Os7xtqtI+Iisw0otO5WA3/AlKoKmi0deKA4RCvSgALLPlNZvHh0BqXe+vZ0gheYGM
	 BHA4qBl6il5cJfR1vfcJs0R9FXzHhVXGXkvT3rigpV/Ev5yXZQUOxvnWZDRgKlmnL5
	 31c/WUMMWR2nJWUZIYrdzBRre1mI8N4I6VYdB28g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 103/371] net: mdio: mdio-i2c: Hold the i2c bus lock during smbus transactions
Date: Fri, 17 Oct 2025 16:51:18 +0200
Message-ID: <20251017145205.666901701@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 4dc8b26a3ac2cb79f19f252d9077696d3ef0823a ]

When accessing an MDIO register using single-byte smbus accesses, we have to
perform 2 consecutive operations targeting the same address,
first accessing the MSB then the LSB of the 16 bit register:

  read_1_byte(addr); <- returns MSB of register at address 'addr'
  read_1_byte(addr); <- returns LSB

Some PHY devices present in SFP such as the Broadcom 5461 don't like
seeing foreign i2c transactions in-between these 2 smbus accesses, and
will return the MSB a second time when trying to read the LSB :

  read_1_byte(addr); <- returns MSB

  	i2c_transaction_for_other_device_on_the_bus();

  read_1_byte(addr); <- returns MSB again

Given the already fragile nature of accessing PHYs/SFPs with single-byte
smbus accesses, it's safe to say that this Broadcom PHY may not be the
only one acting like this.

Let's therefore hold the i2c bus lock while performing our smbus
transactions to avoid interleaved accesses.

Fixes: d4bd3aca33c2 ("net: mdio: mdio-i2c: Add support for single-byte SMBus operations")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251003070311.861135-1-maxime.chevallier@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-i2c.c | 39 ++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/net/mdio/mdio-i2c.c b/drivers/net/mdio/mdio-i2c.c
index 53e96bfab5422..ed20352a589a3 100644
--- a/drivers/net/mdio/mdio-i2c.c
+++ b/drivers/net/mdio/mdio-i2c.c
@@ -116,17 +116,23 @@ static int smbus_byte_mii_read_default_c22(struct mii_bus *bus, int phy_id,
 	if (!i2c_mii_valid_phy_id(phy_id))
 		return 0;
 
-	ret = i2c_smbus_xfer(i2c, i2c_mii_phy_addr(phy_id), 0,
-			     I2C_SMBUS_READ, reg,
-			     I2C_SMBUS_BYTE_DATA, &smbus_data);
+	i2c_lock_bus(i2c, I2C_LOCK_SEGMENT);
+
+	ret = __i2c_smbus_xfer(i2c, i2c_mii_phy_addr(phy_id), 0,
+			       I2C_SMBUS_READ, reg,
+			       I2C_SMBUS_BYTE_DATA, &smbus_data);
 	if (ret < 0)
-		return ret;
+		goto unlock;
 
 	val = (smbus_data.byte & 0xff) << 8;
 
-	ret = i2c_smbus_xfer(i2c, i2c_mii_phy_addr(phy_id), 0,
-			     I2C_SMBUS_READ, reg,
-			     I2C_SMBUS_BYTE_DATA, &smbus_data);
+	ret = __i2c_smbus_xfer(i2c, i2c_mii_phy_addr(phy_id), 0,
+			       I2C_SMBUS_READ, reg,
+			       I2C_SMBUS_BYTE_DATA, &smbus_data);
+
+unlock:
+	i2c_unlock_bus(i2c, I2C_LOCK_SEGMENT);
+
 	if (ret < 0)
 		return ret;
 
@@ -147,17 +153,22 @@ static int smbus_byte_mii_write_default_c22(struct mii_bus *bus, int phy_id,
 
 	smbus_data.byte = (val & 0xff00) >> 8;
 
-	ret = i2c_smbus_xfer(i2c, i2c_mii_phy_addr(phy_id), 0,
-			     I2C_SMBUS_WRITE, reg,
-			     I2C_SMBUS_BYTE_DATA, &smbus_data);
+	i2c_lock_bus(i2c, I2C_LOCK_SEGMENT);
+
+	ret = __i2c_smbus_xfer(i2c, i2c_mii_phy_addr(phy_id), 0,
+			       I2C_SMBUS_WRITE, reg,
+			       I2C_SMBUS_BYTE_DATA, &smbus_data);
 	if (ret < 0)
-		return ret;
+		goto unlock;
 
 	smbus_data.byte = val & 0xff;
 
-	ret = i2c_smbus_xfer(i2c, i2c_mii_phy_addr(phy_id), 0,
-			     I2C_SMBUS_WRITE, reg,
-			     I2C_SMBUS_BYTE_DATA, &smbus_data);
+	ret = __i2c_smbus_xfer(i2c, i2c_mii_phy_addr(phy_id), 0,
+			       I2C_SMBUS_WRITE, reg,
+			       I2C_SMBUS_BYTE_DATA, &smbus_data);
+
+unlock:
+	i2c_unlock_bus(i2c, I2C_LOCK_SEGMENT);
 
 	return ret < 0 ? ret : 0;
 }
-- 
2.51.0



