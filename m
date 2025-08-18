Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5D330F52C;
	Mon, 18 Aug 2025 13:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524204; cv=none; b=LplFlsIE6xbNTGCtwSXfRlbM0RvX8lmQ4T+kv5+GOJ4mzajpR/ibKC+763Gq6OUajamKEl8/27Osd8/wJ4zD9KCz2j6FzbBc3Wl1Wj6VUqQlGm/ePur0yw3ZA+7/0eLfw1NWxFbGj68jXgS8s0CAz6hafwIhnza5kXVWJo1FfA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524204; c=relaxed/simple;
	bh=IYRGJkyYPJ4rTkja+EmISAK+IInL/EMjh7B6qVirJPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJXjToTmgkIi0jDkar4Wqh1yVYhWltYaEjkDPj6YJWtbNp2PGVY45wAvkY+Y+Ymxbe5ja/tocpP/mWFRI/Inhy/T4K1wC6SZiZKh7wN7iL0X8qPqRoXIP9JSjrKpf5ohYLokUD+QpcCowNbeF170rugqoY0DN9TZhMHpgurXCAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5RcpXjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5RcpXjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB25C4CEF1;
	Mon, 18 Aug 2025 13:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524204;
	bh=IYRGJkyYPJ4rTkja+EmISAK+IInL/EMjh7B6qVirJPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5RcpXjXkUrPIDMg5rBWAPYYkquqnVlGilfP9FkWzpC6qgh2yxYcGi+NTFKVMxwy0
	 l3D/IP4+fgsyEt0rDFueOZUBS2N+bJK0tnGkD64Fq3YXkkWXiutcBjFPlTAKq5Un3M
	 GilbOr5Rp00RhL6+wk+45V1dXxchQF58gqxzQ8qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 367/515] scsi: lpfc: Check for hdwq null ptr when cleaning up lpfc_vport structure
Date: Mon, 18 Aug 2025 14:45:53 +0200
Message-ID: <20250818124512.537061471@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9edf80b14b1a..8862343aae55 100644
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



