Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67DC63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBB4C433EF;
	Mon, 20 Feb 2023 13:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901022;
	bh=oHgcWu/dOATSK/GoxVWdu8Flaf2aB6BR8awNd7JS4XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBlgfWuyqhM1XkUTFYki+tSxOyGkL/h1cqovbglQE2vR94xJSefmQ2yQhyvVfkiin
	 oscbtllIrnNbjdK2iI6ZxBpfN20Uqsekh4p1IoBYQIPzsepzfmyCtquldAFidMCCg1
	 slB+TCNn4qvXKMHOKUo8u36yAX3UhbEdQpMyQI1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qian Cai <cai@lca.pw>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 156/156] iommu/amd: Pass gfp flags to iommu_map_page() in amd_iommu_map()
Date: Mon, 20 Feb 2023 14:36:40 +0100
Message-Id: <20230220133609.183427426@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joerg Roedel <jroedel@suse.de>

commit 3057fb9377eb5e73386dd0d8804bf72bdd23e391 upstream.

A recent commit added a gfp parameter to amd_iommu_map() to make it
callable from atomic context, but forgot to pass it down to
iommu_map_page() and left GFP_KERNEL there. This caused
sleep-while-atomic warnings and needs to be fixed.

Reported-by: Qian Cai <cai@lca.pw>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 781ca2de89ba ("iommu: Add gfp parameter to iommu_ops::map")
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3114,7 +3114,7 @@ static int amd_iommu_map(struct iommu_do
 		prot |= IOMMU_PROT_IW;
 
 	mutex_lock(&domain->api_lock);
-	ret = iommu_map_page(domain, iova, paddr, page_size, prot, GFP_KERNEL);
+	ret = iommu_map_page(domain, iova, paddr, page_size, prot, gfp);
 	mutex_unlock(&domain->api_lock);
 
 	domain_flush_np_cache(domain, iova, page_size);


