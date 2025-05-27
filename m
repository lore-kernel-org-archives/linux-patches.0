Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B05154C15;
	Tue, 27 May 2025 17:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365349; cv=none; b=JUmd06HFwwfBHlNSF4QtKuAqOsC0iUR1roPvOj3YAJ57Lv3HXZ6gpDFFbR6Oco8LF80gQfRmK1uwY5Kgnc90Cop93aDzKJ5ONDJyTIaoEMOsz+l/h6wJ4socNb1JrxFeexhszqI4ucvLvsB6ajucxj+rTCat7Mj5bwskultW6yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365349; c=relaxed/simple;
	bh=5rZ4Sa17zaw5w8dH6eSV90sNGpMkW/NMvAtWfPNfAtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Swsn9tDrLie6ZSmNtsmNPZ0R5fSBmw0w0oxsxaStVqjp/oGPbAwZk1CyXw1iWGIccxD4yTQobyWAP+V26Pp5AA1zxYW0jhC0L6Jfk9n2hvSgVUuj+CW5CJyuVLCNJMrrpw/gmjx73geTCVWACMet+FPENelym/wyEL52gi3yo94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4xEYfNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4xEYfNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55A4C4CEE9;
	Tue, 27 May 2025 17:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365349;
	bh=5rZ4Sa17zaw5w8dH6eSV90sNGpMkW/NMvAtWfPNfAtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4xEYfNmVPgU8qxBhF5nuCRPRmocQJeh3KlV4C7e/rEMAvtbD2kgY9yqLXrhBP04c
	 CDdbuAo7zww+lziBLLzMDWEtASqzx49ahfLNyGi/tcul6jJaMSZOfZi3bF93DxKN1r
	 fA+CuwUl8FljOl8FQbN/eqD1der9XMHGMDpvj5OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 317/626] scsi: mpt3sas: Send a diag reset if target reset fails
Date: Tue, 27 May 2025 18:23:30 +0200
Message-ID: <20250527162457.909146772@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

[ Upstream commit 5612d6d51ed2634a033c95de2edec7449409cbb9 ]

When an IOCTL times out and driver issues a target reset, if firmware
fails the task management elevate the recovery by issuing a diag reset to
controller.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Link: https://lore.kernel.org/r/1739410016-27503-5-git-send-email-shivasharan.srikanteshwara@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 87784c96249a7..47faa27bc3559 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -679,6 +679,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	size_t data_in_sz = 0;
 	long ret;
 	u16 device_handle = MPT3SAS_INVALID_DEVICE_HANDLE;
+	int tm_ret;
 
 	issue_reset = 0;
 
@@ -1120,18 +1121,25 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 			if (pcie_device && (!ioc->tm_custom_handling) &&
 			    (!(mpt3sas_scsih_is_pcie_scsi_device(
 			    pcie_device->device_info))))
-				mpt3sas_scsih_issue_locked_tm(ioc,
+				tm_ret = mpt3sas_scsih_issue_locked_tm(ioc,
 				  le16_to_cpu(mpi_request->FunctionDependent1),
 				  0, 0, 0,
 				  MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
 				  0, pcie_device->reset_timeout,
 			MPI26_SCSITASKMGMT_MSGFLAGS_PROTOCOL_LVL_RST_PCIE);
 			else
-				mpt3sas_scsih_issue_locked_tm(ioc,
+				tm_ret = mpt3sas_scsih_issue_locked_tm(ioc,
 				  le16_to_cpu(mpi_request->FunctionDependent1),
 				  0, 0, 0,
 				  MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
 				  0, 30, MPI2_SCSITASKMGMT_MSGFLAGS_LINK_RESET);
+
+			if (tm_ret != SUCCESS) {
+				ioc_info(ioc,
+					 "target reset failed, issue hard reset: handle (0x%04x)\n",
+					 le16_to_cpu(mpi_request->FunctionDependent1));
+				mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
+			}
 		} else
 			mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	}
-- 
2.39.5



