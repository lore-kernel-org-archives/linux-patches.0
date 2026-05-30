Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E93D30676E;
	Sat, 30 May 2026 17:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162336; cv=none; b=AgSdckj21rKQ+bxbu8DM/hHQRotZrUHSvI6p+JEQlWv7//uPGGvBIDboV8kglAdcmZCJ7ZT9Hjyb2yc+gdl1pm7OPnOZvlu0co7LhEQBHsP7YSAD3VUfX6BcFTrfdFvojvmy+t+gBi6wcLjZpsGA4cS3lGPGQZvg7nv80i14MWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162336; c=relaxed/simple;
	bh=KJwSiIpnPv6101oGrLqUEGQ3uqs6Q4E3pxH81GU5HL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rE788u3wHIHK+B9HEZK5PK2n3jXMYoOPrep/L1xDgBhUii0nwu3VnUmL4ng10fb3aTkICDBl+KCV33wrGwWWcb7bOe7PB8iF1WnUmvnPJKz4evQ1yuRHV9H8nglkruc7oo9N81lh8KcCJj4kG9yuRlxTw5FN6XM+KLFwo8zoKIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ip3VIqon; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ip3VIqon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC1B1F00893;
	Sat, 30 May 2026 17:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162335;
	bh=eYEYQcd9jYLIEFqmWYAbjDpMbalK4ZgImvlZaTlvwz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ip3VIqonunJa/J/7FoYFV2Wsynzpiub8te6ZChqc/HBim4yhVcJdKa/EF75VV3jj4
	 GCFXp0F1Sb1bNC93ckoIALoCQnhMN57bAhkdoo1tUCyIZrTA02p6M47/76wMly4idm
	 Ncqjsqjtp2IswSpoPKIO6zdBGRlKAO2f/diYuy+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 890/969] hwmon: (pmbus/adm1266) seed timestamp from the real-time clock
Date: Sat, 30 May 2026 18:06:54 +0200
Message-ID: <20260530160325.281488991@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit b86095e3d7dcf2bf80c747349a35912a87a85098 upstream.

adm1266_set_rtc() seeds the chip's SET_RTC register from
ktime_get_seconds(), which returns CLOCK_MONOTONIC -- i.e. seconds
since the host last booted, not seconds since the Unix epoch.

The chip stamps that value into every blackbox record it captures.
Userspace reading those timestamps back expects wall-clock seconds:
that's what the SET_RTC frame layout documents (datasheet Rev. D,
Table 84) and what every other consumer of "seconds since epoch"
assumes.  Seeding from CLOCK_MONOTONIC gives blackbox records a
timestamp that is only meaningful within a single boot of the host
and silently resets to small values on every reboot.

Switch to ktime_get_real_seconds() so the seed matches what the
register is documented to hold.

Fixes: 15609d189302 ("hwmon: (pmbus/adm1266) read blackbox")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://lore.kernel.org/r/20260515-adm1266-fixes-v1-1-1c1ea1349cfe@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -434,7 +434,7 @@ static int adm1266_set_rtc(struct adm126
 	char write_buf[6];
 	int i;
 
-	kt = ktime_get_seconds();
+	kt = ktime_get_real_seconds();
 
 	memset(write_buf, 0, sizeof(write_buf));
 


