Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93663350843;
	Mon, 18 Aug 2025 14:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525896; cv=none; b=hHJRQmnWtbwm7lGQN+eRhPTFtseVSOX/91tfTGMHtPSzcuXM7tnFENIdRwZ034ab77vVFmWp223eF2sLJzAnuV6nsuRmwHDRSi9DY0OC8pEVgeGXBZZ1nw3nVreThQELEj6T7/CJhs0tBbxFM2jtH+bfzpUaGClgtsSvKmADghk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525896; c=relaxed/simple;
	bh=/+sdwEyU7ldpVmhBRiHeRy/BoMTFQ+OSP41rX2prXBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ts4MDxjQ0AbtgX54nPmypLgSaLS3YXcjuNKUuzSbqxdM4RtL/w1jURSpvFSUrixruNx2+cOPDNUJ8cupMKOnfSjpLlJ8yMSN10MTY9XU6d6tmfnz2WvYZ/qYbNcyY8TnG8t90+Nyd1KVDNsHxr3iaFJxNe5HDGdCbsQ00rj3OFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2rh7RwE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2rh7RwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191F2C4CEEB;
	Mon, 18 Aug 2025 14:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525896;
	bh=/+sdwEyU7ldpVmhBRiHeRy/BoMTFQ+OSP41rX2prXBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2rh7RwEF4fSkZ3Wj3o30pDaDYL2bIAYedWv3Nd8PMgSN+2zJFRqjgNBJQuf2Lscs
	 U47e9fXjDVUrp4VC+pzn/q6G0hi4oDptzDAoh4hh66EfR8rGgys/gNFeQN7jxc15ab
	 tbFvCmdH2VxFPZ3YQfdF95JoGU3k90ER6zBF3p9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 398/570] scsi: lpfc: Check for hdwq null ptr when cleaning up lpfc_vport structure
Date: Mon, 18 Aug 2025 14:46:25 +0200
Message-ID: <20250818124521.189461115@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 8acb744febcd..31a9f142bcb9 100644
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



