Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED493B1EFC;
	Tue, 21 Jul 2026 20:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666150; cv=none; b=ogu2rRSjputmnI0fCXEDEOKfDqml/A7AOjuIRLNUJQOjKzB0sWFC0SDpkG+eUBE/ngS0W15JR6sXKZPb5E38VSFG4WfcOZflNKID3f0ikrmGSe6C2rQUqdMXbO7FvdIYesGjryLwkHXVrnC8jT5trAiA839B8odXJDaY2+7tw1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666150; c=relaxed/simple;
	bh=mCFGgPEVZDvBmw4fh+3aILUfv80mLkuRz5Wlwf83Rbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgdvAKTsPR0ylqiA6ZpSNK2evklnP6ZLqUMWXmnQrV10iQgrgcXciNrlq/T8AXvMtQ/sMSu9quZMWOmzdXN4qGyU5AggODu1jSKgnNmdjQTmuDsMOWCh7DF9GjIrEg/rM4pdZEfqL2+NdNFjyFmPf6rgsoxakHbH/y9AQAmoaxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7M1hPWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7M1hPWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025F51F000E9;
	Tue, 21 Jul 2026 20:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666148;
	bh=zECechAMDnS5WEKFLT1z6JeZx/ramC1Um9Wq4Erc/08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7M1hPWg8+KN1JjSuJB1aA9kxqaFYXFWv6T2jdIfIS9j4ndAHVL4kThz9vPc2vTnf
	 nokNla7jG/TINpQp7RC5XlJfb589rLnM+DiKQOXxcRMh6FLQZqBxiLttpwxWdYalh4
	 GZHS3Z/VINCuKhCUN6n+jhDPZ9T9EGwNAb91g2i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tsai <lucas_tsai@richtek.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0573/1266] power: supply: core: fix supplied_from allocations
Date: Tue, 21 Jul 2026 17:16:50 +0200
Message-ID: <20260721152454.686518142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1893d37dd575de..4f350db05efa09 100644
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



