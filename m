Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BAF79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D53C433EF;
	Thu, 12 Jan 2023 14:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533246;
	bh=GOKQsbHs1KOfOHRUs81yilyq6NH9R8Uny6ZOM4qYO7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTllh6gBQNVv1w72AZ6QXwFjPbf57lyXHRSa6/9YtYXipIjyhLUEjhHWPYJ4mU7Nz
	 AXXNwpiUF0HKoZrjyRs/ONK9vt/q22uCVKBQ4ZCU36oFjZjIBv09VlNImRE8fJs267
	 29Zcrgg8T+eRZyxJzkY23bHVp37MIxZEXniJfbyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 417/783] rtc: rtc-cmos: Do not check ACPI_FADT_LOW_POWER_S0
Date: Thu, 12 Jan 2023 14:52:13 +0100
Message-Id: <20230112135543.653246461@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 6492fed7d8c95f53b0b804ef541324d924d95d41 ]

The ACPI_FADT_LOW_POWER_S0 flag merely means that it is better to
use low-power S0 idle on the given platform than S3 (provided that
the latter is supported) and it doesn't preclude using either of
them (which of them will be used depends on the choices made by user
space).

For this reason, there is no benefit from checking that flag in
use_acpi_alarm_quirks().

First off, it cannot be a bug to do S3 with use_acpi_alarm set,
because S3 can be used on systems with ACPI_FADT_LOW_POWER_S0 and it
must work if really supported, so the ACPI_FADT_LOW_POWER_S0 check is
not needed to protect the S3-capable systems from failing.

Second, suspend-to-idle can be carried out on a system with
ACPI_FADT_LOW_POWER_S0 unset and it is expected to work, so if setting
use_acpi_alarm is needed to handle that case correctly, it should be
set regardless of the ACPI_FADT_LOW_POWER_S0 value.

Accordingly, drop the ACPI_FADT_LOW_POWER_S0 check from
use_acpi_alarm_quirks().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/12054246.O9o76ZdvQC@kreacher
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index d4f6c4dd42c4..19bc1d8a5de5 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1265,9 +1265,6 @@ static void use_acpi_alarm_quirks(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return;
 
-	if (!(acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0))
-		return;
-
 	if (!is_hpet_enabled())
 		return;
 
-- 
2.35.1



