Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2201EF0AE;
	Tue,  3 Dec 2024 15:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239291; cv=none; b=rTzw0I7RqqNmAsh/199hj5ZXpqVauPI4I25Z0CJxbZcR+3jzq+hP7ULNHrPtkZTHTndBHAVZzzE9lgDhPSX2pWR7kyfL2yQHHQAdHTBJWyCbzXS/eJ7dspFagXAZbMWlvr5l+m8E7tJmzougTvcS8qByfszCWqu3WHRwPkuggFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239291; c=relaxed/simple;
	bh=UyuJjcVeP2PlWV4P/9dy1Yzx5ld3er5iLDV6SypyUEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cainrig9tC13vf1GDaTR0Ji8cbbfugn1YvPVv6v3Cwcuw88ugT2WEHkCXP4tOEKLCWN8AP1JjAKSDNFaair3KQ5YLE6HJ3KFv2lcbwQDGv7aaHs+RLTmcHt5YLLF8RhLP4ckk5FW825QWkmIKGkBs1loQFXfVCp5DUnMH+IkNMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pi7R+t+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pi7R+t+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F05C4CECF;
	Tue,  3 Dec 2024 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239291;
	bh=UyuJjcVeP2PlWV4P/9dy1Yzx5ld3er5iLDV6SypyUEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pi7R+t+72Ct71WgQoVNOLWslDjYGNKeVhDBKvd0BTu1W7k0f/FFUaDLJmPvpLUxt5
	 UGdsqhk7p6HXOh4kHtVuc8yc4Bj5HmZUH9N5Zuu3eHd7Yx7x1NxYrU7JZIpD1b1Azh
	 w+0fri7FyjhXfW7kMGjm3LS6HxU1Nkbc+8QdwbnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 563/817] power: supply: bq27xxx: Fix registers of bq27426
Date: Tue,  3 Dec 2024 15:42:15 +0100
Message-ID: <20241203144017.886448404@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 34f99d3b706a519e556841f405c224ca708b1f54 ]

Correct bq27426 registers, according to technical reference manual
it does not have Design Capacity register so it is not register
compatible with bq27421.

Fixes: 5ef6a16033b47 ("power: supply: bq27xxx: Add support for BQ27426")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/r/20241016-fix_bq27426-v2-1-aa6c0f51a9f6@mainlining.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 37 ++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index 750fda543308c..51fb88aca0f9f 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -449,9 +449,29 @@ static u8
 		[BQ27XXX_REG_AP] = 0x18,
 		BQ27XXX_DM_REG_ROWS,
 	},
+	bq27426_regs[BQ27XXX_REG_MAX] = {
+		[BQ27XXX_REG_CTRL] = 0x00,
+		[BQ27XXX_REG_TEMP] = 0x02,
+		[BQ27XXX_REG_INT_TEMP] = 0x1e,
+		[BQ27XXX_REG_VOLT] = 0x04,
+		[BQ27XXX_REG_AI] = 0x10,
+		[BQ27XXX_REG_FLAGS] = 0x06,
+		[BQ27XXX_REG_TTE] = INVALID_REG_ADDR,
+		[BQ27XXX_REG_TTF] = INVALID_REG_ADDR,
+		[BQ27XXX_REG_TTES] = INVALID_REG_ADDR,
+		[BQ27XXX_REG_TTECP] = INVALID_REG_ADDR,
+		[BQ27XXX_REG_NAC] = 0x08,
+		[BQ27XXX_REG_RC] = 0x0c,
+		[BQ27XXX_REG_FCC] = 0x0e,
+		[BQ27XXX_REG_CYCT] = INVALID_REG_ADDR,
+		[BQ27XXX_REG_AE] = INVALID_REG_ADDR,
+		[BQ27XXX_REG_SOC] = 0x1c,
+		[BQ27XXX_REG_DCAP] = INVALID_REG_ADDR,
+		[BQ27XXX_REG_AP] = 0x18,
+		BQ27XXX_DM_REG_ROWS,
+	},
 #define bq27411_regs bq27421_regs
 #define bq27425_regs bq27421_regs
-#define bq27426_regs bq27421_regs
 #define bq27441_regs bq27421_regs
 #define bq27621_regs bq27421_regs
 	bq27z561_regs[BQ27XXX_REG_MAX] = {
@@ -769,10 +789,23 @@ static enum power_supply_property bq27421_props[] = {
 };
 #define bq27411_props bq27421_props
 #define bq27425_props bq27421_props
-#define bq27426_props bq27421_props
 #define bq27441_props bq27421_props
 #define bq27621_props bq27421_props
 
+static enum power_supply_property bq27426_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_CHARGE_FULL,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_MANUFACTURER,
+};
+
 static enum power_supply_property bq27z561_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_PRESENT,
-- 
2.43.0



