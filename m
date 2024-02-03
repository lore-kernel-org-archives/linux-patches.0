Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996FC10A09;
	Sat,  3 Feb 2024 04:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933576; cv=none; b=UFQV+JZITPg68x8OO2cAwllFIXFN8Y12rJyVjxOB/SH6F8eLosXH3grs8Dk2ooDLFQu0ihiMye1fQfREaCptjDAHLDVOyIabBdZp2LozBTaDj4W5MN4ccb1r3rlXE1t0wF8hdCNGz+AX3l8mDD6Z2MDjtNlRvL3UJt8yZqEd98s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933576; c=relaxed/simple;
	bh=v35n3UlDa1mDMfHJRYd4luEd1ISiUa1eNbsCXQcwuI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfyxryuSv64H3MG05v+kkWcXGRULO0rErTHaGX2yDUpdFsghKvjUvr0hR8R3J/MQ01VSYHrGe/XDxaDgisyDufq6QfEx2HOevTxVlb06UmKg+LHqcfL5UlN4j16/CXL+905j4FkAvy5ZkxecX7iSeo1LDegC/Wc42d3We8bXe9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uahwuDxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uahwuDxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D49FC43330;
	Sat,  3 Feb 2024 04:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933576;
	bh=v35n3UlDa1mDMfHJRYd4luEd1ISiUa1eNbsCXQcwuI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uahwuDxeuGykxk/AEhSanHzN3KtKOtrhhITPLuwSGyhJf1Usr9/XFHe2/XCclr8JV
	 gjg7W37JBpA2qmIfAdIcdqDqiwcjLTEUZGqsBQ3kTMZvYswgxPXLB/6PtnAegRxO1a
	 NQFMdAn8PDWbBOU+G5SfJRbi9g3ICLtc48MXtYA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/322] scsi: lpfc: Move determination of vmid_flag after VMID reinitialization completes
Date: Fri,  2 Feb 2024 20:03:45 -0800
Message-ID: <20240203035403.283374914@linuxfoundation.org>
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

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit aba0fb0ef607a71511d23a07406f11130c1a54c5 ]

If priority tagging is set in the service parameters of a FLOGI cmpl, then
we update the vmid_flag.  In the current logic, if a follow up FLOGI cmpl
updates its service parameters such that priority tagging is no longer set,
then the vmid_flag ends up keeping stale data.

Fix by ensuring we clear the vmid_flag member during lpfc_reinit_vmid, and
check the priority tagging service parameter after reinitialization of the
vmid data structures.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20231207224039.35466-4-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c  | 6 +++---
 drivers/scsi/lpfc/lpfc_vmid.c | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 932d47951cf3..18b8325fd419 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1119,12 +1119,12 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 vport->port_state, vport->fc_flag,
 			 sp->cmn.priority_tagging, kref_read(&ndlp->kref));
 
-	if (sp->cmn.priority_tagging)
-		vport->phba->pport->vmid_flag |= (LPFC_VMID_ISSUE_QFPA |
-						  LPFC_VMID_TYPE_PRIO);
 	/* reinitialize the VMID datastructure before returning */
 	if (lpfc_is_vmid_enabled(phba))
 		lpfc_reinit_vmid(vport);
+	if (sp->cmn.priority_tagging)
+		vport->phba->pport->vmid_flag |= (LPFC_VMID_ISSUE_QFPA |
+						  LPFC_VMID_TYPE_PRIO);
 
 	/*
 	 * Address a timing race with dev_loss.  If dev_loss is active on
diff --git a/drivers/scsi/lpfc/lpfc_vmid.c b/drivers/scsi/lpfc/lpfc_vmid.c
index cf8ba840d0ea..773e02ae20c3 100644
--- a/drivers/scsi/lpfc/lpfc_vmid.c
+++ b/drivers/scsi/lpfc/lpfc_vmid.c
@@ -321,5 +321,6 @@ lpfc_reinit_vmid(struct lpfc_vport *vport)
 	if (!hash_empty(vport->hash_table))
 		hash_for_each_safe(vport->hash_table, bucket, tmp, cur, hnode)
 			hash_del(&cur->hnode);
+	vport->vmid_flag = 0;
 	write_unlock(&vport->vmid_lock);
 }
-- 
2.43.0



