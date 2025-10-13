Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC86E30C364;
	Mon, 13 Oct 2025 14:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367221; cv=none; b=qqo7l5Vb40BkOr+m6/otUSUjXFSYSesC8Rx+6PZvRMQfeFk764PIxzNflNkq0i0FLMLN/VnxVgj4Zi82pTmLe3fTcvnl63PQxWAHdgWJqmqAdoMF0dfBUeIRdqGAb9BV4iioYsxAQsJyfsx41HDEXYNL1VKSt5m8S7VkeCdwdRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367221; c=relaxed/simple;
	bh=5VQNacR3zSi7iWZL87gEPLGQlwIQiRdqu/k6WP/5/iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=posjDvfmYxVZtXr5nsYgxxMBUuNlbp93MqPLT063vJLcX/U1SR68m7cpsOppj4ht5zuHwiqWDAZ0eFBib0FzRrxrbJntYm25UVWTNFZJgoBxmf5zrNCMzqHH1PGtz+zM8ObSAZm89wvNf5sna+jDdDOQ73Djko5Acz9umufJkZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2jNiCqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2jNiCqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AB3C113D0;
	Mon, 13 Oct 2025 14:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367221;
	bh=5VQNacR3zSi7iWZL87gEPLGQlwIQiRdqu/k6WP/5/iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2jNiCqXH2vUBfLy1TYz5q+ZDjr2RHIgFOgS6djiRgpVbg9QmpPrggzBgIpG5HggZ
	 X3ZQkcQyknB/XxbO5l4chKm4W37A8MHDj7N6/i1ZJCuz83pfRSG5i8JLE8laV+Nk+9
	 sCl+u51A2yO8Tf+WJ08i2eOPsj3sAfCm8slKhLtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/196] IB/sa: Fix sa_local_svc_timeout_ms read race
Date: Mon, 13 Oct 2025 16:45:08 +0200
Message-ID: <20251013144319.577822127@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Dumitrescu <vdumitrescu@nvidia.com>

[ Upstream commit 1428cd764cd708d53a072a2f208d87014bfe05bc ]

When computing the delta, the sa_local_svc_timeout_ms is read without
ib_nl_request_lock held. Though unlikely in practice, this can cause
a race condition if multiple local service threads are managing the
timeout.

Fixes: 2ca546b92a02 ("IB/sa: Route SA pathrecord query through netlink")
Signed-off-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20250916163112.98414-1-edwards@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/sa_query.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 8c69bdb5bb754..f56eee73ee4a1 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1021,6 +1021,8 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 	if (timeout > IB_SA_LOCAL_SVC_TIMEOUT_MAX)
 		timeout = IB_SA_LOCAL_SVC_TIMEOUT_MAX;
 
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
+
 	delta = timeout - sa_local_svc_timeout_ms;
 	if (delta < 0)
 		abs_delta = -delta;
@@ -1028,7 +1030,6 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 		abs_delta = delta;
 
 	if (delta != 0) {
-		spin_lock_irqsave(&ib_nl_request_lock, flags);
 		sa_local_svc_timeout_ms = timeout;
 		list_for_each_entry(query, &ib_nl_request_list, list) {
 			if (delta < 0 && abs_delta > query->timeout)
@@ -1046,9 +1047,10 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 		if (delay)
 			mod_delayed_work(ib_nl_wq, &ib_nl_timed_work,
 					 (unsigned long)delay);
-		spin_unlock_irqrestore(&ib_nl_request_lock, flags);
 	}
 
+	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+
 settimeout_out:
 	return 0;
 }
-- 
2.51.0



