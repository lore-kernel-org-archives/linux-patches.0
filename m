Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210C52C0276;
	Tue, 16 Dec 2025 11:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885999; cv=none; b=hFpdVXUBRsi7w9uzNd6M8abYqf06+cvInCsLTBsgXusMmvSS0aMeiOgnTCXY/KET4WpyRGaQLGAXlARCyluhpy6+uDeYIgr2FmDbNNs2VCO3t3fCrEqi937bwRE2TttF+t+atQsNeli1QO25fqqp0GJBheU6+HpSc89hTKjfYqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885999; c=relaxed/simple;
	bh=4i0a4G56vDwpIFPztPhUrJo0eLqlwnrOwiTbFq12NbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awDief1e3ozk87lTxS0GXOaLzbGsIsxlUjsxxPBVnmkiJv1xZH8Qj2+O9bk0R7iUYsI8sIvf8lk4jPb5EzLMn/IKhjTMF8rsdWHsa2v6jUIOezasrDHxrPh63AtP0noGOlwefMB9SSp4286XP+Xxx5jJxSqB3Sb7NQXidV9GwOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+DLH1Y3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+DLH1Y3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A148C4CEF5;
	Tue, 16 Dec 2025 11:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885998;
	bh=4i0a4G56vDwpIFPztPhUrJo0eLqlwnrOwiTbFq12NbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+DLH1Y3dZxQQ17S5EdBaci+HWNByO9EXCgvmH9W494lIOfW9i8uDYuEMJcr4B8Ht
	 LeoECvAmVm9XDOncwc7nlKAwwA1bttpRjSfa1LP3GM1ltY9ExyrpFoAdTLIIXL7/tl
	 x7szr5sEBFy0tySAtfnTT3HWw2mk7dFKtfWTwe7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Himanshu Madhani <hmadhani2024@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 280/507] scsi: qla2xxx: Fix improper freeing of purex item
Date: Tue, 16 Dec 2025 12:12:01 +0100
Message-ID: <20251216111355.625212092@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 78b1a242fe612a755f2158fd206ee6bb577d18ca ]

In qla2xxx_process_purls_iocb(), an item is allocated via
qla27xx_copy_multiple_pkt(), which internally calls
qla24xx_alloc_purex_item().

The qla24xx_alloc_purex_item() function may return a pre-allocated item
from a per-adapter pool for small allocations, instead of dynamically
allocating memory with kzalloc().

An error handling path in qla2xxx_process_purls_iocb() incorrectly uses
kfree() to release the item. If the item was from the pre-allocated
pool, calling kfree() on it is a bug that can lead to memory corruption.

Fix this by using the correct deallocation function,
qla24xx_free_purex_item(), which properly handles both dynamically
allocated and pre-allocated items.

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
Link: https://patch.msgid.link/20251113151246.762510-1-zilin@seu.edu.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 316594aa40cc5..42eb65a62f1f3 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -1292,7 +1292,7 @@ void qla2xxx_process_purls_iocb(void **pkt, struct rsp_que **rsp)
 		a.reason = FCNVME_RJT_RC_LOGIC;
 		a.explanation = FCNVME_RJT_EXP_NONE;
 		xmt_reject = true;
-		kfree(item);
+		qla24xx_free_purex_item(item);
 		goto out;
 	}
 
-- 
2.51.0



