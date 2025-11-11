Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF13253944;
	Tue, 11 Nov 2025 01:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824950; cv=none; b=fT4uYu3UYJ92rb1W2fivO5fAQvn5AKjqtpHitfmmPDKv2dDXZ/EeKsirWxWKdgnRUW6br8Y0UPjIYlmQAyBd84eB4yU1GpTHkEqoZ5akK2g3BOxshPCkpIcO/1de9dXUrHI/h8CwGeO4n1LtLwZthacOSG/xJ7zaou0PRZPSgiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824950; c=relaxed/simple;
	bh=4XDfRCifnZKO4Yv2sPeHGkEFl/r/EMoD0Ff8+s/OVhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLRkRAN4bpB1hAaELLdLpLspGskxBJ44XVIuNIHf51Yn6jCn8qGPX8sw5lUTMuyM29/UxQpM3/RuxfKdIYcSXmpNRidN7whTdqwTHP6/LdTuJ4FDywd1ionfTE2UbBM1p0Q6pgzQYmnVNBAbWUXu74F/VxzOeIDWqgX4NArcCrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFy1gom/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFy1gom/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F9EC2BC86;
	Tue, 11 Nov 2025 01:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824950;
	bh=4XDfRCifnZKO4Yv2sPeHGkEFl/r/EMoD0Ff8+s/OVhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFy1gom/ZYDJSH6ETPh4aeat3LqjZ1MbG+PGzVMu02B7ii0ZybExt2rQzsH1u1jat
	 ONOF9FOd4SGjMGX4TKv9GOIWAHkHreRtOvWfPoAB/720Vi2idlERqSgGOS7RKhVahQ
	 A8lP/bGiV3RkXnb0go9mVFQ7ivMGAVOrrVnqRZtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 556/565] scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers
Date: Tue, 11 Nov 2025 09:46:52 +0900
Message-ID: <20251111004539.513170224@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit bb44826c3bdbf1fa3957008a04908f45e5666463 upstream.

Intel platforms with UFS, can support Suspend-to-Idle (S0ix) and
Suspend-to-RAM (S3).  For S0ix the link state should be HIBERNATE.  For
S3, state is lost, so the link state must be OFF.  Driver policy,
expressed by spm_lvl, can be 3 (link HIBERNATE, device SLEEP) for S0ix
but must be changed to 5 (link OFF, device POWEROFF) for S3.

Fix support for S0ix/S3 by switching spm_lvl as needed.  During suspend
->prepare(), if the suspend target state is not Suspend-to-Idle, ensure
the spm_lvl is at least 5 to ensure that resume will be possible from
deep sleep states.  During suspend ->complete(), restore the spm_lvl to
its original value that is suitable for S0ix.

This fix is first needed in Intel Alder Lake based controllers.

Fixes: 7dc9fb47bc9a ("scsi: ufs: ufs-pci: Add support for Intel ADL")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251024085918.31825-2-adrian.hunter@intel.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufshcd-pci.c |   67 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 2 deletions(-)

--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -15,6 +15,7 @@
 #include <linux/pci.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_qos.h>
+#include <linux/suspend.h>
 #include <linux/debugfs.h>
 #include <linux/uuid.h>
 #include <linux/acpi.h>
@@ -36,6 +37,7 @@ struct intel_host {
 	u32		dsm_fns;
 	u32		active_ltr;
 	u32		idle_ltr;
+	int		saved_spm_lvl;
 	struct dentry	*debugfs_root;
 	struct gpio_desc *reset_gpio;
 };
@@ -378,6 +380,7 @@ static int ufs_intel_common_init(struct
 	host = devm_kzalloc(hba->dev, sizeof(*host), GFP_KERNEL);
 	if (!host)
 		return -ENOMEM;
+	host->saved_spm_lvl = -1;
 	ufshcd_set_variant(hba, host);
 	intel_dsm_init(host, hba->dev);
 	if (INTEL_DSM_SUPPORTED(host, RESET)) {
@@ -588,6 +591,66 @@ static int ufshcd_pci_restore(struct dev
 
 	return ufshcd_system_resume(dev);
 }
+
+static int ufs_intel_suspend_prepare(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct intel_host *host = ufshcd_get_variant(hba);
+	int err;
+
+	/*
+	 * Only s2idle (S0ix) retains link state.  Force power-off
+	 * (UFS_PM_LVL_5) for any other case.
+	 */
+	if (pm_suspend_target_state != PM_SUSPEND_TO_IDLE && hba->spm_lvl < UFS_PM_LVL_5) {
+		host->saved_spm_lvl = hba->spm_lvl;
+		hba->spm_lvl = UFS_PM_LVL_5;
+	}
+
+	err = ufshcd_suspend_prepare(dev);
+
+	if (err < 0 && host->saved_spm_lvl != -1) {
+		hba->spm_lvl = host->saved_spm_lvl;
+		host->saved_spm_lvl = -1;
+	}
+
+	return err;
+}
+
+static void ufs_intel_resume_complete(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct intel_host *host = ufshcd_get_variant(hba);
+
+	ufshcd_resume_complete(dev);
+
+	if (host->saved_spm_lvl != -1) {
+		hba->spm_lvl = host->saved_spm_lvl;
+		host->saved_spm_lvl = -1;
+	}
+}
+
+static int ufshcd_pci_suspend_prepare(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	if (!strcmp(hba->vops->name, "intel-pci"))
+		return ufs_intel_suspend_prepare(dev);
+
+	return ufshcd_suspend_prepare(dev);
+}
+
+static void ufshcd_pci_resume_complete(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	if (!strcmp(hba->vops->name, "intel-pci")) {
+		ufs_intel_resume_complete(dev);
+		return;
+	}
+
+	ufshcd_resume_complete(dev);
+}
 #endif
 
 /**
@@ -668,8 +731,8 @@ static const struct dev_pm_ops ufshcd_pc
 	.thaw		= ufshcd_system_resume,
 	.poweroff	= ufshcd_system_suspend,
 	.restore	= ufshcd_pci_restore,
-	.prepare	= ufshcd_suspend_prepare,
-	.complete	= ufshcd_resume_complete,
+	.prepare	= ufshcd_pci_suspend_prepare,
+	.complete	= ufshcd_pci_resume_complete,
 #endif
 };
 


