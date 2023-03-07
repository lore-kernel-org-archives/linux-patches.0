Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A38BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E1BC433D2;
	Tue,  7 Mar 2023 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212918;
	bh=G1IF+I8bklVPCEKPT9SLdAXc7YFDOkHrAmmdYmYM1OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T76/l91Q/YZInLXp5T/am//FOmN3g7q1Nfunw4O8M+UwktK8ysDih6PAOk0JQ9IG8
	 AR5Yp2nJJySR4B2z8Nyy8dajrb7iLe7kZDhYdA4Q1kRmUosQa4OzQtjrhpRQlhFNs3
	 XCK2PWXlaPKGKEOGICpolppVVnBBMyrL45Hl/Vfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Colin Foster <colin.foster@in-advantage.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 338/885] regmap: apply reg_base and reg_downshift for single register ops
Date: Tue,  7 Mar 2023 17:54:32 +0100
Message-Id: <20230307170016.898923418@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 697c3892d825fb78f42ec8e53bed065dd728db3e ]

reg_base and reg_downshift currently don't have any effect if used with
a regmap_bus or regmap_config which only offers single register
operations (ie. reg_read, reg_write and optionally reg_update_bits).

Fix that and take them into account also for regmap_bus with only
reg_read and read_write operations by applying reg_base and
reg_downshift in _regmap_bus_reg_write, _regmap_bus_reg_read.

Also apply reg_base and reg_downshift in _regmap_update_bits, but only
in case the operation is carried out with a reg_update_bits call
defined in either regmap_bus or regmap_config.

Fixes: 0074f3f2b1e43d ("regmap: allow a defined reg_base to be added to every address")
Fixes: 86fc59ef818beb ("regmap: add configurable downshift for addresses")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Tested-by: Colin Foster <colin.foster@in-advantage.com>
Link: https://lore.kernel.org/r/Y9clyVS3tQEHlUhA@makrotopia.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c6d6d53e8cd3f..7de1f27d0323d 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1942,6 +1942,8 @@ static int _regmap_bus_reg_write(void *context, unsigned int reg,
 {
 	struct regmap *map = context;
 
+	reg += map->reg_base;
+	reg >>= map->format.reg_downshift;
 	return map->bus->reg_write(map->bus_context, reg, val);
 }
 
@@ -2840,6 +2842,8 @@ static int _regmap_bus_reg_read(void *context, unsigned int reg,
 {
 	struct regmap *map = context;
 
+	reg += map->reg_base;
+	reg >>= map->format.reg_downshift;
 	return map->bus->reg_read(map->bus_context, reg, val);
 }
 
@@ -3231,6 +3235,8 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 		*change = false;
 
 	if (regmap_volatile(map, reg) && map->reg_update_bits) {
+		reg += map->reg_base;
+		reg >>= map->format.reg_downshift;
 		ret = map->reg_update_bits(map->bus_context, reg, mask, val);
 		if (ret == 0 && change)
 			*change = true;
-- 
2.39.2



