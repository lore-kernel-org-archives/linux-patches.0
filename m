Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBD179FD;
	Thu, 11 Apr 2024 10:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832608; cv=none; b=Z5Fejjhcn1191uYfvWG7CywcuMPaRoPE/8s5vD/D27m+a/XwG55oC5PcLXwpZyLlEtlOeEkAwIDB7Bt17Yx97qRTtYv1DkMK/lNbqZBUC2xArzJPDzBVe8FHk92sBc1Ltz6yISlQVcA0D4c7JP5zmOeb5jCA3MVPyl9fVLHn3ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832608; c=relaxed/simple;
	bh=Bg+MovjjRqJ3tab3tyXMg7QHEC69MdV74NNNKQuCVuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvHLKlc46q6S1rrNNOLlbQYv9qN6GZtAQQMqQUDThZ2E1ACV0ee2xc7B+Eg877z4/6pA/CVQc5cRZxEJYvZV7K25KTfi6eusTNbO1z9hgY+riy082cH/YXZ2InkSe11a7dLQ9HISlvzde4gnsUsW8CCugFuAIOy7dLH9ej5Bk0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFyZ5xPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFyZ5xPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F57C433F1;
	Thu, 11 Apr 2024 10:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832607;
	bh=Bg+MovjjRqJ3tab3tyXMg7QHEC69MdV74NNNKQuCVuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFyZ5xPqhNRbDD+Gn0Fk66bbUf8ftema7UmW4xLX7QcMzVW0df7TL7oSpfdoEhfPz
	 v6jNyBNeh/V8H9CJgQtyeIKYMmWu4lAtgFfYmWtYN3RxU+f2giA3SCS8Hgw9Yrz0o4
	 pnAlNXTRytufnEJt6zheXAlW04BgZ/J64mvBWZFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 23/57] scsi: lpfc: Fix possible memory leak in lpfc_rcv_padisc()
Date: Thu, 11 Apr 2024 11:57:31 +0200
Message-ID: <20240411095408.697378358@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2bd35a7424c25..9b862f1254a42 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -724,8 +724,10 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
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



