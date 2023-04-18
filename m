Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858A42566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A513C433EF;
	Tue, 18 Apr 2023 12:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821322;
	bh=P7ZuACcIa2HspGuV6cg3lJz4794sq1Wj+a1QOGAQrN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kK5IpRL03NcdR5JxUIEwk69BavLgjZIkKdryQSfzwMFdRKR8i216Vq1I4kwqFavPw
	 H/Ej/6xBjmsucpLOA1JdBMjdOfRonxn1+Qu4MeezptpJAFiOugtpvXJodcW/dGOQ3f
	 R2tUxF5RkTSvzQdoDjz6Exa0xVKYTmaYckgyRka0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/124] RDMA/core: Fix GID entry ref leak when create_ah fails
Date: Tue, 18 Apr 2023 14:21:41 +0200
Message-Id: <20230418120312.848506462@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
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
index 5123be0ab02f5..4fcabe5a84bee 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -535,6 +535,8 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
 
 	ret = device->ops.create_ah(ah, &init_attr, udata);
 	if (ret) {
+		if (ah->sgid_attr)
+			rdma_put_gid_attr(ah->sgid_attr);
 		kfree(ah);
 		return ERR_PTR(ret);
 	}
-- 
2.39.2



