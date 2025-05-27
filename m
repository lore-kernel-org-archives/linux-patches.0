Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5C71CD0C;
	Tue, 27 May 2025 17:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366907; cv=none; b=mRjrDWQy4WUfgIojQrvib9si4EK5uu36HnNIdrlVAckVhsvcwPGiWX/+ugayuMtsoUNHv/9fI6yCHXS3u7z9949jmu0ucF34e4OjdFxX1wOhMu72p+80rJ05uJRhV6Ct+Ta/Q/JPuKtNMT5Eg3lHi2DAl80r7PqJ3axuqx3QPt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366907; c=relaxed/simple;
	bh=g7j6sAg1LEraELYf9V3+6Zxv9HxTQpdwrNiAuz9Gr9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhvDuYDePHHFzYo12JsFu+0FvhsBY4+f4CxzXZqq9CkQ3FhAgHf8CK8I29Brz4WFjncy0rryijGT05ioC687lRGv0gSU8cifBT818K2q9PIAZdWX7OHXOfruoDoo4OqX4ke1vClrkFz7oQfwrW+eVscMUiB9oNgW8orf46uTssY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLij+o8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLij+o8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42230C4CEE9;
	Tue, 27 May 2025 17:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366907;
	bh=g7j6sAg1LEraELYf9V3+6Zxv9HxTQpdwrNiAuz9Gr9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLij+o8Gvn0W60OZqYHnqm5ogBRCigAEUjMK5IQR/XALP6nnAZAm676Imt5ovqhPW
	 FQtVzcPw1VwnZGjFGmk2xLkhCBo8POFoJicuWsfdMO3Qqjhk8te7YITBy2q1j2OK73
	 ua8dTkstSpmHGvdz1x+TE6ZVkZLws2FFi+9DwRTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shree Ramamoorthy <s-ramamoorthy@ti.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 185/783] mfd: tps65219: Remove TPS65219_REG_TI_DEV_ID check
Date: Tue, 27 May 2025 18:19:42 +0200
Message-ID: <20250527162520.684118285@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shree Ramamoorthy <s-ramamoorthy@ti.com>

[ Upstream commit 76b58d5111fdcffce615beb71520bc7a6f1742c9 ]

The chipid macro/variable and regmap_read function call is not needed
because the TPS65219_REG_TI_DEV_ID register value is not a consistent value
across TPS65219 PMIC config versions. Reading from the DEV_ID register
without a consistent value to compare it to isn't useful. There isn't a
way to verify the match data ID is the same ID read from the DEV_ID device
register. 0xF0 isn't a DEV_ID value consistent across TPS65219 NVM
configurations.

For TPS65215, there is a consistent value in bits 5-0 of the DEV_ID
register. However, there are other error checks in place within probe()
that apply to both PMICs rather than keeping this isolated check for one
PMIC.

Signed-off-by: Shree Ramamoorthy <s-ramamoorthy@ti.com>
Link: https://lore.kernel.org/r/20250206173725.386720-4-s-ramamoorthy@ti.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65219.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/mfd/tps65219.c b/drivers/mfd/tps65219.c
index 081c5a30b04a2..4aca922658e34 100644
--- a/drivers/mfd/tps65219.c
+++ b/drivers/mfd/tps65219.c
@@ -221,7 +221,6 @@ static const struct regmap_irq_chip tps65219_irq_chip = {
 static int tps65219_probe(struct i2c_client *client)
 {
 	struct tps65219 *tps;
-	unsigned int chipid;
 	bool pwr_button;
 	int ret;
 
@@ -246,12 +245,6 @@ static int tps65219_probe(struct i2c_client *client)
 	if (ret)
 		return ret;
 
-	ret = regmap_read(tps->regmap, TPS65219_REG_TI_DEV_ID, &chipid);
-	if (ret) {
-		dev_err(tps->dev, "Failed to read device ID: %d\n", ret);
-		return ret;
-	}
-
 	ret = devm_mfd_add_devices(tps->dev, PLATFORM_DEVID_AUTO,
 				   tps65219_cells, ARRAY_SIZE(tps65219_cells),
 				   NULL, 0, regmap_irq_get_domain(tps->irq_data));
-- 
2.39.5



