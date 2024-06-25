Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3CA12EBEA;
	Tue, 25 Jun 2024 09:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308536; cv=none; b=MoWYENzK4c6hki0wVq+6+eeTjICoDb+qLe1XSZ4rJ2yoGduW7q6U6fxB29aapUkBQZn3qTac7wPLuUOu5D0EL1GYkMkMSS2KFj0FyiJutPjyVdmvr6L9lKJK1jR289COJIxMYv2i0ItMdFllVyXh4WZC0Ku2NKIde3BsW2caWac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308536; c=relaxed/simple;
	bh=NLSnwnjwSYHojO0vcvUhf3Ewm9OeUk2NU2ozmdD6/K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyPtj/lU8R6ub6V3RV/gWk/Jw/RLBd0aD5+LMsS5on2KrJVt3NX2Wgz9DfdBL/KHLzBV02+fOl/W5RPZkLW94riz0LedGtsXsnPvaB4/93Re3wxikvqkmbwf9VfIU4jXW3iXJunXL7cfRK92OjKWJ7gENr5rrh6d8Zn2jXBiDJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFF9yL07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFF9yL07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01C5C32781;
	Tue, 25 Jun 2024 09:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308536;
	bh=NLSnwnjwSYHojO0vcvUhf3Ewm9OeUk2NU2ozmdD6/K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFF9yL074+cqKYv+kBacs8dqoTyusjKWT63BlF4dc4+9VzCnUklZ6ciUwUtW7F+yj
	 jfP3hEmM6Hnb5ge7eT6N79DaHC+D2xNWsU3ELX6AsA0cFnD+hv6AItVQUsF4LsHUaV
	 iBtUsWw6LMqURjNlz/MTVD4odWAZ/6DAPdcnajOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 154/250] dmaengine: ioatdma: Fix error path in ioat3_dma_probe()
Date: Tue, 25 Jun 2024 11:31:52 +0200
Message-ID: <20240625085553.972979301@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Shubin <n.shubin@yadro.com>

[ Upstream commit f0dc9fda2e0ee9e01496c2f5aca3a831131fad79 ]

Make sure we are disabling interrupts and destroying DMA pool if
pcie_capability_read/write_word() call failed.

Fixes: 511deae0261c ("dmaengine: ioatdma: disable relaxed ordering for ioatdma")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240528-ioatdma-fixes-v2-2-a9f2fbe26ab1@yadro.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/init.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index e76e507ae898c..26964b7c8cf14 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -534,18 +534,6 @@ static int ioat_probe(struct ioatdma_device *ioat_dma)
 	return err;
 }
 
-static int ioat_register(struct ioatdma_device *ioat_dma)
-{
-	int err = dma_async_device_register(&ioat_dma->dma_dev);
-
-	if (err) {
-		ioat_disable_interrupts(ioat_dma);
-		dma_pool_destroy(ioat_dma->completion_pool);
-	}
-
-	return err;
-}
-
 static void ioat_dma_remove(struct ioatdma_device *ioat_dma)
 {
 	struct dma_device *dma = &ioat_dma->dma_dev;
@@ -1181,9 +1169,9 @@ static int ioat3_dma_probe(struct ioatdma_device *ioat_dma, int dca)
 		       ioat_chan->reg_base + IOAT_DCACTRL_OFFSET);
 	}
 
-	err = ioat_register(ioat_dma);
+	err = dma_async_device_register(&ioat_dma->dma_dev);
 	if (err)
-		return err;
+		goto err_disable_interrupts;
 
 	ioat_kobject_add(ioat_dma, &ioat_ktype);
 
@@ -1192,20 +1180,29 @@ static int ioat3_dma_probe(struct ioatdma_device *ioat_dma, int dca)
 
 	/* disable relaxed ordering */
 	err = pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &val16);
-	if (err)
-		return pcibios_err_to_errno(err);
+	if (err) {
+		err = pcibios_err_to_errno(err);
+		goto err_disable_interrupts;
+	}
 
 	/* clear relaxed ordering enable */
 	val16 &= ~PCI_EXP_DEVCTL_RELAX_EN;
 	err = pcie_capability_write_word(pdev, PCI_EXP_DEVCTL, val16);
-	if (err)
-		return pcibios_err_to_errno(err);
+	if (err) {
+		err = pcibios_err_to_errno(err);
+		goto err_disable_interrupts;
+	}
 
 	if (ioat_dma->cap & IOAT_CAP_DPS)
 		writeb(ioat_pending_level + 1,
 		       ioat_dma->reg_base + IOAT_PREFETCH_LIMIT_OFFSET);
 
 	return 0;
+
+err_disable_interrupts:
+	ioat_disable_interrupts(ioat_dma);
+	dma_pool_destroy(ioat_dma->completion_pool);
+	return err;
 }
 
 static void ioat_shutdown(struct pci_dev *pdev)
-- 
2.43.0



