Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840B93AE70
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FA3C433EF;
	Wed,  7 Jun 2023 20:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169916;
	bh=ec36qRJ+96QD5+UG1onfEI4gozfWtT/oTghPRPgB+vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cp9njp6pktRFNB6myPsRcG/BL0Que/2B6QcV4PMxrY3PQJ16CZFYganYuB+ffNgRS
	 SFzK42xcxzHYMkUfw8sY6NQgwi5SUQhw4Ki4ZywIcMEu6uZjS6DpqjymLOQLF3cZGz
	 yoHi1HhIUMmW8oc2kOn84Vx1XvWiFcVtslK77TwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Pan-Doh <pandoh@google.com>,
	Sudheer Dantuluri <dantuluris@google.com>,
	Gary Zibrat <gzibrat@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Nadav Amit <namit@vmware.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.3 233/286] iommu/amd: Fix domain flush size when syncing iotlb
Date: Wed,  7 Jun 2023 22:15:32 +0200
Message-ID: <20230607200930.908120514@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jon Pan-Doh <pandoh@google.com>

commit 2212fc2acf3f6ee690ea36506fb882a19d1bfcab upstream.

When running on an AMD vIOMMU, we observed multiple invalidations (of
decreasing power of 2 aligned sizes) when unmapping a single page.

Domain flush takes gather bounds (end-start) as size param. However,
gather->end is defined as the last inclusive address (start + size - 1).
This leads to an off by 1 error.

With this patch, verified that 1 invalidation occurs when unmapping a
single page.

Fixes: a270be1b3fdf ("iommu/amd: Use only natural aligned flushes in a VM")
Cc: stable@vger.kernel.org # >= 5.15
Signed-off-by: Jon Pan-Doh <pandoh@google.com>
Tested-by: Sudheer Dantuluri <dantuluris@google.com>
Suggested-by: Gary Zibrat <gzibrat@google.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Acked-by: Nadav Amit <namit@vmware.com>
Link: https://lore.kernel.org/r/20230426203256.237116-1-pandoh@google.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2387,7 +2387,7 @@ static void amd_iommu_iotlb_sync(struct
 	unsigned long flags;
 
 	spin_lock_irqsave(&dom->lock, flags);
-	domain_flush_pages(dom, gather->start, gather->end - gather->start, 1);
+	domain_flush_pages(dom, gather->start, gather->end - gather->start + 1, 1);
 	amd_iommu_domain_flush_complete(dom);
 	spin_unlock_irqrestore(&dom->lock, flags);
 }


