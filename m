Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1281332610;
	Sat, 12 Sep 2026 11:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212823; cv=none; b=ERqknkTGVqJTp3hGtdlvm4gLZAeA3VbEsrl3i0WxpgWhRVfFrUlCXiNVTOh5yP1D4M1LBSkhHz+Tn4niquN8n1QIvetlM61Hai0mJSGywdv/lydAFvyWp18blKTW4rqi7u43FboBZslCkpHJqF7JJEveloXj6TTc3G6IrYZ6PxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212823; c=relaxed/simple;
	bh=EmKeX1q3p7a4VGc/AwF/fGinPYuQWDrOOXhfoa11yzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrsbCU1HSnrVHO+99/sNxmffXkrvjzZMeFtvdMzNDCfh0wlOdoIoP4g8C4tYZLVnQ8yQJ5MssgeMJ30OZXVncFK+XJbJy+Z8rMPDBLq57zF781SMzEahjrOCEadokRXpJ+Bo37dznEb36BxqQJHMe3g/XobX5vSjFq47vMgti0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEFAVZfY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEFAVZfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56AB1F000FF;
	Sat, 12 Sep 2026 11:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212822;
	bh=OWAFQD70zOju45HSQVpFYMSm0M3kBb76KSWPmH8tNzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEFAVZfYzv4TuzQulP7pvut9VBcgFdmmOaHcC6O+m17k9DNefFxniqtQGRE3yrtNt
	 Kv84WCzrfuDWeTb/DGK5hKduhGxnfD76mIJeAyQ+J6mObis0HdauEYycMfjCbxClof
	 u4A93dB+DdrbBZR1sJfbkAIW7DjsH6ZAgAai0pZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1513/1518] ACPI: processor: idle: Remove redundant static variable and rename cstate check function
Date: Sat, 12 Sep 2026 09:01:22 +0200
Message-ID: <20260912065657.793572001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 4d613fb1ea0516e1f69d3a4ebfbf2572d5da5368 ]

The function acpi_processor_cstate_first_run_checks() is currently called
only once during initialization in acpi_processor_register_idle_driver().

Since its execution is already limited by the caller's lifecycle, the
internal static 'first_run' variable is redundant and can be safely
removed.

Additionally, the current function name is no longer descriptive of its
behavior, so rename the function to acpi_processor_update_max_cstate()
to better reflect its actual purpose.

Signed-off-by: Huisong Li <lihuisong@huawei.com>
Link: https://patch.msgid.link/20260311065038.4151558-4-lihuisong@huawei.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 66c62e6773c5 ("ACPI: processor: Add cpuidle driver check in acpi_processor_register_idle_driver()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 2de87e5011f5d..ce07505a8de69 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -831,19 +831,13 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
 	return 0;
 }
 
-static inline void acpi_processor_cstate_first_run_checks(void)
+static inline void acpi_processor_update_max_cstate(void)
 {
-	static int first_run;
-
-	if (first_run)
-		return;
 	dmi_check_system(processor_power_dmi_table);
 	max_cstate = acpi_processor_cstate_check(max_cstate);
 	if (max_cstate < ACPI_C_STATES_MAX)
 		pr_notice("processor limited to max C-state %d\n", max_cstate);
 
-	first_run++;
-
 	if (nocst)
 		return;
 
@@ -852,7 +846,7 @@ static inline void acpi_processor_cstate_first_run_checks(void)
 #else
 
 static inline int disabled_by_idle_boot_param(void) { return 0; }
-static inline void acpi_processor_cstate_first_run_checks(void) { }
+static inline void acpi_processor_update_max_cstate(void) { }
 static int acpi_processor_get_cstate_info(struct acpi_processor *pr)
 {
 	return -ENODEV;
@@ -1377,7 +1371,7 @@ void acpi_processor_register_idle_driver(void)
 	int ret = -ENODEV;
 	int cpu;
 
-	acpi_processor_cstate_first_run_checks();
+	acpi_processor_update_max_cstate();
 
 	/*
 	 * ACPI idle driver is used by all possible CPUs.
-- 
2.53.0



