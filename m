Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6076F3A5E97;
	Sat, 17 Oct 2026 16:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253198; cv=none; b=fI+QSIcy4tsCEQtW0zSXMyFnAH0jaYc2WSqQv0V8VLuyoJVqLIUDWoo3XU3QHCOscV16zUnGQ5MAy4fdtzdbgJtjAbP1i+N/dycTOr1mqCG6+CvFrIaOdwFEOkCJ+3/fYccs7FPQf2EcX6PYw3wghFNCEA6+c8WsfaVMAR109to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253198; c=relaxed/simple;
	bh=7+ho9AcqoFZafyfUrnw4F4i/FpA3FjMHPrxID91k650=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYaMkALGI5L3UfzRjOkpzZAdKk7BUNLREAkTAkWWu2f06NTd97NGSLxX3/QatKNCVsQol99uriCjwBXX6PZaeyi6Yj1fla23ZzlzoWgo71bkL36Y/m5Q1UGJVJydIZBuqPPyJ9WQIBZj70JZ0d9jZor/nbXl9Wmhs3oWhBSYNkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwE33QUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwE33QUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD9E1F000C4;
	Sat, 17 Oct 2026 16:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253195;
	bh=mOQTWaulKDYekQx1MFNFWyjLBS+4zGrDLMbGXwUQbDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iwE33QUgbyKRHYIwpn1TgKMILiq2G6zwkN0Q90K3V51rtDk4d99q3Xsc2ARYnxp4R
	 Bd9P+XMEiRSkJ+TBy4/SGbFylMo92VFT4O8uLDMBPTybfNOdjjDYQFeBN0DwVpD0Ya
	 ntHXH3ufNO6lkBWq8xoMbpBGuif8CVk3LQK3N/0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/869] scsi: ufs: core: Add debug log for MCQ command timeout
Date: Sat, 17 Oct 2026 17:48:01 +0200
Message-ID: <20261017160038.042832398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 3abe4113e784b4a1135fe0e89828afecbfebf862 ]

It is difficult to debug situations where an MCQ command timeout occurs,
the corresponding CQ tag response is received, but the request is not
completed.  Add a one-line log to indicate when the CQ entry is abnormal.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260210070837.1820710-3-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 375f3a5691dd ("scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 7ce9aba6bd7d9..d4129ceaede6c 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -310,6 +310,8 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
 		ufshcd_compl_one_cqe(hba, tag, cqe);
 		/* After processed the cqe, mark it empty (invalid) entry */
 		cqe->command_desc_base_addr = 0;
+	} else {
+		dev_err(hba->dev, "Abnormal CQ entry!\n");
 	}
 }
 
-- 
2.53.0



