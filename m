Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233101863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C32CC433D2;
	Wed, 28 Dec 2022 15:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241884;
	bh=Xc63G8dGoxAVjT2qzei02rNsp6d7k7JLzIa7j1RRwek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7EbAw6iymmUZYbxcbyjqM8ewuaoSQr6LLT7yWAfLWQjxj9RTgy727GFVqVQiS8K1
	 p37y8BZM4T7f1EXgs3FDwgGUjjtfWeAwzYqnPIErF5c5YQwCxQ4yXzug/SG6VLRCKv
	 fQWN4QozFhoJmR9oD0FJmF0XABnfn1eCoBKB/z4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 538/731] rtc: rtc-cmos: Do not check ACPI_FADT_LOW_POWER_S0
Date: Wed, 28 Dec 2022 15:40:45 +0100
Message-Id: <20221228144312.138059715@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 7c006c2b125f..bdb1df843c78 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1260,9 +1260,6 @@ static void use_acpi_alarm_quirks(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return;
 
-	if (!(acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0))
-		return;
-
 	if (!is_hpet_enabled())
 		return;
 
-- 
2.35.1



