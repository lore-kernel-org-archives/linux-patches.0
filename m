Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A997646EC78;
	Tue, 21 Jul 2026 19:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662191; cv=none; b=FYlbwQsUjweF1aNE2WDnR8ua62+PfgHqShpQmxudXEaADpVv5SzSwtBhH3pSbvZnVPReDpHzFdcuqnMYZbzvygbe7g5wzn4BZw5MDfZcSFknwl0kgT1X5X0jl5ZSbsT07gUYLo4DahDXEMQVNGvHmkCptJTpO2gDLxTkMu+havs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662191; c=relaxed/simple;
	bh=VAZhGtJCat83lrAt/dgnZN3LiJ3AW4hXsGsuCE7Q/5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2n7dDTacibvaDHoLguDqTewXQgdx9rOutuwlTlUrog8skilhrg7UB+O1MlrxeKovSqzI9eFdi8VzS0AOyaSeOyKElZ4y4g6vb7SZp1NCj6AwemGarlSNwedXucn7XS+/qCFqwgAR3uE0CMmCbcH+ylitMHh3g0uAkgIlCFvkhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svjNHq68; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svjNHq68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C181F000E9;
	Tue, 21 Jul 2026 19:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662190;
	bh=/GVGfXub2tcNzvMOhBAV+LfEVXpmI50V51rHPP1Jg+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=svjNHq68jrydWxLGLe6UuJigdk/10A7e9W/DW9QRR9U9zebijBe0Fw7gSHIiD3lnU
	 Rppxx1y58ZxQvf9RZpTsIX5QkXM/DmFww8KQSHe79VYilXFa+gowuvDZY5A5bEGVB8
	 kh3/GFCEPgJhO9Hw3FH8XSDwI4mPBnv/qE8X9Eew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tsai <lucas_tsai@richtek.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0350/1276] power: supply: core: fix supplied_from allocations
Date: Tue, 21 Jul 2026 17:13:13 +0200
Message-ID: <20260721152453.945365062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 73cc9c236e8333..edc7b3bd9b5c80 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -269,18 +269,13 @@ static int power_supply_check_supplies(struct power_supply *psy)
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



