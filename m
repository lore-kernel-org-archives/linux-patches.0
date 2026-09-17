Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6C73A9D90;
	Thu, 17 Sep 2026 19:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671733; cv=none; b=Qq8lbGEGMeXzhQS+UpXq107qcNPzkItlM77evWH05XBl2JdCRBTEtc8XGt3qYhTPsZ4QN+dI43YJH5ljJbJufQ0qHfeEx8eZX5ng9IZb8gEdZtzXr8mRSTq+oFdVJXwZIIx+uvlNCC83inB6OwOLrJyFJaXXnELWS/ieAcDSsU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671733; c=relaxed/simple;
	bh=mN8IuEnsdPI46vb1G8dbnisix/YcyeQJhqKmpse2eZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/h7IkOIa7NOU+/xf0IEtvVZK+Q8m1Ous8BfMFj+GWnog7rNOh3JHEIXhEporTq9/wBWLvyGLH7salVRh4206g8LglznSmEHwfZZHmmywdRd0ZpksnUNVJU8EMU00wfzMsOoLeMyzxHOYlV/s8tmkzPmRJns13XLaCC6qgHyADU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxbYzfrS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxbYzfrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1ED21F000FF;
	Thu, 17 Sep 2026 19:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671732;
	bh=oWmljWiN5XSbf24B510AvVgBnEnddzFXfyCi5hNcQbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OxbYzfrS/ZKVpYWmo6KchI2SCCSRtWKtrL0BtZUh2v7f2uAwMVnmZyWyJZzOlU1bh
	 TqzqmqOqHPwlKWf6yvk/6UMAI50lv7xTBQ65sbgs7xZfq4bGyzWTDtHMI1bs4dqtsf
	 OrpxEqQsEYEt42Nqq3PcaOodHygSv74rvEM/GzLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1072/1102] ACPI: TAD: Rearrange RT data validation checking
Date: Thu, 17 Sep 2026 16:16:55 +0100
Message-ID: <20260917151607.744113843@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 3329a1416c3350449081ca5daaa94802a65b2992 ]

Move RT data validation checks from acpi_tad_set_real_time() to
a separate function called acpi_tad_rt_is_invalid() and use it
also in acpi_tad_get_real_time() to validate data coming from
the platform firmware.

Also make acpi_tad_set_real_time() return -EINVAL when the RT data
passed to it is invalid (instead of -ERANGE which is somewhat
confusing) and introduce ACPI_TAD_TZ_UNSPEC to represent the
"unspecified timezone" value.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3409319.aeNJFYEL58@rafael.j.wysocki
Stable-dep-of: a3df8bbe0a70 ("ACPI: TAD: Add locking around AML evaluations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_tad.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/drivers/acpi/acpi_tad.c
+++ b/drivers/acpi/acpi_tad.c
@@ -49,6 +49,9 @@ MODULE_AUTHOR("Rafael J. Wysocki");
 /* Special value for disabled timer or expired timer wake policy. */
 #define ACPI_TAD_WAKE_DISABLED	(~(u32)0)
 
+/* ACPI TAD RTC */
+#define ACPI_TAD_TZ_UNSPEC	2047
+
 struct acpi_tad_driver_data {
 	u32 capabilities;
 };
@@ -67,6 +70,16 @@ struct acpi_tad_rt {
 	u8 padding[3]; /* must be 0 */
 } __packed;
 
+static bool acpi_tad_rt_is_invalid(struct acpi_tad_rt *rt)
+{
+	return rt->year < 1900 || rt->year > 9999 ||
+	    rt->month < 1 || rt->month > 12 ||
+	    rt->hour > 23 || rt->minute > 59 || rt->second > 59 ||
+	    rt->tz < -1440 ||
+	    (rt->tz > 1440 && rt->tz != ACPI_TAD_TZ_UNSPEC) ||
+	    rt->daylight > 3;
+}
+
 static int acpi_tad_set_real_time(struct device *dev, struct acpi_tad_rt *rt)
 {
 	acpi_handle handle = ACPI_HANDLE(dev);
@@ -80,12 +93,8 @@ static int acpi_tad_set_real_time(struct
 	unsigned long long retval;
 	acpi_status status;
 
-	if (rt->year < 1900 || rt->year > 9999 ||
-	    rt->month < 1 || rt->month > 12 ||
-	    rt->hour > 23 || rt->minute > 59 || rt->second > 59 ||
-	    rt->tz < -1440 || (rt->tz > 1440 && rt->tz != 2047) ||
-	    rt->daylight > 3)
-		return -ERANGE;
+	if (acpi_tad_rt_is_invalid(rt))
+		return -EINVAL;
 
 	args[0].buffer.pointer = (u8 *)rt;
 	args[0].buffer.length = sizeof(*rt);
@@ -132,6 +141,11 @@ static int acpi_tad_get_real_time(struct
 		goto out_free;
 
 	memcpy(rt, data, sizeof(*rt));
+	if (acpi_tad_rt_is_invalid(rt)) {
+		ret = -ENODATA;
+		goto out_free;
+	}
+
 	ret = 0;
 
 out_free:


