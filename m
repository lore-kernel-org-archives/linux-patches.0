Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D99746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322BDC433C7;
	Sun, 17 Sep 2023 20:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982435;
	bh=TcDiSoqZpwsRiS2vIxVPRAt97qzXpkEL3DM2+StGsXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APiEwXbxaf1krmBn8RGI3MfT5ASIg8jWAz6UxqMAGCs6ImlGboeniu5V++4G1K4g/
	 enPcBjSZZEos1u10IMFAthjkeqhNPbhbmU/CNgywBLchKcvooHYR9J1uhClzVk/I2/
	 CLap8WKF5CqoMCDeKnMRpyaYDGLMG8RVQzJ1nd3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 212/511] vfio/type1: fix cap_migration information leak
Date: Sun, 17 Sep 2023 21:10:39 +0200
Message-ID: <20230917191118.938552768@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Hajnoczi <stefanha@redhat.com>

[ Upstream commit cd24e2a60af633f157d7e59c0a6dba64f131c0b1 ]

Fix an information leak where an uninitialized hole in struct
vfio_iommu_type1_info_cap_migration on the stack is exposed to userspace.

The definition of struct vfio_iommu_type1_info_cap_migration contains a hole as
shown in this pahole(1) output:

  struct vfio_iommu_type1_info_cap_migration {
          struct vfio_info_cap_header header;              /*     0     8 */
          __u32                      flags;                /*     8     4 */

          /* XXX 4 bytes hole, try to pack */

          __u64                      pgsize_bitmap;        /*    16     8 */
          __u64                      max_dirty_bitmap_size; /*    24     8 */

          /* size: 32, cachelines: 1, members: 4 */
          /* sum members: 28, holes: 1, sum holes: 4 */
          /* last cacheline: 32 bytes */
  };

The cap_mig variable is filled in without initializing the hole:

  static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
                         struct vfio_info_cap *caps)
  {
      struct vfio_iommu_type1_info_cap_migration cap_mig;

      cap_mig.header.id = VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION;
      cap_mig.header.version = 1;

      cap_mig.flags = 0;
      /* support minimum pgsize */
      cap_mig.pgsize_bitmap = (size_t)1 << __ffs(iommu->pgsize_bitmap);
      cap_mig.max_dirty_bitmap_size = DIRTY_BITMAP_SIZE_MAX;

      return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
  }

The structure is then copied to a temporary location on the heap. At this point
it's already too late and ioctl(VFIO_IOMMU_GET_INFO) copies it to userspace
later:

  int vfio_info_add_capability(struct vfio_info_cap *caps,
                   struct vfio_info_cap_header *cap, size_t size)
  {
      struct vfio_info_cap_header *header;

      header = vfio_info_cap_add(caps, size, cap->id, cap->version);
      if (IS_ERR(header))
          return PTR_ERR(header);

      memcpy(header + 1, cap + 1, size - sizeof(*header));

      return 0;
  }

This issue was found by code inspection.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Fixes: ad721705d09c ("vfio iommu: Add migration capability to report supported features")
Link: https://lore.kernel.org/r/20230801155352.1391945-1-stefanha@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5623fc28b1ea8..66bbb125d7615 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2866,7 +2866,7 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
 static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
 					   struct vfio_info_cap *caps)
 {
-	struct vfio_iommu_type1_info_cap_migration cap_mig;
+	struct vfio_iommu_type1_info_cap_migration cap_mig = {};
 
 	cap_mig.header.id = VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION;
 	cap_mig.header.version = 1;
-- 
2.40.1



