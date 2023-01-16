Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD286FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E807C433D2;
	Mon, 16 Jan 2023 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887823;
	bh=xBqPdu5/M5iYtBpqJgQv8B7ZhGaaB27wTnALzo3SJYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOTKKoNMlj5Iva80WApWmy4mkzPu6qHFFwjRWNYpvVqPu+1wRWeaHk8Tdlp4QnmZ+
	 Ly9AifAK1qjBHs9nI9Uz/3vr6T4m/TDrHUtxZwe3yuPgcsoiCu3YZSJNaLraz1Jfn6
	 6oaZfBpFJTwFS9xxzefZDB+wg7OeAZUCc89NFJPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Guilherme G. Piccoli" <gpiccoli@canonical.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 265/521] rtc: cmos: Refactor code by using the new dmi_get_bios_year() helper
Date: Mon, 16 Jan 2023 16:48:47 +0100
Message-Id: <20230116154858.993984987@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 604c521259c8051b7607c000eda7938f7a705d92 ]

Refactor code by using the new dmi_get_bios_year() helper instead of
open coding its functionality. This also makes logic slightly clearer.

No changes intended.

Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200123131437.28157-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 8545f0da57fe..58a3104b8a1c 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1204,8 +1204,6 @@ static void rtc_wake_off(struct device *dev)
 /* Enable use_acpi_alarm mode for Intel platforms no earlier than 2015 */
 static void use_acpi_alarm_quirks(void)
 {
-	int year;
-
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return;
 
@@ -1215,8 +1213,10 @@ static void use_acpi_alarm_quirks(void)
 	if (!is_hpet_enabled())
 		return;
 
-	if (dmi_get_date(DMI_BIOS_DATE, &year, NULL, NULL) && year >= 2015)
-		use_acpi_alarm = true;
+	if (dmi_get_bios_year() < 2015)
+		return;
+
+	use_acpi_alarm = true;
 }
 #else
 static inline void use_acpi_alarm_quirks(void) { }
-- 
2.35.1



