Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59E1BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B19EC433EF;
	Tue,  7 Mar 2023 17:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211816;
	bh=keH2jQv69hRTq6n45bANhD2TgPHB6HNnodc9IvO/bds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhAGRIY1pGaA0OvI8OQ56sX4SpfKaSZYguuA8WTd1n64A7DaYgy5/+vHSFbu+7jWv
	 ofdX2MJboVIx91twl50YUFJgukIj5qFed9ycVEorJX1IPCSgfg/LJPDgvmxGMlO54u
	 bpvIlTWHSo6j60vdLPehnlcgVvOueZblqSoXbMhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	syzbot+cb1e0978f6bf46b83a58@syzkaller.appspotmail.com,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.2 0986/1001] iommufd: Make sure to zero vfio_iommu_type1_info before copying to user
Date: Tue,  7 Mar 2023 18:02:38 +0100
Message-Id: <20230307170105.028544697@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Gunthorpe <jgg@nvidia.com>

commit b3551ead616318ea155558cdbe7e91495b8d9b33 upstream.

Missed a zero initialization here. Most of the struct is filled with
a copy_from_user(), however minsz for that copy is smaller than the
actual struct by 8 bytes, thus we don't fill the padding.

Cc: stable@vger.kernel.org # 6.1+
Fixes: d624d6652a65 ("iommufd: vfio container FD ioctl compatibility")
Link: https://lore.kernel.org/r/0-v1-a74499ece799+1a-iommufd_get_info_leak_jgg@nvidia.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reported-by: syzbot+cb1e0978f6bf46b83a58@syzkaller.appspotmail.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/vfio_compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -381,7 +381,7 @@ static int iommufd_vfio_iommu_get_info(s
 	};
 	size_t minsz = offsetofend(struct vfio_iommu_type1_info, iova_pgsizes);
 	struct vfio_info_cap_header __user *last_cap = NULL;
-	struct vfio_iommu_type1_info info;
+	struct vfio_iommu_type1_info info = {};
 	struct iommufd_ioas *ioas;
 	size_t total_cap_size;
 	int rc;


