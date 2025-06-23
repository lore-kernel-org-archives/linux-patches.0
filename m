Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670F94315A;
	Mon, 23 Jun 2025 21:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714914; cv=none; b=A7X26nZBTqoZXuqOd2zjP71PMX3N+EwsAHY+qq/TXfFVYgPEMApcd1ATPJISryC8avbc9hJth9I16MfFSPgPkBZZpNKwY58Y3AD3eTfA6c8USfDuMC9ebJA2jcB+97ZPSZSBjbNE89fyq5OoafXCPD2pX29E3JCydxwqOyzuFKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714914; c=relaxed/simple;
	bh=OiprrUeHyJiDiG/jn4Uan4iV9cvUASgPJuofiqtgfrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQjiBSbqORBdcbpzroYp+SJ2ZDfzj4Fc/5F+fLwJUaRKUbEay6E/IOdKxmCTpRg1SAKu11DLswWF9JfW6RFpRo7ddsTJ+8V56F5fnpD2Qhl9ch+g1WTmGc0JrhECxMNmnqhjSoGRm2CY9qyPV7IX2F5A9OqvBnFqk72bNuxkeW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRiyd7HF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRiyd7HF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92F8C4CEEA;
	Mon, 23 Jun 2025 21:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714914;
	bh=OiprrUeHyJiDiG/jn4Uan4iV9cvUASgPJuofiqtgfrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRiyd7HFrlHUV7HFrBOgX01WQnofTGwey8tv/LZ56hg4aH4uXgQaPtTXoRNX5dMqY
	 GyHVnWfRCpoAFpt/+4PZ07BWX8wQnEAebbJo80+9Q6LXng3enAjnTXmP6QHsvOmlgY
	 3L5qqNLnlLRmPEnOOYuF3ippHZIGqFKvERxQ4bDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/290] scsi: lpfc: Fix lpfc_check_sli_ndlp() handling for GEN_REQUEST64 commands
Date: Mon, 23 Jun 2025 15:07:09 +0200
Message-ID: <20250623130631.946920295@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

[ Upstream commit 05ae6c9c7315d844fbc15afe393f5ba5e5771126 ]

In lpfc_check_sli_ndlp(), the get_job_els_rsp64_did remote_id assignment
does not apply for GEN_REQUEST64 commands as it only has meaning for a
ELS_REQUEST64 command.  So, if (iocb->ndlp == ndlp) is false, we could
erroneously return the wrong value.  Fix by replacing the fallthrough
statement with a break statement before the remote_id check.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250425194806.3585-2-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 5c9bc8af3c2df..ff44283338771 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5101,7 +5101,7 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 		case CMD_GEN_REQUEST64_CR:
 			if (iocb->ndlp == ndlp)
 				return 1;
-			fallthrough;
+			break;
 		case CMD_ELS_REQUEST64_CR:
 			if (remote_id == ndlp->nlp_DID)
 				return 1;
-- 
2.39.5



