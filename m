Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA0910F2;
	Wed, 20 May 2026 18:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302226; cv=none; b=mncKcZ9oFyGqTFYbhwFL1xg5CCsfLa9mN1b+zjmoUnHtHn8jme74cSvKFMNkTzClGiD4EPZcKanBbUYazFdYC4nv9Tfmpd1RIICaS4dZOYSJzlp2r14LqQBlKWmolWUgy8U2Yi/LJfmwIxYt9sOo8MgLuyQ9kz4njPS1Corikxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302226; c=relaxed/simple;
	bh=q0YGmtna5xA92tAd5P1qRBl7zZ/lvO5Y1HUcaVRj+FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PO5BX4AIysz5Np0qishcstKHcbWUqzsA6/yGr5GAGgvz27+WhdXvIk0Qn0TIU3rtTTVzurRMhIFe/OKNSB4II01olO4Qv4GKMt1+6Th/xuqjTlzxlzCVbQDnS6/plFTZDqQgqoeZCq8yHmIV4zJCY+uvF+UlEoSOuKrKqCfASW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0PHEeGF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0PHEeGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711461F000E9;
	Wed, 20 May 2026 18:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302224;
	bh=vBxWOmwd70HYmGugln2ysTKGpnoioT8fCTeSHKVZ1aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0PHEeGFtiv6JFxUG6xhIalCBv3GeShcNGKso0+wQLjLZBGkTssWxcgB0S1THGLl0
	 yjg+7PpnsDO3hEMHTo8DSXhoyaWyaJ3OwcOODMP0TGFx7tFXtf+pfAF2cy8t1aTwvS
	 cKGcP9tUSH2vuWM/2yPj/GMf7hhnGN4pIJ8kG2VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/508] iommufd: vfio compatibility extension check for noiommu mode
Date: Wed, 20 May 2026 18:20:09 +0200
Message-ID: <20260520162102.667777611@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Pan <jacob.pan@linux.microsoft.com>

[ Upstream commit 7147ec874ea08c322d779d8eba28946e294ed1f3 ]

VFIO_CHECK_EXTENSION should return false for TYPE1_IOMMU variants when
in NO-IOMMU mode and IOMMUFD compat container is set. This change makes
the behavior match VFIO_CONTAINER in noiommu mode. It also prevents
userspace from incorrectly attempting to use TYPE1 IOMMU operations
in a no-iommu context.

Fixes: d624d6652a65 ("iommufd: vfio container FD ioctl compatibility")
Link: https://patch.msgid.link/r/20260213183636.3340-1-jacob.pan@linux.microsoft.com
Signed-off-by: Jacob Pan <jacob.pan@linux.microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/vfio_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
index 6c810bf80f99a..7351320394c85 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -283,7 +283,7 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
 	case VFIO_TYPE1_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
 	case VFIO_UNMAP_ALL:
-		return 1;
+		return !ictx->no_iommu_mode;
 
 	case VFIO_NOIOMMU_IOMMU:
 		return IS_ENABLED(CONFIG_VFIO_NOIOMMU);
-- 
2.53.0



