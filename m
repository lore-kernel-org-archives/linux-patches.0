Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0EE3911A9;
	Sat, 17 Oct 2026 16:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254629; cv=none; b=b3j6O1oVwPmHpdE07Ha6qXrPmKT7CV3IevJ1+StX/kiwdlvvTqlfIS24JqBtz7lDkI1Sl+U2lAisr9+/hBeHkc1DcO7jnYXFK0Qi/l0vxKg3ygUHm7TUitxcFU4OhFzZlG1zKhbohtwbedeuwxGns7yIFrFu2FX34BSe5qhLJqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254629; c=relaxed/simple;
	bh=TE0/UFR/bEcraQaHg7C5YiQ4bgBdd766JoRgkPiA38U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtsSmj/Z9HgkzfAI2aRwyVSWMdd4j87qdAMVSJNid9Pu+CKHdxg+WzoyMlomG59nKcON7ZQjNYnBFy96rKLZ1Ubu2eGPW219TW085EPcLviE7H7IR8/QMakOjsNLS+3BBwyg5vqbArnfJgk+X2fZDNYKxWrCZS+lrBoNBWnCbUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1uPr/ZQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1uPr/ZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F2F1F000C4;
	Sat, 17 Oct 2026 16:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254628;
	bh=/ZFHgfURAn8W6ET6/iioBwiE6Hr71NOO/GkRRbKBw64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1uPr/ZQFohG9iGNyagXzvTZRDY1O5nYxcBSD24M3DcCoFkCVT4b+rBRFWE3MnYq7
	 hfzXBkFGY15rMfSV9hSRzIa3g8r8bVq4KBexgPgSzNdcw3BDNDUSZ/0/xV2oAjj4rP
	 Dun9xUYinv+HpDB3vypHBgaXraie8EcjXoaxlP80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 508/869] s390/ism: Fix UAF of sba and ieq during ism_dev_exit()
Date: Sat, 17 Oct 2026 17:55:49 +0200
Message-ID: <20261017160050.125397108@linuxfoundation.org>
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
 drivers/s390/net/ism_drv.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index f2264cf6f40d8..c728095fc5059 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -244,13 +244,16 @@ static int unregister_sba(struct ism_dev *ism)
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
@@ -264,13 +267,16 @@ static int unregister_ieq(struct ism_dev *ism)
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
 
 static int ism_read_local_gid(struct ism_dev *ism)
@@ -580,8 +586,10 @@ static int ism_dev_init(struct ism_dev *ism)
 
 unreg_ieq:
 	unregister_ieq(ism);
+	ism_free_ieq(ism);
 unreg_sba:
 	unregister_sba(ism);
+	ism_free_sba(ism);
 free_irq:
 	free_irq(pci_irq_vector(pdev, 0), ism);
 free_client_arr:
@@ -678,9 +686,13 @@ static void ism_dev_exit(struct ism_dev *ism)
 
 	if (ism_v2_capable)
 		ism_del_vlan_id(ism, ISM_RESERVED_VLANID);
+	/* ism will only generate new IRQs while ieq & sba are registered */
 	unregister_ieq(ism);
 	unregister_sba(ism);
+	/* drain ongoing irpt handlers */
 	free_irq(pci_irq_vector(pdev, 0), ism);
+	ism_free_ieq(ism);
+	ism_free_sba(ism);
 	kfree(ism->sba_client_arr);
 	pci_free_irq_vectors(pdev);
 	list_del_init(&ism->list);
-- 
2.53.0



