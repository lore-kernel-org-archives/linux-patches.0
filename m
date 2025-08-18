Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F85731CA57;
	Mon, 18 Aug 2025 13:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522421; cv=none; b=DRZ4VmF7ee+/SPguWmA2noQf7VuZyDnScbkyzSzF1PTvDXFg/GBMkgzflXF/SmXeqQTV7w3L4MKwb92WJ4ulcdA1LcSdu1fNXQauiVhnMqkLyJ9KkKiGAOGG+OAgVzYZH8iOIsEX83+pQUrls7EdYi/6jy5l0JvG1/Nmr72gMow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522421; c=relaxed/simple;
	bh=ScHznxdBvavaL7r8yIJRt7QTKb1m4a7hSewmriu5Qg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AusIahUJ9SGkBEDTKYkogxnaj/ymNqLUjOKL4N/aFz/sQ4mSY8Yyv8N4CMVd2gjd/BfGjW6/xj1N5Sj3gx2jHUuxYGVig3xDK0Lvoc0oNddS8+6BLIofgB2ba0CU0sKFssyI8UjgLe+01ezMSEXzn2RxXlsGCZiza3BlCE4/HEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUk/yGOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUk/yGOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7392C4CEEB;
	Mon, 18 Aug 2025 13:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522421;
	bh=ScHznxdBvavaL7r8yIJRt7QTKb1m4a7hSewmriu5Qg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUk/yGOyrMfKUu+yJoSQ/uL24iMvQkSnFIG4kSG8o0s4bQBQKIKSrdQqRP1h6AaRE
	 OPpF1n3PDDA3h7bbuPJAB+oVziQ99XIs4yW/qG3Lpk2wjzwzIf4qCLfbQYyOinyAfl
	 H+tdTupddA73oIWgBftzT19BDCVaUxFxDCUiGlI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 311/444] scsi: mpi3mr: Correctly handle ATA device errors
Date: Mon, 18 Aug 2025 14:45:37 +0200
Message-ID: <20250818124500.609211937@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 04caad5a7ba86e830d04750417a15bad8ac2613c ]

With the ATA error model, an NCQ command failure always triggers an abort
(termination) of all NCQ commands queued on the device. In such case, the
SAT or the host must handle the failed command according to the command
sense data and immediately retry all other NCQ commands that were aborted
due to the failed NCQ command.

For SAS HBAs controlled by the mpi3mr driver, NCQ command aborts are not
handled by the HBA SAT and sent back to the host, with an ioc log
information equal to 0x31080000 (IOC_LOGINFO_PREFIX_PL with the PL code
PL_LOGINFO_CODE_SATA_NCQ_FAIL_ALL_CMDS_AFTR_ERR). The function
mpi3mr_process_op_reply_desc() always forces a retry of commands
terminated with the status MPI3_IOCSTATUS_SCSI_IOC_TERMINATED using the
SCSI result DID_SOFT_ERROR, regardless of the ioc_loginfo for the
command. This correctly forces the retry of collateral NCQ abort
commands, but with the retry counter for the command being incremented.
If a command to an ATA device is subject to too many retries due to other
NCQ commands failing (e.g. read commands trying to access unreadable
sectors), the collateral NCQ abort commands may be terminated with an
error as they run out of retries. This violates the SAT specification and
causes hard-to-debug command errors.

Solve this issue by modifying the handling of the
MPI3_IOCSTATUS_SCSI_IOC_TERMINATED status to check if a command is for an
ATA device and if the command ioc_loginfo indicates an NCQ collateral
abort. If that is the case, force the command retry using the SCSI result
DID_IMM_RETRY to avoid incrementing the command retry count.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250606052747.742998-2-dlemoal@kernel.org
Tested-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 1e8735538b23..990646e1e18d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -49,6 +49,13 @@ static void mpi3mr_send_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
 
 #define MPI3_EVENT_WAIT_FOR_DEVICES_TO_REFRESH	(0xFFFE)
 
+/*
+ * SAS Log info code for a NCQ collateral abort after an NCQ error:
+ * IOC_LOGINFO_PREFIX_PL | PL_LOGINFO_CODE_SATA_NCQ_FAIL_ALL_CMDS_AFTR_ERR
+ * See: drivers/message/fusion/lsi/mpi_log_sas.h
+ */
+#define IOC_LOGINFO_SATA_NCQ_FAIL_AFTER_ERR	0x31080000
+
 /**
  * mpi3mr_host_tag_for_scmd - Get host tag for a scmd
  * @mrioc: Adapter instance reference
@@ -3397,7 +3404,18 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 		scmd->result = DID_NO_CONNECT << 16;
 		break;
 	case MPI3_IOCSTATUS_SCSI_IOC_TERMINATED:
-		scmd->result = DID_SOFT_ERROR << 16;
+		if (ioc_loginfo == IOC_LOGINFO_SATA_NCQ_FAIL_AFTER_ERR) {
+			/*
+			 * This is a ATA NCQ command aborted due to another NCQ
+			 * command failure. We must retry this command
+			 * immediately but without incrementing its retry
+			 * counter.
+			 */
+			WARN_ON_ONCE(xfer_count != 0);
+			scmd->result = DID_IMM_RETRY << 16;
+		} else {
+			scmd->result = DID_SOFT_ERROR << 16;
+		}
 		break;
 	case MPI3_IOCSTATUS_SCSI_TASK_TERMINATED:
 	case MPI3_IOCSTATUS_SCSI_EXT_TERMINATED:
-- 
2.39.5



