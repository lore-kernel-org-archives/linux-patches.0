Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92BE17BC4;
	Sat,  3 Feb 2024 04:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933595; cv=none; b=kNsVZkLSw4dukF6+/IfdZeVFNz663yixfCrc+IhQUgghUL2i//PvVeYpL8p40HpRHdEfHYAyoVBZmbzGO5Qq/Pm8b86uUgjI8KmSOmvif+EwnU3WOp2wALevsFH/+8qem1Ug+oJZOlDs+dIDcgf9X9iWdDuduHiofc2MMaNWs4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933595; c=relaxed/simple;
	bh=jFCTz9qqPYvSqujlr5z/Z+3OMnpedauA938lBVHkAhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxboBTPvoL6MDVuoTNuIHgYpRU+d3cIpeSJe7VJj2B/XLZ0lKZjZIzJ7yQEx4Jt3NcFINKsR4gTEiFuP+sKeLTn1nEuBhDKbeyflC1oSVhz0/D6yZvR5NqbkSLfK4WHCu0FzQA56/eMPvsP58VliePhu+ETxwjJ5YOa7J5Z/M/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qS+jCxLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qS+jCxLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B42C43390;
	Sat,  3 Feb 2024 04:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933595;
	bh=jFCTz9qqPYvSqujlr5z/Z+3OMnpedauA938lBVHkAhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qS+jCxLCL7Lnv8RL47h4aHQHzKdb9GdhRKBC5Hk8XSBFciaUEpgXvgi3C55Sh4hqX
	 izavzA164u4SxouCtaBDwmok7zXE3HD4WV8fofHcyWbF4bE8iNZJRwREZ3dUPdfVhl
	 m5NxpEJuxX/iMKRYoMovEmwxSFS8fezOHtLZMoAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/322] scsi: lpfc: Reinitialize an NPIVs VMID data structures after FDISC
Date: Fri,  2 Feb 2024 20:03:44 -0800
Message-ID: <20240203035403.255764406@linuxfoundation.org>
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

[ Upstream commit 8dc8eb89f4df74593ba4bf30c3d31a0fc6d3ea47 ]

After a follow up FDISC cmpl, an NPIV's VMID data structures are not
updated.

Fix by calling lpfc_reinit_vmid and copying the physical port's vmid_flag
to the NPIV's vmid_flag in the NPIV registration cmpl code path.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20231207224039.35466-3-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 54e47f268235..932d47951cf3 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11110,6 +11110,14 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	lpfc_nlp_put(ndlp);
 
 	mempool_free(pmb, phba->mbox_mem_pool);
+
+	/* reinitialize the VMID datastructure before returning.
+	 * this is specifically for vport
+	 */
+	if (lpfc_is_vmid_enabled(phba))
+		lpfc_reinit_vmid(vport);
+	vport->vmid_flag = vport->phba->pport->vmid_flag;
+
 	return;
 }
 
-- 
2.43.0



