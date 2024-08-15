Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DFA1714AE;
	Thu, 15 Aug 2024 13:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729182; cv=none; b=alGCulEm1FBT1tubKqlYZ7VQjaggQT91AQk5jfbfiJfKf6kn58+K5VLLrLEno4bg8Zsr0j/w0AJnGEwxgnCYl+lctVA9qBU5/eQceLpbvrcXSY9nL8p94RAustXKO88N4oseZidxLKWM8aOFt4OExGeUlbSIGVR2IXmbkzbAiK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729182; c=relaxed/simple;
	bh=znAP+bMMCpJixYUSRTb33OOono8Ol1ulCAnveOzN6cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJlCUMAlJRL1qeSXw7rv7Rdmmsvz86ZeYmmjMueDs3TmRVU9F2xUE7BS+pPqeL1+Gtl2TPNw+236pCSj17qUg4GQybu6E8cQv3WyFlmaAOnutQ5jdctzTmrAx62ZnVnbMzbGDtpm2A7/y1lwQjFSOzaFuXPznw21o9XBMjBHox4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvjUt3sT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvjUt3sT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A165EC4AF0D;
	Thu, 15 Aug 2024 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729182;
	bh=znAP+bMMCpJixYUSRTb33OOono8Ol1ulCAnveOzN6cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvjUt3sTSmGZHvqKZk9eDEntVx8t3vbfVg05e36dGPNcvPHKcINjSQGVZ5TEOQhoA
	 EPvBmimh8LYW7OTzzW00Q9Q2qli+6jXh6+casNaOFJOLORzQycHPd6xRL14RAj9nmU
	 Eww+FA7u7rluLY7wGvMHQC4lZhwjM8qsCoTAjA4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/484] hwmon: (max6697) Fix swapped temp{1,8} critical alarms
Date: Thu, 15 Aug 2024 15:17:55 +0200
Message-ID: <20240815131941.937247875@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



