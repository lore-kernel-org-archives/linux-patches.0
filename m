Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB22715ADB4;
	Mon, 23 Jun 2025 22:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717389; cv=none; b=WbXpZ3sQJbbXOJ6dyjWPP4P4nKPX0S91an1VVAvEvy327h389CPi5zxEtNC4NlI11mwmRxAN7UsklPNW+W/UDuxUlGVya5B2URl5vfRQkREg0O8aXlbcF/JaXb7GtgqNzYAqjdKeM7iiPVr71Ctg0OiFB6fVZcEY3ciKRJLC3tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717389; c=relaxed/simple;
	bh=vMVyqZFm6bxusQa5hzK80BJs0TAKgZanO4d+4Rx4Dy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEvyq0Ar3ZdVHuhssKAS/vPV4udJpUr6lu7nWTXMSe6cblq4TKIR5eJ5qoDrhfrZNDDZbOnEjaoXF5fKagT5jBpyOwuQuritgM6aJlPxVO1cqART+5mUbdMJcEdBEK5lACohJkMA8FPXGaRD6JMqO2hd1DNvNevGDpnZ2rDtoCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRzRMcr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRzRMcr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2CBC4CEEA;
	Mon, 23 Jun 2025 22:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717389;
	bh=vMVyqZFm6bxusQa5hzK80BJs0TAKgZanO4d+4Rx4Dy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRzRMcr2s/NhWHqHCVsMkLNcZnvmipH7VGSCkmREYIW2xn+y2Rnb7h3Wxigp4ew7b
	 4122FG6jpT2GHDvFAru5jMREWm4tBiaMKfNTIrtz7u/7o084pfgONQgC78QRzRga8g
	 sL/CJFDMtsozZ1+dEXunPVrCJvveoiDagQi+z7to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 417/508] scsi: lpfc: Fix lpfc_check_sli_ndlp() handling for GEN_REQUEST64 commands
Date: Mon, 23 Jun 2025 15:07:42 +0200
Message-ID: <20250623130655.464414096@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b04112c77fcd1..3a55e410235c0 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5074,7 +5074,7 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
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



