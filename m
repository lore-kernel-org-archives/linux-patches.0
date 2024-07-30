Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F8129A2;
	Tue, 30 Jul 2024 15:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354875; cv=none; b=kTjo2WX0w2NHw4PAp6VL2E8HHYVR01KuIy3dLRGcjGKT4HNccdukF60E20q1Nr5mN7yN1IZ1mq7reAwmOEUWvMyZqWV56FnQefAn399vpzgscQxZ2FimOy+tzLMiROX9UNaZSklyujMSLUtdLh3j5ElEv6klv+mUppT5aEQ+ak4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354875; c=relaxed/simple;
	bh=CW8ZP9etZF0og8l6p8pPr3cHQxuRF/V5RO3TTzlbkDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVKCZDBFA2ZRFHJfdvjYFfd57BUaV31GRMugxuE+tZBeE4vgXZ97QKFMs+F6/lRKN0iA6U9RArOQQEXYTe59kZD84f6GHnHUXZcGzKZ4TFcnEWaQ51fGp8wjkY+WAzFoj91S+oLCjEM7FLBnKZHeDLrKgzkALW5LM0Ca585Gcys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQdZv524; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQdZv524"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F40C4AF0C;
	Tue, 30 Jul 2024 15:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354875;
	bh=CW8ZP9etZF0og8l6p8pPr3cHQxuRF/V5RO3TTzlbkDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQdZv524cc2dDbdu5EjRLR4es72cj1ecOTk1gAOfaSOdDj3VEH6v3J19d2mal1U0h
	 MeBXKzI4RYQK2WkW02UjRo0O1VSM0UEu9Yc6doQO1BqYoPIssHUz8UpiI3F5GoF6tk
	 TpEzrfoZyqRHK56m0sX8TH4LCurlMQkFq/UwIy4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/440] hwmon: (max6697) Fix swapped temp{1,8} critical alarms
Date: Tue, 30 Jul 2024 17:44:23 +0200
Message-ID: <20240730151616.941684591@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 1ea3fd1eb9869fcdcbc9c68f9728bfc47b9503f1 ]

The critical alarm bit for the local temperature sensor (temp1) is in
bit 7 of register 0x45 (not bit 6), and the critical alarm bit for remote
temperature sensor 7 (temp8) is in bit 6 (not bit 7).

This only affects MAX6581 since all other chips supported by this driver
do not support those critical alarms.

Fixes: 5372d2d71c46 ("hwmon: Driver for Maxim MAX6697 and compatibles")
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max6697.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/max6697.c b/drivers/hwmon/max6697.c
index 563e73f071d07..266baae94e3ee 100644
--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -430,14 +430,14 @@ static SENSOR_DEVICE_ATTR_RO(temp6_max_alarm, alarm, 20);
 static SENSOR_DEVICE_ATTR_RO(temp7_max_alarm, alarm, 21);
 static SENSOR_DEVICE_ATTR_RO(temp8_max_alarm, alarm, 23);
 
-static SENSOR_DEVICE_ATTR_RO(temp1_crit_alarm, alarm, 14);
+static SENSOR_DEVICE_ATTR_RO(temp1_crit_alarm, alarm, 15);
 static SENSOR_DEVICE_ATTR_RO(temp2_crit_alarm, alarm, 8);
 static SENSOR_DEVICE_ATTR_RO(temp3_crit_alarm, alarm, 9);
 static SENSOR_DEVICE_ATTR_RO(temp4_crit_alarm, alarm, 10);
 static SENSOR_DEVICE_ATTR_RO(temp5_crit_alarm, alarm, 11);
 static SENSOR_DEVICE_ATTR_RO(temp6_crit_alarm, alarm, 12);
 static SENSOR_DEVICE_ATTR_RO(temp7_crit_alarm, alarm, 13);
-static SENSOR_DEVICE_ATTR_RO(temp8_crit_alarm, alarm, 15);
+static SENSOR_DEVICE_ATTR_RO(temp8_crit_alarm, alarm, 14);
 
 static SENSOR_DEVICE_ATTR_RO(temp2_fault, alarm, 1);
 static SENSOR_DEVICE_ATTR_RO(temp3_fault, alarm, 2);
-- 
2.43.0



