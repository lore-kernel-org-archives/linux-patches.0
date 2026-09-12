Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EFD3AC0D9;
	Sat, 12 Sep 2026 18:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237885; cv=none; b=IKTCXehajotvPhojaMWK+tPOQUgwQMhTt0y7e4X9gcNwFDGxVim0rJSFyDiBaCJIzl3IkMcpPpCtKrYGFA4waKMwYIQRIG3BV20wR9nCm8Edz+gXlajfnHRHEDTaqSVOM9U7DuIZZzfRDD0vhwjEirAGFKL7fAi4iK36ZpF4+zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237885; c=relaxed/simple;
	bh=xJWpXxQO0o1gxuQ1nvU5wI8aFi/4mlhLtvgF48MOGq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gby/avYtlnQBepS3WYqm54QlxMTn2BWXtQ+YWYoJ+fcYIJqa84lc8ryBA06epWpSqwqnXhwrDYklqpqOYDqh+LGDRJpttE508q/WLbXK0bN1CKrVTG+bmGMK03g4MngTslQF0Y2MpbM76L76FpRNMr7nL3pQaRXhZitHKjUNZdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yq5iYB/I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yq5iYB/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFE71F000FF;
	Sat, 12 Sep 2026 18:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237883;
	bh=z++NOvVr5iqN+GOh6gJ4oIhFmCE/u1zY0b45F3MLitc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yq5iYB/I1CH010mZ6DIP3GOvZv7A5D2p1LN+CQUOc/IBPRf4k4VW6E1S1KXWM6/PW
	 e4t+w/9qS8Q5X9vkmPFqdjh5H4Ps2XAOnohJj4z6MBDLRw5Toc7PwhoejrctxXiVqL
	 7UTEpgaAyHfM2BSMybGLOSG9weooeUBsSGxL2FHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.15 347/935] scsi: qla2xxx: Reject non-SCSI SRB on status IOCB fast path
Date: Sat, 12 Sep 2026 08:56:17 +0200
Message-ID: <20260912065534.765440316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit 0f41d07d72f2245208c45374ca8d0a1846cad667 upstream.

qla2x00_status_entry() filters out non-TYPE_SRB entries and the
SRB_NVME_CMD, SRB_BIDI_CMD and SRB_TM_CMD types, then falls through to a
SCSI fast path that assumes the command is an SRB_SCSI_CMD. The first
thing on that path, qla_chk_edif_rx_sa_delete_pending(), and the
subsequent handling both evaluate GET_CMD_SP(sp), i.e. sp->u.scmd.cmd.

The srb u union overlays the SCSI command pointer with other command
layouts (bsg_job, iocb_cmd). If firmware delivers an unexpected
STATUS_TYPE IOCB for a non-SCSI handle, sp->u.scmd.cmd can read as a
non-NULL garbage pointer, bypassing the NULL checks in
qla_chk_edif_rx_sa_delete_pending() and at the cp == NULL test, and
leading to a wild pointer dereference.

Reject any SRB whose type is not SRB_SCSI_CMD before entering the fast
path. The outstanding_cmds slot is left untouched so a genuinely
non-SCSI command still completes through its proper handler.

Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-19-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -17,7 +17,7 @@
  * |                              |                    | 0x212c-0x2134  |
  * | Queue Command and IO tracing |       0x3074       | 0x300b         |
  * |                              |                    | 0x3027-0x3028  |
- * |                              |                    | 0x303d-0x3041  |
+ * |                              |                    | 0x303e-0x3041  |
  * |                              |                    | 0x302e,0x3033  |
  * |                              |                    | 0x3036,0x3038  |
  * |                              |                    | 0x303a		|
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3232,6 +3232,14 @@ qla2x00_status_entry(scsi_qla_host_t *vh
 		return;
 	}
 
+	/* Everything below is the SCSI fast path; reject other SRB types. */
+	if (sp->type != SRB_SCSI_CMD) {
+		ql_dbg(ql_dbg_io, vha, 0x303d,
+		    "Unexpected SRB type %x for status IOCB, sp %p.\n",
+		    sp->type, sp);
+		return;
+	}
+
 	/* Fast path completion. */
 	qla_chk_edif_rx_sa_delete_pending(vha, sp, sts24);
 	sp->qpair->cmd_completion_cnt++;


