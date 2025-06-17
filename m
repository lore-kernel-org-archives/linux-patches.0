Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3692ED159;
	Tue, 17 Jun 2025 16:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177526; cv=none; b=SjX91jVqYav9JPEj376PcoL8/FnvVfFIt2Cb2jx+XDjWYzE1DygbUx7d+rC5yF77RFxxmx98xCo/ZDSdSnGmbOcPSRD++cSuyI92PkftgrA9dppITaunDg7WmyGZlMw4Gv8P+vdm2zo9ZpSjoIOzPK9YUh2iuC76LwugHVx/FAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177526; c=relaxed/simple;
	bh=MFrfPkM+KRIHtg8mQcBd9WiWQCxmKwz4uzMmFWeDve8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2wnkuQ+U2z9nHf/W51qhZMXMEGEHxp/rk7srP1ZHWRjZ6b+HNSFSZjiCLwH1C2xB5RqZ3GenaZX+qZKu8DppGiXTnBHt+p4vOgPTUi8YKAy85ezEJgcsu4O35kDd0OnITLNY5szFcY5TafYtpmJg0/yTrRLFTtL4GbzugoLkPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2OUNzrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2OUNzrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FB0C4CEE3;
	Tue, 17 Jun 2025 16:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177526;
	bh=MFrfPkM+KRIHtg8mQcBd9WiWQCxmKwz4uzMmFWeDve8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2OUNzrF5htB2eazeXktkCWPVrgRx/jEkhuC+VS40efTlS6mPoMKLoG/xL0InY6vI
	 a/G3zr4j+4APyW/+mr6BA7KC3Qtd8OL3UqvTGkQ1A9y9KMsNgfQPTV58p2+gsWCg3W
	 lEQ3fxTwHFdkyW8YUIQIGKWo+PvU23pGkxEmPLHY=
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
Subject: [PATCH 6.15 319/780] RDMA/cma: Fix hang when cma_netevent_callback fails to queue_work
Date: Tue, 17 Jun 2025 17:20:27 +0200
Message-ID: <20250617152504.446614090@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index ab31eefa916b3..274cfbd5aaba7 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -5245,7 +5245,8 @@ static int cma_netevent_callback(struct notifier_block *self,
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



