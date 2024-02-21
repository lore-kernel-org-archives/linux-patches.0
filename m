Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730866A8D6;
	Wed, 21 Feb 2024 14:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525285; cv=none; b=OxrzgVOMB5NYLqB+Jj5Nkc64tZYAxDcctX27t/c9RhOHoIGzhpRQvQnv+rikQkTtL0R4hj8LoN2UqUsJH6c6FTl0NtV0i7xTH9M82imwHGV2pGFSRvtkdjFzf1YnOSsnBbAvXc8a+3Z/feQ4G1cg6dWA5DERMx4WE5HCcBoTPpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525285; c=relaxed/simple;
	bh=LpsVml/HRqemTNjBn2Gpumxk1xSJ0F2l4mfpYglaPGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GlZoNA7DD43wmBId/m+bmi5wn5Sosd7qc2FjyKmnlFgprLNJD5vQlUxeLgTn9z7IaSN0V7mGGIi/axdEGjQR4+Z2aUXAr8+jLpb+gPx5FEC3WLMfnwk9vJRJAczUibBbEiBwpCepDL9OD6fRlTT/5BN1LczKYgpnOLPKD2cTpP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jfRRcHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jfRRcHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954BDC433F1;
	Wed, 21 Feb 2024 14:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525285;
	bh=LpsVml/HRqemTNjBn2Gpumxk1xSJ0F2l4mfpYglaPGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1jfRRcHr+xudHeNFwoCpTHlN2H6eKiev9czQZ88HnZMWlxtVi3n/8lT5G77mgdNIa
	 wPJb0G88prmdKF19C/6eoTi/OiDjuXXhBXVkdq/4aIEh/tUy4rllI7qf7ahS9UBLtC
	 X+5WOItBxWT6aBX4e5AybVYWk+77P8SNlVfISmlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/267] scsi: libfc: Dont schedule abort twice
Date: Wed, 21 Feb 2024 14:07:23 +0100
Message-ID: <20240221125943.141886096@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bf2cc9656e19..22e286f920f4 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -270,6 +270,11 @@ static int fc_fcp_send_abort(struct fc_fcp_pkt *fsp)
 	if (!fsp->seq_ptr)
 		return -EINVAL;
 
+	if (fsp->state & FC_SRB_ABORT_PENDING) {
+		FC_FCP_DBG(fsp, "abort already pending\n");
+		return -EBUSY;
+	}
+
 	per_cpu_ptr(fsp->lp->stats, get_cpu())->FcpPktAborts++;
 	put_cpu();
 
@@ -1698,11 +1703,12 @@ static void fc_fcp_recovery(struct fc_fcp_pkt *fsp, u8 code)
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



