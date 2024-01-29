Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AD715B110;
	Mon, 29 Jan 2024 17:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548093; cv=none; b=d3bISQ1z3ndfhUCLg2OvgitlFUM047Jfzbb6w2hHTWjQXaVClAUxyWLZ5aIAgH0V2i2q8Tplm3PUWshRryCAAsvOuj7kcwZKGNAvMEkpCeQWnN9dZeGk9lUvTTEyh6aJBud+ZhdqsDdHltB3AH7U0LaLlAqGE0ks544zUCB5ulU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548093; c=relaxed/simple;
	bh=nuelweQr/Kmb8yPHWiMYYD/R8wI3Qs5oBDyOlEoFzAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/hiVhuKtSWhn1emigCDYD6fm3kkAGj+YkcTWJTwgp6cxBsPsxnnzlONjLaSxugr6uQiBBXy4qg/tim6LQDj5Jl8wkZ8daXtsqIQbtPFLGiMq2qLkQn4+EgDAwKgkO3hYspaEeJHWxaCSw4btCYNIgdywTNzay5PpezSRzrmANk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fM83K5FU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fM83K5FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF41DC433C7;
	Mon, 29 Jan 2024 17:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548093;
	bh=nuelweQr/Kmb8yPHWiMYYD/R8wI3Qs5oBDyOlEoFzAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fM83K5FUt9ZezZ2aPp2I9AsrjlkGk+HWijVvqAYX9Uq3yFv/7qE+jceFYEZgY0BJ0
	 WOybEmRqH2N22ib1A48MgH6uDL9/o0HJlsZ4uwRSdWVZFmlKVm+zHVDMDiG1k90uzk
	 Muk2FBgKVYvhxYF3xMJZBj7dxKMwPQAvsdkfbqI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	alvin.zhuge@gmail.com,
	renzhamin@gmail.com,
	Kelvie Wong <kelvie@kelvie.ca>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.7 109/346] rtc: cmos: Use ACPI alarm for non-Intel x86 systems too
Date: Mon, 29 Jan 2024 09:02:20 -0800
Message-ID: <20240129170019.604418192@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/rtc/rtc-cmos.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -818,18 +818,24 @@ static void rtc_wake_off(struct device *
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


