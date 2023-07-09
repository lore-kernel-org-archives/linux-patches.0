Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED83522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B02C433C7;
	Sun,  9 Jul 2023 11:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902083;
	bh=rJbJ5dbHadLA+e0Lyeh8vKhF6hT2DijOWtDDSrMQy6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSzsWNRStAv8Ij5Jlryo2fEy/QrjJdjBwxCVhecf/Dy8nCBFvaQjn549DHgH+9m0j
	 ZyNE/JNAJaeKeiFVrOWEIB31g/LEG7DGzpCvvi1CgGQfUWVfkv4XmlpGi8Llb6BMV6
	 0wzFFjCrfZ+u2H7Bpo6sEMg+g9q9/P6+tJu3uIbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 211/431] iommu/virtio: Return size mapped for a detached domain
Date: Sun,  9 Jul 2023 13:12:39 +0200
Message-ID: <20230709111456.113892342@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit 7061b6af34686e7e2364b7240cfb061293218f2d ]

When map() is called on a detached domain, the domain does not exist in
the device so we do not send a MAP request, but we do update the
internal mapping tree, to be replayed on the next attach. Since this
constitutes a successful iommu_map() call, return *mapped in this case
too.

Fixes: 7e62edd7a33a ("iommu/virtio: Add map/unmap_pages() callbacks implementation")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20230515113946.1017624-3-jean-philippe@linaro.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/virtio-iommu.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index fd316a37d7562..3551ed057774e 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -833,25 +833,26 @@ static int viommu_map_pages(struct iommu_domain *domain, unsigned long iova,
 	if (ret)
 		return ret;
 
-	map = (struct virtio_iommu_req_map) {
-		.head.type	= VIRTIO_IOMMU_T_MAP,
-		.domain		= cpu_to_le32(vdomain->id),
-		.virt_start	= cpu_to_le64(iova),
-		.phys_start	= cpu_to_le64(paddr),
-		.virt_end	= cpu_to_le64(end),
-		.flags		= cpu_to_le32(flags),
-	};
-
-	if (!vdomain->nr_endpoints)
-		return 0;
+	if (vdomain->nr_endpoints) {
+		map = (struct virtio_iommu_req_map) {
+			.head.type	= VIRTIO_IOMMU_T_MAP,
+			.domain		= cpu_to_le32(vdomain->id),
+			.virt_start	= cpu_to_le64(iova),
+			.phys_start	= cpu_to_le64(paddr),
+			.virt_end	= cpu_to_le64(end),
+			.flags		= cpu_to_le32(flags),
+		};
 
-	ret = viommu_send_req_sync(vdomain->viommu, &map, sizeof(map));
-	if (ret)
-		viommu_del_mappings(vdomain, iova, end);
-	else if (mapped)
+		ret = viommu_send_req_sync(vdomain->viommu, &map, sizeof(map));
+		if (ret) {
+			viommu_del_mappings(vdomain, iova, end);
+			return ret;
+		}
+	}
+	if (mapped)
 		*mapped = size;
 
-	return ret;
+	return 0;
 }
 
 static size_t viommu_unmap_pages(struct iommu_domain *domain, unsigned long iova,
-- 
2.39.2



