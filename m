Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FE927A929;
	Tue, 27 May 2025 17:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365705; cv=none; b=DB2KKWWhXj8raZYTh8Sj5By0i2R4ptc0xtUwcBzZV+B73ISKukgRtMnNilO1Tfvm+MNpgX9kzHOK1/1sBUz+Png8ALaKsED9tER3f8bSNosQHcP8Ib33+DuxmUUOHM6mE1rmsVJKIRL6wE0X7G7b/9a+dcIa7WQESbaT+9bXxOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365705; c=relaxed/simple;
	bh=kB2BD9viQz3nGOPgZYgfHrpBSGZrSrTtrNMaYjjInpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KL7V5rsHOHEgXtaHvBvfEDmjwzVwtak0FOO33JH+INDGRcEr8AIHKsohIl1lnw7uDMNHPVwS+bFfDJAabSKsq2FcZ+QrsPEj2t7+Gz+ZitlmNB1tE0xSl7VZ7g4xkgazDcmr+w6wuRa2LoodEzCNAqK8zrA8wb/lBJX1g/6YU1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXCt1qqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXCt1qqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2D0C4CEE9;
	Tue, 27 May 2025 17:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365705;
	bh=kB2BD9viQz3nGOPgZYgfHrpBSGZrSrTtrNMaYjjInpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXCt1qqIuICuQpF3TCSHwSY4EiYTppFCdVguwdHwZluDDBIOSAa9z6wJDom/4PMEo
	 t9SLXTgBpLjI++WxK0R9yh39PiHnwMv4rU/NDFYcy3r+Pq+OmZNiurYK5S0Bu1mdf5
	 mO99mU5ooNCtdss5Q8Jqwyo3Ni/5hfUcOQfxB0C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 462/626] scsi: lpfc: Handle duplicate D_IDs in ndlp search-by D_ID routine
Date: Tue, 27 May 2025 18:25:55 +0200
Message-ID: <20250527162503.774641311@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

[ Upstream commit 56c3d809b7b450379162d0b8a70bbe71ab8db706 ]

After a port swap between separate fabrics, there may be multiple nodes in
the vport's fc_nodes list with the same fabric well known address.
Duplication is temporary and eventually resolves itself after dev_loss_tmo
expires, but nameserver queries may still occur before dev_loss_tmo.  This
possibly results in returning stale fabric ndlp objects.  Fix by adding an
nlp_state check to ensure the ndlp search routine returns the correct newer
allocated ndlp fabric object.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250131000524.163662-5-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 6e8d8a96c54fb..31dcabebc9b6d 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5622,6 +5622,7 @@ static struct lpfc_nodelist *
 __lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
 {
 	struct lpfc_nodelist *ndlp;
+	struct lpfc_nodelist *np = NULL;
 	uint32_t data1;
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
@@ -5636,14 +5637,20 @@ __lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
 					 ndlp, ndlp->nlp_DID,
 					 ndlp->nlp_flag, data1, ndlp->nlp_rpi,
 					 ndlp->active_rrqs_xri_bitmap);
-			return ndlp;
+
+			/* Check for new or potentially stale node */
+			if (ndlp->nlp_state != NLP_STE_UNUSED_NODE)
+				return ndlp;
+			np = ndlp;
 		}
 	}
 
-	/* FIND node did <did> NOT FOUND */
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
-			 "0932 FIND node did x%x NOT FOUND.\n", did);
-	return NULL;
+	if (!np)
+		/* FIND node did <did> NOT FOUND */
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
+				 "0932 FIND node did x%x NOT FOUND.\n", did);
+
+	return np;
 }
 
 struct lpfc_nodelist *
-- 
2.39.5



