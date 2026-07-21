Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6DE449B0B;
	Tue, 21 Jul 2026 15:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649417; cv=none; b=DrUge5tgY+VsrXvLdmdBpv8jv/S4Gk8d+NiBj+Oss1dyiaNPCZHdgtDcnuGBMQPytVLAi3zE5dYqjSNUu9NBfr6nJt3XlCCIRQ6/x+jn2BtD/FwNY28MtAN2bGtkbTTS1CCyJ6BmLFmsf64WTsED/Vk46bdc+Gccf2GkEMEg1WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649417; c=relaxed/simple;
	bh=jxHxajqhDWDzP/Eb6Msmz+eLmGhmgitU723C1BmcYNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUbxzaXWjEow7Rs5nVbmLubH+XdrX/bDuML2mgEJmH3iyeq/Np02c0qbkYusVSnPXmz/k2vPvkyfZaoXw+Vh0QcYGDAL60Aql5T6zd6BbjFdK36F2EU8XVLNNRLEP+SvTA90SPkwJ3m5lkDtf0kqp/LpcSgAY5aiNLcwXTdtcaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sInJowGB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sInJowGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B646F1F00A3A;
	Tue, 21 Jul 2026 15:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649416;
	bh=QtWhOBAWwueJpdiJRTAAYaGytR4AIc7bZqBymugCOFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sInJowGBkZTkc6z9qXKwdKcOGFkx3QOK3noY0TPohwyrgp7cCI1rp9JIp50xZbo0H
	 I6MpD62bB7kWXxi17wtRRNrIAmmPUBobiiPaequJE6OcqLm6bZpeXdE2O9Hs3hmtVo
	 UrrxC4/JZyI2NseW2bfbhue7BoJMMUFoMTYkkNys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0570/2077] iommufd: Destroy the pages content after detaching from dmabuf
Date: Tue, 21 Jul 2026 17:04:03 +0200
Message-ID: <20260721152606.253068391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit f2d70dbd3dcefa8e3c380beff9c31f5f033a4221 ]

Sashiko points out this has gotten out of order, the mutex could still be
in use through the dmabuf invalidation callbacks. Don't destroy any of the
pages content until the dmabuf is fully detached.

Fixes: 71db84a092c3 ("iommufd: Add DMABUF to iopt_pages")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/pages.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 7b64002e54b9a2..03c8379bbc347e 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1656,10 +1656,6 @@ void iopt_release_pages(struct kref *kref)
 	WARN_ON(!RB_EMPTY_ROOT(&pages->domains_itree.rb_root));
 	WARN_ON(pages->npinned);
 	WARN_ON(!xa_empty(&pages->pinned_pfns));
-	mmdrop(pages->source_mm);
-	mutex_destroy(&pages->mutex);
-	put_task_struct(pages->source_task);
-	free_uid(pages->source_user);
 	if (iopt_is_dmabuf(pages) && pages->dmabuf.attach) {
 		struct dma_buf *dmabuf = pages->dmabuf.attach->dmabuf;
 
@@ -1672,6 +1668,10 @@ void iopt_release_pages(struct kref *kref)
 	} else if (pages->type == IOPT_ADDRESS_FILE) {
 		fput(pages->file);
 	}
+	mmdrop(pages->source_mm);
+	mutex_destroy(&pages->mutex);
+	put_task_struct(pages->source_task);
+	free_uid(pages->source_user);
 	kfree(pages);
 }
 
-- 
2.53.0



