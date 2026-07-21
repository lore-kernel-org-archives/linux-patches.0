Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6DE35C69D;
	Tue, 21 Jul 2026 21:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669151; cv=none; b=T3z0j8/ar8BBooMNR71Gcj2pQtRXI+fbIYWeS7dflSY+8RyfFbfOpOi7GjJSoL2gAz5q3kZ4Ovqu4YMLjNFO1O9ioOrLaavaGdhYpomV7DsbBw52IsvrbLzTFwjY3s6CPKfaCBVjDpmt3M4DjQ2MZdOAXvKjUKIYNnCoZFCLocw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669151; c=relaxed/simple;
	bh=cxJUA5XW2jocVXmew2gdGy1Dp7P+I2KGbtLTD11EQPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KR1Mn+/ncxezbO95NxuonVqpjR10mIXHvg53VZ7hhD3/vFHEgruQ60GsRK153AGhKyxtGER6VlH5SVMqFIzS8h5FoAsMMHs2Xi7watA+OGgR0yjROOFSvAJ/jAzavVDwzVBuW0cs6WirkghBgYIY2RMMrQEdkTPiRstXn6HoQ2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHjiVPSl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHjiVPSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F351F000E9;
	Tue, 21 Jul 2026 21:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669150;
	bh=Y+kO10o7cd+LOmPqcW5NzGxXfpQnHMa0q+UiLZzwpMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XHjiVPSl07Y3t6Dz2H/Ldt4AFVyHQTUOINDHME39o/ajNpdfgTGYG+c7Br9S4q7ER
	 kPQMdZ925N3NuQq43ODjfsx6cIf6X6mKbBMyRqouNVYr1q0QWtfKuFl6Nh9ARZGsCd
	 NKRvGU6Hz/lgfKuv1pZIC1iQ2iFJp4U+i7zfg01o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tsai <lucas_tsai@richtek.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0446/1067] power: supply: core: fix supplied_from allocations
Date: Tue, 21 Jul 2026 17:17:27 +0200
Message-ID: <20260721152434.595004024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 13801dfa5c3857..54a1d8dee95ddd 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -262,18 +262,13 @@ static int power_supply_check_supplies(struct power_supply *psy)
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



