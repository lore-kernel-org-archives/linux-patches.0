Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2602572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7078C4339B;
	Tue, 18 Apr 2023 12:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822270;
	bh=RMeRXrSJRI8PF8BNwa2iWA7Pbx/glA+7XOCtG4ajn+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oY4UMROnJ0s5meTPvlaL6gCkJwM4pO7dKbcqFI9qnOR13r5Mql01PCAfXfXf2H3ea
	 BdOOeM2pUyIoTjZXoskjaPPDI4cS4dFikXWRL8ipmjAJ1b3jbsb9GTwIl7xzCp8qhF
	 b/ZtdmXXTiw3xNZsZsJIUhDUfjW4EpM8VxvgyZ0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 069/139] RDMA/core: Fix GID entry ref leak when create_ah fails
Date: Tue, 18 Apr 2023 14:22:14 +0200
Message-Id: <20230418120316.400228602@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Saravanan Vajravel <saravanan.vajravel@broadcom.com>

[ Upstream commit aca3b0fa3d04b40c96934d86cc224cccfa7ea8e0 ]

If AH create request fails, release sgid_attr to avoid GID entry
referrence leak reported while releasing GID table

Fixes: 1a1f460ff151 ("RDMA: Hold the sgid_attr inside the struct ib_ah/qp")
Link: https://lore.kernel.org/r/20230401063424.342204-1-saravanan.vajravel@broadcom.com
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 11b1c1603aeb4..b99b3cc283b65 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -532,6 +532,8 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
 	else
 		ret = device->ops.create_ah(ah, &init_attr, NULL);
 	if (ret) {
+		if (ah->sgid_attr)
+			rdma_put_gid_attr(ah->sgid_attr);
 		kfree(ah);
 		return ERR_PTR(ret);
 	}
-- 
2.39.2



