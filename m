Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C191F34BA24;
	Fri,  7 Aug 2026 15:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115109; cv=none; b=GhDdqCEfHypXriOALhBgesbyMDLVQbFI5F8kxkOuG4SYdBJOZkBskUDDPGwkHsudQWO1RdnrOduQBr/sBjsLUO2EF0VvMnU6068vPxpYGtSPuTGJhtUlm0pUU/8aw+eRvQLtvNqnTrBCf500iTSaRt6VoH/K4PGVsbpIXZEUGK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115109; c=relaxed/simple;
	bh=RIFJPSoukY42Vl+cD1sPirtWuliL2wYUeyxlOvpkk4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gu1TSgaEhw0UGkuCYPRUzLrQGP31VuvhP/ERWtzxSQBNGo8etjhte/bYfm5oG7gsGDXwoVVd00VvTWnVJg3vTwaZI7c5tu4fcH0NcYjWL59/OU0CJf0msOrrA3qeo2AHYSPsLQUTPyfCPPfgMd7Y6YRPTMOBG5dx+acu4//DdRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZqdzqdE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZqdzqdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2931C1F000E9;
	Fri,  7 Aug 2026 15:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115107;
	bh=9vopuAyBPu/Eb8jZKOjoUCoKl1QtWAIRxENsN/eeunA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZqdzqdEj5DVnrSE/4VPLEQzYJcAKwiu0Jy1QycS4cCCcs9iSO84G1R4f5npBZPO6
	 rZxk5zlj8nvLRHk2ZPhOSvuTs9M/OshanS7grR4scrOv1jRnDBD58tQ0C4h1oDjPXW
	 /9QwQGd5pXT238tUJxF3qqQsMr3zjkoG0NkG+Ilc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 160/396] iommufd/viommu: Release the igroup lock on the vdevice_size error path
Date: Fri,  7 Aug 2026 16:35:20 +0200
Message-ID: <20260807143427.758217926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 339bd11591593ab7ce88136ab7fd01ef3813b724 upstream.

iommufd_vdevice_alloc_ioctl() takes idev->igroup->lock, then validates the
driver's vdevice_size against the core structure size with a WARN_ON_ONCE.
On failure that guard jumps to out_put_idev, below out_unlock_igroup, so it
skips the mutex_unlock(), leaving the igroup lock held and deadlocking the
next vDEVICE operation on that group.

Jump to out_unlock_igroup instead.

Fixes: ed42eee797ff3 ("iommufd/viommu: Add driver-defined vDEVICE support")
Link: https://patch.msgid.link/r/e903f775d491296a525097e2a90b3eb6a47cf2ef.1783311134.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/viommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index 4081deda9b33..0c12c7e352a1 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -189,7 +189,7 @@ int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		if (WARN_ON_ONCE(viommu->ops->vdevice_size < vdev_size ||
 				 !viommu->ops->vdevice_init)) {
 			rc = -EOPNOTSUPP;
-			goto out_put_idev;
+			goto out_unlock_igroup;
 		}
 		vdev_size = viommu->ops->vdevice_size;
 	}
-- 
2.55.0



