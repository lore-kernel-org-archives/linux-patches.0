Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1D9387571;
	Tue, 10 Mar 2026 11:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141257; cv=none; b=p5/8UOVap3PY+kKqbVVqRy969K2X3dZ2P/P15s8dyL0s3U5PQJuWEYyvbfXIJVgzOwEAdbtGDLwAvpdAHppDLPvJKVNkvNrff1oILxzOvV7ydf0hL/406Ca1r9876s6YKry4dsHoG7IedQDmi2dwEydBIxeoxTlpLaRL4iqSC7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141257; c=relaxed/simple;
	bh=rYWBff07A/Kn+FO31P/IPu8pR77eL/1XSQjziZc5Xlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JY6Cue2/niGatucdYbNWVfVHrrvge4SZyHz4Fc4x2DPfuKbD/Jkwxbo8sbttVhWLCIvPn9t+S6dTLOWpFR+mBcm/LM7FmDkrsUWVOLPvppzRWOYzpB5PtQfnUFlb8bs+U0WQDAtpwVbwyJetFbpTKjakNNR2OLK0fT/q8yUMXPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rlAw+TJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rlAw+TJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA23C2BC9E;
	Tue, 10 Mar 2026 11:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141257;
	bh=rYWBff07A/Kn+FO31P/IPu8pR77eL/1XSQjziZc5Xlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlAw+TJt/yflp7PZBFQ6k/GSSq4IbiU13cwJH7uh2GIeVuo1OBUzZBw2zV2Kq9F+O
	 axTBfSVvN1FDT7xfRzbz6Q6cF5QEmgWPjBRN5lUnpSjoiThS5aq3shD2YcApsWTsxi
	 yu3r2aAFPfeenbZw8rEZsG2eEkfN2zzo399mq5AwRDR0ICjEC7Vd5+e6epUMxGK2UN
	 6hXAz4CrfK/48rkd9jDD0GjgcYL+SkI/ihClITaW1nIRRT64EKNEJkZaScPp+IE2Rt
	 SgWTiq9R/lMOUMtrC2UAr0lHUcmpe8j1/oamNG+oWp4V1h9OYLfPl7wJ2O/wi4LuHQ
	 65MKvDHY7GoVQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>,
	syzbot+bcaf842a1e8ead8dfb89@syzkaller.appspotmail.com,
	Igor Pylypiv <ipylypiv@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 260/311] ata: libata: cancel pending work after clearing deferred_qc
Date: Tue, 10 Mar 2026 07:05:07 -0400
Message-ID: <cd42107eeedac0bf20245ff2eb46575e1f0df57e.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit aac9b27f7c1f2b2cf7f50a9ca633ecbbcaf22af9 ]

Syzbot reported a WARN_ON() in ata_scsi_deferred_qc_work(), caused by
ap->ops->qc_defer() returning non-zero before issuing the deferred qc.

ata_scsi_schedule_deferred_qc() is called during each command completion.
This function will check if there is a deferred QC, and if
ap->ops->qc_defer() returns zero, meaning that it is possible to queue the
deferred qc at this time (without being deferred), then it will queue the
work which will issue the deferred qc.

Once the work get to run, which can potentially be a very long time after
the work was scheduled, there is a WARN_ON() if ap->ops->qc_defer() returns
non-zero.

While we hold the ap->lock both when assigning and clearing deferred_qc,
and the work itself holds the ap->lock, the code currently does not cancel
the work after clearing the deferred qc.

This means that the following scenario can happen:
1) One or several NCQ commands are queued.
2) A non-NCQ command is queued, gets stored in ap->deferred_qc.
3) Last NCQ command gets completed, work is queued to issue the deferred
   qc.
4) Timeout or error happens, ap->deferred_qc is cleared. The queued work is
   currently NOT canceled.
5) Port is reset.
6) One or several NCQ commands are queued.
7) A non-NCQ command is queued, gets stored in ap->deferred_qc.
8) Work is finally run. Yet at this time, there is still NCQ commands in
   flight.

The work in 8) really belongs to the non-NCQ command in 2), not to the
non-NCQ command in 7). The reason why the work is executed when it is not
supposed to, is because it was never canceled when ap->deferred_qc was
cleared in 4). Thus, ensure that we always cancel the work after clearing
ap->deferred_qc.

Another potential fix would have been to let ata_scsi_deferred_qc_work() do
nothing if ap->ops->qc_defer() returns non-zero. However, canceling the
work when clearing ap->deferred_qc seems slightly more logical, as we hold
the ap->lock when clearing ap->deferred_qc, so we know that the work cannot
be holding the lock. (The function could be waiting for the lock, but that
is okay since it will do nothing if ap->deferred_qc is not set.)

Reported-by: syzbot+bcaf842a1e8ead8dfb89@syzkaller.appspotmail.com
Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Fixes: eddb98ad9364 ("ata: libata-eh: correctly handle deferred qc timeouts")
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-eh.c   | 1 +
 drivers/ata/libata-scsi.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index b373cceb95d23..563432400f727 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -659,6 +659,7 @@ void ata_scsi_cmd_error_handler(struct Scsi_Host *host, struct ata_port *ap,
 			 */
 			WARN_ON_ONCE(qc->flags & ATA_QCFLAG_ACTIVE);
 			ap->deferred_qc = NULL;
+			cancel_work(&ap->deferred_qc_work);
 			set_host_byte(scmd, DID_TIME_OUT);
 			scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
 		} else if (i < ATA_MAX_QUEUE) {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 6b954efa9adb1..98ee5e7f61eb6 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1699,6 +1699,7 @@ void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
 
 	scmd = qc->scsicmd;
 	ap->deferred_qc = NULL;
+	cancel_work(&ap->deferred_qc_work);
 	ata_qc_free(qc);
 	scmd->result = (DID_SOFT_ERROR << 16);
 	scsi_done(scmd);
-- 
2.51.0

