Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F20D47127A;
	Tue, 21 Jul 2026 18:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659920; cv=none; b=r+uRTp590PXhcYJkYYykMFM8+lTUJWD4k9LzOI8Bp0yaG1nDzktx2PUT7NpM6A7BLt6YCx0m6bmL69+A1z3OtdhuIm4xtna9g2Zfouovzr4F/4zhYgCXfhCI6qVMONPlkqyt9ifWfp22Au6tpXppgXIIMW3AxfxxFGwGxn8boPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659920; c=relaxed/simple;
	bh=LEWe0KojWKyBRpH5oB9VIsXkx53lOefJ9buztARTyvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6TUAz5Wr1D7kHbrAv9gNO7HyZM1FV6RSntiCp/tfQnG0g08rOezNL9Gmtx+MBqAY8hhyzNjnkFcTk5Guc03XCqkdjn/B3iuTyY22wHDP0FUrOMYvQTsiY2uC8tzHPlOEAFeLTcIIaF+Hhbu5br6YLYMNv8Yrk21Tex2ALKQuK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/E/BF8v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/E/BF8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B2C1F00A3A;
	Tue, 21 Jul 2026 18:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659919;
	bh=snkan5oi0JQ2llbPwLz5fk/HrmJzrh2tVqIWkpQXGhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M/E/BF8voJ7pKX+Zb5KVheb9borWpIqvupMamdZBfXh7YkLmZqAMmvEkx2sm7EmB0
	 NMeIlXYtGeVzNhAYXFvVW2NkH1iQyr6pkuAGdoEB7jbvm/4LaOA9cHjJJmccv0HyfU
	 xxdybxLdWTYTIiOtIVVyd+PDdwv8jWgMI7xV2Enk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tsai <lucas_tsai@richtek.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0739/2077] power: supply: core: fix supplied_from allocations
Date: Tue, 21 Jul 2026 17:06:52 +0200
Message-ID: <20260721152610.226688180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Tsai <lucas_tsai@richtek.com>

[ Upstream commit ba61aed9a34671222d1149acfc2f0179a9ce7e80 ]

If dts property power-supplies has multiple values, then accessing to
psy->supplied_from[i-1] in __power_supply_populate_supplied_from will
overrun supplied_from array.

Fixes: f6e0b081fb30 ("power_supply: Populate supplied_from hierarchy from the device tree")
Signed-off-by: Lucas Tsai <lucas_tsai@richtek.com>
Link: https://patch.msgid.link/20260609114403.3896073-1-lucas_tsai@richtek.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index a446d3d086fcd2..2532e221b2e191 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -292,18 +292,13 @@ static int power_supply_check_supplies(struct power_supply *psy)
 	if (cnt == 1)
 		return 0;
 
-	/* All supplies found, allocate char ** array for filling */
-	psy->supplied_from = devm_kzalloc(&psy->dev, sizeof(*psy->supplied_from),
+	/* All supplies found, allocate char * array for filling */
+	psy->supplied_from = devm_kcalloc(&psy->dev,
+					  cnt - 1, sizeof(*psy->supplied_from),
 					  GFP_KERNEL);
 	if (!psy->supplied_from)
 		return -ENOMEM;
 
-	*psy->supplied_from = devm_kcalloc(&psy->dev,
-					   cnt - 1, sizeof(**psy->supplied_from),
-					   GFP_KERNEL);
-	if (!*psy->supplied_from)
-		return -ENOMEM;
-
 	return power_supply_populate_supplied_from(psy);
 }
 #else
-- 
2.53.0



