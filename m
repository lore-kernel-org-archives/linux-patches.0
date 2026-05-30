Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6963ACA4D;
	Sat, 30 May 2026 18:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165009; cv=none; b=SsQUyQxCbg9oh9JfC0Yy7Or2iAQUkFAjAiA1TN7C81zyNGKYCEG4S77Tv4rhoz1DBmjNB4pQYZ5NtErmodoWx34wA9PTAwu1EYtVdb2OhVFdcRJOL0qYfl6oczdVRXQ3w9B93KkQvnFW0y154ddF//E+cx9nHfj1Ef881Ui4dxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165009; c=relaxed/simple;
	bh=aSZJsUK7g9C1XPfEZRlWVrEPiU+0TXJo0mL+UmOwz4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwJMZN//AVnpq1hTAeqCR75wqiFOa/qsRsloajYq5gkpri4Xi1ecM0u47MU3MFapIgFkjUi9RNTRePonuOIVuaDpd+jictkyxQaKPAagPq0EdjmozKoZKz1xSbjk0n89lBX7/z/xOUTd8ee7iUWGf9tmnVAHLxsa6E0eBTz4G7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pjFI3ej; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pjFI3ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7D71F00893;
	Sat, 30 May 2026 18:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165008;
	bh=KzrRgGrESfzhoWOp8ptSV0aOoGQ2jdkig4e8lcJi4k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2pjFI3ej1yFx7v2CLvtfHdOoA13hUGZrq33piySpsdiDhbK7O20zBmCzhLVr/pL9m
	 BUhVO6owV0gofj9WdUo83fbcSzwDMRvEGjb1Wa8JBdb1guMA4wcTZL3BHUwEPAQHpp
	 lzLMgsBNbcQTZKx+fFnavE5Z15CaRwLH/fUD+OW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 716/776] hwmon: (pmbus/adm1266) seed timestamp from the real-time clock
Date: Sat, 30 May 2026 18:07:10 +0200
Message-ID: <20260530160258.326499072@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


