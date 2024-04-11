Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C301F5FA;
	Thu, 11 Apr 2024 10:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830196; cv=none; b=TYIjhK9aBahJSkGP1jgvEeqKOzBEtWKMVl7WyrnJiMLCR1hlVNCfJumlxRzNDB9rr9l31j3BWdD3BHj0PRtBrh15oEwRdLGC6dhoHGrrLPQsB5JZ60JYxwGgrAyoLgmKKXG055Z37ZNMloTTlCCBGWvAmh9JKiFeo0e8cB8Qchg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830196; c=relaxed/simple;
	bh=NtGX7f0Cm+UTNX/pgWLaI/hGBWagYVhzStyJ8Hb4ScQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLCPyb+BYauFqrCbTtspTMasy+4B3fjkNiqnk+H5MIzBfPucNxxWQtRajYNEUZnvqM7WHm3rqk5vW5NumpU/iqeRGfID/4ZEcMDkDwGxzVcWbeTfRZUMi/Vb+B9jWVXyWLfIfKAKrSGEOsSih7nuX1HEJA/s0T2NOSN/Jf4Zpt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMpCu0D9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMpCu0D9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74CDC433F1;
	Thu, 11 Apr 2024 10:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830196;
	bh=NtGX7f0Cm+UTNX/pgWLaI/hGBWagYVhzStyJ8Hb4ScQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMpCu0D99SHA6Lg1gWTe2NatAi8tNpZyP6UmU64IUBPa+9dOUHkn0Yq7y7zKH+aO4
	 5NXx8bTJwxIsvs6GJj8lQukAWZPtHOjzWT2X8rl3HQan+n6dEeHfQ+qJcaIN1hS2bD
	 zQQYhGsk69icb+SnWff/keXgme2CKwMMtlMXDlQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 068/143] scsi: lpfc: Fix possible memory leak in lpfc_rcv_padisc()
Date: Thu, 11 Apr 2024 11:55:36 +0200
Message-ID: <20240411095422.961838597@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 2ae917d4bcab80ab304b774d492e2fcd6c52c06b ]

The call to lpfc_sli4_resume_rpi() in lpfc_rcv_padisc() may return an
unsuccessful status.  In such cases, the elsiocb is not issued, the
completion is not called, and thus the elsiocb resource is leaked.

Check return value after calling lpfc_sli4_resume_rpi() and conditionally
release the elsiocb resource.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240131185112.149731-3-justintee8345@gmail.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index d9074929fbab8..b147304b01fa1 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -748,8 +748,10 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				/* Save the ELS cmd */
 				elsiocb->drvrTimeout = cmd;
 
-				lpfc_sli4_resume_rpi(ndlp,
-					lpfc_mbx_cmpl_resume_rpi, elsiocb);
+				if (lpfc_sli4_resume_rpi(ndlp,
+						lpfc_mbx_cmpl_resume_rpi,
+						elsiocb))
+					kfree(elsiocb);
 				goto out;
 			}
 		}
-- 
2.43.0



