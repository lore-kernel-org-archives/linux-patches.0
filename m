Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6D82DE1F3;
	Tue, 17 Jun 2025 15:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175108; cv=none; b=lnC8Mlzal88zbYfrnbZFPcfClEjxMXIEJQ7ySwpHJSeyu6i4h4GmhbRFD2JfP8LlBqdNIDOr6OhVtsFgFMbGGjtk+8XKI2pHNMombDRqH82ZRIv1zWld8UxWEBcWXtAxXWaavVEB7e6PU2ol/9XhG5B/n2HKb26q6W+KT58Avfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175108; c=relaxed/simple;
	bh=mLTKk9cFhtttwTq3ZdTS4XiQqXduVurFIGhNgofI1jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3By+fgLsnTVXRyQDPCNAdxDroRzbpeUj2+61p/1tLmDXVYXyMXImweRpPcqMdkL177K5Tb3GOAnt47JWdkOL2wvlFjxora2xgcvu4AUHlrfXrrMJip/LxwSgjcjqWdXRe/zwUMlf7i0x/nGxunORDutr3NYixGtg1sjAfQUiHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZCWNA/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZCWNA/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2B7C4CEE3;
	Tue, 17 Jun 2025 15:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175107;
	bh=mLTKk9cFhtttwTq3ZdTS4XiQqXduVurFIGhNgofI1jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZCWNA/o90xj7O450T474HpzAqrppb/PSw1MM+/mR9aQRBGNgIaMSMSE9fPi8p8ca
	 e/vHgsK2GDTKLlcOsKa9lx/Z/J4/lnvX5dMmvBHrX+LhSoX3P4jNQUMFKed0mC0niL
	 bLgF4v/UoIEpIctZ24m6bd0SNQ7CeTbnkSjWUDgQ=
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
Subject: [PATCH 6.6 144/356] RDMA/cma: Fix hang when cma_netevent_callback fails to queue_work
Date: Tue, 17 Jun 2025 17:24:19 +0200
Message-ID: <20250617152344.033269243@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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
index 348527cf1e7bf..a5ceae2e075ad 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -5215,7 +5215,8 @@ static int cma_netevent_callback(struct notifier_block *self,
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



