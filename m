Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3825A192D8A;
	Sat, 12 Sep 2026 07:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198038; cv=none; b=jqduBMbgElnRkese7ix9EdIkeTrW1c6pZxmlqg5WDBRVFQJVNllNCgY6oWsKCnRflXNGENOlsyOppebzhiuFqWCfRS1d77wp9hNlT4PFM3SJ62+fHpLICKaIyqQVzDR7RMlr1ttuvONbIVAoiSr333d3QUHzbW75TcQOFQSEMII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198038; c=relaxed/simple;
	bh=pJRagrwjqvpsWnnbnAOnnvVX7qVfMEFyUZQZDzjvHug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2ODTsxmd0SUHyEk2ROxbf3e7P9d4iSPLKclJBeXw1kcAoxTAQ75OI7US//q2E3FmovYkMt44nV1hboiKZ7nlcdNS2+6GtnYXiJTF5sDwS78nZQ6C4UziQ6apklS4RsgbpUrcXgIMo+WuPOYRxPdO8VxQwML+Df4/ezziqz6q44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tw71gFLT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tw71gFLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E538B1F000FF;
	Sat, 12 Sep 2026 07:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198037;
	bh=TNLt465Mem5YSWL4f+cRuXAgUWOr+TX2jkrGZVyrr+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tw71gFLTl0lejoE2mmw3LrWyy0h1BS3MPiLH0zEOaDHO9xZl0qvPkkRQju3q3pCkI
	 HQOq3cmDehOibXfISc3chn/AsmzNdNK1hul7OuamNZMhfJuHisZ0gzCvzxdM7NQr1a
	 ka8o5B7Mp3NDodu4bBeB0ehXsyZSTHzI6Yo33its=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0298/1815] leds: st1202: Validate LED reg property against channel count
Date: Sat, 12 Sep 2026 08:34:08 +0200
Message-ID: <20260912065655.945941789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Fombuena <fombuena@outlook.com>

[ Upstream commit cf197514bdfd3877f42b5dce1efd40b7b686547e ]

The reg property from the device tree is used directly as an array index
into chip->leds[] without bounds checking. A value >= ST1202_MAX_LEDS
would cause an out-of-bounds write during probe.

Fixes: 259230378c65 ("leds: Add LED1202 I2C driver")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: Claude:claude-sonnet-4-6
Link: https://patch.msgid.link/GV1PR08MB849718B43321DB7E5A05D17BC5F52@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 19cb5b38d9762..2593ff39f22a6 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -277,13 +277,19 @@ static int st1202_dt_init(struct st1202_chip *chip)
 {
 	struct device *dev = &chip->client->dev;
 	struct st1202_led *led;
-	int err, reg;
+	int err;
+	u32 reg;
 
 	for_each_available_child_of_node_scoped(dev_of_node(dev), child) {
 		err = of_property_read_u32(child, "reg", &reg);
 		if (err)
 			return dev_err_probe(dev, err, "Invalid register\n");
 
+		if (reg >= ST1202_MAX_LEDS)
+			return dev_err_probe(dev, -EINVAL,
+					"LED reg %u out of range [0, %d]\n",
+					reg, ST1202_MAX_LEDS - 1);
+
 		led = &chip->leds[reg];
 		led->is_active = true;
 		led->fwnode = of_fwnode_handle(child);
-- 
2.53.0



