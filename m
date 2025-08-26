Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79ADFBF0;
	Tue, 26 Aug 2025 13:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214064; cv=none; b=DeAQxKMBK2fVvWR7f3rggMVqsYTOyNv0snHx90zw3i8qnSX6NBlEQg6ZuNPLmOu3ZTvxe6PoQganJ1X9sAY2x1tUG46EfZ7wWOCWs68IsPiou1T1/b3fjKc4BdGDnnZibCVbSMrQ3aRcVXUafhycnDFvHWOuRas3XIfk086Qaqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214064; c=relaxed/simple;
	bh=uxYB0vHT0VYPqXmT99aNuxfJCQXwcbWDfgcuDz5ZZzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEA2pE1blgU3VJ2XLn+mZF5cYr3b4XIV9eTn/JL3GrgizBrVeUIMQOj7IZ4rAyxGlwy2n2ibSXK91wLywrjYUcxMx95S3h9lwIAaMILSjgwRu5lzFP9JG7UYGc/pQrb3yQWJ3bh27z7MMAvvfTJ4OPGt4xAemSvS3kVZEe26nqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsIeKdhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsIeKdhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E21C4CEF1;
	Tue, 26 Aug 2025 13:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214063;
	bh=uxYB0vHT0VYPqXmT99aNuxfJCQXwcbWDfgcuDz5ZZzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsIeKdhLgyxcM1AhFDPn1IadK77oB7QH5tMuU5IKo9Kt+NKU9M6JXz6HndRE1CR7G
	 NBWJ4mRaj8F0IQaT8zWYsojyRjegxes5QvK1sRlmtCVmpiTsSCfqgxkr79ifb6IfKd
	 tYel+McqlL46TJ2SzCdxfwV3ko7fA20c0BRab4QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Boshi Yu <boshiyu@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 552/587] RDMA/erdma: Fix ignored return value of init_kernel_qp
Date: Tue, 26 Aug 2025 13:11:41 +0200
Message-ID: <20250826111007.065964860@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Boshi Yu <boshiyu@linux.alibaba.com>

[ Upstream commit d5c74713f0117d07f91eb48b10bc2ad44e23c9b9 ]

The init_kernel_qp interface may fail. Check its return value and free
related resources properly when it does.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Reviewed-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Boshi Yu <boshiyu@linux.alibaba.com>
Link: https://patch.msgid.link/20250725055410.67520-3-boshiyu@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 29ad2f5ffabe..e990690d8b3c 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -979,7 +979,9 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 		if (ret)
 			goto err_out_cmd;
 	} else {
-		init_kernel_qp(dev, qp, attrs);
+		ret = init_kernel_qp(dev, qp, attrs);
+		if (ret)
+			goto err_out_xa;
 	}
 
 	qp->attrs.max_send_sge = attrs->cap.max_send_sge;
-- 
2.50.1



