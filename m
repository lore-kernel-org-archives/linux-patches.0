Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001158BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C8BC433D2;
	Tue, 28 Mar 2023 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015115;
	bh=NP0Ls7B1aIxpGe0fZTWet09qyPVhMgouoYrI9T3wV+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/6KSFzBnSbnOIoxIyK0cIjkzhleVVbmpRf6idlyv7Z/2Q/ZwZ4LRJbWptluAzxOe
	 Uq5nEYnfheK+g/CnEI4Ndam0jpWCnS2QR26gBtT9FwSyZ3rM/TynQFINb5awVEJWsD
	 yBE3wC9doBCi11sBJs90enKHxWMhO/YufGQdMN4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anson Tsao <anson.tsao@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 130/240] ACPI: x86: Drop quirk for HP Elitebook
Date: Tue, 28 Mar 2023 16:41:33 +0200
Message-Id: <20230328142625.191331946@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit e32d546c483a2a0f607687f5b521c2a2f942ffbe ]

There was a quirk in `acpi/x86/s2idle.c` for an HP Elitebook G9
platforms to force AMD GUID codepath instead of Microsoft codepath.

This was due to a bug with WCN6855 WLAN firmware interaction with
the system.

This bug is fixed by WCN6855 firmware:
WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.23

Remove the quirk as it's no longer necessary with this firmware.

Link: https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/?id=c7a57ef688f7d99d8338a5d8edddc8836ff0e6de
Tested-by: Anson Tsao <anson.tsao@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/s2idle.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index c7afce465a071..e499c60c45791 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -384,29 +384,6 @@ static const struct acpi_device_id amd_hid_ids[] = {
 	{}
 };
 
-static int lps0_prefer_amd(const struct dmi_system_id *id)
-{
-	pr_debug("Using AMD GUID w/ _REV 2.\n");
-	rev_id = 2;
-	return 0;
-}
-static const struct dmi_system_id s2idle_dmi_table[] __initconst = {
-	{
-		/*
-		 * AMD Rembrandt based HP EliteBook 835/845/865 G9
-		 * Contains specialized AML in AMD/_REV 2 path to avoid
-		 * triggering a bug in Qualcomm WLAN firmware. This may be
-		 * removed in the future if that firmware is fixed.
-		 */
-		.callback = lps0_prefer_amd,
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
-			DMI_MATCH(DMI_BOARD_NAME, "8990"),
-		},
-	},
-	{}
-};
-
 static int lps0_device_attach(struct acpi_device *adev,
 			      const struct acpi_device_id *not_used)
 {
@@ -586,7 +563,6 @@ static const struct platform_s2idle_ops acpi_s2idle_ops_lps0 = {
 
 void __init acpi_s2idle_setup(void)
 {
-	dmi_check_system(s2idle_dmi_table);
 	acpi_scan_add_handler(&lps0_handler);
 	s2idle_set_ops(&acpi_s2idle_ops_lps0);
 }
-- 
2.39.2



