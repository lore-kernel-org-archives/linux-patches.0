Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D32175A98;
	Sat, 28 Feb 2026 17:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301403; cv=none; b=J3nh79yGJ92pRrnKX2d2DpxBsv4c8Y6B0Yq87WY4Wh63lgqgqoUOEjSYTATp8hsKaTsEcgi2wqGNwMRk+HK024Mgc+qPo7dxgATPiZDGAIVnP4kXMjdY/7WX6I9WEAo7DGGFD2LmvIuufNfDCHmEYZAs4DB9ORE0SpkyOrbuyFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301403; c=relaxed/simple;
	bh=VYxZee+WZHv8VmJp6p+SGQWMaZCd5KJAiLp5Is6OUJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhXBj9QklVHa8B6qlHhh9Ek+pcEMlp4wRAG3v5anqE4Xchy3JyYV1udXimLro1+WnSKqebp0Nj6fHxFNTcoEVJ03+SwCHRVrx6gjzSz3MYcf9nWeCpvJh2WBW13a9TVrmYEjPo/olG/OFJpumyMPIYcFSvNKQSuRVDSv8dZ2s8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O2lOsRSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O2lOsRSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BAFC116D0;
	Sat, 28 Feb 2026 17:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301403;
	bh=VYxZee+WZHv8VmJp6p+SGQWMaZCd5KJAiLp5Is6OUJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2lOsRSAFkUKFgOwNv9Lcf+l82bRIeekTq0eTxQgSCxoSaavPqk+kAFNSlgB2L44p
	 fm/2BYgD5fDqNN+hehgLtqrKHIWJJF5L+jcHD2JJ/EAnmLHKfbbJcEgobi0Y7im2z3
	 boG0PHFjB+GaVGaKSsrbRCnuuO4sKWb8T07PzdgA0zRr2z/efmmSkByuMGsHKl4tot
	 9phobHLy+MV/4HZ41oRxnVle0L0/w2DzwiAfh/vGbN6Zp4t1J452YtdgAnHHizdDjk
	 LI0DjuwQu8R2sQagjcH3IslVYAuc62cVfT/tSfbKvbe5UqYshAui5m+jSrsX8gruh9
	 rP+itqSB+g5bQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Kory Maincent (TI.com)" <kory.maincent@bootlin.com>,
	stable@vger.kernel.org,
	Andrew Davis <afd@ti.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 592/752] mfd: tps65219: Implement LOCK register handling for TPS65214
Date: Sat, 28 Feb 2026 12:45:03 -0500
Message-ID: <20260228174750.1542406-592-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Kory Maincent (TI.com)" <kory.maincent@bootlin.com>

[ Upstream commit d3fcf276b501a82d4504fd5b1ed40249546530d1 ]

The TPS65214 PMIC variant has a LOCK_REG register that prevents writes to
nearly all registers when locked. Unlock the registers at probe time and
leave them unlocked permanently.

This approach is justified because:
- Register locking is very uncommon in typical system operation
- No code path is expected to lock the registers during runtime
- Adding a custom regmap write function would add overhead to every
  register write, including voltage changes triggered by CPU OPP
  transitions from the cpufreq governor which could happen quite
  frequently

Cc: stable@vger.kernel.org
Fixes: 7947219ab1a2d ("mfd: tps65219: Add support for TI TPS65214 PMIC")
Reviewed-by: Andrew Davis <afd@ti.com>
Signed-off-by: Kory Maincent (TI.com) <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20251218-fix_tps65219-v5-1-8bb511417f3a@bootlin.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65219.c       | 9 +++++++++
 include/linux/mfd/tps65219.h | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/drivers/mfd/tps65219.c b/drivers/mfd/tps65219.c
index 65a952555218d..7275dcdb7c44f 100644
--- a/drivers/mfd/tps65219.c
+++ b/drivers/mfd/tps65219.c
@@ -498,6 +498,15 @@ static int tps65219_probe(struct i2c_client *client)
 		return ret;
 	}
 
+	if (chip_id == TPS65214) {
+		ret = i2c_smbus_write_byte_data(client, TPS65214_REG_LOCK,
+						TPS65214_LOCK_ACCESS_CMD);
+		if (ret) {
+			dev_err(tps->dev, "Failed to unlock registers %d\n", ret);
+			return ret;
+		}
+	}
+
 	ret = devm_regmap_add_irq_chip(tps->dev, tps->regmap, client->irq,
 				       IRQF_ONESHOT, 0, pmic->irq_chip,
 				       &tps->irq_data);
diff --git a/include/linux/mfd/tps65219.h b/include/linux/mfd/tps65219.h
index 55234e771ba73..3abf937191d0c 100644
--- a/include/linux/mfd/tps65219.h
+++ b/include/linux/mfd/tps65219.h
@@ -149,6 +149,8 @@ enum pmic_id {
 #define TPS65215_ENABLE_LDO2_EN_MASK                    BIT(5)
 #define TPS65214_ENABLE_LDO1_EN_MASK			BIT(5)
 #define TPS65219_ENABLE_LDO4_EN_MASK			BIT(6)
+/* Register Unlock */
+#define TPS65214_LOCK_ACCESS_CMD			0x5a
 /* power ON-OFF sequence slot */
 #define TPS65219_BUCKS_LDOS_SEQUENCE_OFF_SLOT_MASK	GENMASK(3, 0)
 #define TPS65219_BUCKS_LDOS_SEQUENCE_ON_SLOT_MASK	GENMASK(7, 4)
-- 
2.51.0

