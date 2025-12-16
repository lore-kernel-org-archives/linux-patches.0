Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C253502BF;
	Tue, 16 Dec 2025 11:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886209; cv=none; b=MTuzxDYQaGheQ/+iQLIECXdqWOzzO17lXwxsgu/kEu0ATqDFXjfxMtN0+oAj3Jxsh1uGF+AAKTqxRBar+r+9c/xD+dEKr6/kopeD9Lt3Me0R0Jqu3UyMzcYeHPj+6EtnSgKiZYcqJu9dxQ9GqHXjrl8vPkLUXUPNDPREnDLLwCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886209; c=relaxed/simple;
	bh=i+Z0ylR131jMyOQ8rzZedrLa6JgfH5xB0R8I5cLKngo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQ7knAwwb/CnnkKYd0rGO8bnu/M9NjnbSe3mD3H+gsA2Fk5SuncqnjMSDZQMjMHA1/5HJl3hb6/wqKXYhCZ8+mNtByCuDtpaXlmji4lks3QpDWOUjOSOY7OLmMFV6isLW5d5n1DLBYiDn0mLayDz3dnpuLy9zvnjFOdJo7vrKds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fdb5KL13; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fdb5KL13"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE39C4CEF1;
	Tue, 16 Dec 2025 11:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886209;
	bh=i+Z0ylR131jMyOQ8rzZedrLa6JgfH5xB0R8I5cLKngo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fdb5KL13m+0ivS6KR44TIPuR0eF+roifcnsFz8kRg2Nw9PF5vw0Q9nwI2I/adDNZP
	 NH4LdddTvFHIBOdRUoO3Q0InMYtyIKZ8ULuAKppRK49hoU+9EKHRq3aPY8XSKdYaxD
	 HC0VpM/lhY8g0pM5QrUm/2T3B5zkQnF8ZToD/i4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 369/507] hwmon: sy7636a: Fix regulator_enable resource leak on error path
Date: Tue, 16 Dec 2025 12:13:30 +0100
Message-ID: <20251216111358.826255448@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



