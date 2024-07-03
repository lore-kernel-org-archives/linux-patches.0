Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62515173352;
	Wed,  3 Jul 2024 10:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003673; cv=none; b=JSOrJU+diZeSsNHaZZkQhlCvOR19KgWC5l00uhu/6dVJKkvtNDUoiIfnH9JpLBEYI87oiM4r9qkXQjWgK2ah0mHTS27cKYXfaLSRxU6I96ZGu5cgd5xrm2rfqVE5GPi6MKixSuXbfASBFKWwqhG9OptDvt9fxjr2T2ZdapazwVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003673; c=relaxed/simple;
	bh=iBzAWZztPE3mzOD2goR3w38cfERmP6wAqaEYfz+iiik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJXrzto6b3duLV8xX7csNxZR13RQ/enINGa98w4jg6/oY3M9bgN8VS0p3hNEKvtDNI9LOSa+7k6kO2aYyMHLZtj+EJKolySgRBeSq4eoCy3ch3Ob7iSr0DHsISdShXqFlvIM8deHclfuPt8+ascwheFgTDOkyJHsATgRI/YJEbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzL7wYoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzL7wYoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA943C2BD10;
	Wed,  3 Jul 2024 10:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003673;
	bh=iBzAWZztPE3mzOD2goR3w38cfERmP6wAqaEYfz+iiik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzL7wYoKGzVsiNggQKgCLOd2eZjU03WhTX8sSf48X/Wy7A4yq9Hx5cvBr08fSwdys
	 Vd/imf90cWUduNmQ7hQW+aSIj+9tx58pd0ZbB6sEHgGMMDqCJJbwWSc3VysG9+VYua
	 MZ9FUr9An0kdzACYmFZFb8e4DtZ/XOC2Rb33aC58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/139] scsi: mpt3sas: Gracefully handle online firmware update
Date: Wed,  3 Jul 2024 12:39:51 +0200
Message-ID: <20240703102833.990544350@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>

[ Upstream commit ffedeae1fa545a1d07e6827180c3923bf67af59f ]

Issue:

During online Firmware upgrade operations it is possible that MaxDevHandles
filled in IOCFacts may change with new FW.  With this we may observe kernel
panics when driver try to access the pd_handles or blocking_handles buffers
at offset greater than the old firmware's MaxDevHandle value.

Fix:

_base_check_ioc_facts_changes() looks for increase/decrease in IOCFacts
attributes during online firmware upgrade and increases the pd_handles,
blocking_handles, etc buffer sizes to new firmware's MaxDevHandle value if
this new firmware's MaxDevHandle value is greater than the old firmware's
MaxDevHandle value.

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 4254dfeda82f ("scsi: mpt3sas: Avoid test/set_bit() operating in non-allocated memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 93 +++++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h |  2 +
 2 files changed, 95 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 7588c2c11a879..54faddb637c46 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6719,6 +6719,13 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	if (r)
 		goto out_free_resources;
 
+	/*
+	 * Copy current copy of IOCFacts in prev_fw_facts
+	 * and it will be used during online firmware upgrade.
+	 */
+	memcpy(&ioc->prev_fw_facts, &ioc->facts,
+	    sizeof(struct mpt3sas_facts));
+
 	ioc->non_operational_loop = 0;
 	ioc->got_task_abort_from_ioctl = 0;
 	return 0;
@@ -6884,6 +6891,85 @@ mpt3sas_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
 	wait_event_timeout(ioc->reset_wq, ioc->pending_io_count == 0, 10 * HZ);
 }
 
+/**
+ * _base_check_ioc_facts_changes - Look for increase/decrease of IOCFacts
+ *     attributes during online firmware upgrade and update the corresponding
+ *     IOC variables accordingly.
+ *
+ * @ioc: Pointer to MPT_ADAPTER structure
+ */
+static int
+_base_check_ioc_facts_changes(struct MPT3SAS_ADAPTER *ioc)
+{
+	u16 pd_handles_sz;
+	void *pd_handles = NULL, *blocking_handles = NULL;
+	void *pend_os_device_add = NULL, *device_remove_in_progress = NULL;
+	struct mpt3sas_facts *old_facts = &ioc->prev_fw_facts;
+
+	if (ioc->facts.MaxDevHandle > old_facts->MaxDevHandle) {
+		pd_handles_sz = (ioc->facts.MaxDevHandle / 8);
+		if (ioc->facts.MaxDevHandle % 8)
+			pd_handles_sz++;
+
+		pd_handles = krealloc(ioc->pd_handles, pd_handles_sz,
+		    GFP_KERNEL);
+		if (!pd_handles) {
+			ioc_info(ioc,
+			    "Unable to allocate the memory for pd_handles of sz: %d\n",
+			    pd_handles_sz);
+			return -ENOMEM;
+		}
+		memset(pd_handles + ioc->pd_handles_sz, 0,
+		    (pd_handles_sz - ioc->pd_handles_sz));
+		ioc->pd_handles = pd_handles;
+
+		blocking_handles = krealloc(ioc->blocking_handles,
+		    pd_handles_sz, GFP_KERNEL);
+		if (!blocking_handles) {
+			ioc_info(ioc,
+			    "Unable to allocate the memory for "
+			    "blocking_handles of sz: %d\n",
+			    pd_handles_sz);
+			return -ENOMEM;
+		}
+		memset(blocking_handles + ioc->pd_handles_sz, 0,
+		    (pd_handles_sz - ioc->pd_handles_sz));
+		ioc->blocking_handles = blocking_handles;
+		ioc->pd_handles_sz = pd_handles_sz;
+
+		pend_os_device_add = krealloc(ioc->pend_os_device_add,
+		    pd_handles_sz, GFP_KERNEL);
+		if (!pend_os_device_add) {
+			ioc_info(ioc,
+			    "Unable to allocate the memory for pend_os_device_add of sz: %d\n",
+			    pd_handles_sz);
+			return -ENOMEM;
+		}
+		memset(pend_os_device_add + ioc->pend_os_device_add_sz, 0,
+		    (pd_handles_sz - ioc->pend_os_device_add_sz));
+		ioc->pend_os_device_add = pend_os_device_add;
+		ioc->pend_os_device_add_sz = pd_handles_sz;
+
+		device_remove_in_progress = krealloc(
+		    ioc->device_remove_in_progress, pd_handles_sz, GFP_KERNEL);
+		if (!device_remove_in_progress) {
+			ioc_info(ioc,
+			    "Unable to allocate the memory for "
+			    "device_remove_in_progress of sz: %d\n "
+			    , pd_handles_sz);
+			return -ENOMEM;
+		}
+		memset(device_remove_in_progress +
+		    ioc->device_remove_in_progress_sz, 0,
+		    (pd_handles_sz - ioc->device_remove_in_progress_sz));
+		ioc->device_remove_in_progress = device_remove_in_progress;
+		ioc->device_remove_in_progress_sz = pd_handles_sz;
+	}
+
+	memcpy(&ioc->prev_fw_facts, &ioc->facts, sizeof(struct mpt3sas_facts));
+	return 0;
+}
+
 /**
  * mpt3sas_base_hard_reset_handler - reset controller
  * @ioc: Pointer to MPT_ADAPTER structure
@@ -6949,6 +7035,13 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 	if (r)
 		goto out;
 
+	r = _base_check_ioc_facts_changes(ioc);
+	if (r) {
+		ioc_info(ioc,
+		    "Some of the parameters got changed in this new firmware"
+		    " image and it requires system reboot\n");
+		goto out;
+	}
 	if (ioc->rdpq_array_enable && !ioc->rdpq_array_capable)
 		panic("%s: Issue occurred with flashing controller firmware."
 		      "Please reboot the system and ensure that the correct"
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 941a4faf20be0..b0297a9c92389 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1032,6 +1032,7 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @event_log: event log pointer
  * @event_masks: events that are masked
  * @facts: static facts data
+ * @prev_fw_facts: previous fw facts data
  * @pfacts: static port facts data
  * @manu_pg0: static manufacturing page 0
  * @manu_pg10: static manufacturing page 10
@@ -1235,6 +1236,7 @@ struct MPT3SAS_ADAPTER {
 
 	/* static config pages */
 	struct mpt3sas_facts facts;
+	struct mpt3sas_facts prev_fw_facts;
 	struct mpt3sas_port_facts *pfacts;
 	Mpi2ManufacturingPage0_t manu_pg0;
 	struct Mpi2ManufacturingPage10_t manu_pg10;
-- 
2.43.0



