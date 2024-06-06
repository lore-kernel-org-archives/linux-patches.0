Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D93A1C8A00;
	Thu,  6 Jun 2024 14:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683714; cv=none; b=bFN67kdzw++2XF29FOOxVAb/hUZuaagUPMu02xGxqpvpYamtkXyGjNilYzUyTVAfqL+9W5yXpbhRu8KOkVVTZDShb6mxhkpY1lGZr+txwO7nxpXZyJO4nLK3h4e5pPWJcn+TCARnsSnseMJ36edjEP9UdugcDR/wbVnzFKSFHUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683714; c=relaxed/simple;
	bh=jCQgsKEd6HYv/EmLo4n+jTVBECBhEgy8i58BcgPQSxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FY6V8qa/IooJhT4ziYpDm1Ke/Soj2rSIeX3cs+TtK78L2VCKm6BH70LRRD4dEddqkJq8Q0i6k50LM9+MdHlGYRJdcnckHfMpXin+aqVCV8+nAqx88pbYD3ScuLIR3YUmTHD8db32v/unwMBIXACxL+BhlFBjsth3G7BTxpdgtQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBYF2zMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBYF2zMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EE9C2BD10;
	Thu,  6 Jun 2024 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683713;
	bh=jCQgsKEd6HYv/EmLo4n+jTVBECBhEgy8i58BcgPQSxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBYF2zMTWGha+PP7E5WVnHwBeuN5wsb0XP6kaEu4XFrYq9RYx7ry9n0wM4w/wEqvI
	 H/nqszk7yKIQszoWIru78WUj10Z8UyppLQbXI7GTCqmSopjU9RSuVG0yT6KKLI5zS7
	 W0FmFHb6SrzpS+stjeWDt7g4vI//kpItAsJ+s4LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neha Malcom Francis <n-francis@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 647/744] regulator: tps6594-regulator: Correct multi-phase configuration
Date: Thu,  6 Jun 2024 16:05:19 +0200
Message-ID: <20240606131753.218667762@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Neha Malcom Francis <n-francis@ti.com>

[ Upstream commit 74b38cd77d3eb63c6d0ad9cf2ae59812ae54d3ee ]

According to the TPS6594 PMIC Manual (linked) 8.3.2.1.4 Multi-Phase BUCK
Regulator Configurations section, the PMIC ignores all the other bucks'
except the primary buck's regulator registers. This is BUCK1 for
configurations BUCK12, BUCK123 and BUCK1234 while it is BUCK3 for
BUCK34. Correct the registers mapped for these configurations
accordingly.

Fixes: f17ccc5deb4d ("regulator: tps6594-regulator: Add driver for TI TPS6594 regulators")
Link: https://www.ti.com/lit/gpn/tps6594-q1
Signed-off-by: Neha Malcom Francis <n-francis@ti.com>
Link: https://msgid.link/r/20240521094758.2190331-1-n-francis@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps6594-regulator.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/tps6594-regulator.c b/drivers/regulator/tps6594-regulator.c
index b7f0c87797577..5fad61785e72f 100644
--- a/drivers/regulator/tps6594-regulator.c
+++ b/drivers/regulator/tps6594-regulator.c
@@ -287,30 +287,30 @@ static struct tps6594_regulator_irq_type *tps6594_ldos_irq_types[] = {
 static const struct regulator_desc multi_regs[] = {
 	TPS6594_REGULATOR("BUCK12", "buck12", TPS6594_BUCK_1,
 			  REGULATOR_VOLTAGE, tps6594_bucks_ops, TPS6594_MASK_BUCKS_VSET,
-			  TPS6594_REG_BUCKX_VOUT_1(1),
+			  TPS6594_REG_BUCKX_VOUT_1(0),
 			  TPS6594_MASK_BUCKS_VSET,
-			  TPS6594_REG_BUCKX_CTRL(1),
+			  TPS6594_REG_BUCKX_CTRL(0),
 			  TPS6594_BIT_BUCK_EN, 0, 0, bucks_ranges,
 			  4, 4000, 0, NULL, 0, 0),
 	TPS6594_REGULATOR("BUCK34", "buck34", TPS6594_BUCK_3,
 			  REGULATOR_VOLTAGE, tps6594_bucks_ops, TPS6594_MASK_BUCKS_VSET,
-			  TPS6594_REG_BUCKX_VOUT_1(3),
+			  TPS6594_REG_BUCKX_VOUT_1(2),
 			  TPS6594_MASK_BUCKS_VSET,
-			  TPS6594_REG_BUCKX_CTRL(3),
+			  TPS6594_REG_BUCKX_CTRL(2),
 			  TPS6594_BIT_BUCK_EN, 0, 0, bucks_ranges,
 			  4, 0, 0, NULL, 0, 0),
 	TPS6594_REGULATOR("BUCK123", "buck123", TPS6594_BUCK_1,
 			  REGULATOR_VOLTAGE, tps6594_bucks_ops, TPS6594_MASK_BUCKS_VSET,
-			  TPS6594_REG_BUCKX_VOUT_1(1),
+			  TPS6594_REG_BUCKX_VOUT_1(0),
 			  TPS6594_MASK_BUCKS_VSET,
-			  TPS6594_REG_BUCKX_CTRL(1),
+			  TPS6594_REG_BUCKX_CTRL(0),
 			  TPS6594_BIT_BUCK_EN, 0, 0, bucks_ranges,
 			  4, 4000, 0, NULL, 0, 0),
 	TPS6594_REGULATOR("BUCK1234", "buck1234", TPS6594_BUCK_1,
 			  REGULATOR_VOLTAGE, tps6594_bucks_ops, TPS6594_MASK_BUCKS_VSET,
-			  TPS6594_REG_BUCKX_VOUT_1(1),
+			  TPS6594_REG_BUCKX_VOUT_1(0),
 			  TPS6594_MASK_BUCKS_VSET,
-			  TPS6594_REG_BUCKX_CTRL(1),
+			  TPS6594_REG_BUCKX_CTRL(0),
 			  TPS6594_BIT_BUCK_EN, 0, 0, bucks_ranges,
 			  4, 4000, 0, NULL, 0, 0),
 };
-- 
2.43.0



