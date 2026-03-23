Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588BE3AEF50;
	Mon, 23 Mar 2026 14:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277493; cv=none; b=l0JiyWlrROd6yInmG5x0+bvnFOV1NAu6W+xa6OTRhapkAlcZdeDrhAX0aVwLrrsJcwxdRGq3Ga2oQz27wGrQ7dytA7yaa+3dwfl2OE/8G5LRmxYaJTFJXcFCHlDdgSArqTcG95OUeCKfUfsQ9Vkg6AfQwUECsRuZ9IvrmBkszb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277493; c=relaxed/simple;
	bh=4vxM1+lhVEZUefXpN7jBiUSVVn9mahxGnWOJeDlF0qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZhfEgu7RjcC9VXeIoCHN0vyX0+ng0LqbNHCewrAF/bjfI5RS/L6K07rC9ZLgdONp0lWtceGOSEy+89c2vI3bBDqP3yHe2NT/w+fppD/Cn9GL86A++JZpme0vxpTCW+Qf5RLZWeO9proQXh57DpC1d2de5V4FFwNUfZmsZsYOj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlPOmzGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlPOmzGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38BEC4CEF7;
	Mon, 23 Mar 2026 14:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277493;
	bh=4vxM1+lhVEZUefXpN7jBiUSVVn9mahxGnWOJeDlF0qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlPOmzGMO97zbwkMI84FruFpqjbjl2QZTzd86GRAtP8D8Wd/QA9RkDA6DNy/nJyYB
	 2OPIjc8ktBXXjFh89Cp4xRnAGGXDnhmSUQq6iPNCayE6sjCLQ1zZuTrPbZDBMVNYwl
	 BpH5m9M9NcjjfM80akHPD5M+gmF9veJJJjXZYAAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Solanki <naresh.solanki@9elements.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 459/460] hwmon: (max6639) Fix pulses-per-revolution implementation
Date: Mon, 23 Mar 2026 14:47:35 +0100
Message-ID: <20260323134537.856835750@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit e7bae9a7a5e1251ab414291f4e9304d702bb9221 ]

The valid range for the pulses-per-revolution devicetree property is
1..4. The current code checks for a range of 1..5. Fix it.

Declare the variable used to retrieve pulses per revolution from
devicetree as u32 (unsigned) to match the of_property_read_u32() API.

The current code uses a postfix decrement when writing the pulses per
resolution into the chip. This has no effect since the value is evaluated
before it is decremented. Fix it by decrementing before evaluating the
value.

Fixes: 7506ebcd662b ("hwmon: (max6639) : Configure based on DT property")
Cc: Naresh Solanki <naresh.solanki@9elements.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max6639.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/max6639.c b/drivers/hwmon/max6639.c
index 0b0a9f4c2307f..154250099adf1 100644
--- a/drivers/hwmon/max6639.c
+++ b/drivers/hwmon/max6639.c
@@ -234,7 +234,7 @@ static int max6639_read_fan(struct device *dev, u32 attr, int channel,
 static int max6639_set_ppr(struct max6639_data *data, int channel, u8 ppr)
 {
 	/* Decrement the PPR value and shift left by 6 to match the register format */
-	return regmap_write(data->regmap, MAX6639_REG_FAN_PPR(channel), ppr-- << 6);
+	return regmap_write(data->regmap, MAX6639_REG_FAN_PPR(channel), --ppr << 6);
 }
 
 static int max6639_write_fan(struct device *dev, u32 attr, int channel,
@@ -536,8 +536,8 @@ static int max6639_probe_child_from_dt(struct i2c_client *client,
 
 {
 	struct device *dev = &client->dev;
-	u32 i;
-	int err, val;
+	u32 i, val;
+	int err;
 
 	err = of_property_read_u32(child, "reg", &i);
 	if (err) {
@@ -552,8 +552,8 @@ static int max6639_probe_child_from_dt(struct i2c_client *client,
 
 	err = of_property_read_u32(child, "pulses-per-revolution", &val);
 	if (!err) {
-		if (val < 1 || val > 5) {
-			dev_err(dev, "invalid pulses-per-revolution %d of %pOFn\n", val, child);
+		if (val < 1 || val > 4) {
+			dev_err(dev, "invalid pulses-per-revolution %u of %pOFn\n", val, child);
 			return -EINVAL;
 		}
 		data->ppr[i] = val;
-- 
2.51.0



