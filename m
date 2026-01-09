Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14C32DEA6F;
	Fri,  9 Jan 2026 12:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960002; cv=none; b=O+M6EuyVmIPkX4sgx+wtuo+DRbLFoUDBm9hsk66SZ+1RVR9in18WTYO+CZJVxQLaME7QXx9mfH/INOiZvNjBwimKbmZsIMaqzrbB601XTzsE52Fo6B6ZIybjutY6B006AZVtSy/lhpT465DXLr6Olx4U73RQDZVJ9KXY2PqBhqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960002; c=relaxed/simple;
	bh=yjf9wsyzmMXz5DpoHRPcgTZNfbuo7fFY40LPpgzVPJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvHw9V++Z02BJ1g8ZxH1DqwHKY6/86yEg43z8MULBDsDfE8hQW9cXMtJCg27djTom6Ol/b0gzKcifrAdoJjrJX2QAT7MOOd3+xE2cpq3g9dJrxq64TkeRf9IDY53GOxWi2pGHHOozMrjaGMqJfQEkSfaT4iT/FJ7Hj40yurIz38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRXtS65r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRXtS65r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF6CC4CEF1;
	Fri,  9 Jan 2026 12:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960001;
	bh=yjf9wsyzmMXz5DpoHRPcgTZNfbuo7fFY40LPpgzVPJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRXtS65rUCmE4ohUFi/XTe8MZNDRctDzLm3VzYwVHUWn5sr4SjKnxGGchpUkwjzVE
	 69KzO/73+R287j+sZrQ3q54ssa8dB53V6dwWoQxf/8DWm/56stzWTxSUqL8d0v+F+X
	 iNdXnq9NJV0Yp9azbahPoXBDWW8ihjGXKlyZQ7uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/737] hwmon: sy7636a: Fix regulator_enable resource leak on error path
Date: Fri,  9 Jan 2026 12:35:57 +0100
Message-ID: <20260109112142.205471388@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 2f88425ef590b7fcc2324334b342e048edc144a9 ]

In sy7636a_sensor_probe(), regulator_enable() is called but if
devm_hwmon_device_register_with_info() fails, the function returns
without calling regulator_disable(), leaving the regulator enabled
and leaking the reference count.

Switch to devm_regulator_get_enable() to automatically
manage the regulator resource.

Fixes: de34a4053250 ("hwmon: sy7636a: Add temperature driver for sy7636a")
Suggested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/r/20251126162602.2086-1-vulab@iscas.ac.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sy7636a-hwmon.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/hwmon/sy7636a-hwmon.c b/drivers/hwmon/sy7636a-hwmon.c
index a12fc0ce70e76..d51daaf63d632 100644
--- a/drivers/hwmon/sy7636a-hwmon.c
+++ b/drivers/hwmon/sy7636a-hwmon.c
@@ -66,18 +66,13 @@ static const struct hwmon_chip_info sy7636a_chip_info = {
 static int sy7636a_sensor_probe(struct platform_device *pdev)
 {
 	struct regmap *regmap = dev_get_regmap(pdev->dev.parent, NULL);
-	struct regulator *regulator;
 	struct device *hwmon_dev;
 	int err;
 
 	if (!regmap)
 		return -EPROBE_DEFER;
 
-	regulator = devm_regulator_get(&pdev->dev, "vcom");
-	if (IS_ERR(regulator))
-		return PTR_ERR(regulator);
-
-	err = regulator_enable(regulator);
+	err = devm_regulator_get_enable(&pdev->dev, "vcom");
 	if (err)
 		return err;
 
-- 
2.51.0



