Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CD31D435F;
	Mon, 17 Aug 2026 13:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974164; cv=none; b=X4bkE2k+lH7EbPW0dp/X3JtuRhU6MerbjeTc+Khhrn1ywWDyML40C6RkQsNeaW3hCaOM22rLlrxJWdioIUJQPv8vLkCVYaUsxN3mbOYVDoHybEG4tidI99Hpz9pii/gC07mHPh9qrUyT4t9owWqGIdqgarCWObbUmOCxYrH5PIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974164; c=relaxed/simple;
	bh=9L1hacZM6pb02/tpgy0g22lxiokZJragOlPvM5pco58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAmfFc+3oevdYpVgoc4jculTG2J6H0DezGXCGMlZtkJTa/BkzllBdJAcl6aGqpDuYVQRvqceF4T7+qTxgXCAMz/f+MYw8Go5lWjAmBL9Vy1XCffimYlmsWb4N9A+FDmfwsfD4Qw0pvPL8+RXhwgn8KukAWL9NfPKAjX9Ykx9dgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQgDkTTz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQgDkTTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1E91F000E9;
	Mon, 17 Aug 2026 13:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974163;
	bh=pBnX9fMyKSl+APDE7EvRWVkqm5wE5L4FKqk6Q1E+ML0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQgDkTTzfGkKObhHDTdz/OCTGe6kcS0nyBpFDrybk2NaitGHD7j6R2MnjFToTGOIL
	 wf1ZqoIxrPo+TOkOvBrq3cre2fezqdHKvxKx4NR9alZdYvQcuM08GrwLyAD4mNPR2e
	 nk7UXLnt4L0dqRjP2L9ZyurpuiZlRIkeVDofsLCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 110/271] s390/ism: Fix UAF of sba and ieq during ism_dev_exit()
Date: Mon, 17 Aug 2026 15:30:35 +0200
Message-ID: <20260817132541.397970851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7d0479e4e0956..369aa21b1ff7c 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -148,13 +148,16 @@ static int unregister_sba(struct ism_dev *ism)
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
@@ -168,13 +171,16 @@ static int unregister_ieq(struct ism_dev *ism)
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
@@ -573,6 +579,7 @@ static int ism_dev_init(struct ism_dev *ism)
 
 unreg_sba:
 	unregister_sba(ism);
+	ism_free_sba(ism);
 free_irq:
 	free_irq(pci_irq_vector(pdev, 0), ism);
 free_vectors:
@@ -585,9 +592,13 @@ static void ism_dev_exit(struct ism_dev *ism)
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



