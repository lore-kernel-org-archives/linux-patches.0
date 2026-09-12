Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E46E385D68;
	Sat, 12 Sep 2026 19:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242152; cv=none; b=TxosWq5+Cq72nap+7WzILXRZdE9veOwinan5bPHRHACCF4KCh6760e+dT6sOSZvEComWthWpi8Aiei+/2bzI8wJwVFlDkXBBseEYkdEOOwu0kgf4cYBuVcM2NalBmlXnrC1Q2jsamXLI62Tw63OQXI+PuAcqFOkIZ0Gmp9aBsXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242152; c=relaxed/simple;
	bh=GtsQdNp6nLXe5IvVhnR77UmtjoqpYlZNm9IawHE28lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCjkz1F3YEf1kCydTmycLww4RO8KjkX66/iybbKpUwg3vQiAfVepmSwHjRGy8pnjWKVHZLAKziGBjpPw8GkMDKoF/sdf87iVNYtTU0kGlP276J0qnLpj4vFi2ETeZBud0cW3fflCxjyBX8vnX9xbCGFEofP+Z7r2oY2CE6KvInM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKaqxCUr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKaqxCUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7421F000FF;
	Sat, 12 Sep 2026 19:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242149;
	bh=pygjglk0cziB6Q3+2irddnLvy19PqwODTMq2aITLt/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKaqxCUrlW050TIE2CmddBLCUvRrygRSvijz6FeBQCpTwQ6h9pA/y0pMhtiEt81aF
	 dNxlWW1PeXy/wzkpKgBH0vBk+QSLZmboW7JoMmrsAhnB9xxBStwoUV3KW3ChzfTcGC
	 sgCc3NMB/OWAxHH5AZtbgau7PHnnhq9MrzuSej3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 304/798] scsi: qla2xxx: Avoid double completion in async IOCB timeout
Date: Sat, 12 Sep 2026 08:58:52 +0200
Message-ID: <20260912065524.128999779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit bb45bc4bd53c95a7bf6f782577b5ede94c0f8aa8 upstream.

qla2x00_async_iocb_timeout() tries to abort a timed-out async IOCB. When
qla24xx_async_abort_cmd() fails, both the SRB_LOGIN_CMD path and the
SRB_CTRL_VP/default path scan outstanding_cmds[] for the SRB and then
call sp->done(sp, QLA_FUNCTION_TIMEOUT) unconditionally, without checking
whether the SRB was actually found and removed.

If the response ISR completes the same handle first, it removes the SRB
under qp_lock_ptr and runs sp->done() -> complete(sp->comp). The
submitter qla24xx_control_vp() wakes from wait_for_completion(), clears
sp->comp, drops its reference and returns, reclaiming the on-stack
completion. The timer reference keeps the SRB alive across the timeout
handler, but not the submitter's stack. The timeout then issues a second
sp->done() -> qla_ctrlvp_sp_done(), which evaluates "if (sp->comp)
complete(sp->comp)"; with the pointer loaded before the submitter's NULL
store, complete() writes into the freed stack frame, a use-after-free.

Track whether this path removed the SRB from outstanding_cmds and only
call sp->done() when it did, so the command is completed exactly once by
whichever path owns it. This mirrors the sp_found guard already used in
qla24xx_abort_iocb_timeout().

Fixes: f6145e86d21f ("scsi: qla2xxx: Fix race between switch cmd completion and timeout")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-21-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -206,7 +206,7 @@ qla2x00_async_iocb_timeout(void *data)
 	srb_t *sp = data;
 	fc_port_t *fcport = sp->fcport;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
-	int rc, h;
+	int rc, h, found;
 	unsigned long flags;
 
 	if (fcport) {
@@ -229,6 +229,7 @@ qla2x00_async_iocb_timeout(void *data)
 			lio->u.logio.data[1] =
 				lio->u.logio.flags & SRB_LOGIN_RETRIED ?
 				QLA_LOGIO_LOGIN_RETRIED : 0;
+			found = 0;
 			spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
 			for (h = 1; h < sp->qpair->req->num_outstanding_cmds;
 			    h++) {
@@ -236,11 +237,19 @@ qla2x00_async_iocb_timeout(void *data)
 				    sp) {
 					sp->qpair->req->outstanding_cmds[h] =
 					    NULL;
+					found = 1;
 					break;
 				}
 			}
 			spin_unlock_irqrestore(sp->qpair->qp_lock_ptr, flags);
-			sp->done(sp, QLA_FUNCTION_TIMEOUT);
+			/*
+			 * Only complete the command if this path removed it
+			 * from outstanding_cmds.  Otherwise the ISR already
+			 * completed it and a second sp->done() would race the
+			 * submitter's freeing of the on-stack completion.
+			 */
+			if (found)
+				sp->done(sp, QLA_FUNCTION_TIMEOUT);
 		}
 		break;
 	case SRB_LOGOUT_CMD:
@@ -253,6 +262,7 @@ qla2x00_async_iocb_timeout(void *data)
 	default:
 		rc = qla24xx_async_abort_cmd(sp, false);
 		if (rc) {
+			found = 0;
 			spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
 			for (h = 1; h < sp->qpair->req->num_outstanding_cmds;
 			    h++) {
@@ -260,11 +270,19 @@ qla2x00_async_iocb_timeout(void *data)
 				    sp) {
 					sp->qpair->req->outstanding_cmds[h] =
 					    NULL;
+					found = 1;
 					break;
 				}
 			}
 			spin_unlock_irqrestore(sp->qpair->qp_lock_ptr, flags);
-			sp->done(sp, QLA_FUNCTION_TIMEOUT);
+			/*
+			 * Only complete the command if this path removed it
+			 * from outstanding_cmds.  Otherwise the ISR already
+			 * completed it and a second sp->done() would race the
+			 * submitter's freeing of the on-stack completion.
+			 */
+			if (found)
+				sp->done(sp, QLA_FUNCTION_TIMEOUT);
 		}
 		break;
 	}


