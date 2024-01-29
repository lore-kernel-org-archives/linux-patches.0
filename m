Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B1C15959E;
	Mon, 29 Jan 2024 17:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548253; cv=none; b=kpvBEVEKN57Kpxn7gLeuLHFXQ/kZcCcohptIlrgM6lVDrQ5sKE8cZSuY4j7nGSsnRCqt9kR5QuugfZnAUXHEnPbLQMZFU3yMy2ryG02qS0ozfpcR0i8QhmJwI258nJrXTp64uqez0e4DvKozXPAIEaLg95q3A0u36StSyBrl1uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548253; c=relaxed/simple;
	bh=FzHtAgobPaKKjnOTX+v7bS7F/tAsufJwsSOaDYbKN2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBqBtIb6nn2skz/sqDdArggwROtBhh4nLhbYcd7+uEteYHxWoT2KZFnWQASHJePvLkZOhTiugt78Qd/oWi1SqoHi4WthmRoNGy7ghvU2NbxtVWOZiHJsu5UXGrmGuvxt1KoTNSg8jLfrb7gIdy01nu5ZuO+o6ZHGDZH1VeLdBY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7S5ADTn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7S5ADTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE8AC43390;
	Mon, 29 Jan 2024 17:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548253;
	bh=FzHtAgobPaKKjnOTX+v7bS7F/tAsufJwsSOaDYbKN2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7S5ADTn6vv6WoVjystXiEREx+2kc6UbNLU1lFH8IBLbQyz6gHrJUz0ke6prjXX7q
	 XRpqqIHaktGyRKYqbxtHkFYUmJpJ22sspjfZhIMek5LFBWgkxNLpZtrVNdeRNYD44x
	 qR2wSiTBDZ4YjsIQ0pmQ/hW4uzCAVe138b1icIRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	alvin.zhuge@gmail.com,
	renzhamin@gmail.com,
	Kelvie Wong <kelvie@kelvie.ca>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 048/185] rtc: cmos: Use ACPI alarm for non-Intel x86 systems too
Date: Mon, 29 Jan 2024 09:04:08 -0800
Message-ID: <20240129170000.133905518@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 3d762e21d56370a43478b55e604b4a83dd85aafc upstream.

Intel systems > 2015 have been configured to use ACPI alarm instead
of HPET to avoid s2idle issues.

Having HPET programmed for wakeup causes problems on AMD systems with
s2idle as well.

One particular case is that the systemd "SuspendThenHibernate" feature
doesn't work properly on the Framework 13" AMD model. Switching to
using ACPI alarm fixes the issue.

Adjust the quirk to apply to AMD/Hygon systems from 2021 onwards.
This matches what has been tested and is specifically to avoid potential
risk to older systems.

Cc:  <stable@vger.kernel.org> # 6.1+
Reported-by:  <alvin.zhuge@gmail.com>
Reported-by:  <renzhamin@gmail.com>
Closes: https://github.com/systemd/systemd/issues/24279
Reported-by: Kelvie Wong <kelvie@kelvie.ca>
Closes: https://community.frame.work/t/systemd-suspend-then-hibernate-wakes-up-after-5-minutes/39392
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20231106162310.85711-1-mario.limonciello@amd.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-cmos.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 228fb2d11c70..696cfa7025de 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -818,18 +818,24 @@ static void rtc_wake_off(struct device *dev)
 }
 
 #ifdef CONFIG_X86
-/* Enable use_acpi_alarm mode for Intel platforms no earlier than 2015 */
 static void use_acpi_alarm_quirks(void)
 {
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_INTEL:
+		if (dmi_get_bios_year() < 2015)
+			return;
+		break;
+	case X86_VENDOR_AMD:
+	case X86_VENDOR_HYGON:
+		if (dmi_get_bios_year() < 2021)
+			return;
+		break;
+	default:
 		return;
-
+	}
 	if (!is_hpet_enabled())
 		return;
 
-	if (dmi_get_bios_year() < 2015)
-		return;
-
 	use_acpi_alarm = true;
 }
 #else
-- 
2.43.0



