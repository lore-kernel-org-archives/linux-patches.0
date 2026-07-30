Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736D41AF0BB;
	Thu, 30 Jul 2026 14:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421376; cv=none; b=Taja2LaH7ZJC4CgcaDOCIuXHHremoW5bzwCaiyfy++rYcc4uOoJbcEoNKoxzQrX7npjwSb0eKypj8C6ckAoTGXhoeFy17wUBA2xaWhca79dhETUXdU4b2P/T95sqXUpOkL3RgkYSe2hbF8/pAevdFzUE7qxpPou4vN04XmuNLZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421376; c=relaxed/simple;
	bh=Ck46AE5XbZNS9LFO4Gq2gTBlUD/01kz30qL45Wkdca4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwLTMq5YRi/5Mb/prU155UmbWU9Mmfo62BRkoQ2BFKuamRDjJ0f10/LOOWMN2yz0nVTV+bCfhTOAOjy4ZVX8BshlaMlTcsZ9aZejtiV5fYdLKBVDEtAoPOWuEU1trfa/l7z7TpqulSb2MvxRI4xyXv/31xuogQgfoxQtpSx94/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGwygbTB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGwygbTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB441F000E9;
	Thu, 30 Jul 2026 14:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421373;
	bh=vBwMAIQnvXqPCeWu/b4xI+LyprxYfiNH/uVW/kdEgzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGwygbTBvKqeyrWBQcO70t3Q+9QFex+VzUd4y3tpkCQu8V02UIS55+IWLuZbNYH8q
	 E1RVxyu+500z3bBN116GQQnxJV/5ykK3k+IuWd2pFkxQDWGJ8oHeURFa9Z93unBygk
	 KH/AZLXQ44h0JFWNy3dZN+jHEfjez3J0OSWcPJ/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 038/744] RDMA/core: Fix memory leak in __ib_create_cq() on invalid cqe
Date: Thu, 30 Jul 2026 16:05:11 +0200
Message-ID: <20260730141445.091811375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit e939334ea7dd219f100f963dbb1cb43df520c20a ]

Move the zero CQE validation before rdma_zalloc_drv_obj() to avoid
leaking the CQ object when returning -EINVAL.

Fixes: a2917582887a ("RDMA/core: Reject zero CQE count")
Link: https://patch.msgid.link/r/20260625020148.224537-1-zhaochenguang@kylinos.cn
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index bac87de9cc6735..2f3237e6086b9b 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2199,13 +2199,13 @@ struct ib_cq *__ib_create_cq(struct ib_device *device,
 	struct ib_cq *cq;
 	int ret;
 
+	if (WARN_ON_ONCE(!cq_attr->cqe))
+		return ERR_PTR(-EINVAL);
+
 	cq = rdma_zalloc_drv_obj(device, ib_cq);
 	if (!cq)
 		return ERR_PTR(-ENOMEM);
 
-	if (WARN_ON_ONCE(!cq_attr->cqe))
-		return ERR_PTR(-EINVAL);
-
 	cq->device = device;
 	cq->comp_handler = comp_handler;
 	cq->event_handler = event_handler;
-- 
2.53.0



