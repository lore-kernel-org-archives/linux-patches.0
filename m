Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3D14F20D;
	Tue, 23 Jan 2024 01:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974009; cv=none; b=BgKF7qF+ad0r4tVqA2pEksoFJYmcvFJLj/gzj0kXKGARmn7vX9fT+iFRtkX3RUUGBYRq8FbB4jp+dfWmbG4Ct1E90Syr2g/Hofm+8IHhxJkLb+AErV/FjwNJEaJYmUNaiRoELzjJR/DOiygkIeC7naV/mBykP20RqfEnMlRyoao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974009; c=relaxed/simple;
	bh=vQJqG7GAQiGnlO1Wq6eJLSr6DdevrxEJS1eScIKzk/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1S8wmg07EnYWmQNrA1XWuz2Vnv3BevddprzYuO8xihUYzLItIWx4j9m3+m2K+ObQRpVZ5E4xAZYUnT3DIPcPful7+KarA07VY46Pua09MYIJJVylsmGmdlQ7otvTJycKxAw1+OvgDMPaibfiiFZu/mFFX2aWM3WzPS2mba+BKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5jAxRbM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5jAxRbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E49C43390;
	Tue, 23 Jan 2024 01:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974009;
	bh=vQJqG7GAQiGnlO1Wq6eJLSr6DdevrxEJS1eScIKzk/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5jAxRbMM0aky85siHyCzh9zj87L4T72dAQVqxx8veMnCjTpyg80q28xr4WVB81Ch
	 P7MZ0GMMuay4WgIGb3dgsXR0hQJH6UIcMT0KPqoOsTrPkqRYn9qrg2J2Jbrk3rNjF1
	 3xgJbug/AmokfsR9eQTATcSuiYJB5zgd9vYDDCaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erwin Tsaur <erwin.tsaur@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/374] ACPI: extlog: Clear Extended Error Log status when RAS_CEC handled the error
Date: Mon, 22 Jan 2024 15:55:46 -0800
Message-ID: <20240122235747.745398592@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 38c872a9e96f72f2947affc0526cc05659367d3d ]

When both CONFIG_RAS_CEC and CONFIG_ACPI_EXTLOG are enabled, Linux does
not clear the status word of the BIOS supplied error record for corrected
errors. This may prevent logging of subsequent uncorrected errors.

Fix by clearing the status.

Fixes: 23ba710a0864 ("x86/mce: Fix all mce notifiers to update the mce->kflags bitmask")
Reported-by: Erwin Tsaur <erwin.tsaur@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_extlog.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index e648158368a7..088db2356998 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -145,9 +145,14 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 	static u32 err_seq;
 
 	estatus = extlog_elog_entry_check(cpu, bank);
-	if (estatus == NULL || (mce->kflags & MCE_HANDLED_CEC))
+	if (!estatus)
 		return NOTIFY_DONE;
 
+	if (mce->kflags & MCE_HANDLED_CEC) {
+		estatus->block_status = 0;
+		return NOTIFY_DONE;
+	}
+
 	memcpy(elog_buf, (void *)estatus, ELOG_ENTRY_LEN);
 	/* clear record status to enable BIOS to update it again */
 	estatus->block_status = 0;
-- 
2.43.0



