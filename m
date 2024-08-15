Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFBF1A01CC;
	Thu, 15 Aug 2024 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731923; cv=none; b=M25/13hwjrdNWRNHZQUULPWE0DRTKMpFVWq9i9b6iJx/+e9s5ON9/Zqk/q9l2W83elcD5ZO8daV+41axKt6qgc0+R2SQqj+/BG8EvnIFJZkjRcZeEUu5hyhvLt5toeUhTyD8my+NIeCR4V20QQuGlQHgRkTdXtHl1IxOfFAJYB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731923; c=relaxed/simple;
	bh=vw7aXJ8eAYFJZbIqJ6E5DAX1BBq5xYb8JkhrAFoyoBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8xuO/BuDNmdaAkdidXGGurxWv/ykMhULsxXCXjzYpfcRSCmsKHNJmfFETpcLsJEnWlrFUemHEfa5bMRvcnOf0OXKG962s3t+WmhMR0Qt5ran4cin+PgrxKvfgdv+cvuJjZvzsSdWUYWg02XevD8zw2QwsZGUSYdDkXSy6I4OeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsCsALvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsCsALvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9B9C4AF0C;
	Thu, 15 Aug 2024 14:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731923;
	bh=vw7aXJ8eAYFJZbIqJ6E5DAX1BBq5xYb8JkhrAFoyoBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsCsALvpC9hdoGzqZsZgQZWr0sOonS+IhHHHSody9mtiH6QndpUXwsm9uEeImYPC+
	 2Nn7JELltlne/qMcHRsKeoY1wg6p1MQProp01S0TEaysZHSI57c58oRNrhXuAJspRJ
	 RgN/nxqOOAy9/S0RUpDBLKpkn3p4CuHDTXR/NaFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/352] hwmon: (max6697) Fix swapped temp{1,8} critical alarms
Date: Thu, 15 Aug 2024 15:21:18 +0200
Message-ID: <20240815131919.686058506@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3fa2a3b3c9954..7508d67c3dfb0 100644
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



