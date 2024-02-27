Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D89913B2B9;
	Tue, 27 Feb 2024 13:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041154; cv=none; b=GWG/7g16vdq/rB7JjieVe3ceTZtk06VV8futzadlDCM6/iunsAS7kCRHLeWRc3oY5vD1nOAVgUripMdhqriWPfPEFVgZ9Ig2e2RCQRjw9YOjg2NdmTspxqbWl6VxL2ZvYVnEyHIxNIe5xC/29R7ezvGyfxxFd5WUdGvfLsViFJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041154; c=relaxed/simple;
	bh=OGcAB7iwVyjO5WB//nhE11nkYWF9XSTr8TPwpayNhIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKB4RohY56RKL0/o44xPBmRue1zUBT32GtQTeZI7N7Y7R3zoRBfpEmiuQ4D3P6Cm9BSEaC9dBzgEo0K9lcm3HR2jGpffZS8EZlLhDzBd9ecHeT8FGo2+1feXf1AV+MqIcCIyFX9wCz8Sl6DaqbJhO76IQAq+eCYrKkoZVij4LGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7HNqkGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7HNqkGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C638BC43394;
	Tue, 27 Feb 2024 13:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041154;
	bh=OGcAB7iwVyjO5WB//nhE11nkYWF9XSTr8TPwpayNhIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7HNqkGbBRKFTiQxY6f6+yXgtzYUrnbArt6p/0yr+G5kcFbPt4vEs6+09u46zjtqm
	 +xVuNQDBL8sU2oBUdRaVXhNmdRoxk76wQ4Jl3TSR1JbbGwhh9Z0FFYcdv4etFINPaz
	 399PL/hkF5pa5JnjpbqE7VWV9oQiqq3KjtKQGTy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Sindhu Devale <sindhu.devale@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 239/334] RDMA/irdma: Set the CQ read threshold for GEN 1
Date: Tue, 27 Feb 2024 14:21:37 +0100
Message-ID: <20240227131638.593906613@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 666047f3ece9f991774c1fe9b223139a9ef8908d ]

The CQ shadow read threshold is currently not set for GEN 2.  This could
cause an invalid CQ overflow condition, so remove the GEN check that
exclused GEN 1.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Link: https://lore.kernel.org/r/20240131233849.400285-4-sindhu.devale@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index cb828e3da478e..0b046c061742b 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2186,9 +2186,8 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 		info.cq_base_pa = iwcq->kmem.pa;
 	}
 
-	if (dev->hw_attrs.uk_attrs.hw_rev >= IRDMA_GEN_2)
-		info.shadow_read_threshold = min(info.cq_uk_init_info.cq_size / 2,
-						 (u32)IRDMA_MAX_CQ_READ_THRESH);
+	info.shadow_read_threshold = min(info.cq_uk_init_info.cq_size / 2,
+					 (u32)IRDMA_MAX_CQ_READ_THRESH);
 
 	if (irdma_sc_cq_init(cq, &info)) {
 		ibdev_dbg(&iwdev->ibdev, "VERBS: init cq fail\n");
-- 
2.43.0



