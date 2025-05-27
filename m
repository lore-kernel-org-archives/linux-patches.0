Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1155627D786;
	Tue, 27 May 2025 17:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367446; cv=none; b=NggJAj8JvAdvT13sz43Q6FugjEfsvWAi6tcJAliIRvYS/VSk5LU5pulph0VhBC3xRKfGEJ3Ahf3V0yCNbUQQyAQ2kUgZ1z8+n6msrryUo23kFhrr0aN/bNY1u2s74JB+1apNmr+haqXGxNQh6T8pQy+5SUDGaGXyo0g8SpxQJ74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367446; c=relaxed/simple;
	bh=eK768Ao5/MM/aJoRUOrXh5P3mh0Rxk8W5trTVHLHwqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VleN4kXnVvIUAr1bvfsdHUQ2qxvM5R5nDBMKi2ykkkqnYhMa0+a5+Nv6gSCDFE+9YFDofFOjDhZhCjIJmBFMbUi8oGPGX1fB13gJcIWoX8OuHJY2udXndWhSsHIAXOYm9YDny1FnIyskj0L2s9kb9UVxkjd5syW1A9hp0ZErYGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tRPddsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tRPddsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAC3C4CEEB;
	Tue, 27 May 2025 17:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367445;
	bh=eK768Ao5/MM/aJoRUOrXh5P3mh0Rxk8W5trTVHLHwqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tRPddsLTVPGdnjQVjNh+xs83yY0UTfn5i/d5cmh2Q1wzHiVvLLukg5U9qBFjrTxA
	 z2xt0Nlqzl9eM5IFKbB/zoX6zJzt3D5m5fcMKKIuk/QSz2QGNyBYeS7CnOMX8I8lS3
	 qz/gfuloA0KXLY7ogitqh64LAB0Ec7bkor5PJKak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 391/783] scsi: mpt3sas: Send a diag reset if target reset fails
Date: Tue, 27 May 2025 18:23:08 +0200
Message-ID: <20250527162529.016917493@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



