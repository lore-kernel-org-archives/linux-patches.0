Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74047359F99;
	Fri,  9 Jan 2026 12:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960283; cv=none; b=iyFEGbVpTlwLlrVeTVAjV7q68Lr9l4rHnqNe0ed3Sf1CGIWMFfP1wRxry9/8nowvXT2yaUaOwrf8BFEWncNPdpdh10yOYfoqH/rIr+REo4FPztiHLP4bdZrLqAfrl/SJIOT45O+T+pbaFR+NFp3/Vbi6rLIfMVeLZnKaYE8sslY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960283; c=relaxed/simple;
	bh=Hi7ahjfBYpHeag6nOrn28N/WfMHWkOxOey2xjzLiUoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaQX08UwbseS+KONEnDAOsuowqADmyMn/YOh/gfkpRv6sJxK/B15S2pKFDV3zKtZZ9N90y57DZdqIfocC/6zdeCAvs8pJBvTLlbnACc2fv3A6vtGWK60UQesCuCYI3Bfgk+M8VeUMMO42+QLxwUrlca8RkRn1VlT0hSi71T7kik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=viAPAXuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="viAPAXuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EFAC4CEF1;
	Fri,  9 Jan 2026 12:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960283;
	bh=Hi7ahjfBYpHeag6nOrn28N/WfMHWkOxOey2xjzLiUoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=viAPAXuvemkTheOjOByip8ajmLlp8AingVf8DjqVvZ6B/KIPp811jkQjy0H3mzRRj
	 FV32042NMs5U7qDq4wK4PBn2YEfcR0pwx+S93Lo/eJof+6RK/LARzwVVneFdYjC7gr
	 bP8cAwp5dHh83LvW+TSAqmztAGqooyCAEULHjaqI=
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
Subject: [PATCH 6.6 348/737] iommufd/selftest: Check for overflow in IOMMU_TEST_OP_ADD_RESERVED
Date: Fri,  9 Jan 2026 12:38:07 +0100
Message-ID: <20260109112147.076819523@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 00b794d74e03b..8025ff65ed4de 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -512,14 +512,20 @@ static int iommufd_test_add_reserved(struct iommufd_ucmd *ucmd,
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
 	iommufd_put_object(&ioas->obj);
 	return rc;
-- 
2.51.0



