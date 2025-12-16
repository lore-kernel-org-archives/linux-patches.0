Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFB8340DB7;
	Tue, 16 Dec 2025 11:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884743; cv=none; b=Ius46422nBeixZ6Sue3bQmqAIWw7nQT7IzC8BzQokZ6iRL8Izpyy4cqP+3z5rzSHNyxE5iPONKxrqIDb59IjVNtVlisH8t/rtIXr1HMTgPqY3ortEYz4zjaIePXwMRvu129L4WFUzqn/QmIhXtU579NnfYiEzgr4ddrn+UpPDU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884743; c=relaxed/simple;
	bh=yI6o7d4X0gqb4KMtg/RBm5kQqE9K8uNpnstlZOGfjJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqs285krgKxxodRc6jQho81Wn0hFcFlsUxojXJFm2lRpmwYpOtRogedD2L9tknRMHkgnY44TeVW3i9h2JUWLsC+2wU4IoCv53hOrLyz9qGHyjJJbzJEz8dqp+LZgCKINA+OyEf9/Rm28YQMa6Eh9kTS9UWDCZcBjW1Q7/hak1vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ancjjWiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ancjjWiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B3AC4CEF1;
	Tue, 16 Dec 2025 11:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884743;
	bh=yI6o7d4X0gqb4KMtg/RBm5kQqE9K8uNpnstlZOGfjJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ancjjWiFcTAYUqRDHDtX6p4je9S/7cJz9d7lBignrb+qXGmfxZSmWFWfh2iiErUEU
	 cJ0YMeFv5ilVQQZC/PYvtrL20AG+Pj+tpSDhZwPw6bIQi3eIk4NM0Oknm7A3rStdER
	 7QwbNSC9HTday+dTFnloLcRBBsC4jnN9CBv2Yge8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 242/354] hwmon: sy7636a: Fix regulator_enable resource leak on error path
Date: Tue, 16 Dec 2025 12:13:29 +0100
Message-ID: <20251216111329.680978688@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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



