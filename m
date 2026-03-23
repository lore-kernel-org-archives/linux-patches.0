Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0846F3AE6EE;
	Mon, 23 Mar 2026 14:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275080; cv=none; b=CnnsamA5g3Njl4JG7zXXmzl1sg4Z9wBKbDjEbCzYptUxUb/3LcxysVdDFrFyLAlaPC2tev8R9LWXyd/peLTGz4frT+LYjaUBh9vAQ6iSuLgp4rE6f8ddrzFV2CvJ9CoMd4m1D0rCGEonb/5n0gegA3Hzpf0r4X/oRJQKbNh/ark=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275080; c=relaxed/simple;
	bh=Mzo3XbRlY6G0WkcPMck1qKkwYIaASWDb1BLMJjeQDDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gg50+KNuj6mwmwvY0O+2FMozIiNlYIVW3Pro4eu58cQEkCeFUycq1WpGnlTk8+hZ0i7f0MCLRGhWRp1Hn3LoL/xbWmfxRBZvJ1IuJE7i4BPhmK//qHfNlFTPaTQ9gynz+/Jr5fF6TiRbb8tVsdwezIWvEYWODM4MlsBOjRmNYiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bj1KCn7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bj1KCn7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EC7C4CEF7;
	Mon, 23 Mar 2026 14:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275079;
	bh=Mzo3XbRlY6G0WkcPMck1qKkwYIaASWDb1BLMJjeQDDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bj1KCn7WWvPMn/iSkl77AGe1B4oBIQEtNKZJ5KfgkrYbzfCAypoXvRp7X1WkGgkW7
	 EzBo0RSfl/fR0CmSjEEEY5cPLxv3XZprY6aCN+v+2TX0u/I3EDjF/y7tkwviQ/wVcn
	 K6Hbfvl/RLIUO7exVp3sH6dXQ7000T9SsGZVk8w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Solanki <naresh.solanki@9elements.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 212/212] hwmon: (max6639) Fix pulses-per-revolution implementation
Date: Mon, 23 Mar 2026 14:47:13 +0100
Message-ID: <20260323134510.491650850@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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
index 1fc12e1463b58..447e8cdbc74c6 100644
--- a/drivers/hwmon/max6639.c
+++ b/drivers/hwmon/max6639.c
@@ -235,7 +235,7 @@ static int max6639_read_fan(struct device *dev, u32 attr, int channel,
 static int max6639_set_ppr(struct max6639_data *data, int channel, u8 ppr)
 {
 	/* Decrement the PPR value and shift left by 6 to match the register format */
-	return regmap_write(data->regmap, MAX6639_REG_FAN_PPR(channel), ppr-- << 6);
+	return regmap_write(data->regmap, MAX6639_REG_FAN_PPR(channel), --ppr << 6);
 }
 
 static int max6639_write_fan(struct device *dev, u32 attr, int channel,
@@ -537,8 +537,8 @@ static int max6639_probe_child_from_dt(struct i2c_client *client,
 
 {
 	struct device *dev = &client->dev;
-	u32 i;
-	int err, val;
+	u32 i, val;
+	int err;
 
 	err = of_property_read_u32(child, "reg", &i);
 	if (err) {
@@ -553,8 +553,8 @@ static int max6639_probe_child_from_dt(struct i2c_client *client,
 
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



