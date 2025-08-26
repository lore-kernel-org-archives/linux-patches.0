Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444CC1FF1C4;
	Tue, 26 Aug 2025 12:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213174; cv=none; b=t4o8hLUulS/ioOumhOuz4gvA0OMNtJFLkUPzv01YVbnbkL+7ZrRaBvWkdpsj2TOhjunMk/n7qMNCsT2Y5QmMHkUYOPXrzYqVnLbVXhlxEN4uV3u1VTgN8dvtxVfVjeEJt86q+iQMx9vZVsMWwhihZJX+Nl8d+8KiGRL/L//xy8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213174; c=relaxed/simple;
	bh=Kh3tWsEvUELjXYZiE7kiJ7AIbzDWZfUx3tjc4nMyFwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMswKB26sWKB+iSOCDjWxwobTWojU4aFGYQ6CWXh5TXeYNaPROlW4FZ6hCbFKxdDFZQbk4UfqcoWWr0HSA+vEbZJDUDyMh0G2oRKiYicShKmXaEOjZh520QMBe9fxV0hxcZNuZbpDhTwsBxtEFYIsy6N3/hb7gHKUEQ4EU9wUZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uc7jNs/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uc7jNs/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EB1C4CEF1;
	Tue, 26 Aug 2025 12:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213174;
	bh=Kh3tWsEvUELjXYZiE7kiJ7AIbzDWZfUx3tjc4nMyFwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uc7jNs/6DQHEHfC74u7onrRucvKa4PuuI7H5cF+dnI2OK6YhOxVuqVzZaje9pUDag
	 VeOYRHI8iqWDz4+6hGkdbkQl9nkRd6p3cFC+eX2T+3ieLmNSKGr3Gbl2Gygkn0E3SD
	 9bTbFQMl1Q2s7REvnQHoSYMHFSWTntCDwXQKw5Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/587] scsi: mpt3sas: Correctly handle ATA device errors
Date: Tue, 26 Aug 2025 13:06:37 +0200
Message-ID: <20250826110959.238236082@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 15592a11d5a5c8411ac8494ec49736b658f6fbff ]

With the ATA error model, an NCQ command failure always triggers an abort
(termination) of all NCQ commands queued on the device. In such case, the
SAT or the host must handle the failed command according to the command
sense data and immediately retry all other NCQ commands that were aborted
due to the failed NCQ command.

For SAS HBAs controlled by the mpt3sas driver, NCQ command aborts are not
handled by the HBA SAT and sent back to the host, with an ioc log
information equal to 0x31080000 (IOC_LOGINFO_PREFIX_PL with the PL code
PL_LOGINFO_CODE_SATA_NCQ_FAIL_ALL_CMDS_AFTR_ERR). The function
_scsih_io_done() always forces a retry of commands terminated with the
status MPI2_IOCSTATUS_SCSI_IOC_TERMINATED using the SCSI result
DID_SOFT_ERROR, regardless of the log_info for the command.  This
correctly forces the retry of collateral NCQ abort commands, but with the
retry counter for the command being incremented. If a command to an ATA
device is subject to too many retries due to other NCQ commands failing
(e.g. read commands trying to access unreadable sectors), the collateral
NCQ abort commands may be terminated with an error as they run out of
retries. This violates the SAT specification and causes hard-to-debug
command errors.

Solve this issue by modifying the handling of the
MPI2_IOCSTATUS_SCSI_IOC_TERMINATED status to check if a command is for an
ATA device and if the command loginfo indicates an NCQ collateral
abort. If that is the case, force the command retry using the SCSI result
DID_IMM_RETRY to avoid incrementing the command retry count.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250606052747.742998-3-dlemoal@kernel.org
Tested-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 0afa485fb300..7bef42a2fb57 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -196,6 +196,14 @@ struct sense_info {
 #define MPT3SAS_PORT_ENABLE_COMPLETE (0xFFFD)
 #define MPT3SAS_ABRT_TASK_SET (0xFFFE)
 #define MPT3SAS_REMOVE_UNRESPONDING_DEVICES (0xFFFF)
+
+/*
+ * SAS Log info code for a NCQ collateral abort after an NCQ error:
+ * IOC_LOGINFO_PREFIX_PL | PL_LOGINFO_CODE_SATA_NCQ_FAIL_ALL_CMDS_AFTR_ERR
+ * See: drivers/message/fusion/lsi/mpi_log_sas.h
+ */
+#define IOC_LOGINFO_SATA_NCQ_FAIL_AFTER_ERR	0x31080000
+
 /**
  * struct fw_event_work - firmware event struct
  * @list: link list framework
@@ -5824,6 +5832,17 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 			scmd->result = DID_TRANSPORT_DISRUPTED << 16;
 			goto out;
 		}
+		if (log_info == IOC_LOGINFO_SATA_NCQ_FAIL_AFTER_ERR) {
+			/*
+			 * This is a ATA NCQ command aborted due to another NCQ
+			 * command failure. We must retry this command
+			 * immediately but without incrementing its retry
+			 * counter.
+			 */
+			WARN_ON_ONCE(xfer_cnt != 0);
+			scmd->result = DID_IMM_RETRY << 16;
+			break;
+		}
 		if (log_info == 0x31110630) {
 			if (scmd->retries > 2) {
 				scmd->result = DID_NO_CONNECT << 16;
-- 
2.39.5



