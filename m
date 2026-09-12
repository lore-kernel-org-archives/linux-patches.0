Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD083624BC;
	Sat, 12 Sep 2026 08:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203513; cv=none; b=IJxDv1ftji0dQ2WXBJ5cVL6QOMaOq1rT37x3WLJ+mCrfB05TNjHgEq+nePXEPJV9qmK+P2/1/NM94IgXp6mEoghFOVJuvQgPD9cWaH85EQGS4WKjwrd2An6SwA0R8NsHK4gvqJ0E9+zWhNE0L6uBepnTFJWm+kvCmY1c+N6jd08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203513; c=relaxed/simple;
	bh=eflRRXDA1iK758RSz4eI9QXGws/qmpBv03VHF+m94Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oe/Fr0FY0eaWl/04NC8q3+EgdDfitxOlzF9SSwUYuGYfPzWR6qLns6s5hnMFvuAywvKUNFO9dJfOH5ZIakLJgr4/vmQn4Xt29O8aUnjsJuDZoFmial9LdrH71ahUj0fvDUS6uxIvdzEt/5d189GCT1Ki71Wq4zuW+O02S7dgXkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/h7lrPi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/h7lrPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C511F000FF;
	Sat, 12 Sep 2026 08:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203512;
	bh=XIHaCD1fa1oE2hZ5zA8NgofFSj66MSO0h205wmNLNXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/h7lrPiLUvCD94OuNwtIKLEUO1cT1CLjrUvlokJKp4W8k2wZkJ/zFLitVVIkjw8L
	 S71OJ0Elk4FBqc4aarYekMfyQtfEFt46rpPOS8dyGqAQvEGWmxD9+gsJWCvv+8135h
	 bLkiDxUho9mvtbC4VCBUQ08VLUoZ/NpzaE6mUcAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Kalle Niemi <kaleposti@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH 7.2 1416/1815] power: supply: bd71828: Fix current direction
Date: Sat, 12 Sep 2026 08:52:46 +0200
Message-ID: <20260912065722.262477044@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit d012fab12fed2053e0dca4c8cd4e2b2053afabfb ]

Both the current and the average current registers contain same
'direction' -bit to denote the direction of the current. The code
reading these registers incorrectly caches the direction read from the
first register, and uses it also for the second.

Fix this by initializing the direction bit for both register reads.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 5bff79dad20a ("power: supply: Add bd718(15/28/78) charger driver")
Tested-by: Andreas Kemnade <andreas@kemnade.info> # Kobo Clara 2e rev B
Tested-by: Kalle Niemi <kaleposti@gmail.com>
Link: https://patch.msgid.link/22c6816204b3f2a8b50df8171e384937822d195b.1786356145.git.mazziesaccount@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bd71828-power.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/bd71828-power.c b/drivers/power/supply/bd71828-power.c
index e5e5f25474f54..98e9b096cd1c9 100644
--- a/drivers/power/supply/bd71828-power.c
+++ b/drivers/power/supply/bd71828-power.c
@@ -191,12 +191,13 @@ static int bd71828_get_current_ds_adc(struct bd71828_power *pwr, int *curr, int
 {
 	__be16 tmp_curr;
 	char *tmp = (char *)&tmp_curr;
-	int dir = 1;
 	int regs[] = { pwr->regs->ibat, pwr->regs->ibat_avg };
 	int *vals[] = { curr, curr_avg };
 	int ret, i;
 
-	for (dir = 1, i = 0; i < ARRAY_SIZE(regs); i++) {
+	for (i = 0; i < ARRAY_SIZE(regs); i++) {
+		int dir = 1;
+
 		ret = regmap_bulk_read(pwr->regmap, regs[i], &tmp_curr,
 				       sizeof(tmp_curr));
 		if (ret)
-- 
2.53.0



