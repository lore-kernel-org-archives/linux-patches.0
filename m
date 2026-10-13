Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C4E4EFFC9;
	Tue, 13 Oct 2026 11:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891986; cv=none; b=SpKSi7RgYgwdvxkVNEZYjpoioYNHcyXGv+mlszsZ9Pf4OXlvn+k3v+OfkrOFy+eL+5kS8PNN4s52/7dyYGb+EcQDPE15nQjlPfUhv4187eFkRm+gw+qcEgRKf3mGuew4+uGkzFn+ZWXZLh4Og0ihcrN69dcE42juFi7X+1+pjIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891986; c=relaxed/simple;
	bh=2SS114JJ8I7lddLw/w0o81SIFN+GdAvKMgR1hy0iqvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUBiirdzxcrJ+HYdKiX5sB9mpYOPslGKpP/6Ca8g1syhjxE1ok2Plyav7r1xSPPdKsvYgec6lV92Mx/Yhh58MswG5Aw8qTonxWIBn10d4WZaDLj3jfZxj1bfAFqfvmt7lnz0YSePTNQRrkqEIY2QhQsQ+wN314mqAKs2E5VdcPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdLq6oqU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdLq6oqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9D61F000FF;
	Tue, 13 Oct 2026 11:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791891985;
	bh=rDSYLFpnFALZhWG6XpRWOL3iQ6zlNSnUG4DQtkIXzmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MdLq6oqUjK478ii6GAK1jnrqhtrPYRvAO4kHw8AQgqRx7UiTZVPA3o/WmSP92TvZy
	 hZS8EUw5i06BH9l7UNIpt8Cd+fa1K8GkrN84hn/f6GP6zTeoyUHNq8/gp+WKYAhv04
	 cJFgnkQSEgW1oCJXknCUgI4n0iVPUV5d8QHnbnEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 7.2 022/281] ata: libata-scsi: do not lose CHECK CONDITION for failed ATAPI commands
Date: Tue, 13 Oct 2026 13:35:38 +0200
Message-ID: <20261013112855.588294762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hengyu Liang <hengyul@cs.unc.edu>

commit bc8ce2cea5f77c4bd1a5184705e300e83546c0c4 upstream.

Since commit 2e1d2e65e773 ("ata: libata-scsi: terminate deferred commands
on time out"), atapi_qc_complete() sets SAM_STAT_CHECK_CONDITION for a
failed command only if cmd->result is zero, so that the DID_TIME_OUT or
DID_REQUEUE host byte of a terminated command is preserved.

However, cmd->result can also be non-zero for a regular failed ATAPI
command completed through libata EH: ata_eh_analyze_tf() calls
ata_eh_decide_disposition(), that is, scsi_check_sense(), on the sense
data obtained with REQUEST SENSE, and scsi_check_sense() sets the SCSI
midlayer internal byte of the result for some sense codes, e.g.
SCSIML_STAT_TGT_FAILURE for ILLEGAL REQUEST with ASC 0x20 (INVALID
COMMAND OPERATION CODE) or 0x24 (INVALID FIELD IN CDB), or
SCSIML_STAT_MED_ERROR for MEDIUM ERROR with ASC 0x11 (UNRECOVERED READ
ERROR). For such commands, atapi_qc_complete() keeps the result as is and
the command completes with a GOOD status byte, even though it failed and
valid sense data is available.

As a result, passthrough users see these failed ATAPI commands as
successful. For example, with the emulated IDE CD-ROM drive of QEMU and
no medium loaded, a PLAY AUDIO MSF command issued with SG_IO completes
with status 0x00 (and no DRIVER_SENSE) instead of 0x02 (CHECK CONDITION)
with sense key ILLEGAL REQUEST, ASC/ASCQ 0x20/0x00, and the CDROM ioctls
CDROMPLAYTRKIND, CDROMSUBCHNL, CDROMPAUSE, CDROMRESUME, CDROMPLAYMSF and
CDROM_GET_MCN return 0 instead of -ENOMEDIUM or -EOPNOTSUPP.

Fix this by setting the status byte to SAM_STAT_CHECK_CONDITION whenever
the host byte is not set. Use set_status_byte() rather than overwriting
the whole result, so that the SCSI midlayer internal byte set by
scsi_check_sense() is preserved, as ata_scsi_qc_complete() already does
for ATA commands.

Fixes: 2e1d2e65e773 ("ata: libata-scsi: terminate deferred commands on time out")
Cc: stable@vger.kernel.org
Suggested-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260929164135.266708-1-hengyul@cs.unc.edu
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3026,10 +3026,15 @@ static void atapi_qc_complete(struct ata
 		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
 			qc->dev->sdev->locked = 0;
 
-		if (cmd->result)
-			ata_scsi_qc_done(qc, false, 0);
-		else
-			ata_scsi_qc_done(qc, true, SAM_STAT_CHECK_CONDITION);
+		/*
+		 * Report CHECK CONDITION unless the command was terminated
+		 * with a host byte set. Only set the status byte, so that the
+		 * SCSI midlayer internal byte, which scsi_check_sense() may
+		 * have set from the sense data, is preserved.
+		 */
+		if (get_host_byte(cmd) == DID_OK)
+			set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
+		ata_scsi_qc_done(qc, false, 0);
 		goto schedule_deferred;
 	}
 


