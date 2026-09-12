Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4D82DBF75;
	Sat, 12 Sep 2026 15:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228528; cv=none; b=dXk1Kppfa2IFmvbYlkHmqMi0IPVLuQ65iSYdEwG6krAT0+AaE2kujfP6wKjfHJV1xHx6u0aSrYLQ34nejWxU+s8nbetOmtuZ4adHvLPxtMrMdFBszNsSc0daFkrgUgkNKVcKPg75LTgLujc+8u4CxjgvYokO54AMRssMUCWtRaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228528; c=relaxed/simple;
	bh=OwraRaVUmhJ3sYESoKKZNnIRzr8089fC7kw3Faf8Ymc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kr9ZcJ8Dn5jLCAKgnBLz7KH6Z3T4N/pBBpML6zuHdVDNkTIPoUxG9CRRy9Qp2N0Xgm9vr35Y5SilH3zbuGuPddS8aS8woEiWEermFC361Z+FrSOW5O2+x4aX52gKG8FfOUub08P6pBE6x8MMMvcq7UtjfBjYd0rTzLbrPCfyw6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFzTQt4E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFzTQt4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D961F000FF;
	Sat, 12 Sep 2026 15:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228526;
	bh=l7jNPTxMLd/YphwOEna7RlCR7qAbknn7YI3wAGDsv5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFzTQt4Ex0ie4vbR9HXLxvwS7beQ6FLtxT6++J88YN4LHqT/qqVamQv8Ia3C586du
	 0PNH1vi3/aPitZrIsIWoT6FSX5uAWe0CsAI/U+a9pPqO9JQ3HyL4AI+Mf8bY0EwCeG
	 M4RqZTg1BwQPNKE1my/nc70lbPGqSx7ZYOgGOn8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 0402/1191] scsi: qla2xxx: Reject non-SCSI SRB on status IOCB fast path
Date: Sat, 12 Sep 2026 08:52:10 +0200
Message-ID: <20260912065557.267190985@linuxfoundation.org>
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
@@ -3258,6 +3258,14 @@ qla2x00_status_entry(scsi_qla_host_t *vh
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


