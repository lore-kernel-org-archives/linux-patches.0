Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076402D94B5;
	Tue, 13 Oct 2026 12:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895849; cv=none; b=ggS09n1eRvn65Kehqnixt7W0+gt9q9i6UzLaa6gMMumBoK/vpJ9TdIsjMnHVDNXyNckky1UtQghNEku7UsF09X0p8tqo0qyDy9++IT+PaSZVtbdQbbZBTCujqK+y0OIeZPdHqPHTRxVXiwd8MxmPNR1FzwJqUt6fVHPOqswJ4wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895849; c=relaxed/simple;
	bh=9/uTSbKgf7Q12KNioxYfTWlpr9Sj4Oxs+g+5YWhJapw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leBeU0vzrD7ZMpO9+T2VsZ7pHJOxMnoLyC4Y6ikwtkbKfJfyqQyz4gTfzJHlfs4Dtu7f/ssRA8KlRqkSGTpLQOZsntIm/PVw86jfpgn6MgwxQxn50cIYb5Osh5fL22KU+khkzFOgcgRZaZKOHNrWukjhYikf3D6Gi8JudWfK5ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDQLXxJt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDQLXxJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE061F000FF;
	Tue, 13 Oct 2026 12:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895847;
	bh=bHg0P5GAFF4vo/FBMCpuj68vCbGomqwWlV1iD1hMqLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDQLXxJt76XudzBCjAYHlDZ5fqfgY5yYAxmjGD5s5/5qARrfRANz6gM41haaiia3b
	 QcLshezrScvlgsFHphLZ72Vo0WghwPIcsbnGWf2B8cCHk0cezySt25Sodc4ky1Anb/
	 6fqkC8rDhKcDIr95zA2E50+kMO8fZAgY+fWuHLR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 411/497] regulator: tps6594-regulator: Fix n_linear_ranges for TPS65224 BUCK2-4
Date: Tue, 13 Oct 2026 13:39:38 +0200
Message-ID: <20261013112917.644372177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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


