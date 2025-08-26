Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528DF260586;
	Tue, 26 Aug 2025 14:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217950; cv=none; b=o75xMBTUf1TvraOKGUwRuF4B3ckV2lvVRBS9QxYyyaOPSQZ6OQcHg4HEOl2wwIKPCZ/lB+LoShXBQNoG9HmoM42f99VLFydI0latKJHCGhRhwT43768wsGb6f6DFArxinHsBZ566YeiRcAFlNCTXo67kLTvMMTo5CMPv/V31mYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217950; c=relaxed/simple;
	bh=OBSfZee4OMXqxhbVD4Hxz1QKf63KGwIzuKiPC2bbUKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=molLu7/2mVcPO8g+7aAtXg8eDywr2Szxyrxbikv2hu3ttimeBZSvsxT0+IgeGEOenjlzAX6mQexwQDL+KyljY7FyLPRp38AXyKcW+fT3NrIynOW8o9tzM3Q8ZevEx4x8cxsmQsA6t1tCvCcOtHpcIYECQJ0mdaE3T9OY50DzHVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8A1iSg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8A1iSg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA33C113CF;
	Tue, 26 Aug 2025 14:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217949;
	bh=OBSfZee4OMXqxhbVD4Hxz1QKf63KGwIzuKiPC2bbUKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8A1iSg3f2c0DxIZeqsZHfMoobXGTXqhfq3yVpxfyrpOzqbl46dtfEaHdwCYvIyDL
	 wDClB9BcVhVKnbM/3qHGiuJeVs996HWcydfVxvqThr2R9XQuZ4Z1I9Ubl9mOpP48gW
	 9Tx69JGritDQeX5axEB3VM15UiIkCHkdQsxq0e5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 305/523] scsi: lpfc: Check for hdwq null ptr when cleaning up lpfc_vport structure
Date: Tue, 26 Aug 2025 13:08:35 +0200
Message-ID: <20250826110931.979114620@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 212153483874..a35426409a6f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -469,6 +469,10 @@ lpfc_sli4_vport_delete_fcp_xri_aborted(struct lpfc_vport *vport)
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



