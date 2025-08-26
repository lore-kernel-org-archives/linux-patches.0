Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDF31DD9D3;
	Tue, 26 Aug 2025 12:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213169; cv=none; b=I6gDd8hgujQ/RvlOa2uj0M/+E5uDesH0J3B1Z5j6AhQpFWoZhr5aHCFKU254jxtERj2SU3jv+Y96Ilv945QPxTW32rSryxqyi70Qz+gDNUKuqx6cPWcHRgoxO2A/TW0du/ROJeatpVZz+UAEbNfy1oUo/DJIz0jc47YEeYAOdxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213169; c=relaxed/simple;
	bh=bS38em7zvpPwralGmmwG6T8aZmBnH+iZBSNTTCM6/KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7acr8enYrIye6DubCjl7AzOrcod8FBdF7y9IiBcGn1XiEivPzVx9sYofjz4fifowtxdos3HO/CHY7BTl6xXqjgaLizoYV2xSZJI6oubQ5JO5y+5ztYPh+j5qTUiURNdn1bYVwOaza0HB7GjzgCeYN7zn+mevLojLLnrtMCek1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvndfjFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvndfjFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691DFC4CEF1;
	Tue, 26 Aug 2025 12:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213168;
	bh=bS38em7zvpPwralGmmwG6T8aZmBnH+iZBSNTTCM6/KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvndfjFhPpgJC7nIHhfVwF8N16u0WSQZ4atqowWPpVgFvqdLUJ01BG9Y8eovxRBHw
	 XkmblwCFAJAyNAlaIpjlF1ifUXAdpZSjsQ544zH51p44NWaTBCVQcSEvh4MLhW9RZT
	 Wrbp3jvGChnv8wMy9ZqN/ZbqUZb+3vj/4GPNSdqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 246/587] scsi: lpfc: Check for hdwq null ptr when cleaning up lpfc_vport structure
Date: Tue, 26 Aug 2025 13:06:35 +0200
Message-ID: <20250826110959.188456385@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 070654cc9292..dcbb2432c978 100644
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



