Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9A92528EF;
	Tue, 20 May 2025 14:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750366; cv=none; b=fLlhYZXJbDmuHqbAPRc5Gtgr3E34l7iceD/rxzTVKwrwunTY5RpS9JD+ShFxkaB189gir04J9DVpZNaghua7zD+sqYriJnQfPdal43SmCPr9kwS0ffFTr8hTtSWbJrP5C9rFVCJAOpP9k9CWjhABn6rGV2IfO0kY90CqFo+GPO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750366; c=relaxed/simple;
	bh=/8c+T4HvE5O9erztxaRdYTAs+w9ubr4B3fnDQ9KVQEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMuN2usfnXxFk+jxft7Bw59PLU4pLzURXsirWMEHq9CD4fxFLAfTlCmMtDXCsz+oK+j4vd7DoMlAsXcjNxXJz3VBOEFEJRo9LHTJ5dJsd709SdcDFUnwBsP1ZLnpR0jfPuiJ3qhhFl755w056aOUONoG4IQt1JzHWBFxUg+4xuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZlXsaGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZlXsaGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1939DC4CEEB;
	Tue, 20 May 2025 14:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750365;
	bh=/8c+T4HvE5O9erztxaRdYTAs+w9ubr4B3fnDQ9KVQEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZlXsaGcdWvaJ5v4D5Zt3Cu+PubN9Oxy5bnswdOpnEohHAp1NwtEknFvY+GAXnogp
	 8pjp8JHaeE8o/ek1qwa9Bgxd8Me3hWOWA6m8PzNJENoiVwwbaKSdzWZlR9WzzxdLC7
	 PblSWT1pnL3y3nuXmwtvhYMkX13WMQVAoyEX3K3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 128/143] dmaengine: idxd: Refactor remove call with idxd_cleanup() helper
Date: Tue, 20 May 2025 15:51:23 +0200
Message-ID: <20250520125815.055212111@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit a409e919ca321cc0e28f8abf96fde299f0072a81 upstream.

The idxd_cleanup() helper cleans up perfmon, interrupts, internals and
so on. Refactor remove call with the idxd_cleanup() helper to avoid code
duplication. Note, this also fixes the missing put_device() for idxd
groups, enginces and wqs.

Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Cc: stable@vger.kernel.org
Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20250404120217.48772-10-xueshuai@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -905,7 +905,6 @@ static void idxd_shutdown(struct pci_dev
 static void idxd_remove(struct pci_dev *pdev)
 {
 	struct idxd_device *idxd = pci_get_drvdata(pdev);
-	struct idxd_irq_entry *irq_entry;
 
 	idxd_unregister_devices(idxd);
 	/*
@@ -918,21 +917,12 @@ static void idxd_remove(struct pci_dev *
 	get_device(idxd_confdev(idxd));
 	device_unregister(idxd_confdev(idxd));
 	idxd_shutdown(pdev);
-	if (device_pasid_enabled(idxd))
-		idxd_disable_system_pasid(idxd);
 	idxd_device_remove_debugfs(idxd);
-
-	irq_entry = idxd_get_ie(idxd, 0);
-	free_irq(irq_entry->vector, irq_entry);
-	pci_free_irq_vectors(pdev);
+	idxd_cleanup(idxd);
 	pci_iounmap(pdev, idxd->reg_base);
-	if (device_user_pasid_enabled(idxd))
-		idxd_disable_sva(pdev);
-	pci_disable_device(pdev);
-	destroy_workqueue(idxd->wq);
-	perfmon_pmu_remove(idxd);
 	put_device(idxd_confdev(idxd));
 	idxd_free(idxd);
+	pci_disable_device(pdev);
 }
 
 static struct pci_driver idxd_pci_driver = {


