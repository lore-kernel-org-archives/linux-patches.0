Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04852FDC30;
	Sat, 12 Sep 2026 14:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222563; cv=none; b=Q/XJM+8LkkgmThk7LsHazn/SFo6phHhQp6EHKCqNJUHnKqr2RBsNa1VtVdKAxAYO1w+BgQ5ejlIoxaAdpWyo9ZQdG3AsaFsZanHjDoeoP8ni3sV+Okl14ZHoIAbiFhbj1/5NDzYTJajPfp6Z2uX7ZnXujUM0Y4gAlND24YdhYX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222563; c=relaxed/simple;
	bh=QhEu5y5DTjWhGniLQDlzE0/oTW/LMC64TqdGKZjf5p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkchJubYeyXRI3YickNsYDITMULLbLNH59SybYtPiMyX+OA0++TK0Hx0RCbUXRgS5GB/dqmuyWw4WSzZWc0UyOxZBtW1QBMI8+d/0j0vjvmCWZ10c+IeXG5kYqTraDUsWpsttq60L7y0Sfwx5wZOIkdF91QXq/N9vXesG4L1Rh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDj7vbjr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDj7vbjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C491F000FF;
	Sat, 12 Sep 2026 14:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222559;
	bh=Ouk8UPpalYYydOXWHJTxsUejwn+PSfakjKi2xvMzdiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZDj7vbjrXhjhUfllL8/Ha0GwmRSgq8z6jy26JALdeAh899b0rnRu9h4Mwq+C34Oi0
	 PKFnUbhMZC4fRiV2FSvpmg6Uy+VjVU5k0V7vFdC5Ax02KkJWx/xR5lJrbl2JDHBmID
	 yUcy4a/oA8SOMGNhjoUaq3A7e0bn//mSZfKwqGyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richard <thomas.richard@bootlin.com>,
	Nishanth Menon <nm@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0611/1424] regulator: tps6594-regulator: Fix the number of irqs for TPS65224 and TPS6594
Date: Sat, 12 Sep 2026 08:50:43 +0200
Message-ID: <20260912065620.974688561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Thomas Richard <thomas.richard@bootlin.com>

[ Upstream commit 8141b6da1763b9db009e5dcf873869bb31bcef45 ]

The number of irqs is computed to allocate the right amount of memory for
the irq data. An array of struct tps6594_regulator_irq_data is allocated
one time for all the irqs. Each irq uses one cell of the array.

If the computed number of irqs is not correct, not allocated memory could
be used.

Fix the	values used in the calculation for TPS6594 and TPS65224.

Fixes: 00c826525fba (regulator: tps6594-regulator: Add TI TPS65224 PMIC regulators)
Signed-off-by: Thomas Richard <thomas.richard@bootlin.com>
Tested-by: Nishanth Menon <nm@ti.com>
Link: https://msgid.link/r/20240603170100.2394402-1-thomas.richard@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7fd28093b3ef ("regulator: tps6594: Fix device node reference leaks in multiphase loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps6594-regulator.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/tps6594-regulator.c b/drivers/regulator/tps6594-regulator.c
index 4a859f4c0f835..ac53792e3fede 100644
--- a/drivers/regulator/tps6594-regulator.c
+++ b/drivers/regulator/tps6594-regulator.c
@@ -653,18 +653,14 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (tps->chip_id == LP8764) {
-		nr_buck = ARRAY_SIZE(buck_regs);
-		nr_ldo = 0;
-		nr_types = REGS_INT_NB;
-	} else if (tps->chip_id == TPS65224) {
+	if (tps->chip_id == TPS65224) {
 		nr_buck = ARRAY_SIZE(tps65224_buck_regs);
 		nr_ldo = ARRAY_SIZE(tps65224_ldo_regs);
-		nr_types = REGS_INT_NB;
+		nr_types = TPS65224_REGS_INT_NB;
 	} else {
 		nr_buck = ARRAY_SIZE(buck_regs);
-		nr_ldo = ARRAY_SIZE(tps6594_ldo_regs);
-		nr_types = TPS65224_REGS_INT_NB;
+		nr_ldo = (tps->chip_id == LP8764) ? 0 : ARRAY_SIZE(tps6594_ldo_regs);
+		nr_types = REGS_INT_NB;
 	}
 
 	reg_irq_nb = nr_types * (nr_buck + nr_ldo);
-- 
2.53.0



