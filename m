Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA7118FDAA;
	Fri,  6 Dec 2024 15:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497799; cv=none; b=bJH+g+JdSzKIkXx8iSek552Osra+qCxV6px6rQseZ2f2hretPZOfdhRdQvbVmPF0bAvPyiD1ZIPk8r/BArLPA9fP0hC9yhL06HtQDtkx6POjnant1iTEB4SD+YEb5Edllq0VmhAJWncBmoBRz+EJrURrA32eqp+QN+4yUUClgs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497799; c=relaxed/simple;
	bh=sxCvcrF0t7ZTN3sz6edUyKIeNer7jJL/iCt5psNDN9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuiMvXoqwWCldXF6JjxdXE643FIfk+uYlul+3oXnhk+pqD7I+BHhsASdLA2oA2YXhkyiz1i/dGa4OtoiIc203J1bwlgJSvej7t+aUFvlAqhfBXr01odHgYEtNDXYcZ3dpjVbkGGOttEIh1W4yGDbwSvhJkRz6P2vFmQbCyfayKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpV1IbZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpV1IbZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3204C4CED1;
	Fri,  6 Dec 2024 15:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497799;
	bh=sxCvcrF0t7ZTN3sz6edUyKIeNer7jJL/iCt5psNDN9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tpV1IbZKnhKmOoF6ek6PxMdCOIbAn3nE6IOKmsMsoH6/2/RrOoL7V7JbIjEEqtQ6x
	 aTwu0T9q6Q02wXa7J3qmbvfsVCIAeBEhtz9YcPwuYwjVo2CPOSA1CFtZhYEQjvh9IY
	 Cn4cDK3lXwAOZ4eGOs3Db1ktUbAKI3WuvLGW+ph8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tsai <lucas_tsai@richtek.com>,
	ChiYuan Huang <cy_huang@richtek.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 397/676] power: supply: rt9471: Use IC status regfield to report real charger status
Date: Fri,  6 Dec 2024 15:33:36 +0100
Message-ID: <20241206143708.857335737@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit c46a9ee5c6210682611d3d4276436c23a95e1996 ]

Use IC status regfield to rewrite the 'get_staus' function. The original
one cannot cover some special scenario like as charger OTG or JEITA case.

Fixes: 4a1a5f6781d8 ("power: supply: rt9471: Add Richtek RT9471 charger driver")
Reported-by: Lucas Tsai <lucas_tsai@richtek.com>
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://lore.kernel.org/r/67ba92bb4a9c51d9cafadab30b788a3a2c3048e1.1727252762.git.cy_huang@richtek.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9471.c | 48 ++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/power/supply/rt9471.c b/drivers/power/supply/rt9471.c
index f62154d929028..522a67736fa5a 100644
--- a/drivers/power/supply/rt9471.c
+++ b/drivers/power/supply/rt9471.c
@@ -139,6 +139,19 @@ enum {
 	RT9471_PORTSTAT_DCP,
 };
 
+enum {
+	RT9471_ICSTAT_SLEEP = 0,
+	RT9471_ICSTAT_VBUSRDY,
+	RT9471_ICSTAT_TRICKLECHG,
+	RT9471_ICSTAT_PRECHG,
+	RT9471_ICSTAT_FASTCHG,
+	RT9471_ICSTAT_IEOC,
+	RT9471_ICSTAT_BGCHG,
+	RT9471_ICSTAT_CHGDONE,
+	RT9471_ICSTAT_CHGFAULT,
+	RT9471_ICSTAT_OTG = 15,
+};
+
 struct rt9471_chip {
 	struct device *dev;
 	struct regmap *regmap;
@@ -255,31 +268,32 @@ static int rt9471_get_ieoc(struct rt9471_chip *chip, int *microamp)
 
 static int rt9471_get_status(struct rt9471_chip *chip, int *status)
 {
-	unsigned int chg_ready, chg_done, fault_stat;
+	unsigned int ic_stat;
 	int ret;
 
-	ret = regmap_field_read(chip->rm_fields[F_ST_CHG_RDY], &chg_ready);
-	if (ret)
-		return ret;
-
-	ret = regmap_field_read(chip->rm_fields[F_ST_CHG_DONE], &chg_done);
+	ret = regmap_field_read(chip->rm_fields[F_IC_STAT], &ic_stat);
 	if (ret)
 		return ret;
 
-	ret = regmap_read(chip->regmap, RT9471_REG_STAT1, &fault_stat);
-	if (ret)
-		return ret;
-
-	fault_stat &= RT9471_CHGFAULT_MASK;
-
-	if (chg_ready && chg_done)
-		*status = POWER_SUPPLY_STATUS_FULL;
-	else if (chg_ready && fault_stat)
+	switch (ic_stat) {
+	case RT9471_ICSTAT_VBUSRDY:
+	case RT9471_ICSTAT_CHGFAULT:
 		*status = POWER_SUPPLY_STATUS_NOT_CHARGING;
-	else if (chg_ready && !fault_stat)
+		break;
+	case RT9471_ICSTAT_TRICKLECHG ... RT9471_ICSTAT_BGCHG:
 		*status = POWER_SUPPLY_STATUS_CHARGING;
-	else
+		break;
+	case RT9471_ICSTAT_CHGDONE:
+		*status = POWER_SUPPLY_STATUS_FULL;
+		break;
+	case RT9471_ICSTAT_SLEEP:
+	case RT9471_ICSTAT_OTG:
 		*status = POWER_SUPPLY_STATUS_DISCHARGING;
+		break;
+	default:
+		*status = POWER_SUPPLY_STATUS_UNKNOWN;
+		break;
+	}
 
 	return 0;
 }
-- 
2.43.0



