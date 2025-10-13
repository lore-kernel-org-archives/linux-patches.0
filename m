Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7B9309EE9;
	Mon, 13 Oct 2025 15:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369839; cv=none; b=C9AJoJwOtM1Ke/r79TyIfGwNB9mncPNUOpEJ2pPyOmD+Xda89/3CYK7NGk0dlsDQGdxzGeZJAvToQtNxRPn6heFp+B4vX78LccHSBUsSii22m7xoaVegs8edxDEuNh5UqV1m/DgfT17+0dHYBopj3nLkinh5PCtqHMnuGJiZBDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369839; c=relaxed/simple;
	bh=W+HBipdf4dRVgb5q7kLbJzDLx+P5Sxvn0m06XbdAves=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFqxC4JjAaAJsSvL64Zox8wAEBlkotGqzS13n5/5RtzMsLQMbOGGeNiNv3enMoTjkdp65JxGJiUeSPNKxHfWLH7U9hQP56UomRkXHsV9mmwvuWix9IWQLBv17bcXtTV/C0azYxPgfOwxxF5tVc7KbVmmjLoabpv/0HBEN/kk+aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0a/3xHFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0a/3xHFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B448BC4CEFE;
	Mon, 13 Oct 2025 15:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369839;
	bh=W+HBipdf4dRVgb5q7kLbJzDLx+P5Sxvn0m06XbdAves=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0a/3xHFzCWI3Rk9vDRanE4e5z1BqqnRE+q5+NNVXBTQwc9aA/Sw6qTDg4elmq+sYc
	 h9UHkypDF9cDyGklhEfUh1xrHLBDxAiVFlNBusek1X/Gy/fb6qViCdIsK+jtyjL9uD
	 HtuCzHJx0CpnyDytfYxNgZ7AIoi/bkqS7Yxd7LOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 387/563] IB/sa: Fix sa_local_svc_timeout_ms read race
Date: Mon, 13 Oct 2025 16:44:08 +0200
Message-ID: <20251013144425.294053333@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 53571e6b3162c..66df5bed6a562 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1013,6 +1013,8 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 	if (timeout > IB_SA_LOCAL_SVC_TIMEOUT_MAX)
 		timeout = IB_SA_LOCAL_SVC_TIMEOUT_MAX;
 
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
+
 	delta = timeout - sa_local_svc_timeout_ms;
 	if (delta < 0)
 		abs_delta = -delta;
@@ -1020,7 +1022,6 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 		abs_delta = delta;
 
 	if (delta != 0) {
-		spin_lock_irqsave(&ib_nl_request_lock, flags);
 		sa_local_svc_timeout_ms = timeout;
 		list_for_each_entry(query, &ib_nl_request_list, list) {
 			if (delta < 0 && abs_delta > query->timeout)
@@ -1038,9 +1039,10 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
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



