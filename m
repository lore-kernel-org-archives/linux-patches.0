Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF011DE89C;
	Mon, 10 Mar 2025 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630525; cv=none; b=dooSU1yG7aOUqQPPtoeJ6jVXL26Sy/sujxSeOdCzYyz1GNkfXnYcydwvPuZ79GeNWP8l6C2O1LCoH0bU+SVJ8IGTOQmEUn8f66y5TpmYfY/TNcBpNL+EnOsKxiIIjQTUd6ucpJn6sPo58JDFF4FQtl4i2MQtc69WeuR1j/q9pwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630525; c=relaxed/simple;
	bh=mcOFbP1DxCuclKaMgxQw/vSy8WBakJjLZIi6R/z3wIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSTieuqc1jZw5jNtBhb1LrRmlsZN5///iNBQdnrTwepmZPeF4Ywxy6+Ia8u4jgBYiL6IVgZdgszICTqvgoIlSoSIJjc1pusKdOVyxlw8ps2+RynsVJHpGpHD/2tp8Na6bhHrBIAkZaR0i/bSZzG9svvqg5q5FRNpPedHPPibjtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUWjKl4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUWjKl4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24615C4CEEC;
	Mon, 10 Mar 2025 18:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630525;
	bh=mcOFbP1DxCuclKaMgxQw/vSy8WBakJjLZIi6R/z3wIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUWjKl4qzGgtkUat0y+FBdTpawELiIb39XC9GfFy3SyXaUPrs1FJ4mrKMr7NhPGie
	 0r3PXLLPl+NotcrtJMMjjxyAkhaAltrWxTrlrNqPG+pvcItL1CoEHeQPwkB19I8NBB
	 zQRMISCsdnGO1tgk1HUIKpVXqKOQ5ITEcPornw9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 444/620] tpm: Use managed allocation for bios event log
Date: Mon, 10 Mar 2025 18:04:50 +0100
Message-ID: <20250310170603.121206598@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 441b7152729f4a2bdb100135a58625fa0aeb69e4 ]

Since the bios event log is freed in the device release function,
let devres handle the deallocation. This will allow other memory
allocation/mapping functions to be used for the bios event log.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Stable-dep-of: a3a860bc0fd6 ("tpm: Change to kvalloc() in eventlog/acpi.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/eventlog/acpi.c |  5 +++--
 drivers/char/tpm/eventlog/efi.c  | 13 +++++++------
 drivers/char/tpm/eventlog/of.c   |  3 ++-
 drivers/char/tpm/tpm-chip.c      |  1 -
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/eventlog/acpi.c b/drivers/char/tpm/eventlog/acpi.c
index cd266021d0103..bd757d836c5cf 100644
--- a/drivers/char/tpm/eventlog/acpi.c
+++ b/drivers/char/tpm/eventlog/acpi.c
@@ -14,6 +14,7 @@
  * Access to the event log extended by the TCG BIOS of PC platform
  */
 
+#include <linux/device.h>
 #include <linux/seq_file.h>
 #include <linux/fs.h>
 #include <linux/security.h>
@@ -135,7 +136,7 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
 	}
 
 	/* malloc EventLog space */
-	log->bios_event_log = kmalloc(len, GFP_KERNEL);
+	log->bios_event_log = devm_kmalloc(&chip->dev, len, GFP_KERNEL);
 	if (!log->bios_event_log)
 		return -ENOMEM;
 
@@ -164,7 +165,7 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
 	return format;
 
 err:
-	kfree(log->bios_event_log);
+	devm_kfree(&chip->dev, log->bios_event_log);
 	log->bios_event_log = NULL;
 	return ret;
 }
diff --git a/drivers/char/tpm/eventlog/efi.c b/drivers/char/tpm/eventlog/efi.c
index e6cb9d525e30c..4e9d7c2bf32ee 100644
--- a/drivers/char/tpm/eventlog/efi.c
+++ b/drivers/char/tpm/eventlog/efi.c
@@ -6,6 +6,7 @@
  *      Thiebaud Weksteen <tweek@google.com>
  */
 
+#include <linux/device.h>
 #include <linux/efi.h>
 #include <linux/tpm_eventlog.h>
 
@@ -55,7 +56,7 @@ int tpm_read_log_efi(struct tpm_chip *chip)
 	}
 
 	/* malloc EventLog space */
-	log->bios_event_log = kmemdup(log_tbl->log, log_size, GFP_KERNEL);
+	log->bios_event_log = devm_kmemdup(&chip->dev, log_tbl->log, log_size, GFP_KERNEL);
 	if (!log->bios_event_log) {
 		ret = -ENOMEM;
 		goto out;
@@ -76,7 +77,7 @@ int tpm_read_log_efi(struct tpm_chip *chip)
 			     MEMREMAP_WB);
 	if (!final_tbl) {
 		pr_err("Could not map UEFI TPM final log\n");
-		kfree(log->bios_event_log);
+		devm_kfree(&chip->dev, log->bios_event_log);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -91,11 +92,11 @@ int tpm_read_log_efi(struct tpm_chip *chip)
 	 * Allocate memory for the 'combined log' where we will append the
 	 * 'final events log' to.
 	 */
-	tmp = krealloc(log->bios_event_log,
-		       log_size + final_events_log_size,
-		       GFP_KERNEL);
+	tmp = devm_krealloc(&chip->dev, log->bios_event_log,
+			    log_size + final_events_log_size,
+			    GFP_KERNEL);
 	if (!tmp) {
-		kfree(log->bios_event_log);
+		devm_kfree(&chip->dev, log->bios_event_log);
 		ret = -ENOMEM;
 		goto out;
 	}
diff --git a/drivers/char/tpm/eventlog/of.c b/drivers/char/tpm/eventlog/of.c
index a9ce66d09a754..741ab2204b11a 100644
--- a/drivers/char/tpm/eventlog/of.c
+++ b/drivers/char/tpm/eventlog/of.c
@@ -10,6 +10,7 @@
  * Read the event log created by the firmware on PPC64
  */
 
+#include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/tpm_eventlog.h>
@@ -65,7 +66,7 @@ int tpm_read_log_of(struct tpm_chip *chip)
 		return -EIO;
 	}
 
-	log->bios_event_log = kmemdup(__va(base), size, GFP_KERNEL);
+	log->bios_event_log = devm_kmemdup(&chip->dev, __va(base), size, GFP_KERNEL);
 	if (!log->bios_event_log)
 		return -ENOMEM;
 
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 65d800ecc9964..a3459238ecb36 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -267,7 +267,6 @@ static void tpm_dev_release(struct device *dev)
 	idr_remove(&dev_nums_idr, chip->dev_num);
 	mutex_unlock(&idr_lock);
 
-	kfree(chip->log.bios_event_log);
 	kfree(chip->work_space.context_buf);
 	kfree(chip->work_space.session_buf);
 	kfree(chip->allocated_banks);
-- 
2.39.5



