Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548321ACEA3;
	Mon, 30 Dec 2024 15:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574216; cv=none; b=N4yjpko4U5LYWb+nHii3GDtU0k8z45AJ8huK5EvR5WbXahuT3GpFofSR6tofposoUxa2jb1yenzeGcjs/J3koetZJVKWu9w5eWpYsgE+RxedPxeX0tAWvM6vSV4Z8PMtvJXdIe3fmDl4ofjVzUN6Zo+3zRUKPsMTKywMZfbkZbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574216; c=relaxed/simple;
	bh=Swr8/+H/38DE/bE1Z7SoZDmmrJdDZA2sEcC9MAyPMrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQ6I/FMNHsWKh9SE5tRT2hNM2CEE/jRMFqxT59z0gVnSExElN58+DZK9+aevLw5CUMlEdLIK0VvS2OVKtTTn7llNkK/EXgEAjh8KLNVFGCuqp79amaygRY7id0qzZ9jBC4phNC95yO6T3r7MhEJIPEK7EmY9ybBlMdGyohmrY7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrXy5OxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrXy5OxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C94C4CED0;
	Mon, 30 Dec 2024 15:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574215;
	bh=Swr8/+H/38DE/bE1Z7SoZDmmrJdDZA2sEcC9MAyPMrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrXy5OxUVWiMu3ra95CO+PqCtOYP05SxlpTraM+tRfBulUHI7lj9qdCCnhfCro+jr
	 nl6+fnS3P8cT72qULY9wXDweHuhaOB4xaaIayA0CzgWEvMVZEmCNsFttW8z21877RD
	 Otwh4YG8HO35zlOUy2e9qxHBD9e6IuWBH7lVj7gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prayas Patel <prayas.patel@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/114] scsi: mpi3mr: Handling of fault code for insufficient power
Date: Mon, 30 Dec 2024 16:43:07 +0100
Message-ID: <20241230154220.791241305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit fb6eb98f3965e2ee92cbcb466051d2f2acf552d1 ]

Before retrying initialization, check and abort if the fault code
indicates insufficient power. Also mark the controller as unrecoverable
instead of issuing reset in the watch dog timer if the fault code
indicates insufficient power.

Signed-off-by: Prayas Patel <prayas.patel@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20241110194405.10108-5-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 2e6245bd4282..5ed31fe57474 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1035,6 +1035,36 @@ static const char *mpi3mr_reset_type_name(u16 reset_type)
 	return name;
 }
 
+/**
+ * mpi3mr_is_fault_recoverable - Read fault code and decide
+ * whether the controller can be recoverable
+ * @mrioc: Adapter instance reference
+ * Return: true if fault is recoverable, false otherwise.
+ */
+static inline bool mpi3mr_is_fault_recoverable(struct mpi3mr_ioc *mrioc)
+{
+	u32 fault;
+
+	fault = (readl(&mrioc->sysif_regs->fault) &
+		      MPI3_SYSIF_FAULT_CODE_MASK);
+
+	switch (fault) {
+	case MPI3_SYSIF_FAULT_CODE_COMPLETE_RESET_NEEDED:
+	case MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED:
+		ioc_warn(mrioc,
+		    "controller requires system power cycle, marking controller as unrecoverable\n");
+		return false;
+	case MPI3_SYSIF_FAULT_CODE_INSUFFICIENT_PCI_SLOT_POWER:
+		ioc_warn(mrioc,
+		    "controller faulted due to insufficient power,\n"
+		    " try by connecting it to a different slot\n");
+		return false;
+	default:
+		break;
+	}
+	return true;
+}
+
 /**
  * mpi3mr_print_fault_info - Display fault information
  * @mrioc: Adapter instance reference
@@ -1373,6 +1403,11 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 	ioc_info(mrioc, "ioc_status(0x%08x), ioc_config(0x%08x), ioc_info(0x%016llx) at the bringup\n",
 	    ioc_status, ioc_config, base_info);
 
+	if (!mpi3mr_is_fault_recoverable(mrioc)) {
+		mrioc->unrecoverable = 1;
+		goto out_device_not_present;
+	}
+
 	/*The timeout value is in 2sec unit, changing it to seconds*/
 	mrioc->ready_timeout =
 	    ((base_info & MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_MASK) >>
@@ -2734,6 +2769,11 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	mpi3mr_print_fault_info(mrioc);
 	mrioc->diagsave_timeout = 0;
 
+	if (!mpi3mr_is_fault_recoverable(mrioc)) {
+		mrioc->unrecoverable = 1;
+		goto schedule_work;
+	}
+
 	switch (trigger_data.fault) {
 	case MPI3_SYSIF_FAULT_CODE_COMPLETE_RESET_NEEDED:
 	case MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED:
-- 
2.39.5



