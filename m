Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4444518C914;
	Tue, 30 Jul 2024 17:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359285; cv=none; b=BzvV5YQKURadl6Xkrnd6y68ybPi6w/1kzUxLHwA8hZmtOGh0v8IkH4DgDRljBUgDtCs6j4r4ynn1x1lVXjc6bADhaxnZ8mron0VutHKMtSohY4ROgQn459r+eFhc48bKY7Nze1Z6bx8jgEDXT9O7xqCjlAsgC1wZvCks1/GR5b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359285; c=relaxed/simple;
	bh=lDW/eR9ymchpCx8KdiaqXGqz5dOJk1Jhrkzlay0PiVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgoCjGSj2zYAoR+VzKeqj7si6X/C794In+710AFz2DVebGXC8LADxDFnXCqGv1Jz2nfoDlvixZRMUijG3FevmKAPVEJQxLoVERWZOQ4xqAWGfGWW/zhpamw+lIEAPCcmMleBXaXtRsm6pnAqU1Ggs8dY5eJ/kWc5/TxMYMjHi4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEoGWovt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEoGWovt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4822C4AF0F;
	Tue, 30 Jul 2024 17:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359285;
	bh=lDW/eR9ymchpCx8KdiaqXGqz5dOJk1Jhrkzlay0PiVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEoGWovtBHD7JDhr3nt7PiTy7f+Es3BXo1a0NZgWhpn1dhPPBNI1fOl9yeoaBTtOP
	 zavriqPFyjRcbYkNcG4DGxbChDFJj9zHvJZIEnKPiezN1abIqrC0NOdJnXD984fJnn
	 G4Iz6frndQGJtaUKrF/T9YgwpjR+w4tBXOXwGzaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 458/568] scsi: lpfc: Allow DEVICE_RECOVERY mode after RSCN receipt if in PRLI_ISSUE state
Date: Tue, 30 Jul 2024 17:49:25 +0200
Message-ID: <20240730151657.920851707@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

commit 9609385dd91b26751019b22ca9bfa4bec7602ae1 upstream.

Certain vendor specific targets initially register with the fabric as an
initiator function first and then re-register as a target function
afterwards.

The timing of the target function re-registration can cause a race
condition such that the driver is stuck assuming the remote port as an
initiator function and never discovers the target's hosted LUNs.

Expand the nlp_state qualifier to also include NLP_STE_PRLI_ISSUE because
the state means that PRLI was issued but we have not quite reached
MAPPED_NODE state yet.  If we received an RSCN in the PRLI_ISSUE state,
then we should restart discovery again by going into DEVICE_RECOVERY.

Fixes: dded1dc31aa4 ("scsi: lpfc: Modify when a node should be put in device recovery mode during RSCN")
Cc: <stable@vger.kernel.org> # v6.6+
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240628172011.25921-3-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5782,7 +5782,7 @@ lpfc_setup_disc_node(struct lpfc_vport *
 				return NULL;
 
 			if (ndlp->nlp_state > NLP_STE_UNUSED_NODE &&
-			    ndlp->nlp_state < NLP_STE_PRLI_ISSUE) {
+			    ndlp->nlp_state <= NLP_STE_PRLI_ISSUE) {
 				lpfc_disc_state_machine(vport, ndlp, NULL,
 							NLP_EVT_DEVICE_RECOVERY);
 			}


