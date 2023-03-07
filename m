Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00D6BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46683C433D2;
	Tue,  7 Mar 2023 17:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211819;
	bh=A+L2d0s5qEvlJy5SZd8aXbR52n2VR5daQ8naEPogjco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5DDUmGcgg6/wSBUDGih4KAoZoie9SNaIXsonhf/grkjGhb0j6T9kA/48D+xEKqFe
	 UwU/pz6N0y8ExwghZoH5CH0GXl1YFOVQxgXP/MwvZNyWqYZOKZ0hdQBJaQ95X3DD0E
	 YdkrYsnaqLlns0QT7aJmkMxTz8GA68IFvl3aVO6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.2 0987/1001] iommufd: Do not add the same hwpt to the ioas->hwpt_list twice
Date: Tue,  7 Mar 2023 18:02:39 +0100
Message-Id: <20230307170105.077566205@linuxfoundation.org>
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

commit b4ff830eca097df51af10a9be29e8cc817327919 upstream.

The hwpt is added to the hwpt_list only during its creation, it is never
added again. This hunk is some missed leftover from rework. Adding it
twice will corrupt the linked list in some cases.

It effects HWPT specific attachment, which is something the test suite
cannot cover until we can create a legitimate struct device with a
non-system iommu "driver" (ie we need the bus removed from the iommu code)

Cc: stable@vger.kernel.org
Fixes: e8d57210035b ("iommufd: Add kAPI toward external drivers for physical devices")
Link: https://lore.kernel.org/r/1-v1-4336b5cb2fe4+1d7-iommufd_hwpt_jgg@nvidia.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reported-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/device.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -346,10 +346,6 @@ int iommufd_device_attach(struct iommufd
 		rc = iommufd_device_do_attach(idev, hwpt);
 		if (rc)
 			goto out_put_pt_obj;
-
-		mutex_lock(&hwpt->ioas->mutex);
-		list_add_tail(&hwpt->hwpt_item, &hwpt->ioas->hwpt_list);
-		mutex_unlock(&hwpt->ioas->mutex);
 		break;
 	}
 	case IOMMUFD_OBJ_IOAS: {


