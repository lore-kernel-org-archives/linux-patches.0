Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8AF3F9280;
	Wed, 20 May 2026 18:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301574; cv=none; b=O3A8Msocjsfl8xnuDkXtnWYXrb0A8dX/CVuLr2OeZuV3/QJoSx3TGi5+7DlmJwQJEv0brsxpf9K8cBXI4DvnPzNLkWqv//0LSVmk7LeGL8VlFMEP6g4C5Ugommd/gvjwXDb1M+Jvara3ZQhMnHUrdfwXiCMlMw06Qe7Me41c0QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301574; c=relaxed/simple;
	bh=gQrgyyx41IEBQ+tjIv7b7P5F6Beg1RVLyKm2xuL1LOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAmMG9g6ToSkWpyLfU/Z/WwbLjJ2xnHRVv7Sx1mLvs2XDIktDSDBom7nDgfz1lCR0jZopqFztRrkNpRvz3jhW/bgNcJBVhYWbTWqGr9B8kiE7NUhehG2keA3hRVlXSewqc6NGMi2Uu7NuYbYhXTIfgWksznk6EcS6oGTMjRIdHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zRKjL1r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zRKjL1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E491F000E9;
	Wed, 20 May 2026 18:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301573;
	bh=NtVIoEo18iV9ifysk3f5a8XP7Y6h2doZWwAnewp6t/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1zRKjL1rNC7bxkCEvnmXDPzel3QEyeWXVjfs9rQefqhWGDSWHIaV3jJs4ohB5qr3A
	 t7WQe+Z/Jz0EYV187NYxh40EoPJcyu+5Ln+qh40L4cv1kUpPQpfsaNFJia7iwEoMQq
	 k07wOHgxElUFfU48vnIfGTcwtD8ZHBGBG1L2pfqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 604/666] iommu/amd: Put list_add/del(dev_data) back under the domain->lock
Date: Wed, 20 May 2026 18:23:35 +0200
Message-ID: <20260520162124.359505810@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 4a552f7890f0870f6d9fd4fbc6c05cea7bfd4503 ]

The list domain->dev_list is protected by the domain->lock spinlock.
Any iteration, addition or removal must be under the lock.

Move the list_del() up into the critical section. pdom_is_sva_capable(),
and destroy_gcr3_table() do not interact with the list element.

Wrap the list_add() in a lock, it would make more sense if this was under
the same critical section as adjusting the refcounts earlier, but that
requires more complications.

Fixes: d6b47dec3684 ("iommu/amd: Reduce domain lock scope in attach device path")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/1-v1-3b9edcf8067d+3975-amd_dev_list_locking_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 6f2ce142dff7a..65d61b9c7382c 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2292,6 +2292,7 @@ static int attach_device(struct device *dev,
 	struct iommu_dev_data *dev_data = dev_iommu_priv_get(dev);
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
 	struct pci_dev *pdev;
+	unsigned long flags;
 	int ret = 0;
 
 	mutex_lock(&dev_data->mutex);
@@ -2332,7 +2333,9 @@ static int attach_device(struct device *dev,
 
 	/* Update data structures */
 	dev_data->domain = domain;
+	spin_lock_irqsave(&domain->lock, flags);
 	list_add(&dev_data->list, &domain->dev_list);
+	spin_unlock_irqrestore(&domain->lock, flags);
 
 	/* Update device table */
 	dev_update_dte(dev_data, true);
@@ -2379,6 +2382,7 @@ static void detach_device(struct device *dev)
 	/* Flush IOTLB and wait for the flushes to finish */
 	spin_lock_irqsave(&domain->lock, flags);
 	amd_iommu_domain_flush_all(domain);
+	list_del(&dev_data->list);
 	spin_unlock_irqrestore(&domain->lock, flags);
 
 	/* Clear GCR3 table */
@@ -2387,7 +2391,6 @@ static void detach_device(struct device *dev)
 
 	/* Update data structures */
 	dev_data->domain = NULL;
-	list_del(&dev_data->list);
 
 	/* decrease reference counters - needs to happen after the flushes */
 	pdom_detach_iommu(iommu, domain);
-- 
2.53.0



