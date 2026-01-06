Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DEB34CFCF;
	Tue,  6 Jan 2026 17:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720014; cv=none; b=hdpwrhffDnW3F2TBSvd+Yep/+rqgulJuUO7XwTSRG4hUbBckD/BxH+HW54GmtHqrhmFKldQEETGQLgwLNUt2YXqMqNgZ9EMOliyZsxx4AfGs5v45u4TlkEzyv1kPXfMCULqOlwKBlcHXEHQepNNrZefTqTueU3FcwBkgHIaBJN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720014; c=relaxed/simple;
	bh=QdYHl8AIsPIh0gUhrRkGwDUG5QuSWkwSOZaqALpFav0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZV3L2DABZ2a+FTXSxw/C5h9p8wEfaoE8MvZJrI8HPBwbKEXWYYNiStc5VlWWH7IuJrjgFueVcSGiuKFJ665v8OC6btDIRIjz7hlwb35nlZm5Zfl0kPTr5vPJIMblT+n1r90eFvj9TikxCTFvOkGtaKQPEaSze2AXDMHOKDau55I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OeM4HfKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OeM4HfKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5EBC116C6;
	Tue,  6 Jan 2026 17:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720014;
	bh=QdYHl8AIsPIh0gUhrRkGwDUG5QuSWkwSOZaqALpFav0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OeM4HfKtqPIHNkFW2qaHwjqfgScOQPkwSyTap47Fn3kPR8+rgXbYBarwhAxF9jNX7
	 6Jk+Z+eEYVViHb1PX8Rx7BC3rldeGdyR4AGI9SagcUEprNDSSWX5LWuOmJ+WE770xV
	 Nod43eqfTarkE+eQXO8AIUAFjV3aZ6OMCV17hVFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/567] iommufd/selftest: Check for overflow in IOMMU_TEST_OP_ADD_RESERVED
Date: Tue,  6 Jan 2026 17:57:28 +0100
Message-ID: <20260106170453.779631456@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit e6a973af11135439de32ece3b9cbe3bfc043bea8 ]

syzkaller found it could overflow math in the test infrastructure and
cause a WARN_ON by corrupting the reserved interval tree. This only
effects test kernels with CONFIG_IOMMUFD_TEST.

Validate the user input length in the test ioctl.

Fixes: f4b20bb34c83 ("iommufd: Add kernel support for testing iommufd")
Link: https://patch.msgid.link/r/0-v1-cd99f6049ba5+51-iommufd_syz_add_resv_jgg@nvidia.com
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Reported-by: syzbot+57fdb0cf6a0c5d1f15a2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69368129.a70a0220.38f243.008f.GAE@google.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/selftest.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 540437be168a0..aed260d4a93cc 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -836,14 +836,20 @@ static int iommufd_test_add_reserved(struct iommufd_ucmd *ucmd,
 				     unsigned int mockpt_id,
 				     unsigned long start, size_t length)
 {
+	unsigned long last;
 	struct iommufd_ioas *ioas;
 	int rc;
 
+	if (!length)
+		return -EINVAL;
+	if (check_add_overflow(start, length - 1, &last))
+		return -EOVERFLOW;
+
 	ioas = iommufd_get_ioas(ucmd->ictx, mockpt_id);
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 	down_write(&ioas->iopt.iova_rwsem);
-	rc = iopt_reserve_iova(&ioas->iopt, start, start + length - 1, NULL);
+	rc = iopt_reserve_iova(&ioas->iopt, start, last, NULL);
 	up_write(&ioas->iopt.iova_rwsem);
 	iommufd_put_object(ucmd->ictx, &ioas->obj);
 	return rc;
-- 
2.51.0



