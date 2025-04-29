Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6481917E3;
	Tue, 29 Apr 2025 17:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948423; cv=none; b=Ln3jAclVZPjJrw1EBfhCy2E0BSkJQnOTL5Nj10z3Ja71qkkHnqblmUzbJLSF/clcXxtQ7oHMmkF/9zGqe46oNd6+GmYnMssKvf8X36x2/R1bUzNG1FFMz9xEZCOLyJgCrHLk0zffU0cXtIfIRdopTicLBRj27mrM8R86CVx9rws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948423; c=relaxed/simple;
	bh=AgHMfWP45GJNCtASSFK1N/ZOTLBuD8jKcUIj2qDfhBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U625K9Vuay+eng7vr9lh+XCLSaAeJCJxgqrVkp6YkYEbbRKO0RmtcRXwaI4hs4Rmd8Q5GQk6qZRvSxOdRFwpT2DMMDXNH0TE1cZlR89nb/UTEeEnrZyqiA1w7zsApvLYZSVedQwa8jHuZuArjmj1fP2drxS+UstvbH/RKGi7kck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1N0kztw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1N0kztw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87658C4CEE3;
	Tue, 29 Apr 2025 17:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948422;
	bh=AgHMfWP45GJNCtASSFK1N/ZOTLBuD8jKcUIj2qDfhBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1N0kztwFazKdAzTvMkpNQfMDBGYH0oEtOiStW2PmcgIZwwsm2bDPVs+DEGO+Udvo
	 ynm4o2MCDar82H4+eYOfVWaIKBUX3w6SbrUbesamoBTSCy5ZMdSKFTGt259hRvwDGS
	 ntetT+nlPRUN4hfnCgJ1uhLlB3l1P2G4IsUXXrDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.12 269/280] iommu: Handle race with default domain setup
Date: Tue, 29 Apr 2025 18:43:30 +0200
Message-ID: <20250429161126.143962569@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Robin Murphy <robin.murphy@arm.com>

commit b46064a18810bad3aea089a79993ca5ea7a3d2b2 upstream.

It turns out that deferred default domain creation leaves a subtle
race window during iommu_device_register() wherein a client driver may
asynchronously probe in parallel and get as far as performing DMA API
operations with dma-direct, only to be switched to iommu-dma underfoot
once the default domain attachment finally happens, with obviously
disastrous consequences. Even the wonky of_iommu_configure() path is at
risk, since iommu_fwspec_init() will no longer defer client probe as the
instance ops are (necessarily) already registered, and the "replay"
iommu_probe_device() call can see dev->iommu_group already set and so
think there's nothing to do either.

Fortunately we already have the right tool in the right place in the
form of iommu_device_use_default_domain(), which just needs to ensure
that said default domain is actually ready to *be* used. Deferring the
client probe shouldn't have too much impact, given that this only
happens while the IOMMU driver is probing, and thus due to kick the
deferred probe list again once it finishes.

Reported-by: Charan Teja Kalla <quic_charante@quicinc.com>
Fixes: 98ac73f99bc4 ("iommu: Require a default_domain for all iommu drivers")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/e88b94c9b575034a2c98a48b3d383654cbda7902.1740753261.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3115,6 +3115,11 @@ int iommu_device_use_default_domain(stru
 		return 0;
 
 	mutex_lock(&group->mutex);
+	/* We may race against bus_iommu_probe() finalising groups here */
+	if (!group->default_domain) {
+		ret = -EPROBE_DEFER;
+		goto unlock_out;
+	}
 	if (group->owner_cnt) {
 		if (group->domain != group->default_domain || group->owner ||
 		    !xa_empty(&group->pasid_array)) {


