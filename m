Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BA26FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B79EC433A0;
	Mon,  3 Apr 2023 14:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533263;
	bh=TZQ9Sm5l2kDAZhpM/PIy0lbG0iqc5RAQW1RYefq0zTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Am/i8RqnXqA6zHYJBUFYKoH7RIr6501jVZmMBZ7sBBzN+YN3KF6IrZFR9pIzibGAb
	 TlsFLRQ/llBo82+Vg5TgdD1YlBpeKYMc+NNbY8maAKJb01jQbVnEVeZ9vwEQAqdHyF
	 zla8BXzdh4nDkJtQDuOQnPJo93jpRt48/D9Hnz6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 087/187] net: dsa: microchip: ksz8863_smi: fix bulk access
Date: Mon,  3 Apr 2023 16:08:52 +0200
Message-Id: <20230403140418.822152875@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 392ff7a84cbca34118ca286dfbfe8aee24605897 ]

Current regmap bulk access is broken, resulting to wrong reads/writes
if ksz_read64/ksz_write64 functions are used.
Mostly this issue was visible by using ksz8_fdb_dump(), which returned
corrupt MAC address.

The reason is that regmap was configured to have max_raw_read/write,
even if ksz8863_mdio_read/write functions are able to handle unlimited
read/write accesses. On ksz_read64 function we are using multiple 32bit
accesses by incrementing each access by 1 instead of 4. Resulting buffer
had 01234567.12345678 instead of 01234567.89abcdef.

We have multiple ways to fix it:
- enable 4 byte alignment for 32bit accesses. Since the HW do not have
  this requirement. It will break driver.
- disable max_raw_* limit.

This patch is removing max_raw_* limit for regmap accesses in ksz8863_smi.

Fixes: 60a364760002 ("net: dsa: microchip: Add Microchip KSZ8863 SMI based driver support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8863_smi.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
index 2f4623f3bd852..3698112138b78 100644
--- a/drivers/net/dsa/microchip/ksz8863_smi.c
+++ b/drivers/net/dsa/microchip/ksz8863_smi.c
@@ -82,22 +82,16 @@ static const struct regmap_bus regmap_smi[] = {
 	{
 		.read = ksz8863_mdio_read,
 		.write = ksz8863_mdio_write,
-		.max_raw_read = 1,
-		.max_raw_write = 1,
 	},
 	{
 		.read = ksz8863_mdio_read,
 		.write = ksz8863_mdio_write,
 		.val_format_endian_default = REGMAP_ENDIAN_BIG,
-		.max_raw_read = 2,
-		.max_raw_write = 2,
 	},
 	{
 		.read = ksz8863_mdio_read,
 		.write = ksz8863_mdio_write,
 		.val_format_endian_default = REGMAP_ENDIAN_BIG,
-		.max_raw_read = 4,
-		.max_raw_write = 4,
 	}
 };
 
@@ -108,7 +102,6 @@ static const struct regmap_config ksz8863_regmap_config[] = {
 		.pad_bits = 24,
 		.val_bits = 8,
 		.cache_type = REGCACHE_NONE,
-		.use_single_read = 1,
 		.lock = ksz_regmap_lock,
 		.unlock = ksz_regmap_unlock,
 	},
@@ -118,7 +111,6 @@ static const struct regmap_config ksz8863_regmap_config[] = {
 		.pad_bits = 24,
 		.val_bits = 16,
 		.cache_type = REGCACHE_NONE,
-		.use_single_read = 1,
 		.lock = ksz_regmap_lock,
 		.unlock = ksz_regmap_unlock,
 	},
@@ -128,7 +120,6 @@ static const struct regmap_config ksz8863_regmap_config[] = {
 		.pad_bits = 24,
 		.val_bits = 32,
 		.cache_type = REGCACHE_NONE,
-		.use_single_read = 1,
 		.lock = ksz_regmap_lock,
 		.unlock = ksz_regmap_unlock,
 	}
-- 
2.39.2



