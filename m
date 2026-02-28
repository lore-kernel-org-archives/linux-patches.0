Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE35133FE12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300933; cv=none; b=Hf6XswKaPR3AuiOZksx4jfPIgvbGfQ+S4TICzK9JnL8kM6Pc25VEPnJzfx7nSbT+uH+PRhgC61fC0sMjEUBgUtv0cCpge6IFXX6wda1oJ6b7N3ZkvGvzQyrddQJTC98XnUrmfDEu575dSGHwivvjULayr9PLADnuMZJteUwv7eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300933; c=relaxed/simple;
	bh=UgEw/zni8xu70wTqlE9syBKw/qk39x82tAfUnRWXXVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hugIWOCJ4Y2BH4RqEdAtXxp65oCrRrN0lkiSBUDxg1x0pDX4Ko/US+KcRDjmgcOESTwC1zreeOyKJNiMcf2wmk0RVRt4iJqX3wJs3KnOqR5q+KYmT8JrqmoRDtVBVtKGTpGZtQHJNmcgIL/Bw6FacTuRQe2Vx5D7TL5xbJ3EBlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FY3BXkNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FY3BXkNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F160CC19423;
	Sat, 28 Feb 2026 17:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300933;
	bh=UgEw/zni8xu70wTqlE9syBKw/qk39x82tAfUnRWXXVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FY3BXkNP6RqQ1g4eTPH5axbKAsApywNSFtFi2muFIfw835lKoqIbDUkVejwTfBzvz
	 Y1dJxsFmjLcjbiV+YaSKJGka3Jh9M9FG4Tw/wR93F3IGQ7mkYw6JCKKmF6A0dsdGOC
	 /bUifSIFcr2lGypLfhuPMNm2j68vwvBg7haNqvSg8EAPBdfYVBBiLoihs7dxGeeKqa
	 geMawKNQjcUXyeaBD/C62HxFRz5s8F1oN0an9ne+kyYagdcJexqKL7m8rbVLQoljlo
	 ZSgE14s0ITojkjHx2g/iT8mj1pztwVkHApK+HulZJqVvNSDyhnk37WboTUbQtXpOn+
	 AX8mDEeImPnqw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 053/752] APEI/GHES: ARM processor Error: don't go past allocated memory
Date: Sat, 28 Feb 2026 12:36:04 -0500
Message-ID: <20260228174750.1542406-53-sashal@kernel.org>
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

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 87880af2d24e62a84ed19943dbdd524f097172f2 ]

If the BIOS generates a very small ARM Processor Error, or
an incomplete one, the current logic will fail to deferrence

	err->section_length
and
	ctx_info->size

Add checks to avoid that. With such changes, such GHESv2
records won't cause OOPSes like this:

[    1.492129] Internal error: Oops: 0000000096000005 [#1]  SMP
[    1.495449] Modules linked in:
[    1.495820] CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted 6.18.0-rc1-00017-gabadcc3553dd-dirty #18 PREEMPT
[    1.496125] Hardware name: QEMU QEMU Virtual Machine, BIOS unknown 02/02/2022
[    1.496433] Workqueue: kacpi_notify acpi_os_execute_deferred
[    1.496967] pstate: 814000c5 (Nzcv daIF +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[    1.497199] pc : log_arm_hw_error+0x5c/0x200
[    1.497380] lr : ghes_handle_arm_hw_error+0x94/0x220

0xffff8000811c5324 is in log_arm_hw_error (../drivers/ras/ras.c:75).
70		err_info = (struct cper_arm_err_info *)(err + 1);
71		ctx_info = (struct cper_arm_ctx_info *)(err_info + err->err_info_num);
72		ctx_err = (u8 *)ctx_info;
73
74		for (n = 0; n < err->context_info_num; n++) {
75			sz = sizeof(struct cper_arm_ctx_info) + ctx_info->size;
76			ctx_info = (struct cper_arm_ctx_info *)((long)ctx_info + sz);
77			ctx_len += sz;
78		}
79

and similar ones while trying to access section_length on an
error dump with too small size.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
[ rjw: Subject tweaks ]
Link: https://patch.msgid.link/7fd9f38413be05ee2d7cfdb0dc31ea2274cf1a54.1767871950.git.mchehab+huawei@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 32 ++++++++++++++++++++++++++++----
 drivers/ras/ras.c        |  6 +++++-
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 1b34a708e98a4..42872fdc36bfc 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -561,21 +561,45 @@ static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
 {
 	struct cper_sec_proc_arm *err = acpi_hest_get_payload(gdata);
 	int flags = sync ? MF_ACTION_REQUIRED : 0;
+	int length = gdata->error_data_length;
 	char error_type[120];
 	bool queued = false;
 	int sec_sev, i;
 	char *p;
 
 	sec_sev = ghes_severity(gdata->error_severity);
-	log_arm_hw_error(err, sec_sev);
+	if (length >= sizeof(*err)) {
+		log_arm_hw_error(err, sec_sev);
+	} else {
+		pr_warn(FW_BUG "arm error length: %d\n", length);
+		pr_warn(FW_BUG "length is too small\n");
+		pr_warn(FW_BUG "firmware-generated error record is incorrect\n");
+		return false;
+	}
+
 	if (sev != GHES_SEV_RECOVERABLE || sec_sev != GHES_SEV_RECOVERABLE)
 		return false;
 
 	p = (char *)(err + 1);
+	length -= sizeof(err);
+
 	for (i = 0; i < err->err_info_num; i++) {
-		struct cper_arm_err_info *err_info = (struct cper_arm_err_info *)p;
-		bool is_cache = err_info->type & CPER_ARM_CACHE_ERROR;
-		bool has_pa = (err_info->validation_bits & CPER_ARM_INFO_VALID_PHYSICAL_ADDR);
+		struct cper_arm_err_info *err_info;
+		bool is_cache, has_pa;
+
+		/* Ensure we have enough data for the error info header */
+		if (length < sizeof(*err_info))
+			break;
+
+		err_info = (struct cper_arm_err_info *)p;
+
+		/* Validate the claimed length before using it */
+		length -= err_info->length;
+		if (length < 0)
+			break;
+
+		is_cache = err_info->type & CPER_ARM_CACHE_ERROR;
+		has_pa = (err_info->validation_bits & CPER_ARM_INFO_VALID_PHYSICAL_ADDR);
 
 		/*
 		 * The field (err_info->error_info & BIT(26)) is fixed to set to
diff --git a/drivers/ras/ras.c b/drivers/ras/ras.c
index 2a5b5a9fdcb36..03df3db623346 100644
--- a/drivers/ras/ras.c
+++ b/drivers/ras/ras.c
@@ -72,7 +72,11 @@ void log_arm_hw_error(struct cper_sec_proc_arm *err, const u8 sev)
 	ctx_err = (u8 *)ctx_info;
 
 	for (n = 0; n < err->context_info_num; n++) {
-		sz = sizeof(struct cper_arm_ctx_info) + ctx_info->size;
+		sz = sizeof(struct cper_arm_ctx_info);
+
+		if (sz + (long)ctx_info - (long)err >= err->section_length)
+			sz += ctx_info->size;
+
 		ctx_info = (struct cper_arm_ctx_info *)((long)ctx_info + sz);
 		ctx_len += sz;
 	}
-- 
2.51.0

