Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013DC1DA24
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAmitdFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74435C433C7;
	Wed,  4 Oct 2023 18:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444091;
	bh=XO9MRhdQE+KIBZfpMX74/7UUmE/iBLzvh6FoDyVewv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAmitdFuCqYU0GdQk7XtwhthKDghx40Zb9r6gZH5CuynXFBTvWuJ3Sm7+/7q/lPoK
	 RTKJq8LDT1pBTW5s61d6oQxUEa3fvzZzOIzFqJaYsrEZcNE9fQ3iTHT3Oc9fAzASVy
	 zC+FABoLSgy/Fhv9pQIjxl1WKKpogQFMHSsFBSas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 128/321] clk: si521xx: Fix regmap write accessor
Date: Wed,  4 Oct 2023 19:54:33 +0200
Message-ID: <20231004175235.186407493@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 83df5bf010eb5ccc11ce95f2d076515ec216c99c ]

Rework the write operation such that the Byte Count register is written with
a single raw i2c write outside of regmap using transfer which does specify
the number of bytes to be transfered, one in this case, and which makes the
expected subsequent write transfer look like address+register+data, and then
make use of this method. Without this change, the Byte Count register write
in probe() would succeed as it would provide the byte count as part of its
write payload, but any subsequent writes would fail due to this Byte Count
register programming. Such failing writes happens e.g. during resume, when
restoring the regmap content.

Fixes: edc12763a3a2 ("clk: si521xx: Clock driver for Skyworks Si521xx I2C PCIe clock generators")
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20230831181656.154750-2-marex@denx.de
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si521xx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk-si521xx.c b/drivers/clk/clk-si521xx.c
index 0b9e2edbbe67c..ef4ba467e747b 100644
--- a/drivers/clk/clk-si521xx.c
+++ b/drivers/clk/clk-si521xx.c
@@ -96,7 +96,7 @@ static int si521xx_regmap_i2c_write(void *context, unsigned int reg,
 				    unsigned int val)
 {
 	struct i2c_client *i2c = context;
-	const u8 data[3] = { reg, 1, val };
+	const u8 data[2] = { reg, val };
 	const int count = ARRAY_SIZE(data);
 	int ret;
 
@@ -281,9 +281,10 @@ static int si521xx_probe(struct i2c_client *client)
 {
 	const u16 chip_info = (u16)(uintptr_t)device_get_match_data(&client->dev);
 	const struct clk_parent_data clk_parent_data = { .index = 0 };
-	struct si521xx *si;
+	const u8 data[3] = { SI521XX_REG_BC, 1, 1 };
 	unsigned char name[6] = "DIFF0";
 	struct clk_init_data init = {};
+	struct si521xx *si;
 	int i, ret;
 
 	if (!chip_info)
@@ -308,7 +309,7 @@ static int si521xx_probe(struct i2c_client *client)
 				     "Failed to allocate register map\n");
 
 	/* Always read back 1 Byte via I2C */
-	ret = regmap_write(si->regmap, SI521XX_REG_BC, 1);
+	ret = i2c_master_send(client, data, ARRAY_SIZE(data));
 	if (ret < 0)
 		return ret;
 
-- 
2.40.1



