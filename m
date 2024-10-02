Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C07029CE7;
	Wed,  2 Oct 2024 13:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875859; cv=none; b=bD5cnsSTFWa6SJEgJAsr/tI1tQ7oIlFEiM0pr9fQYaC0ueEWS5OwbuJpK01oy71oBkXigan4dyaJ31uAva/dk+N7bcLrXcWVKy9lJke4aS/GxXqZuUbLIS/38EZdu0rn8J0YEMqIVLO+V2mEeJK/7ElLlLCsMmSbtNW2vXUM4/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875859; c=relaxed/simple;
	bh=G8PvboJzQ2U20ZHWldOTvTaUhm2nChbl8o9+DUaww00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjjaVph6iCzd8oz2vtPpVB2qPhQzu2uprhXkLjFiME3NOj69nFLSsvqdbv2INlqti5rvN1J53673gK7uWgUYtrBC/iQJN0IKF7J3uZr497w9mNfDiC6kxG+FrFaJCBg6zBu5U1V9hQMdCcg46wjBZgD8KFCDcl5KjBp4bYIaR2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xt0/kDeZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xt0/kDeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3BCC4CEC5;
	Wed,  2 Oct 2024 13:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875859;
	bh=G8PvboJzQ2U20ZHWldOTvTaUhm2nChbl8o9+DUaww00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xt0/kDeZszVJj4ao7TNsNHmwlbidiqBPh8PPV1/qQtgbUjcTB1wk6NFh0Qo1TPeJj
	 sdmjvXQ3322VV5di3zDL9qpQHAseYjsMpABVCTzZC4DgmfkIW1zk2dwc2/27aSKksU
	 qJTb5nMG6jvrxu5y77ONmUtjVKpPs15/aIyrYPbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 245/695] ata: libata: Clear DID_TIME_OUT for ATA PT commands with sense data
Date: Wed,  2 Oct 2024 14:54:03 +0200
Message-ID: <20241002125832.231878137@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit e5dd410acb34c7341a0a93b429dcf3dabf9e3323 ]

When ata_qc_complete() schedules a command for EH using
ata_qc_schedule_eh(), blk_abort_request() will be called, which leads to
req->q->mq_ops->timeout() / scsi_timeout() being called.

scsi_timeout(), if the LLDD has no abort handler (libata has no abort
handler), will set host byte to DID_TIME_OUT, and then call
scsi_eh_scmd_add() to add the command to EH.

Thus, when commands first enter libata's EH strategy_handler, all the
commands that have been added to EH will have DID_TIME_OUT set.

libata has its own flag (AC_ERR_TIMEOUT), that it sets for commands that
have not received a completion at the time of entering EH.

Thus, libata doesn't really care about DID_TIME_OUT at all, and currently
clears the host byte at the end of EH, in ata_scsi_qc_complete(), before
scsi_eh_finish_cmd() is called.

However, this clearing in ata_scsi_qc_complete() is currently only done
for commands that are not ATA passthrough commands.

Since the host byte is visible in the completion that we return to user
space for ATA passthrough commands, for ATA passthrough commands that got
completed via EH (commands with sense data), the user will incorrectly see:
ATA pass-through(16): transport error: Host_status=0x03 [DID_TIME_OUT]

Fix this by moving the clearing of the host byte (which is currently only
done for commands that are not ATA passthrough commands) from
ata_scsi_qc_complete() to the start of EH (regardless if the command is
ATA passthrough or not).

While at it, use the proper helper function to clear the host byte, rather
than open coding the clearing.

This will make sure that we:
-Correctly clear DID_TIME_OUT for both ATA passthrough commands and
 commands that are not ATA passthrough commands.
-Do not needlessly clear the host byte for commands that did not go via EH.
 ata_scsi_qc_complete() is called both for commands that are completed
 normally (without going via EH), and for commands that went via EH,
 however, only commands that went via EH will have DID_TIME_OUT set.

Fixes: 24aeebbf8ea9 ("scsi: ata: libata: Change ata_eh_request_sense() to not set CHECK_CONDITION")
Reported-by: Igor Pylypiv <ipylypiv@google.com>
Closes: https://lore.kernel.org/linux-ide/ZttIN8He8TOZ7Lct@google.com/
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Tested-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-eh.c   | 8 ++++++++
 drivers/ata/libata-scsi.c | 3 ---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 214b935c2ced7..7df9ec9f924c4 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -630,6 +630,14 @@ void ata_scsi_cmd_error_handler(struct Scsi_Host *host, struct ata_port *ap,
 	list_for_each_entry_safe(scmd, tmp, eh_work_q, eh_entry) {
 		struct ata_queued_cmd *qc;
 
+		/*
+		 * If the scmd was added to EH, via ata_qc_schedule_eh() ->
+		 * scsi_timeout() -> scsi_eh_scmd_add(), scsi_timeout() will
+		 * have set DID_TIME_OUT (since libata does not have an abort
+		 * handler). Thus, to clear DID_TIME_OUT, clear the host byte.
+		 */
+		set_host_byte(scmd, DID_OK);
+
 		ata_qc_for_each_raw(ap, qc, i) {
 			if (qc->flags & ATA_QCFLAG_ACTIVE &&
 			    qc->scsicmd == scmd)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 473e00a58a8b0..fc8d99ea2e581 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1691,9 +1691,6 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 			set_status_byte(qc->scsicmd, SAM_STAT_CHECK_CONDITION);
 	} else if (is_error && !have_sense) {
 		ata_gen_ata_sense(qc);
-	} else {
-		/* Keep the SCSI ML and status byte, clear host byte. */
-		cmd->result &= 0x0000ffff;
 	}
 
 	ata_qc_done(qc);
-- 
2.43.0



