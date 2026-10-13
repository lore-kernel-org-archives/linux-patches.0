Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442D44EE858;
	Tue, 13 Oct 2026 12:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893036; cv=none; b=piqsViugExyW25s4hVXVsYbE0VIbmkdqawMviMM3rNm3HGj7MKwJL38QL2ZHG7Qzui5bTD65H1OKps2fxP15fxoFm/etGzHRfjb7ptusV9Pa4x5kd9y28mhixuqydW+S/9mSD7KtrbXzE1E7oVDWYwZ2OGugJ1GPh96FuUf7lJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893036; c=relaxed/simple;
	bh=FuXNAwcSAgRUzy5BPYPMF9fzuKs3jqwBKhSeTXBdYIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mu/mo8AOFbFxdIgfOS95qSNyVQpYgbDZ6ybKAmpAYpjplZtACSYdgOUNRoje9iHDsH31EnkSgfA+sClG3etaZcHFJmV7UEaUIkYGSFEbsIzPL5USkKOsbwmt75e+UEjLDu1qZGFWxL/7uKiCYqCBHkA/y7BkdeJra1fRMS2eR4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrA23WTI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrA23WTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED2D1F000FF;
	Tue, 13 Oct 2026 12:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893035;
	bh=H7uyYyXPIvVo7clkTztZ0mhNRK1yG+oT+zptKJrt0Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hrA23WTICNoEw7jSxBZEDQk0wIB/s1TxrFNsnEF+kvfReNV/Hkoaf74L8SaCHvPkT
	 hL0CqgsJ9/H392Sx8CXr80tgjQNJQPaUEYL4Z524JQsyuDMS9x+fOzVGIwN+umNpb8
	 EoeoBwP3+/bT9yqWXVFxax0THV3V8TC1hnAF/MYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 090/621] regulator: tps6594-regulator: Fix n_linear_ranges for TPS65224 BUCK2-4
Date: Tue, 13 Oct 2026 13:31:25 +0200
Message-ID: <20261013112922.989225528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Ridham Khurana <khurana.ridham222@gmail.com>

commit 2f15518682c779b1014552cb2ccb4a2052f85f27 upstream.

The TPS65224 BUCK2, BUCK3 and BUCK4 descriptors pass 4 as
n_linear_ranges, but tps65224_bucks_2_3_4_ranges[] only has two
entries, covering selectors 0x00-0x45.

The linear range helpers loop over n_linear_ranges entries, so any
lookup of a selector above 0x45 reads past the end of the array and
treats whatever follows it as two more ranges. This happens on the
normal registration path when the core checks the voltage constraints
against every selector. TPS652G1 uses the same descriptors and is
affected too.

Use ARRAY_SIZE() so the count always matches the table.

Fixes: 00c826525fba ("regulator: tps6594-regulator: Add TI TPS65224 PMIC regulators")
Cc: stable@vger.kernel.org
Signed-off-by: Ridham Khurana <khurana.ridham222@gmail.com>
Link: https://patch.msgid.link/20260930105333.3522412-1-khurana.ridham222@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/tps6594-regulator.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/regulator/tps6594-regulator.c
+++ b/drivers/regulator/tps6594-regulator.c
@@ -241,21 +241,21 @@ static const struct regulator_desc tps65
 			  TPS65224_MASK_BUCKS_VSET,
 			  TPS6594_REG_BUCKX_CTRL(1),
 			  TPS6594_BIT_BUCK_EN, 0, 0, tps65224_bucks_2_3_4_ranges,
-			  4, 0, 0, NULL, 0, 0),
+			  ARRAY_SIZE(tps65224_bucks_2_3_4_ranges), 0, 0, NULL, 0, 0),
 	TPS6594_REGULATOR("BUCK3", "buck3", TPS6594_BUCK_3,
 			  REGULATOR_VOLTAGE, tps6594_bucks_ops, TPS65224_MASK_BUCKS_VSET,
 			  TPS6594_REG_BUCKX_VOUT_1(2),
 			  TPS65224_MASK_BUCKS_VSET,
 			  TPS6594_REG_BUCKX_CTRL(2),
 			  TPS6594_BIT_BUCK_EN, 0, 0, tps65224_bucks_2_3_4_ranges,
-			  4, 0, 0, NULL, 0, 0),
+			  ARRAY_SIZE(tps65224_bucks_2_3_4_ranges), 0, 0, NULL, 0, 0),
 	TPS6594_REGULATOR("BUCK4", "buck4", TPS6594_BUCK_4,
 			  REGULATOR_VOLTAGE, tps6594_bucks_ops, TPS65224_MASK_BUCKS_VSET,
 			  TPS6594_REG_BUCKX_VOUT_1(3),
 			  TPS65224_MASK_BUCKS_VSET,
 			  TPS6594_REG_BUCKX_CTRL(3),
 			  TPS6594_BIT_BUCK_EN, 0, 0, tps65224_bucks_2_3_4_ranges,
-			  4, 0, 0, NULL, 0, 0),
+			  ARRAY_SIZE(tps65224_bucks_2_3_4_ranges), 0, 0, NULL, 0, 0),
 };
 
 static const struct tps6594_regulator_irq_type tps6594_buck1_irq_types[] = {


