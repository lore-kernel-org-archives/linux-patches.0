Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD01439FD9;
	Fri, 24 Nov 2023 18:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2Y3QVXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666C1C433C7;
	Fri, 24 Nov 2023 18:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849609;
	bh=NwQGOON365d9QGumIQVMzFpepMKgLeAYejL1hOcWTck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2Y3QVXOjEtquVqk18JGiWUS/aLFKkh8q8tZoEeGkVILIxu6ERoKohoTdLLp4etN2
	 ahJJv/OnDbzhmOiZqLMwVV2uMKsn0QYZoJMe8kqurUNjM8f1rL0rfARhWVMDaJjNkV
	 3XnHp9A26elRkHSESTGdJ5ZucN8PldfZJK5tbS+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 250/530] scsi: qla2xxx: Fix system crash due to bad pointer access
Date: Fri, 24 Nov 2023 17:46:56 +0000
Message-ID: <20231124172035.670953343@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quinn Tran <qutran@marvell.com>

commit 19597cad64d608aa8ac2f8aef50a50187a565223 upstream.

User experiences system crash when running AER error injection.  The
perturbation causes the abort-all-I/O path to trigger. The driver assumes
all I/O on this path is FCP only. If there is both NVMe & FCP traffic, a
system crash happens. Add additional check to see if I/O is FCP or not
before access.

PID: 999019  TASK: ff35d769f24722c0  CPU: 53  COMMAND: "kworker/53:1"
 0 [ff3f78b964847b58] machine_kexec at ffffffffae86973d
 1 [ff3f78b964847ba8] __crash_kexec at ffffffffae9be29d
 2 [ff3f78b964847c70] crash_kexec at ffffffffae9bf528
 3 [ff3f78b964847c78] oops_end at ffffffffae8282ab
 4 [ff3f78b964847c98] exc_page_fault at ffffffffaf2da502
 5 [ff3f78b964847cc0] asm_exc_page_fault at ffffffffaf400b62
   [exception RIP: qla2x00_abort_srb+444]
   RIP: ffffffffc07b5f8c  RSP: ff3f78b964847d78  RFLAGS: 00010046
   RAX: 0000000000000282  RBX: ff35d74a0195a200  RCX: ff35d76886fd03a0
   RDX: 0000000000000001  RSI: ffffffffc07c5ec8  RDI: ff35d74a0195a200
   RBP: ff35d76913d22080   R8: ff35d7694d103200   R9: ff35d7694d103200
   R10: 0000000100000000  R11: ffffffffb05d6630  R12: 0000000000010000
   R13: ff3f78b964847df8  R14: ff35d768d8754000  R15: ff35d768877248e0
   ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 6 [ff3f78b964847d70] qla2x00_abort_srb at ffffffffc07b5f84 [qla2xxx]
 7 [ff3f78b964847de0] __qla2x00_abort_all_cmds at ffffffffc07b6238 [qla2xxx]
 8 [ff3f78b964847e38] qla2x00_abort_all_cmds at ffffffffc07ba635 [qla2xxx]
 9 [ff3f78b964847e58] qla2x00_terminate_rport_io at ffffffffc08145eb [qla2xxx]
10 [ff3f78b964847e70] fc_terminate_rport_io at ffffffffc045987e [scsi_transport_fc]
11 [ff3f78b964847e88] process_one_work at ffffffffae914f15
12 [ff3f78b964847ed0] worker_thread at ffffffffae9154c0
13 [ff3f78b964847f10] kthread at ffffffffae91c456
14 [ff3f78b964847f50] ret_from_fork at ffffffffae8036ef

Cc: stable@vger.kernel.org
Fixes: f45bca8c5052 ("scsi: qla2xxx: Fix double scsi_done for abort path")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20231030064912.37912-1-njavali@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1836,8 +1836,16 @@ static void qla2x00_abort_srb(struct qla
 		}
 
 		spin_lock_irqsave(qp->qp_lock_ptr, *flags);
-		if (ret_cmd && blk_mq_request_started(scsi_cmd_to_rq(cmd)))
-			sp->done(sp, res);
+		switch (sp->type) {
+		case SRB_SCSI_CMD:
+			if (ret_cmd && blk_mq_request_started(scsi_cmd_to_rq(cmd)))
+				sp->done(sp, res);
+			break;
+		default:
+			if (ret_cmd)
+				sp->done(sp, res);
+			break;
+		}
 	} else {
 		sp->done(sp, res);
 	}


