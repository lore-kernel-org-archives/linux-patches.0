Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE86646D557;
	Tue, 21 Jul 2026 17:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656743; cv=none; b=gCgOh1ZbWwhnd+EYSM8nwav+oTPnER6q4qHSM+ub2Y3giz3hHbVAh1+RFmC89wh2039kChW2ZhbjR4sDAZN72we7tDZ/ra9f2SiWBZzfr6Ht0hOvoeqth1P7IBU4iqtJftP/rZP6OSrDeVq52x2IPjbMHwAXRg3ZhsHb4wRxoLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656743; c=relaxed/simple;
	bh=PIGxEtA7l96CxHsyq8IuufqeFgt70h/Id3kydglxkhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFKfClXUEogidLieGJ0Exd6A9w6WfIZSO3X4qlAq7NJQ8VE2e1Ylxcgx4N4gsCoQXKiTNUhRJn8cZ0fYjM6lEafJZfFNbkNoRRRLkXpbVCeWq2Xj25V1qT/+14VuEJzrPm0FW/akzjxoTy/ZI9CVvcHqdHpKZyUz9joKL7J5gLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pg8x8+j4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pg8x8+j4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7121F000E9;
	Tue, 21 Jul 2026 17:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656742;
	bh=IKfJO1mtmaURGJnTTZx2TJJC2ydt85Ry6sTIcMQfUwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pg8x8+j45kGp22Nwy6ZqwntYdyzzF0JMvOfYLE84PFVj/ZYVbCy2EEihXUnoSTE1m
	 fhP/rVtSU58/9JTX5ozO9W/uc2aabCnY9bVvzGVWSbcJyQ0jr5VPU4VeKD4C5m+iN0
	 mvk1zVAP71Z0OHcJkpaRmV8PloU9biMH4mepLu5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tsai <lucas_tsai@richtek.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0501/1611] power: supply: core: fix supplied_from allocations
Date: Tue, 21 Jul 2026 17:10:17 +0200
Message-ID: <20260721152526.613568854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9a28381e2607d6..42ad333394d94a 100644
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



