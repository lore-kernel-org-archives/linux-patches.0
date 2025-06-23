Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D3B3FB1B;
	Mon, 23 Jun 2025 21:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713091; cv=none; b=BhUwA09lfC3t1Q3MRFgXk8kc/3LAuyk6MUtw/LOeWxNSmtfzNGIBxlIYbOiazMIrqh61edqlK5M9Y5duYDi/A6bvwhmYTDnFfSR+othdZVrQFLVplvFaoZjnL9FVS3HoA0oHuLwiq3Bp/345ib7qsEzfxoOfsG59zhFkqvMJ20o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713091; c=relaxed/simple;
	bh=1UTF/S6aZpyj6xjMBN08aLda/FR+QfOdqBZ1ZdsOXXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEEHvhBz/U2rfdV4l389dAv2tF4gWp9xnrbtlFxRlxDURGtVSp9EXERE0c/5b31s5e1TAU3lKhAU6tKnj2VGSvDOhiIei08/z2qRDec/A30qm1zX456Ydr9SReJDipFRAwzRplpjwGVka2RV1/wm+YKCyeJzFleaYoBqvOSicNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmFwn44U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmFwn44U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20ECDC4CEEA;
	Mon, 23 Jun 2025 21:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713091;
	bh=1UTF/S6aZpyj6xjMBN08aLda/FR+QfOdqBZ1ZdsOXXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmFwn44Uf709tfE5dnMJPZ4Y0RSROfYFY8a0mXnsPwRWmWLw9GZUiGFSn0Tjys8s+
	 qJGLeX7NvnElxPgTqPRF312n6ZVrzngAIJJmwyEgev6m4qarcNnhdP3YXxX52Gw5oU
	 hw8nkhcVc3VM9DfWTQJZhsIUhriEz6GIPQ/eFf38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Morgenstein <jackm@nvidia.com>,
	Feng Liu <feliu@nvidia.com>,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sharath Srinivasan <sharath.srinivasan@oracle.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/508] RDMA/cma: Fix hang when cma_netevent_callback fails to queue_work
Date: Mon, 23 Jun 2025 15:02:22 +0200
Message-ID: <20250623130647.655981666@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Jack Morgenstein <jackm@nvidia.com>

[ Upstream commit 92a251c3df8ea1991cd9fe00f1ab0cfce18d7711 ]

The cited commit fixed a crash when cma_netevent_callback was called for
a cma_id while work on that id from a previous call had not yet started.
The work item was re-initialized in the second call, which corrupted the
work item currently in the work queue.

However, it left a problem when queue_work fails (because the item is
still pending in the work queue from a previous call). In this case,
cma_id_put (which is called in the work handler) is therefore not
called. This results in a userspace process hang (zombie process).

Fix this by calling cma_id_put() if queue_work fails.

Fixes: 45f5dcdd0497 ("RDMA/cma: Fix workqueue crash in cma_netevent_work_handler")
Link: https://patch.msgid.link/r/4f3640b501e48d0166f312a64fdadf72b059bd04.1747827103.git.leon@kernel.org
Signed-off-by: Jack Morgenstein <jackm@nvidia.com>
Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index bb3c361bd8d45..0b2cb31d0f999 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -5190,7 +5190,8 @@ static int cma_netevent_callback(struct notifier_block *self,
 			   neigh->ha, ETH_ALEN))
 			continue;
 		cma_id_get(current_id);
-		queue_work(cma_wq, &current_id->id.net_work);
+		if (!queue_work(cma_wq, &current_id->id.net_work))
+			cma_id_put(current_id);
 	}
 out:
 	spin_unlock_irqrestore(&id_table_lock, flags);
-- 
2.39.5



