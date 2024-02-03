Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128C4171CE;
	Sat,  3 Feb 2024 04:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933545; cv=none; b=BWYc2nNgD0nUO2AZOH2A+spuROqvFqEy+uTyYQMSgsJt+izbWTS/By3tKOaQibNxiPPNMI15UgZAnvZbnOdez9+sgOfevRC81POmKunP4bXW5C0LT6TFTVK/aS7RVLi2dtpDBecJgAHrqQOL5EuQF/15ZDWcvnthSImzB6WTWlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933545; c=relaxed/simple;
	bh=cpyNM3V1ZXfcj6RivsgNtfC1MfMNISzLbVloIfjF660=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJA9O1HgFEB8yjfrbr48UgCJBj9x0D3epAcwDB9FhAdsFVivvkkQ77DLhrmAr9Ig6RDzLg3abojn3Vasu75ZUrN0U9QD38PhWFjYmxJTZxtHcBHgfyffHIesWkcapgFHU+JGAkl3yr+oL6xVRwse+7bnLzNMuT7Nh0x2PM6YWGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxTFcWKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxTFcWKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB18C43394;
	Sat,  3 Feb 2024 04:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933544;
	bh=cpyNM3V1ZXfcj6RivsgNtfC1MfMNISzLbVloIfjF660=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxTFcWKg1bAWSsATIv6vplxe+AUXSCjY8PeFD7yywb0++Pf5MY9zOJlJ/p/LxvCSy
	 AYjMpGs8sA6SxkIgQwG+F+NWCXBO82un2J3iR7noD6VTm+Hd/uTveqfjuBwXorvngL
	 mP2GBrdQzNWfxChXz1yVSMQzCEQAjIhMsYnJ128k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/322] scsi: libfc: Dont schedule abort twice
Date: Fri,  2 Feb 2024 20:03:09 -0800
Message-ID: <20240203035402.127857863@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit b57c4db5d23b9df0118a25e2441c9288edd73710 ]

The current FC error recovery is sending up to three REC (recovery) frames
in 10 second intervals, and as a final step sending an ABTS after 30
seconds for the command itself.  Unfortunately sending an ABTS is also the
action for the SCSI abort handler, and the default timeout for SCSI
commands is also 30 seconds. This causes two ABTS to be scheduled, with the
libfc one slightly earlier. The ABTS scheduled by SCSI EH then sees the
command to be already aborted, and will always return with a 'GOOD' status
irrespective on the actual result from the first ABTS.  This causes the
SCSI EH abort handler to always succeed, and SCSI EH never to be engaged.
Fix this by not issuing an ABTS when a SCSI command is present for the
exchange, but rather wait for the abort scheduled from SCSI EH.  And warn
if an abort is already scheduled to avoid similar errors in the future.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20231129165832.224100-2-hare@kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libfc/fc_fcp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 945adca5e72f..3f189cedf6db 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -265,6 +265,11 @@ static int fc_fcp_send_abort(struct fc_fcp_pkt *fsp)
 	if (!fsp->seq_ptr)
 		return -EINVAL;
 
+	if (fsp->state & FC_SRB_ABORT_PENDING) {
+		FC_FCP_DBG(fsp, "abort already pending\n");
+		return -EBUSY;
+	}
+
 	this_cpu_inc(fsp->lp->stats->FcpPktAborts);
 
 	fsp->state |= FC_SRB_ABORT_PENDING;
@@ -1690,11 +1695,12 @@ static void fc_fcp_recovery(struct fc_fcp_pkt *fsp, u8 code)
 	fsp->status_code = code;
 	fsp->cdb_status = 0;
 	fsp->io_status = 0;
-	/*
-	 * if this fails then we let the scsi command timer fire and
-	 * scsi-ml escalate.
-	 */
-	fc_fcp_send_abort(fsp);
+	if (!fsp->cmd)
+		/*
+		 * Only abort non-scsi commands; otherwise let the
+		 * scsi command timer fire and scsi-ml escalate.
+		 */
+		fc_fcp_send_abort(fsp);
 }
 
 /**
-- 
2.43.0



