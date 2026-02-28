Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166233191D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300945; cv=none; b=BCZKNQOp6bVuCgKHjUGVEoII2c+Nm0I04bzfUebYYQRVNv+gxrg0EnuV75MdB36uOz7CXjvDmBs/vf0MG49bqFpAF7+qOYHHiW57eLJjJPsYoeAtyqKY5wQJv+GeftJ12pvKpvAIs6G40/AJ9M4yk0oSMEAMSjMg14LAgehUajc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300945; c=relaxed/simple;
	bh=QwhXKNi/vNy8r6491k6uaFNuZUrIqHFH2csANta3Ee8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRYeialbHe5hmoFm6jcTp8gEi/iEnNtIYRv4a5xnQDf47hRJfMhtTgPG0V4wS/8X6FNboFOoJoR+5DIPDbG18fq7yOi1BjhJdXX7H/BhTcQzwDnhoOrpFBclHFEl1Ta0D4ODZT2totgfQ0kceo8PgRABQ3u3ZZBhLw47DNHsVUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BF4ZHg+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BF4ZHg+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67567C116D0;
	Sat, 28 Feb 2026 17:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300945;
	bh=QwhXKNi/vNy8r6491k6uaFNuZUrIqHFH2csANta3Ee8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BF4ZHg+oX2ondk7xWfZl/vVUi8K1Xb5ztHYMdVj+zcvi8XpTqYkPRa00lnQq8UU2r
	 HYKPYVyp2PojyFG1aIblUcTLC/gvoMNCjbOuqbkgKWnBN99h6rC60z9gqmWWetrZUN
	 pQrX8K85LQw7YyJX8PFN4CUX/uqJKabkfuma44sO9n6iKxTCfvjX5MOvsKTvjsKgqE
	 FphR7AbhumzfYMPpSQu9HeT53sg8KW9cyTi4AVODJU5UskWfnXWaL39SjnGyvrGDip
	 GEe5HbF/SPNwfLKL+CWOssr32ocCRrZn68kb/u/CgOdrAWXacEqVP+ilIFu78/z34a
	 Nl4qix/UAc3fg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jakob Riemenschneider <riemenschneiderjakob@gmail.com>,
	Antheas Kapenekakis <antheas@antheas.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/752] ACPI: x86: s2idle: Invoke Microsoft _DSM Function 9 (Turn On Display)
Date: Sat, 28 Feb 2026 12:36:18 -0500
Message-ID: <20260228174750.1542406-67-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jakob Riemenschneider <riemenschneiderjakob@gmail.com>

[ Upstream commit 229ecbaac6b31f89c554b77eb407377a5eade7d4 ]

Windows 11, version 22H2 introduced a new function index (Function 9) to
the Microsoft LPS0 _DSM, titled "Turn On Display Notification".

According to Microsoft documentation, this function signals to the system
firmware that the OS intends to turn on the display when exiting Modern
Standby. This allows the firmware to release Power Limits (PLx) earlier.

Crucially, this patch fixes a functional issue observed on the Lenovo Yoga
Slim 7i Aura (15ILL9), where system fans and keyboard backlights fail to
resume after suspend. Investigation linked shows the EC on this device
turns off these components during sleep but requires the Function 9
notification to wake them up again.

This patch defines the new function index (ACPI_MS_TURN_ON_DISPLAY) and
invokes it in acpi_s2idle_restore_early_lps0(). The execution order is
updated to match the logic of an "intent" signal:

 1. LPS0 Exit (Function 6)
 2. Turn On Display Intent (Function 9)
 3. Modern Standby Exit (Function 8)
 4. Screen On (Function 4)

Invoking Function 9 before the Modern Standby Exit ensures the firmware
has time to restore power rails and functionality (like fans) before the
software fully exits the sleep state.

Link: https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/modern-standby-firmware-notifications#turn-on-display-notification-function-9
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220505
Suggested-by: Antheas Kapenekakis <antheas@antheas.dev>
Signed-off-by: Jakob Riemenschneider <riemenschneiderjakob@gmail.com>
Link: https://patch.msgid.link/20260127200121.1292216-1-riemenschneiderjakob@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/s2idle.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index dd0b40b9bbe8b..377a268867c21 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -45,6 +45,7 @@ static const struct acpi_device_id lps0_device_ids[] = {
 #define ACPI_LPS0_EXIT		6
 #define ACPI_LPS0_MS_ENTRY      7
 #define ACPI_LPS0_MS_EXIT       8
+#define ACPI_MS_TURN_ON_DISPLAY 9
 
 /* AMD */
 #define ACPI_LPS0_DSM_UUID_AMD      "e3f32452-febc-43ce-9039-932122d37721"
@@ -373,6 +374,8 @@ static const char *acpi_sleep_dsm_state_to_str(unsigned int state)
 			return "lps0 ms entry";
 		case ACPI_LPS0_MS_EXIT:
 			return "lps0 ms exit";
+		case ACPI_MS_TURN_ON_DISPLAY:
+			return "lps0 ms turn on display";
 		}
 	} else {
 		switch (state) {
@@ -619,6 +622,9 @@ void acpi_s2idle_restore_early(void)
 	if (lps0_dsm_func_mask_microsoft > 0) {
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT,
 				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
+		/* Intent to turn on display */
+		acpi_sleep_run_lps0_dsm(ACPI_MS_TURN_ON_DISPLAY,
+				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
 		/* Modern Standby exit */
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_MS_EXIT,
 				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
-- 
2.51.0

