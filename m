Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A365200112;
	Tue, 26 Aug 2025 13:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215362; cv=none; b=rvwO83B+rMdM2QQu5XpdwPVvjQTejLVtPr+/0d4uJVacVxTnpZv6ISXazaTs3YLQXpC3P2o/dtYQfWTOlP4m65JtME0uAigG23RW7WI8bTIEPnDXVHKoKdjpamttkRTNJU6o/4twJLYn9qjMiJlK1UqOOH4w4oVOzFRZIQnqoZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215362; c=relaxed/simple;
	bh=BKOK7dNJ+lf86P0cCuZPLTeWSBBDpV+cz8SHw0u/QQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5O4EKntESudALEQBsqDJAeY9bPTbMicZZYA9OGxrFJAZIg57eU04nQGffbvxWFKOH64N7VgIUlZ9EcnjxkuJTRD8w23MRKww3jSbBbaTzkSHpDIEdRIqe6u20byuVQ3vCqg6nuIwM9cxXiBo4TJikYsvK1YMTGGYxoukX7ni1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OEYWGZl2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEYWGZl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF5DC4CEF1;
	Tue, 26 Aug 2025 13:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215361;
	bh=BKOK7dNJ+lf86P0cCuZPLTeWSBBDpV+cz8SHw0u/QQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OEYWGZl2b3r9+1Z3qJTvIncRG9nRl6z1LCSrRMlRQewDUnVn/PcO4xPm+iyt3EE77
	 7zKRDHI4UbJYIJrhnuNZE7cQIOSfDXT9uDfOcNE4NJih4DI+pUONxRZR5ZA/+8A3GU
	 uPU5lumytJOWfM6pzI6bJmoD4ym/JHqHEKJGf1NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Boshi Yu <boshiyu@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 455/482] RDMA/erdma: Fix ignored return value of init_kernel_qp
Date: Tue, 26 Aug 2025 13:11:48 +0200
Message-ID: <20250826110942.068510854@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2edf0d882c6a..cc2b20c8b050 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -727,7 +727,9 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
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



