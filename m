Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50029314B8F;
	Sat, 17 Oct 2026 17:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257686; cv=none; b=VSNfKnm5xrUNYfi4qNFH6KybqgS1nzsK4vkYi33V44kKJQfAw27fQAkSX5WxYXvbHi/fhxct9974Bw0OU+ua8bPOvkGCbqKOtnmJ4rrVYfLvQ6BoPgyafRU/RAeafkO8MA27DWgn2mzu238ffYvs8hx+WvXR20xJsYBdY2xFAFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257686; c=relaxed/simple;
	bh=ygA21o0fkfWgmfgzWL7omZGfzjNbsmGn63iKiMeHubs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBZp2JXPgVy/fS6QhbAQPzaUfR0IcJEHARLCEJ6Co97SPwRNJWOuUsRfELZDiRbDV3TFSZHSNUgEKqlglDHndjiZQjK/i7ccKHs8tFLYN75dqlMclhQloY4uoaAc2dBd2CD7K3HaKlUofRbGHPTgrAReQ7TvTRREdkmAa1Nn2Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1aY/9tK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1aY/9tK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526851F000C4;
	Sat, 17 Oct 2026 17:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257684;
	bh=JOXr9g53gPrHkMuR0sRn9PhxJ7QsNvBzJpoDZH8w6OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y1aY/9tKB3480b1tx9ldSHzgKyEtyVPLZe8lw3DFPMUbTnRhmeXWlSFII8L8fufm2
	 yW2modwyXhXsyBgOzxyJgSbTiZLMIrRmJAC+0CNQFZMZGJzR1kGYEEkt1Q87RAQ9s0
	 UPSUzLmGQ6nt7kTjrTesaZ/s5w+QFqL2+J05z8Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0638/1674] scsi: lpfc: Fix failure to delete vports when discovery is in progress
Date: Sat, 17 Oct 2026 17:48:30 +0200
Message-ID: <20261017160447.473810585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 7bb6cb7bb21c01cda4425efc935eb8f187832eb6 ]

Requests to delete an NPIV port may fail repeatedly if the initial request
is received during discovery.

If the FC_UNLOADING load_flag is set, then skip CT response processing for
the physical port.  This allows discovery processing for other lpfc_vport
objects to reach their cmpl routines before deleting the vport.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240131185112.149731-8-justintee8345@gmail.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: ede596b1434b ("scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_ct.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 1775115239860..3f5d8c1a9913a 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -943,8 +943,8 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 	}
 
-	/* Don't bother processing response if vport is being torn down. */
-	if (vport->load_flag & FC_UNLOADING) {
+	/* Skip processing response on pport if unloading */
+	if (vport == phba->pport && vport->load_flag & FC_UNLOADING) {
 		if (vport->fc_flag & FC_RSCN_MODE)
 			lpfc_els_flush_rscn(vport);
 		goto out;
@@ -1166,8 +1166,8 @@ lpfc_cmpl_ct_cmd_gid_pt(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 	}
 
-	/* Don't bother processing response if vport is being torn down. */
-	if (vport->load_flag & FC_UNLOADING) {
+	/* Skip processing response on pport if unloading */
+	if (vport == phba->pport && vport->load_flag & FC_UNLOADING) {
 		if (vport->fc_flag & FC_RSCN_MODE)
 			lpfc_els_flush_rscn(vport);
 		goto out;
-- 
2.53.0



