Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5402B3BFAC8;
	Sat, 17 Oct 2026 17:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259391; cv=none; b=uXx8sGg4q/78pPFVxhRgMkTXWrtwqh8FxddsvPRfiNUjOXCUrVBF8CN+pbu0ag/SU/pTfnMye8Sf26qZKGm2Pnis3PPsZypv7qyMzF1tNIxlhP9XExRxcZmkf0jD00W2q1xty4LXskyP9bNzChqjz6Ji/OQBeIf7gw5SNQG8xOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259391; c=relaxed/simple;
	bh=a+Y3OuZ6GwyJJoaanpxdOdGc21EapP1DkGX6cK+e63U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Famqa/bSrf/gyr+2x/IBl02Q//Z398QVLCLQ2dGhNSJveg+jM1qHMYPsukP8DH51NrlOm6yieTBIhKMzPbq0SbjnNzN8YvKWMT/8NIhuQOpGB1v0lcz0nZMG3oOqkGMJfsZl1YdmK1JNC2gpEJtfx6mYsk8x9MF1NPUu0ZL0OTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2EpQTax; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2EpQTax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9711F000C4;
	Sat, 17 Oct 2026 17:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259390;
	bh=zM7XgSZfKdeNrg/0sXGQPS/GpkedWZlDdxDzMsUh0tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2EpQTaxFR4v8tzCg7gUJ16Gkk/5e919J2yE8uDWI5XtMm8Pq6C2P/WXJGXMrq/G4
	 lc0+saLODNFI3wlAMsDaZF2hqowlc3oS6xX7OcyqJqOrxW5F4lNudflkdYxmHd4Zx+
	 b7H+y8EPJf2kCAq1NpshKWYz+ARRmxm3FHM0DjBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1199/1674] s390/ism: Fix UAF of sba and ieq during ism_dev_exit()
Date: Sat, 17 Oct 2026 17:57:51 +0200
Message-ID: <20261017160501.915038475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 950f45ff8217b..183b2f274ebdd 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -243,13 +243,16 @@ static int unregister_sba(struct ism_dev *ism)
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
@@ -263,13 +266,16 @@ static int unregister_ieq(struct ism_dev *ism)
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
@@ -603,8 +609,10 @@ static int ism_dev_init(struct ism_dev *ism)
 
 unreg_ieq:
 	unregister_ieq(ism);
+	ism_free_ieq(ism);
 unreg_sba:
 	unregister_sba(ism);
+	ism_free_sba(ism);
 free_irq:
 	free_irq(pci_irq_vector(pdev, 0), ism);
 free_client_arr:
@@ -702,9 +710,13 @@ static void ism_dev_exit(struct ism_dev *ism)
 	if (SYSTEM_EID.serial_number[0] != '0' ||
 	    SYSTEM_EID.type[0] != '0')
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



