Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248EE42A9B;
	Tue, 27 May 2025 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368132; cv=none; b=AvekAD2S2fmB8pgtZXKox24j7alsIZYMS8gPhIiQluhNt1XL3cKxAFQKGhHJm34q+T9bEbT7qQ9NY6OCe2OtxnjI1FFhAbS2HVQu+e4+eEMatdSgVQFIn/BZLRthxyO8MkOUDwH7Oea/VUBrI9Ry3RzXWzAr1PZxeZEQumN+3UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368132; c=relaxed/simple;
	bh=MfnjnACiNJtUBL7LSwL5j5Pbe3eKvRJ1teYBL4EGkhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6waWuHPEc035Ku9EHWbB2q6amq80MXst5hE1tn9doA4UCPFwtGNP3alryshhJEkj/gDPR7bIpvXBjRXUuyK2Y6ylHTxpJ4LogjQ7VOs7T+qAacyBMO+C+QZpRGVMk0x9c2kB4kROnqFRLuB1t0lwxeXl6H9Xkva5aXYQYNFWV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CM71Z6wv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CM71Z6wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465C3C4CEE9;
	Tue, 27 May 2025 17:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368131;
	bh=MfnjnACiNJtUBL7LSwL5j5Pbe3eKvRJ1teYBL4EGkhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CM71Z6wvfkmPG+Hyt9b0sAK/mmC2kyxzr1deVLmWTO8n1rPsszuZcnUavIHSWvTD0
	 hRWHi84EWU1tdqK8T/7JaR5yu6zNNdERlqWUlzQz8klBg+8dB+Dl5EnViEnbwZR0qC
	 077FPO4NZwW6HWJ/jAHF3FwOs1HfDqaPTOUcBCeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 578/783] scsi: lpfc: Ignore ndlp rport mismatch in dev_loss_tmo callbk
Date: Tue, 27 May 2025 18:26:15 +0200
Message-ID: <20250527162536.680744549@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 23ed62897746f49f195d819ce6edeb1db27d1b72 ]

With repeated port swaps between separate fabrics, there can be multiple
registrations for fabric well known address 0xfffffe.  This can cause ndlp
reference confusion due to the usage of a single ndlp ptr that stores the
rport object in fc_rport struct private storage during transport
registration.  Subsequent registrations update the ndlp->rport field with
the newer rport, so when transport layer triggers dev_loss_tmo for the
earlier registered rport the ndlp->rport private storage is referencing the
newer rport instead of the older rport in dev_loss_tmo callbk.

Because the older ndlp->rport object is already cleaned up elsewhere in
driver code during the time of fabric swap, check that the rport provided
in dev_loss_tmo callbk actually matches the rport stored in the LLDD's
ndlp->rport field.  Otherwise, skip dev_loss_tmo work on a stale rport.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250131000524.163662-4-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 45d268d49060e..07cd611f34bd5 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -228,10 +228,16 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
 		return;
 
-	/* check for recovered fabric node */
-	if (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
-	    ndlp->nlp_DID == Fabric_DID)
+	/* Ignore callback for a mismatched (stale) rport */
+	if (ndlp->rport != rport) {
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_NODE,
+			      "6788 fc rport mismatch: d_id x%06x ndlp x%px "
+			      "fc rport x%px node rport x%px state x%x "
+			      "refcnt %u\n",
+			      ndlp->nlp_DID, ndlp, rport, ndlp->rport,
+			      ndlp->nlp_state, kref_read(&ndlp->kref));
 		return;
+	}
 
 	if (rport->port_name != wwn_to_u64(ndlp->nlp_portname.u.wwn))
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-- 
2.39.5



