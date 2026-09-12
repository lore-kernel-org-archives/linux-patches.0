Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5361A20ED;
	Sat, 12 Sep 2026 15:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225650; cv=none; b=p/1dO/rhLLgj1/4Pd/8C0b7ruqWcjrhuDuzYQotCGHNdnZJnVNmxqS110lvKAlY1rRZ+Fn/x85OdFuqpdGIGgLpdgUi6Uo0ZeENP95UxE8Mo7R3hxuC9J+MArOkvqpBHch1qpDkW2PcX+JEKdvo1vMS1m8zLQ+PAtle0L1iJjd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225650; c=relaxed/simple;
	bh=KD8jSvSvJgVCzp/4Df6f72Rro0AvtXerwmJkYNw235A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfCiTbnfQm/sy+9Ys3jzF5TgY0jJk2LiRkglTlsdm6hDV7/Pk3USSgZ6G/RpD0ZwgaHoD+u3lO9+W5v+8Bp4pxJc9hRzPl9/nmUFJMAfDBfi3StL9rFJfddrMc1ULrjnvfsBhjD/l+nUfpg2+Iz089VfnnVJvGZAN5xm4Us2qfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmkjD4vS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmkjD4vS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7029C1F000FF;
	Sat, 12 Sep 2026 15:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225649;
	bh=L24HO0/VvJOr+R+f/ay3nkRM1Ycp5M3g5tqPgZgCXh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmkjD4vSZSG2QbJnqcS43U6ptHCZ0QopXbkwjVhsgB5A2sbQ7oW9Uv0PvJlaSzAAY
	 5MxOABd5eb7YmevP12qukjU6zmCYwW6D0HjQ1Ro/0TqZrFxom+w/5Wg/DswLimwTYk
	 a2VtjlZNCIgAXbctuk0wJ+4grxmFYqJuRpgLXeJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars Petter Mostad <lars.petter.mostad@appear.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1242/1424] hwmon: (emc1403) Support 11 bit accuracy
Date: Sat, 12 Sep 2026 09:01:14 +0200
Message-ID: <20260912065635.098155548@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit e77b204ad4d01d3aee5e18fe33dc6d7a09953308 ]

Various temperature and limit registers support 11 bit accuracy.
Add support for it.

Cc: Lars Petter Mostad <lars.petter.mostad@appear.net>
Tested-by: Lars Petter Mostad <lars.petter.mostad@appear.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 75f2c0b36907 ("hwmon: (emc1403) Drop hysteresis for low limit temperature")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/emc1403.c | 55 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 8caa365b5ec71..5aafcf2d8ef38 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -178,17 +178,52 @@ static u8 emc1403_temp_regs[][4] = {
 	},
 };
 
+static s8 emc1403_temp_regs_low[][4] = {
+	[0] = {
+		[temp_min] = -1,
+		[temp_max] = -1,
+		[temp_crit] = -1,
+		[temp_input] = 0x29,
+	},
+	[1] = {
+		[temp_min] = 0x14,
+		[temp_max] = 0x13,
+		[temp_crit] = -1,
+		[temp_input] = 0x10,
+	},
+	[2] = {
+		[temp_min] = 0x18,
+		[temp_max] = 0x17,
+		[temp_crit] = -1,
+		[temp_input] = 0x24,
+	},
+	[3] = {
+		[temp_min] = 0x2f,
+		[temp_max] = 0x2e,
+		[temp_crit] = -1,
+		[temp_input] = 0x2b,
+	},
+};
+
 static int __emc1403_get_temp(struct thermal_data *data, int channel,
 			      enum emc1403_reg_map map, long *val)
 {
 	unsigned int regval;
 	int ret;
+	s8 reg;
 
 	ret = regmap_read(data->regmap, emc1403_temp_regs[channel][map], &regval);
 	if (ret < 0)
 		return ret;
 	*val = regval * 1000;
 
+	reg = emc1403_temp_regs_low[channel][map];
+	if (reg >= 0) {
+		ret = regmap_read(data->regmap, reg, &regval);
+		if (ret < 0)
+			return ret;
+		*val += (regval >> 5) * 125;
+	}
 	return 0;
 }
 
@@ -336,12 +371,26 @@ static int emc1403_set_temp(struct thermal_data *data, int channel,
 {
 	unsigned int regval;
 	int ret;
+	u8 regh;
+	s8 regl;
 
-	val = clamp_val(val, 0, 255000);
+	regh = emc1403_temp_regs[channel][map];
+	regl = emc1403_temp_regs_low[channel][map];
 
 	mutex_lock(&data->mutex);
-	regval = DIV_ROUND_CLOSEST(val, 1000);
-	ret = regmap_write(data->regmap, emc1403_temp_regs[channel][map], regval);
+	if (regl >= 0) {
+		val = clamp_val(val, 0, 255875);
+		regval = DIV_ROUND_CLOSEST(val, 125);
+		ret = regmap_write(data->regmap, regh, regval >> 3);
+		if (ret < 0)
+			goto unlock;
+		ret = regmap_write(data->regmap, regl, (regval & 0x07) << 5);
+	} else {
+		val = clamp_val(val, 0, 255000);
+		regval = DIV_ROUND_CLOSEST(val, 1000);
+		ret = regmap_write(data->regmap, regh, regval);
+	}
+unlock:
 	mutex_unlock(&data->mutex);
 	return ret;
 }
-- 
2.53.0



