Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE139BE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B9CC433C8;
	Mon, 19 Jun 2023 10:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171690;
	bh=0OaXNXm5oHA9dyz0XYN+Fp19Mv3CUzYpCqsBEVYGsrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTTG899epN8b3eKWmksvkXqgKiQ6k3dhmYNEfyYyOUqnGRn1e1M4hBzGhRBvYNWgW
	 O/vOvnlyVkcMwA5UCBj4c/SjTPgrZh6ii9zKFV7oiJlOhHE1CGRYmSj7ZR7jztjOOw
	 wLs20hOvl6tL8qfA1k+ojGI7IdZHF5PveHfhJfII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/166] IB/isert: Fix possible list corruption in CMA handler
Date: Mon, 19 Jun 2023 12:29:59 +0200
Message-ID: <20230619102200.749403744@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
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

[ Upstream commit 7651e2d6c5b359a28c2d4c904fec6608d1021ca8 ]

When ib_isert module receives connection error event, it is
releasing the isert session and removes corresponding list
node but it doesn't take appropriate mutex lock to remove
the list node.  This can lead to linked  list corruption

Fixes: bd3792205aae ("iser-target: Fix pending connections handling in target stack shutdown sequnce")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Link: https://lore.kernel.org/r/20230606102531.162967-3-saravanan.vajravel@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 50d7373b425c0..a02a3caeaa4e7 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -657,9 +657,13 @@ static int
 isert_connect_error(struct rdma_cm_id *cma_id)
 {
 	struct isert_conn *isert_conn = cma_id->qp->qp_context;
+	struct isert_np *isert_np = cma_id->context;
 
 	ib_drain_qp(isert_conn->qp);
+
+	mutex_lock(&isert_np->mutex);
 	list_del_init(&isert_conn->node);
+	mutex_unlock(&isert_np->mutex);
 	isert_conn->cm_id = NULL;
 	isert_put_conn(isert_conn);
 
-- 
2.39.2



