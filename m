Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BBE2D9EFF;
	Mon, 17 Aug 2026 13:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974934; cv=none; b=p9EGs/RtHh4NpiLI+ICFTZQXFeJZilw6nhX94perN3XyQqakjsBOqgV4Yiv/+V8XvGC7CQmPc6O4r2t5thC7DVQ4hfP7bUIOPbFsJ3C0wCSZ0CpBCk4KmtmWEanYUSgBEDEksF3b0W1VTATV8JP0efDG36hcEBbpHgO0YTMuflI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974934; c=relaxed/simple;
	bh=kzTPB7dQZHvz3A22hIYHySyxltIfXLe2QCigaPPcnC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWBGHTaZSbCRsu+3iJMj3A5ZS9v0mLUivvkQi6DRaC7HaByf9AwSOJ/qOVE90yh9dzwFw0ptYf2gIkhbZliijYUU9O/8GoEC9Zy8Ywg6tMY9nnBUAaYhxk9JDM5bTumTPjNDT9beREZa+HPJuKqbd/k3/E/Aom8dfCrik2oHleU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xy5xPj5/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xy5xPj5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BC01F00A3D;
	Mon, 17 Aug 2026 13:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974923;
	bh=AeeDJ8jN2u7Uig8+x6SwL9c3qQoxAo5+PDVBBFk1eu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xy5xPj5/U2SGDG1vG2CV6jU7M2xuAfDwiOcUvhGMF7Lk/WA90Xsn2QR/4LS0R5vVz
	 HAA815ytwM7ubcfVEbOEOpy+Wf0gEt3f8LUSpb5L98TE1mkpjLHAzOt+FEg6fvHJk9
	 7zoB/pnPgcI1Zzr4TD/fPJKdeFWFGq1VlI/y7BHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 100/250] s390/ism: Fix UAF of sba and ieq during ism_dev_exit()
Date: Mon, 17 Aug 2026 15:31:01 +0200
Message-ID: <20260817132540.611851133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit b1896543ce59c4258625a35cf41e23a9a1f80ea2 ]

A ism interrupt handler can be active in parallel with ism_dev_exit(),
accessing freed data structures.

No new interrupts will be generated after unregister_ieq(). Drain ongoing
interrupt handlers by free_irq(), before freeing ism data structures.

Fixes: 684b89bc39ce ("s390/ism: add device driver for internal shared memory")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Link: https://patch.msgid.link/20260805131043.954639-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index f84aa2e676e9b..b842410cf41cc 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -149,13 +149,16 @@ static int unregister_sba(struct ism_dev *ism)
 	if (ret && ret != ISM_ERROR)
 		return -EIO;
 
+	return 0;
+}
+
+static void ism_free_sba(struct ism_dev *ism)
+{
 	dma_free_coherent(&ism->pdev->dev, PAGE_SIZE,
 			  ism->sba, ism->sba_dma_addr);
 
 	ism->sba = NULL;
 	ism->sba_dma_addr = 0;
-
-	return 0;
 }
 
 static int unregister_ieq(struct ism_dev *ism)
@@ -169,13 +172,16 @@ static int unregister_ieq(struct ism_dev *ism)
 	if (ret && ret != ISM_ERROR)
 		return -EIO;
 
+	return 0;
+}
+
+static void ism_free_ieq(struct ism_dev *ism)
+{
 	dma_free_coherent(&ism->pdev->dev, PAGE_SIZE,
 			  ism->ieq, ism->ieq_dma_addr);
 
 	ism->ieq = NULL;
 	ism->ieq_dma_addr = 0;
-
-	return 0;
 }
 
 static int ism_read_local_gid(struct dibs_dev *dibs)
@@ -574,6 +580,7 @@ static int ism_dev_init(struct ism_dev *ism)
 
 unreg_sba:
 	unregister_sba(ism);
+	ism_free_sba(ism);
 free_irq:
 	free_irq(pci_irq_vector(pdev, 0), ism);
 free_vectors:
@@ -586,9 +593,13 @@ static void ism_dev_exit(struct ism_dev *ism)
 {
 	struct pci_dev *pdev = ism->pdev;
 
+	/* ism will only generate new IRQs while ieq & sba are registered */
 	unregister_ieq(ism);
 	unregister_sba(ism);
+	/* drain ongoing irpt handlers */
 	free_irq(pci_irq_vector(pdev, 0), ism);
+	ism_free_ieq(ism);
+	ism_free_sba(ism);
 	pci_free_irq_vectors(pdev);
 }
 
-- 
2.53.0



