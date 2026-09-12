Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD889223328;
	Sat, 12 Sep 2026 15:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228538; cv=none; b=fJMgMVsZw0iqwMD/ARJbEt0yPDYWwCaYWlscpQEJIqbmUuDrCW3+rlcn6cg/R7SBwEP7ytapeWANa5X9ec++A4PPo7YXFA7tctlRMJBNWWmwTbzvQIWiStgenMfoQwhckMJEPnRlNY5wkWgb+a4miMjYZkTF44+rJNfeK3fMPKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228538; c=relaxed/simple;
	bh=ldSnSChQgOd51RoSFe4bMva60GSAF+SLskkCLK46R24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWVnq8tExAwojfRLBsJpenx9XT2F815Yzd6GuPhG+sHhf2iwt2OiTk593Hb0aindPLl/DnEET2G81+kuS/WdlizJRJn1DViMB9nzfZ0ezCGXJUHTD9v6K9Lt3qt+vclQ2cQyY/xwjz3FYAfafo3CaS61Yor8HMdZZeMikQShLdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIAGtBwJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIAGtBwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DF01F000FF;
	Sat, 12 Sep 2026 15:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228536;
	bh=RfEM3kWnXGi+PZpIqy+rN6XAkiF7qjt/wXaGTsZUzAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIAGtBwJ6WUV2sBcFBvNvGzEQ5lZjXIYb2/9G4Shm3iBuGCEqyPhxbVZ3J6W8Zvsn
	 BFVY/P7LXFbvbv/KTVXO5OTXGUEftDI+Xa6/fEHVHhgGSIwYnj8hpH6SLWLanifLyp
	 oCYKmRtMorNGavip0ct+6/nuXi+FSgbMUK9Wt/Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 0404/1191] scsi: qla2xxx: Avoid double completion in async IOCB timeout
Date: Sat, 12 Sep 2026 08:52:12 +0200
Message-ID: <20260912065557.312141605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -228,7 +228,7 @@ qla2x00_async_iocb_timeout(void *data)
 	srb_t *sp = data;
 	fc_port_t *fcport = sp->fcport;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
-	int rc, h;
+	int rc, h, found;
 	unsigned long flags;
 
 	if (fcport) {
@@ -251,6 +251,7 @@ qla2x00_async_iocb_timeout(void *data)
 			lio->u.logio.data[1] =
 				lio->u.logio.flags & SRB_LOGIN_RETRIED ?
 				QLA_LOGIO_LOGIN_RETRIED : 0;
+			found = 0;
 			spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
 			for (h = 1; h < sp->qpair->req->num_outstanding_cmds;
 			    h++) {
@@ -258,11 +259,19 @@ qla2x00_async_iocb_timeout(void *data)
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
@@ -275,6 +284,7 @@ qla2x00_async_iocb_timeout(void *data)
 	default:
 		rc = qla24xx_async_abort_cmd(sp, false);
 		if (rc) {
+			found = 0;
 			spin_lock_irqsave(sp->qpair->qp_lock_ptr, flags);
 			for (h = 1; h < sp->qpair->req->num_outstanding_cmds;
 			    h++) {
@@ -282,11 +292,19 @@ qla2x00_async_iocb_timeout(void *data)
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


