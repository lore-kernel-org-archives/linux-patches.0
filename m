Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF09647A87D;
	Fri,  7 Aug 2026 15:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117414; cv=none; b=kuPMxGZyCJww4ONPnEl+d8esswtPX7bzBxUGBsYvdOgoPUPBe6ooC2MugWWvdwVT/bMMO8rpIlpGljC2PJtbuJ3NugpAAXI19SZtHpyoXl2K1Qv/9ed0EN6YFHOeLW0vfD5e7OeoNzc8NQY23bBWWbAr8RWr4b6UvEDGWsHRfu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117414; c=relaxed/simple;
	bh=rEz1skUYHT20E2/RdzDQR9eSoVcvACmPY5KNSF2NP0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdtEaPftvNCVwVk/LM60dUezdzRlPRoaJi1ExgmCGHr4LRzqao2yFI6VchBkIk0jlrw3ld/2eR8lpWdw4zwl7sp4w3WFCx9Q3vmm8i3dGK16uHodCNIg6WanVAjPfPyQplaHtrRy3sgACb+RRqp1cKBfxeeuI2/uW6DS2f/hQf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZeVbF42k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeVbF42k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F7A1F000E9;
	Fri,  7 Aug 2026 15:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117412;
	bh=C/l5phdYZTDJrQwgfracEt/DgpCSAG5IwRnXVgix3dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZeVbF42kyZrFKYU+h4altojoeCzAlhkCcPiPwVqPfzU6muLIYcPc0cvYmVkvHatnV
	 xG2LgKAWe7ete/hfw1n2bjmqBD4w+qetnXTsmm2dKg+zC7emfIAZn0wPbA8V6JaO/F
	 Jl09/s5+STT0qH2N2vd0Lp5rc/y8p671M1TFDXI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 7.1 266/438] ata: libata-scsi: schedule deferred atapi command
Date: Fri,  7 Aug 2026 16:37:42 +0200
Message-ID: <20260807143433.661174380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit e7468b3f9b404ac7c1329ef07c146c3356dfbd01 upstream.

Modify atapi_qc_complete() to call ata_scsi_schedule_deferred_qc() to
ensure that any deferred queued command can execute. This is similar to
ata_scsi_qc_complete() function for regular ATA devices.

Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2991,6 +2991,7 @@ static void atapi_fixup_inquiry(struct s
 
 static void atapi_qc_complete(struct ata_queued_cmd *qc)
 {
+	struct ata_link *link = qc->dev->link;
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	unsigned int err_mask = qc->err_mask;
 
@@ -3020,12 +3021,12 @@ static void atapi_qc_complete(struct ata
 			ata_scsi_qc_done(qc, false, 0);
 		else
 			ata_scsi_qc_done(qc, true, SAM_STAT_CHECK_CONDITION);
-		return;
+		goto schedule_deferred;
 	}
 
 	if (cmd->result) {
 		ata_scsi_qc_done(qc, false, 0);
-		return;
+		goto schedule_deferred;
 	}
 
 	/* successful completion path */
@@ -3033,6 +3034,9 @@ static void atapi_qc_complete(struct ata
 		atapi_fixup_inquiry(cmd);
 
 	ata_scsi_qc_done(qc, true, SAM_STAT_GOOD);
+
+schedule_deferred:
+	ata_scsi_schedule_deferred_qc(link);
 }
 /**
  *	atapi_xlat - Initialize PACKET taskfile


