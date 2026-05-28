Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785402F8E83;
	Thu, 28 May 2026 20:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999702; cv=none; b=u2Wl3ZFLgkCCsEoBUdPAFJ1zqY/5j7zDYhTvaNgYLwYZ0hebQx3wQAyl7SnfRN1hmwuBDnX2NlSDuk+QmsUPrtyMJ6ROxXxZhhcIvFUQ4fIalC/AGzoeVU9f1rGDGJSS1huwWtfgaSxFdhtkJH8K1hn6st8XdIQ7TSug1m0QcBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999702; c=relaxed/simple;
	bh=rnRBi64MTTlhbfM9wJ0klWsbHpmCS0+cYBnxgiyhPt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsAp/QkRleCsQ1FPWwmDBTEYse8TFBlMCZRdXNJvXYtjolNNhjrGqhHR+LnTUh3/r5LL6M+I9H+IEQkiKWBMhN9adK2wlj47SN0dt8+u4Q5ilq4VbUkqD2Rj0WwPKeQlJ31VROYnlrfrPMrzy+t54dhqdsRgTT4+v3O9AnZddLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjB5fQGU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjB5fQGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EADA1F000E9;
	Thu, 28 May 2026 20:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999700;
	bh=NOrSMH7p+j0kHf49YKlyyR9nNM74SAm4e+z36FCdE24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AjB5fQGUN44l6ctSsnTz7oWSmSx70A6zRhREHdnCpMsHUHr0D1NOfv1PGqfv3xfAT
	 j4is4e40c/c00KiYlKbjnn4Ori6iACPUD0q7po4DBSvq7ui1jYF3crIT7VSYQJ/wvm
	 8VFm8ujqSPIFBDKevghM4YgTASyAah2KpoVzFDXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 161/377] hwmon: (pmbus/adm1266) seed timestamp from the real-time clock
Date: Thu, 28 May 2026 21:46:39 +0200
Message-ID: <20260528194643.086311822@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
@@ -432,7 +432,7 @@ static int adm1266_set_rtc(struct adm126
 	char write_buf[6];
 	int i;
 
-	kt = ktime_get_seconds();
+	kt = ktime_get_real_seconds();
 
 	memset(write_buf, 0, sizeof(write_buf));
 


