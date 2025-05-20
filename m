Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338C62F37;
	Tue, 20 May 2025 14:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749921; cv=none; b=czeoA0KckJNkzlo4aPYIKEXBZHWaPzP/JDa5fYC8lLtYw6klWNAZwLDtgBOJOH7iX9OreNEQsO8845mOlxsQ0tcS9ZxqiTGhrYIY+DnUioEToaTQDPR3I0FDbqwxxS76R4fII9fCDhbo04VGW1UJhcay5ygqhTrNfHJiJ1CqATk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749921; c=relaxed/simple;
	bh=Om0qtSjCkeBcorcpSADp/93V3yAegtQLGu43jMdfEfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuShbaAk8+TEjDG8H6vFdcmClz00nDzlBbM1JO+swMKNNtdMngxXIsWa8MNlo2xpsySnCYtLoiZnaPXlmO/eLXzFbT/f/hl8jGVGiZ+do2s5cEX0b1KINLaMnbjN5xC6furT5+l1WIxHaLt1z6js3ffLtpPGlbQ0Gy6C/8r5dJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9ieEBfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9ieEBfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B78C4CEEA;
	Tue, 20 May 2025 14:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749921;
	bh=Om0qtSjCkeBcorcpSADp/93V3yAegtQLGu43jMdfEfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9ieEBfDCLROTCrpjXP3QVF6L5mBELH2E73BzClg9aqnanPpkfiL7z1Pj5Od9Pku6
	 uXT4ZDYLe1VKVjTd4hGmNzQbT8K4nLg6CZDqusfy7w3+7wuC78eSCkymZNsOmtrxCp
	 JIUXKtTKnaNCTJ1CsuTUbQs1DKyqrBWUJ9iTsHZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 102/117] dmaengine: idxd: Refactor remove call with idxd_cleanup() helper
Date: Tue, 20 May 2025 15:51:07 +0200
Message-ID: <20250520125808.041497768@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -891,7 +891,6 @@ static void idxd_shutdown(struct pci_dev
 static void idxd_remove(struct pci_dev *pdev)
 {
 	struct idxd_device *idxd = pci_get_drvdata(pdev);
-	struct idxd_irq_entry *irq_entry;
 
 	idxd_unregister_devices(idxd);
 	/*
@@ -904,21 +903,12 @@ static void idxd_remove(struct pci_dev *
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


