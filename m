Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35CB6FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18595C433C7;
	Sun, 17 Sep 2023 19:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979683;
	bh=PpP5ZRHtK1fJfVAMHD2y03tuAh0dISzCxhhfPEoHJIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4gBn+a/ygUMJ9JTI/3FdKupsp36LLIuHa/4fCTKXWI3YMP6mPAyDSiE4tI1W48C4
	 CSce8MgOnf77YNnUTZ59AMLWvCOk0XAiqFBk2ji/aXoV/sfcEMxvh+EyhYHGm1LbsO
	 UVFdxWR8ZSTU1Zqa9KjrPaiIarN2jfXwZlKzOmMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 383/406] scsi: qla2xxx: If fcport is undergoing deletion complete I/O with retry
Date: Sun, 17 Sep 2023 21:13:57 +0200
Message-ID: <20230917191111.375051397@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 707531bc2626c1959a03b93566ebb4e629c99276 ]

Driver unload with I/Os in flight causes server to crash.  Complete I/O
with DID_IMM_RETRY if fcport undergoing deletion.

CPU: 44 PID: 35008 Comm: qla2xxx_4_dpc Kdump: loaded Tainted: G
OE  X   5.3.18-22-default #1 SLE15-SP2 (unreleased)
Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 07/16/2020
RIP: 0010:dma_direct_unmap_sg+0x24/0x60
Code: 4c 8b 04 24 eb b9 0f 1f 44 00 00 85 d2 7e 4e 41 57
      4d 89 c7 41 56 41 89 ce 41 55 49 89 fd 41 54 41 89 d4 55 31 ed 53 48 89
      f3 <8b> 53 18 48 8b 73 10 4d 89 f8 44 89 f1 4c 89 ef 83 c5 01 e8 44 ff
RSP: 0018:ffffc0c661037d88 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000002
RDX: 000000000000001d RSI: 0000000000000000 RDI: ffff9a51ee53b0b0
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff9a51ee53b0b0
R10: ffffc0c646463dc8 R11: ffff9a4a067087c8 R12: 000000000000001d
R13: ffff9a51ee53b0b0 R14: 0000000000000002 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff9a523f800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000018 CR3: 000000043740a004 CR4: 00000000007606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
qla2xxx_qpair_sp_free_dma+0x20d/0x3c0 [qla2xxx]
qla2xxx_qpair_sp_compl+0x35/0x90 [qla2xxx]
__qla2x00_abort_all_cmds+0x180/0x390 [qla2xxx]
? qla24xx_process_purex_list+0x100/0x100 [qla2xxx]
qla2x00_abort_all_cmds+0x5e/0x80 [qla2xxx]
qla2x00_do_dpc+0x317/0xa30 [qla2xxx]
kthread+0x10d/0x130
? kthread_park+0xa0/0xa0
ret_from_fork+0x35/0x40

Link: https://lore.kernel.org/r/20201202132312.19966-14-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 6d0b65569c0a ("scsi: qla2xxx: Flush mailbox commands on chip reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f1e7868787d4a..78a335f862cee 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -879,8 +879,8 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 			goto qc24_fail_command;
 	}
 
-	if (!fcport) {
-		cmd->result = DID_NO_CONNECT << 16;
+	if (!fcport || fcport->deleted) {
+		cmd->result = DID_IMM_RETRY << 16;
 		goto qc24_fail_command;
 	}
 
@@ -961,8 +961,8 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 		goto qc24_fail_command;
 	}
 
-	if (!fcport) {
-		cmd->result = DID_NO_CONNECT << 16;
+	if (!fcport || fcport->deleted) {
+		cmd->result = DID_IMM_RETRY << 16;
 		goto qc24_fail_command;
 	}
 
-- 
2.40.1



