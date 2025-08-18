Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F261320CCE;
	Mon, 18 Aug 2025 13:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522411; cv=none; b=Amvm8ehpTlw4+LHnLiuAAwIk3ttOtP+RX6/B2iXxkD8SOrvjJIltztsLKKC3xh09nqajHmILPLp/7qbHHRK2IQgC9Py/9hbozzEh+AxiWOfc8uuDYjktJyaEyCQFEbI5wSaTEGaVrrjDtgkxgAF4kbsalAYss4pUC4Dp71OO8K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522411; c=relaxed/simple;
	bh=hoCH2UmPxT2qVpti29m3L8slEpXvSjmZYjwbZuS05tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9FOHBHDX++Cy+9bBlwQfYlLH3D9Q1D4u+CuAFpXcPvlsjSNFNDDhKCoPNN8Mi9HeUQx44Kio2YhZ0jRR2BzgW6wMXeJ8RTmQ3ywxl0RMOouClaygpGst76qC/YbidGUzYYjAQKsLw32RgOZEOjAvRUrNN6OtxDbjY5bAETQzW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGfBHlha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGfBHlha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870E8C4CEF1;
	Mon, 18 Aug 2025 13:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522410;
	bh=hoCH2UmPxT2qVpti29m3L8slEpXvSjmZYjwbZuS05tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGfBHlhal/QeVhCMjIRolHAJ7XWPJtr/kB5lrK2AsYTZZEpneOlyP33JcvoWkYTZM
	 5oL7vJQiDfW2CjlC/DmIHg2vydeBCAQLmrd5X0uL/+7/Sl61m1EqjUsN9S9Jg14Q8k
	 znzRfhJ1i6ShQHAQSi+qZqpQJnWM+qifEX98ImRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 308/444] scsi: lpfc: Check for hdwq null ptr when cleaning up lpfc_vport structure
Date: Mon, 18 Aug 2025 14:45:34 +0200
Message-ID: <20250818124500.499717546@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 6698796282e828733cde3329c887b4ae9e5545e9 ]

If a call to lpfc_sli4_read_rev() from lpfc_sli4_hba_setup() fails, the
resultant cleanup routine lpfc_sli4_vport_delete_fcp_xri_aborted() may
occur before sli4_hba.hdwqs are allocated.  This may result in a null
pointer dereference when attempting to take the abts_io_buf_list_lock for
the first hardware queue.  Fix by adding a null ptr check on
phba->sli4_hba.hdwq and early return because this situation means there
must have been an error during port initialization.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250618192138.124116-4-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 905026a4782c..67e089881181 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -390,6 +390,10 @@ lpfc_sli4_vport_delete_fcp_xri_aborted(struct lpfc_vport *vport)
 	if (!(vport->cfg_enable_fc4_type & LPFC_ENABLE_FCP))
 		return;
 
+	/* may be called before queues established if hba_setup fails */
+	if (!phba->sli4_hba.hdwq)
+		return;
+
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	for (idx = 0; idx < phba->cfg_hdw_queue; idx++) {
 		qp = &phba->sli4_hba.hdwq[idx];
-- 
2.39.5



